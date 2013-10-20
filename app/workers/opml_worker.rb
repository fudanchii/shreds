require 'opml'

class OPMLWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def fetch_feed_from(bundle, category = Category.default)
    jids = []
    bundle.each do |outline|
      unless outline.type == 'rss' then
        category = outline.title
        jids += fetch_feed_from(outline.outlines, category) unless outline.outlines.empty?
      else
        jid = FeedWorker.perform_async(:create, outline.feed_url, category)
        jids << "create-#{jid}"
      end
    end
    jids
  end

  def watch_feed_fetcher(jids)
    results = $redis.pipelined do
      jids.each {|j| EventPool.get(j) }
    end
    jids = jids.zip(results).map do|j, r|
      EventPool.remove(j) unless r.nil?
      j if r.nil?
    end.compact
    if jids.empty?
      EventPool.add("opml-#{jid}", { view: 'via_opml' })
    else
      sleep 2
      watch_feed_fetcher(jids)
    end
  end

  def perform(input_file)
    File.open(input_file, "r") do |f|
      # slurrrp
      bundle = OPMLDoc.parse(f.read)
      create_jids = fetch_feed_from(bundle.outlines)
      watch_feed_fetcher(create_jids)
    end
  ensure
    File.unlink(input_file)
  end

  def self.save_file(upfile)
    error = nil
    name = upfile.original_filename.gsub(/[^\w\.\-]/,'_')
    input_file = "tmp/#{name}"
    unless ['.xml','.opml','.txt'].include?(File.extname(name).downcase) then
      raise OPMLWorkerError.new('<strong>Can only</strong> accept xml file.')
    else
      wrote, buff = 0, ''
      File.open(input_file, 'wb') do |f|
        while upfile.read(32768, buff) do
          f.write(buff)
          wrote += buff.length
        end
      end
      if wrote == 0 then
        File.unlink(input_fie)
        raise OPMLWorkerError.new('<strong>Empty file</strong> uploaded.')
      end
    end
    self.perform_async(input_file)
  end
end

class OPMLWorkerError < IOError
end

