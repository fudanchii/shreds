namespace :newsitem do
  desc 'Destroy all newsitem marked as read'
  task clear: :environment do
    Subscription.find_each(&:clear_read_news)
  end

  desc 'Mark all news as read'
  task mark_as_read: :environment do
    Newsitem.all.each do |item|
      item.update(unread: false)
    end
  end
end

namespace :feed do
  desc 'Update all feeds'
  task update: :environment do
    Feed.all.each do |feed|
      FeedWorker.perform_async(:fetch, feed.id)
    end
  end
end
