class GroupTag
  include DataMapper::Resource

  property :id, Serial #TODO define id based on [group_id, tagging_id]

  belongs_to :group
  belongs_to :tag
  
  # man, this is so disgusting.
  def taggables
    self.tag.taggings.select do |t|
      t.tag_context == 'categories' and t.taggable.group == self.group
    end.map{|t| t.taggable }
  end

  is :state_machine, :initial => :private, :column => :state do
    state :private
    state :public

    event :publicize do
      transition :from => :private, :to => :public
    end

    event :privatize do
      transition :from => :public, :to => :private
    end
  end
end
