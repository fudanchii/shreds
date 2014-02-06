Rake::Task[:test].enhance { Rake::Task["konacha:run"].invoke }
