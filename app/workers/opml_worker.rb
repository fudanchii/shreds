require 'opml'

class OPMLWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def fetch_feed_from(bundle, category = Category.default)
    jids = []
    bundle.each do |outline|
      if outline.feed_url.nil?
        category = outline.title || outline.text
        jids += fetch_feed_from(outline.outlines, category) unless outline.outlines.empty?
      else
        jid = FeedWorker.perform_async(:create, outline.feed_url, category)
        jids << "create-#{jid}"
      end
    end
    jids
  end

  def watch_feed_fetcher(jids)
    results = EventPool.pipelined { jids.each {|j| EventPool.get(j) } }
    jids = jids.zip(results).map {|j, r|
      EventPool.remove(j) unless r.nil?
      j if r.nil?
    }.compact
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
    name = upfile.original_filename.gsub(/[^\w\.\-]/, '_')
    input_file = "tmp/#{name}"
    if ['.xml', '.opml', '.txt'].include?(File.extname(name).downcase)
      wrote, buff = 0, ''
      File.open(input_file, 'wb') do |f|
        while upfile.read(32768, buff)
          f.write(buff)
          wrote += buff.length
        end
      end
      if wrote == 0
        File.unlink(input_fie)
        fail OPMLWorkerError, '<strong>Empty file</strong> uploaded.'
      end
    else
      fail OPMLWorkerError, '<strong>Can only</strong> accept xml file.'
    end
    perform_async(input_file)
  end
end

class OPMLWorkerError < IOError
end
