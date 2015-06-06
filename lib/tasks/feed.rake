
namespace :feed do
  desc 'Update all feeds'
  task update: :environment do
    require 'recurring/update_feed'
    UpdateFeed.new.perform
  end
end
