class Artifact
  include DataMapper::Resource
  include Paperclip::Resource
  property :description, String, :nullable => false, :length => 255
  has_attached_file :attachment
  include Groupthink::Resource
end
