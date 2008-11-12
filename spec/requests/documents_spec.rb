require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

Category.generate unless Category.count > 0


given "a document exists" do
  Document.all.destroy!
  get_document
end

given "a group user is logged in" do
  login_as_group_user
end

context "when logged in as group member", :given => "a group user is logged in" do
  describe "resource(@group, @category, :documents)" do
    describe "a successful POST" do
      before(:each) do
        @category = get_category
        @group = get_group
        Document.all.destroy!
        @response = request(resource(@group, @category, :documents), :method => "POST", 
          :params => { :document => Document.generate_attributes(:request_safe) })
      end
      
      it "redirects to resource(@group, @category, @document)" do
        @response.should redirect_to(resource(@group, @category, Document.first), :message => {:notice => "document was successfully created"})
      end
      
    end
  end

  describe "resource(@group, @category, :documents, :new)" do
    before(:each) do
      @response = request(resource(get_group, get_category, :documents, :new))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @category, @document, :edit)", :given => "a document exists" do
    before(:each) do
      @response = request(resource(get_group, get_category, get_document, :edit))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @category, @document)", :given => "a document exists" do
    describe "PUT" do
      before(:each) do
        @response = request(resource(get_group, get_category, get_document), :method => "PUT", 
          :params => {:document => Document.generate_attributes(:request_safe).merge(:title => 'Groupthink rocks') })
      end
    
      it "redirect to the article show action" do
        @response.should redirect_to(resource(get_group, get_category, get_document))
      end
    end
    
    describe "a successful DELETE" do
       before(:each) do
         @response = request(resource(get_group, get_category, get_document), :method => "DELETE")
       end

       it "should redirect to the index action" do
         @response.should redirect_to(resource(get_group, get_category, :documents))
       end

     end
  end
end

describe "resource(@group, @category, :documents)" do
  describe "GET" do
    
    before(:each) do
      @category = Category.first
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category, :documents))
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
      @category = Category.first
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category, :documents))
    end
    
    it "has a list of documents" do
      pending "haven't decided what this should look like yet"
      @response.should have_xpath("//ul/li")
    end
  end
end

describe "resource(@group, @category, @document)", :given => "a document exists" do
  
  describe "GET" do
    before(:each) do
      @document = Document.first
      @category = Category.get @document.category.id
      @group = Group.get @category.group.id
      @response = request(resource(@group, @category, @document))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
end
