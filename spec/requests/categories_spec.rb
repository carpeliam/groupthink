require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

Group.generate unless Group.count > 0

given "a category exists" do
  get_category
end

given "user is not logged in" do

end

context "when logged in", :given => "a group user is logged in" do
  describe "resource(@group, :categories)" do
    describe "a successful POST" do
      before(:each) do
        Category.all.destroy!
        @group = get_group
        @response = request(resource(@group, :categories), :method => "POST",
          :params => { :category => Category.generate_attributes(:request_safe) })
      end

      it "redirects to resource(@group, @category)" do
        @response.should redirect_to(resource(@group, Category.first), :message => {:notice => "category was successfully created"})
      end

    end
  end
  
  describe "resource(@group, @category)", :given => "a category exists" do
    describe "PUT" do
      before(:each) do
        @category = get_category
        @group = Group.get @category.group.id
        @response = request(resource(@group, @category), :method => "PUT",
          :params => { :category => Category.generate_attributes(:request_safe) })
      end

      it "redirect to the article show action" do
        @response.should redirect_to(resource(@group, @category))
      end
    end
    
    describe "a successful DELETE" do
      before(:each) do
        @group = get_group
        @response = request(resource(@group, get_category), :method => "DELETE")
      end

      it "should redirect to the index action" do
        @response.should redirect_to(resource(@group, :categories))
      end
    end
  end

  describe "resource(@group, :categories, :new)" do
    before(:each) do
      @response = request(resource(get_group, :categories, :new))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @category, :edit)", :given => "a category exists" do
    before(:each) do
      @response = request(resource(get_group, get_category, :edit))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

end

context "when not logged in" do #, :given => "user is not logged in" do
  describe "resource(@group, :categories)" do
    describe "a POST attempt" do
      before(:each) do
        Category.all.destroy!
        @response = request(resource(Group.first, :categories), :method => "POST",
          :params => { :category => Category.generate_attributes(:request_safe) })
      end

      it "redirects to login page" do
        @response.should_not be_successful
      end

    end
  end
  
  describe "resource(@group, @category)", :given => "a category exists" do
    describe "PUT" do
      before(:each) do
        @category = Category.first
        @group = Group.get @category.group.id
        @response = request(resource(@group, @category), :method => "PUT",
          :params => { :category => Category.generate_attributes(:request_safe) })
      end

      it "redirect to login page" do
        @response.should_not be_successful
      end
    end
    
    describe "a successful DELETE" do
      before(:each) do
        @group = Group.first
        @response = request(resource(@group, Category.first), :method => "DELETE")
      end

      it "redirects to login page" do
        @response.should_not be_successful
      end
    end
  end

  describe "resource(@group, :categories, :new)" do
    before(:each) do
      @response = request(resource(Group.first, :categories, :new))
    end

    it "redirects to login page" do
      @response.should_not be_successful
    end
  end

  describe "resource(@group, @category, :edit)", :given => "a category exists" do
    before(:each) do
      @category = Category.first
      @response = request(resource(get_group, get_category, :edit))
    end

    it "redirects to login page" do
      @response.should_not be_successful
    end
  end

end


describe "resource(@group, :categories)" do
  describe "GET" do

    before(:each) do
      @response = request(resource(Group.first, :categories))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of categories" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul")
    end

  end

  describe "GET", :given => "a category exists" do
    before(:each) do
      @response = request(resource(Group.first, :categories))
    end

    it "has a list of categories" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul/li")
    end
  end

end

describe "resource(@group, @category)", :given => "a category exists" do

  describe "GET" do
    before(:each) do
      @category = Category.first
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end
end

