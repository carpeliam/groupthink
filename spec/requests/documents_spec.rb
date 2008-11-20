require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

Group.generate unless Group.count > 0

given "a document exists" do
  Document.all.destroy!
  get_document
end

given "a group user is logged in" do
  login_as_group_user
end

context "when logged in as group member", :given => "a group user is logged in" do
  describe "resource(@group, :documents)" do
    describe "a successful POST" do
      before(:each) do
        @group = get_group
        Document.all.destroy!
        @response = request(resource(@group, :documents), :method => "POST", 
          :params => { :document => Document.generate_attributes(:request_safe) })
      end
      
      it "redirects to resource(@group, @document)" do
        @response.should redirect_to(resource(@group, Document.first), :message => {:notice => "document was successfully created"})
      end
      
    end
  end

  describe "resource(@group, :documents, :new)" do
    before(:each) do
      @response = request(resource(get_group, :documents, :new))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @document, :edit)", :given => "a document exists" do
    before(:each) do
      @response = request(resource(get_group, get_document, :edit))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @document)", :given => "a document exists" do
    describe "PUT" do
      before(:each) do
        sleep 1 # to make sure updated_at is unique
        @version_count = get_document.versions.size
        @response = request(resource(get_group, get_document), :method => "PUT", 
          :params => {:document => {:title => 'Groupthink rocks', :body => (get_document.body + 'unique')} })
      end
    
      it "redirects to the show action" do
        @response.should redirect_to(resource(get_group, get_document))
      end
      
      it "increments the version count" do
        get_document.versions.size.should == @version_count + 1
      end
    end
    
    describe "a successful DELETE" do
       before(:each) do
         @response = request(resource(get_group, get_document), :method => "DELETE")
       end

       it "should redirect to the index action" do
         @response.should redirect_to(resource(get_group, :documents))
       end

     end
  end
end

describe "resource(@group, :documents)" do
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
end

describe "resource(@group, @document)", :given => "a document exists" do
  
  describe "GET" do
    before(:each) do
      @document = Document.first
      @group = Group.get @document.group.id
      @response = request(resource(@group, @document))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
end

describe "resource(@group, @document, :diff)", :given => "a document exists" do
  
  describe "GET" do
    before(:each) do
      @document = Document.first
      @document.body += 'a'
      sleep 1 # to make sure updated_at is unique
      @document.save # create a version
      @group = Group.get @document.group.id
      @response = request(resource(@group, @document, :diff, :version => 1))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
end
