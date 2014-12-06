namespace :test do
  Rake::TestTask.new(defer: 'test:prepare') do |t|
    t.libs << 'test'
    t.pattern = 'test/deferrables/**/*_test.rb'
    t.verbose = false
  end
end

Rake::Task[:test].enhance { Rake::Task['teaspoon'].invoke }
Rake::Task[:test].enhance { Rake::Task['test:defer'].invoke }
