require 'opml/defs'

class ProcessOPML
  include Sidekiq::Worker

  sidekiq_options retry: false

  def fetch_feed_from(bundle, category = Category.default)
    jids = []
    bundle.each do |outline|
      if outline.feed_url.nil?
        category = outline.title || outline.text
        jids += fetch_feed_from(outline.outlines, category) unless outline.outlines.empty?
      else
        jid = CreateSubscription.perform_async @user_id, outline.feed_url, category
        jids << "create-#{jid}"
      end
    end
    jids
  end

  def watch_feed_fetcher(jids)
    loop do
      results = EventPool.pipelined { |conn| jids.each { |j| conn.get(j) } }
      jids = jids.zip(results).map do |j, r|
        EventPool.remove(j) unless r.nil?
        j if r.nil?
      end.compact
      if jids.empty?
        EventPool.add("opml-#{jid}", view: 'via_opml')
        return
      end
      sleep 1
    end
  end

  def perform(uid, input_file)
    @user_id = uid
    File.open(input_file, 'r') do |f|
      # slurrrp
      bundle = OPML::Doc.parse(f.read)
      create_jids = fetch_feed_from(bundle.outlines)
      watch_feed_fetcher(create_jids)
    end
  ensure
    File.unlink(input_file)
  end
end
