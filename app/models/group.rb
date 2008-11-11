class Group
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :length => 100, :nullable => false
  
  belongs_to :leader, :class_name => 'User'
  
  has n, :users, :through => Resource
  has n, :documents
  
  validates_present :leader
  #validates_length :name, :in => (1..100)
  
  validates_with_method :leader_is_member
  
  def leader_is_member
    [self.users.include?(self.leader), "The leader of the group must be a member."]
  end

end
