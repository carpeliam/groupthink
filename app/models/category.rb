class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :nullable => false
  property :created_at, DateTime, :lazy => true
  property :updated_at, DateTime, :lazy => true

  belongs_to :group
  # TODO remove before(:destroy) when :dependent => :destroy works
  has n, :documents#, :dependent => :destroy
  has n, :artifacts#, :dependent => :destroy

  is :nested_set, :scope => [:group_id]

  before :valid?, :inherit_group

  validates_present :group

  private
  before :destroy do # temporary replacement for :dependent => :destroy
    self.documents.destroy!
    self.artifacts.destroy!
  end

  def inherit_group
    self.group = self.parent.group unless self.parent.nil?
  end
end
