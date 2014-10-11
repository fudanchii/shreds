require 'opml'

class ProcessOPML
  include Sidekiq::Worker

  sidekiq_options :retry => false

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
    results = EventPool.pipelined { jids.each { |j| EventPool.get(j) } }
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

  def perform(uid, input_file)
    @user_id = uid
    File.open(input_file, 'r') do |f|
      # slurrrp
      bundle = OPMLDoc.parse(f.read)
      create_jids = fetch_feed_from(bundle.outlines)
      watch_feed_fetcher(create_jids)
    end
  ensure
    File.unlink(input_file)
  end
end
