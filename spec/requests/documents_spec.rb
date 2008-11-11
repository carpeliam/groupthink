require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a group exists" do
  Group.all.destroy!
  #create_group
  Group.generate
end

given "a document exists" do
  Document.all.destroy!
  Document.generate
end

given "a group user is logged in" do
  login_as_group_user
end

given "a group user is logged in and a document exists" do
  login_as_group_user
  create_document
end

describe "resource(@group, :documents)", :given => "a group exists" do
  describe "GET" do
    
    before(:each) do
      @group = Group.first
      @response = request(resource(@group, :documents))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of documents" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a document exists" do
    before(:each) do
      @group = Group.first
      @response = request(resource(@group, :documents))
    end
    
    it "has a list of documents" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST", :given => "a group user is logged in" do
    before(:each) do
      @group = Group.first
      Document.all.destroy!
      @response = request(resource(@group, :documents), :method => "POST", 
        :params => { :document => Document.generate_attributes(:request_safe) })
    end
    
    it "redirects to resource(@group, :documents)" do
      @response.should redirect_to(resource(@group, Document.first), :message => {:notice => "document was successfully created"})
    end
    
  end
end

describe "resource(@group, :documents, :new)", :given => "a group user is logged in" do
  before(:each) do
    @response = request(resource(Group.first, :documents, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@group, @document, :edit)", :given => "a group user is logged in and a document exists" do
  before(:each) do
    @response = request(resource(get_group, get_document, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@group, @document)", :given => "a group user is logged in and a document exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Group.first, Document.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @doc = get_document
      @response = request(resource(get_group, @doc), :method => "PUT", 
        :params => { :document => Document.generate_attributes(:request_safe) })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(get_group, @doc))
    end
  end
end

describe "resource(@group, @document)" do
  describe "a successful DELETE", :given => "a group user is logged in and a document exists" do
     before(:each) do
       @response = request(resource(get_group, get_document), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(get_group, :documents))
     end

   end
end
