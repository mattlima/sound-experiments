require 'sprockets/coffee-react'

::Sprockets.register_preprocessor 'application/javascript', ::Sprockets::CoffeeReact
::Sprockets.register_engine '.cjsx', ::Sprockets::CoffeeReactScript
::Sprockets.register_engine '.js.cjsx', ::Sprockets::CoffeeReactScript

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# data.experiments.each do |experiment_group|
#   experiment_group = experiment_group.symbolize_keys
#   experiment_group[:members].each do |experiment|
#     proxy "/experiments/#{experiment_group[:slug]}/#{experiment[:slug]}/index.html", "/views/test.html", locals: experiment
#   end
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'assets/stylesheets'

set :js_dir, 'assets/javascripts'

set :images_dir, 'assets/images'

set :layouts_dir, 'assets/layouts'

# activate :livereload

activate :directory_indexes

#Compile jsx files
activate :react

after_configuration do
  sprockets.append_path File.dirname(::React::Source.bundled_path_for('react.js'))
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end


#after_configuration do
#  sprockets.append_path File.dirname(::React::Source.bundled_path_for('react.js'))
#end
