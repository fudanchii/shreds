xml.instruct!
xml.opml(:version => '1.0') do
  xml.head do
    xml.title 'Your feed subscriptions in Shreds Reader.'
  end
  xml.body do
    @categories.each do |category|
      if category.name == category.class.default
        category.feeds.each do |feed|
          xml.outline(
            :text    => feed.title,
            :title   => feed.title,
            :type    => 'rss',
            :xmlUrl  => feed.feed_url,
            :htmlUrl => feed.url
          )
        end
      else
        xml.outline(:text => category.name, :title => category.name) do
          category.feeds.each do |feed|
            xml.outline(
              :text    => feed.title,
              :title   => feed.title,
              :type    => 'rss',
              :xmlUrl  => feed.feed_url,
              :htmlUrl => feed.url
            )
          end
        end
      end
    end
  end
end.html_safe
