# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( es6-application.js
                                                  teaspoon-teaspoon.js
                                                  teaspoon.css
                                                  teaspoon-mocha.js
                                                  mocha/1.17.1.js )

Rails.application.config.assets.configure do |env|
  env.register_transformer 'text/ecmascript-6', 'application/javascript',
                           Sprockets::ES6.new('modules' => 'amd',
                                              'moduleIds' => true,
                                              'externalHelpers' => true)
end
