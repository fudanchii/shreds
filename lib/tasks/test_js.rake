Rake::Task[:test].enhance { Rake::Task['konacha:run'].invoke }

namespace :test do
  desc 'Test javascript with konacha via browser.'
  task :js => 'konacha:serve' do
  end
end
