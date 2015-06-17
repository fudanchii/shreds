
namespace :feed do
  desc 'Update all feeds'
  task update: :environment do
    require 'recurring/update_feed'
    UpdateFeed.new.perform
  end

  desc 'Apply filters to existing newsitems'
  task filter: :environment do
    require 'shreds/feed/filters'
    Newsitem.find_each do |n|
      Shreds::Feed::Filters.new.run n
      n.save!
      puts "#{n.permalink} filtered..."
    end
  end
end
