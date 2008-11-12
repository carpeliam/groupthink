class Document
  include DataMapper::Resource
  
  property :id, Serial

  property :title, String, :length => 100, :nullable => false
  property :body, Text, :nullable => false
  property :updated_at, DateTime
  belongs_to :category
  belongs_to :author, :class_name => 'User'
  
  is_versioned :on => :updated_at
  
  validates_present :category
  validates_present :author
  
  validates_with_method :author_is_member_of_group, :if => :new_record?
  
  def group
    self.category.group if self.category
  end
  
  private
  def author_is_member_of_group
    [(!!self.group and !!self.author and self.group.users.include? self.author),
      "The author must be a member of the group."]
  end

end
