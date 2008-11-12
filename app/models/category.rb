class Category
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :nullable => false
  
  belongs_to :group
  # TODO remove before(:destroy) when :dependent => :destroy works
  has n, :documents#, :dependent => :destroy
  
  is :nested_set, :scope => [:group_id]
  
  before :valid?, :inherit_group
  
  def inherit_group
    self.group = self.parent.group unless self.parent.nil?
  end

  validates_present :group
  
  before :destroy do # temporary replacement for :dependent => :destroy
    self.documents.destroy!
  end
end
