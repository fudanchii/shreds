# frozen_string_literal: true

Rake::Task[:test].enhance { Rake::Task['teaspoon'].invoke }
