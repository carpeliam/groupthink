module Groupthink
  module Resource
    def self.included(model)
      model.class_eval do

        private
        def author_is_member_of_group
          [(!!self.group and !!self.author and self.group.users.include? self.author),
          "The author must be a member of the group."]
        end

        public
        property   :id,         DataMapper::Types::Serial
        property   :title,      String,   :length => 100, :nullable => false
        property   :created_at, DateTime, :lazy => true
        property   :updated_at, DateTime, :lazy => true
        belongs_to :group
        belongs_to :author, :class_name => 'User'

        has_tags_on :tags, :categories
        is_versioned :on => :updated_at

        validates_present :group
        validates_present :author

        validates_with_method :author_is_member_of_group, :if => :new_record?

        before :frozen_category_list=, :track_cat_list

        after :save, :manage_group_tags

        def track_cat_list
          #          @tags_have_changed = (self.frozen_tag_list.blank? or
          #            self.frozen_tag_list.split(',') == self.tag_list)
          @cat_list = self.frozen_category_list
        end

        def manage_group_tags
          if @cat_list != self.frozen_category_list
            old_tags = @cat_list.to_s.split(',')
            new_tags = self.category_list
            removed_tags = old_tags - new_tags
            added_tags = new_tags - old_tags

            # delete any group tags that no longer have resources
            removed_tags.each do |tag_name|
              tag = Tag.first(:name => tag_name)
              next if tag.taggings.any?{|tagging| tagging.taggable.group == self.group and tagging.tag_context == 'categories' }
              gtag = GroupTag.first(:tag_id => tag.id, :group_id => self.group.id)
              gtag.destroy
            end

            # add any new tags
            added_tags.each do |tag_name|
              tag = Tag.first(:name => tag_name)
              next if tag.taggings.any?{|tagging| tagging.taggable != self and tagging.taggable.group == self.group and tagging.tag_context == 'categories' }
              GroupTag.create(:tag_id => tag.id, :group_id => self.group.id)
            end
          end
        end # manage_group_tags
      end # class_eval
    end # self.included
  end # Resource
end # Groupthink
