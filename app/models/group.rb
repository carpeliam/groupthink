class Group
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   :length => 100, :nullable => false, :unique => true
  property :created_at, DateTime, :lazy => true
  property :updated_at, DateTime, :lazy => true
  
  belongs_to :leader, :class_name => 'User'
  has n,     :users,  :through => Resource
  # TODO remove before(:destroy) when :dependent => :destroy works
  has n,     :categories#, :dependent => :destroy

  validates_present     :leader
  validates_with_method :leader_is_member

  has_slug :on => :name, :called => :grouplink


  private
  def leader_is_member
    [self.users.include?(self.leader), "The leader of the group must be a member."]
  end
  
  before :destroy do # temporary replacement for :dependent => :destroy
    self.categories.each {|c| c.destroy }
  end
end
