class Document
  include DataMapper::Resource
  property :body, DataMapper::Types::Text, :nullable => false
  include Groupthink::Resource
end
