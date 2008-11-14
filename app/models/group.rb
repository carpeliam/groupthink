class Group
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   :length => 100, :nullable => false
  property :created_at, DateTime, :lazy => true
  property :updated_at, DateTime, :lazy => true

  property :grouplink,  String,   :length => 100, :lazy => false,
                                  :nullable => false, :unique_index => true
  before :valid?, :create_permalink


  belongs_to :leader, :class_name => 'User'
  has n,     :users,  :through => Resource
  # TODO remove before(:destroy) when :dependent => :destroy works
  has n,     :categories#, :dependent => :destroy

  validates_present     :leader
  validates_with_method :leader_is_member


  private
  def create_permalink #TODO refactor this out into a plugin
    slug = Slugalizer.slugalize(self.name)
    count = Group.count(:grouplink.like => "#{slug}%", :id.not => self.id)
    self.grouplink = (count == 0) ? slug : "#{slug}-#{count + 1}"
  end

  def leader_is_member
    [self.users.include?(self.leader), "The leader of the group must be a member."]
  end
  
  before :destroy do # temporary replacement for :dependent => :destroy
    self.categories.each {|c| c.destroy }
  end
end
