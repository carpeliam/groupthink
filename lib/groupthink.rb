module Groupthink
  module Resource
    def self.included(model)
      model.class_eval do

        #private
        def author_is_member_of_group
          [(!!self.group and !!self.author and self.group.users.include? self.author),
          "The author must be a member of the group."]
        end

        public
        property :id, DataMapper::Types::Serial
        property :title, String, :length => 100, :nullable => false
        property :created_at, DateTime, :lazy => true
        property :updated_at, DateTime, :lazy => true
        belongs_to :category
        belongs_to :author, :class_name => 'User'

        is_versioned :on => :updated_at

        validates_present :category
        validates_present :author

        validates_with_method :author_is_member_of_group, :if => :new_record?

        def group
          self.category.group if self.category
        end

      end
    end
  end
end

