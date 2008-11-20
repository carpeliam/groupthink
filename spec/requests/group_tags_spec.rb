require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a group_tag exists" do
  Document.all.destroy!
  Artifact.all.destroy!
  Tag.all.destroy!
  Tagging.all.destroy!
  doc = get_document
  doc.category_list = 'finally'
  doc.save
end

context "when logged in as group member", :given => "a group user is logged in" do
#  describe "resource(@group, :group_tags)" do
#    describe "a successful POST" do
#      before(:each) do
#        GroupTag.all.destroy!
#        @response = request(resource(@group, :group_tags), :method => "POST",
#        :params => { :group_tag => { :id => nil }})
#      end

#      it "redirects to resource(@group, :group_tags)" do
#        @response.should redirect_to(resource(@group, GroupTag.first), :message => {:notice => "group_tag was successfully created"})
#      end

#    end
#  end

  describe "resource(@group, @group_tag)", :given => "a group_tag exists" do
#    describe "a successful DELETE" do
#      before(:each) do
#        @response = request(resource(@group, GroupTag.first), :method => "DELETE")
#      end

#      it "should redirect to the index action" do
#        @response.should redirect_to(resource(@group, :group_tags))
#      end
#    end
    
    describe "PUT" do
      before(:each) do
        @group_tag = GroupTag.first
        @group = get_group
        @response = request(resource(@group, @group_tag), :method => "PUT",
        :params => { :group_tag => {:id => @group_tag.id} })
      end

      it "redirect to the show action" do
        @response.should redirect_to(resource(@group, @group_tag))
      end
    end
  end

#  describe "resource(@group, :group_tags, :new)" do
#    before(:each) do
#      @response = request(resource(@group, :group_tags, :new))
#    end

#    it "responds successfully" do
#      @response.should be_successful
#    end
#  end

  describe "resource(@group, @group_tag, :edit)", :given => "a group_tag exists" do
    before(:each) do
      @response = request(resource(get_group, GroupTag.first, :edit))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end
end

describe "resource(@group, :group_tags)" do
  describe "GET" do

    before(:each) do
      @response = request(resource(get_group, :group_tags))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of group_tags" do
      pending
      @response.should have_xpath("//ul")
    end

  end

  describe "GET", :given => "a group_tag exists" do
    before(:each) do
      @response = request(resource(get_group, :group_tags))
    end

    it "has a list of group_tags" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end

end

describe "resource(@group, @group_tag)", :given => "a group_tag exists" do

  describe "GET" do
    before(:each) do
      # fails because somewhere along the line, tags are getting deleted-
      # i think this is just in the test harness, doesn't seem to happen in
      # development, and i'm not concerned about this branch enough to worry
      # about it right now.
      @response = request(resource(get_group, GroupTag.first))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end
end
