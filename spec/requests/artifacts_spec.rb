require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a artifact exists" do
  Artifact.all.destroy!
  get_artifact
end

context "when logged in", :given => "a group user is logged in" do
  describe "resource(@group, @category, :artifacts)" do
    describe "a successful POST" do
      before(:each) do
        @category = get_category
        @group = get_group
        Artifact.all.destroy!
        @response = request(resource(@group, @category, :artifacts), :method => "POST",
        :params => { :artifact => Artifact.generate_attributes(:request_safe)})
      end

      it "redirects to resource(@group, @category, @artifact)" do
        @response.should redirect_to(resource(@group, @category, Artifact.first), :message => {:notice => "artifact was successfully created"})
      end

    end
  end

  describe "resource(@group, @category, :artifacts, :new)" do
    before(:each) do
      @category = get_category
      @group = get_group
      @response = request(resource(@group, @category, :artifacts, :new))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @category, @artifact)", :given => "a artifact exists" do
    describe "PUT" do
      before(:each) do
        @category = get_category
        @group = get_group
        @artifact = get_artifact
        @response = request(resource(@group, @category, @artifact), :method => "PUT",
        :params => { :artifact => Artifact.generate_attributes(:request_safe) })
      end

      it "redirect to the article show action" do
        @response.should redirect_to(resource(@group, @category, @artifact))
      end
    end
    describe "a successful DELETE" do
      before(:each) do
        @category = get_category
        @group = get_group
        @artifact = get_artifact
        @response = request(resource(@group, @category, @artifact), :method => "DELETE")
      end

      it "should redirect to the index action" do
        @response.should redirect_to(resource(@group, @category, :artifacts))
      end

    end
  end

  describe "resource(@group, @category, @artifact, :edit)", :given => "a artifact exists" do
    before(:each) do
      @category = get_category
      @group = get_group
      @artifact = get_artifact
      @response = request(resource(@group, @category, @artifact, :edit))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

end

describe "resource(@group, @category, :artifacts)" do
  describe "GET" do

    before(:each) do
      @category = Category.first
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category, :artifacts))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of artifacts" do
      pending
      @response.should have_xpath("//ul")
    end

  end

  describe "GET", :given => "a artifact exists" do
    before(:each) do
      @category = Category.first
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category, :artifacts))
    end

    it "has a list of artifacts" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end

end


describe "resource(@group, @category, @artifact)", :given => "a artifact exists" do

  describe "GET" do
    before(:each) do
      @category = Category.first
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category, Artifact.first))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

end

