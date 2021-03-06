# Go to http://wiki.merbivore.com/pages/init-rb

#Merb.push_path(:lib, Merb.root / "lib")


require 'config/dependencies.rb'



use_orm :datamapper
use_test :rspec
use_template_engine :haml

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '92ca0560d9d08f131b14e69087801cb248401127'  # required for cookie session store
  # c[:session_id_key] = '_session_id' # cookie session id key, defaults to "_session_id"
  c[:compass] = {
    :stylesheets => 'app/stylesheets',
    :compiled_stylesheets => 'public/stylesheets/compiled'
  }
end

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
  require 'lib/diff'
  require 'lib/groupthink'
  
  Merb::Slices::config[:merb_watchable][:sender] = 'Groupthink <groupthink@carpeliam.com>'
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Merb::Mailer.config = {
    :host   => 'localhost',
    :port   => 25,
    :domain => 'localhost.localdomain'
  }
end

