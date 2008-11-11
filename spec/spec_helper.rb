require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require "spec" # Satisfies Autotest and anyone else not using the Rake tasks

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end

require File.dirname(__FILE__) / 'fixtures.rb'

Merb::Test.add_helpers do
  def create_user
    User.generate(:login => 'liam')
  end
  
  def get_user
    user = create_user unless user = User.first(:login => 'liam')
    return user
  end
  
  def login
    user = get_user
    rack = request(url(:login), :method => "PUT",
      :params => {:login => "liam", :password => "password"})
    return user
  end
  
  def login_as_group_user
    user = login
    Group.all.destroy!
    create_group
    return user
  end
  
  def create_group
    user = get_user
    Group.generate :name => 'Groupthink', :leader => user, :users => [user]
  end
  
  def get_group
    group = create_group unless group = Group.first(:name => 'Groupthink')
    return group
  end
  
  def create_document
    group = get_group
    Document.generate :author => group.leader, :group => group
  end
  
  def get_document
    document = create_document unless document = Document.first(:title => 'Groupthink rocks')
    return document
  end
  
end

given "a user is logged in" do
  login
end
