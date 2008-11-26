Document.auto_migrate!
Artifact.auto_migrate!
DataMapper.auto_migrate!

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)

# FIXME why doesn't this work?
# from http://wiki.merbivore.com/testing/rspec/datamapper-transactions

#  config.after(:each) do
#    repository(:default) do
#      while repository.adapter.current_transaction
#        repository.adapter.current_transaction.rollback
#        repository.adapter.pop_transaction
#      end
#    end
#  end

#  config.before(:each) do
#    repository(:default) do
#      transaction = DataMapper::Transaction.new(repository)
#      transaction.begin
#      repository.adapter.push_transaction(transaction)
#    end
#  end
end

