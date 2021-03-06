require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a group exists" do
  Group.all.each {|g| g.destroy }
  Group.generate
end

context "when logged in", :given => 'a user is logged in' do
  describe "resource(:groups, :new)" do
    before(:each) do
      @response = request(resource(:groups, :new))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "joining a group", :given => 'a group exists' do
    before(:each) do
      @response = request(resource(Group.first, :join), :method => "PUT")
    end
    
    it "should redirect to the group page" do
      @response.should redirect_to(resource(Group.first), :message => {:notice => "You were successfully added to the group"})
    end
  end
end

context "when logged in as group member", :given => "a group user is logged in" do
  describe "resource(:groups)" do
    describe "a successful POST" do
      before(:each) do
        Group.all(:id.not => get_group.id).each {|g| g.destroy }
        @response = request(resource(:groups), :method => "POST",
          :params => { :group => Group.generate_attributes(:request_safe) })
      end

      it "redirects to resource(@group)" do
        @response.should redirect_to(resource(Group.first(:id.not => get_group.id)), :message => {:notice => "group was successfully created"})
      end

    end
  end
  
  describe "resource(@group)" do
    describe "PUT", :given => "a group user is logged in" do
      before(:each) do
        @response = request(resource(Group.first), :method => "PUT",
          :params => { :group => Group.generate_attributes(:request_safe) })
      end

      it "redirect to the show action" do
        @response.should redirect_to(resource(Group.first))
      end
    end
    
    describe "a successful DELETE" do
      before(:each) do
        @response = request(resource(get_group), :method => "DELETE")
      end

      it "should redirect to the index action" do
        @response.should redirect_to(resource(:groups))
      end
    end
  end

  describe "resource(@group, :edit)" do
    before(:each) do
      @response = request(resource(Group.first, :edit))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, :leave)" do
    before(:each) do
      @response = request(resource(Group.first, :leave), :method => "PUT")
    end
    
    it "should redirect to the group page" do
      @response.should redirect_to(resource(Group.first), :message => {:notice => "Sorry to see you go"})
    end
  end
end

describe "resource(:groups)" do
  describe "GET" do

    before(:each) do
      @response = request(resource(:groups))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of groups" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul")
    end

  end

  describe "GET", :given => "a group exists" do
    before(:each) do
      @response = request(resource(:groups))
    end

    it "has a list of groups" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul/li")
    end
  end
end

describe "resource(@group)", :given => "a group exists" do
  describe "GET" do
    before(:each) do
      @response = request(resource(Group.first))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end
end

