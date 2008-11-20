require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "an artifact exists" do
  Artifact.all.destroy!
  get_artifact
end

context "when logged in", :given => "a group user is logged in" do
  describe "resource(@group, :artifacts)" do
    describe "a successful POST" do
      before(:each) do
        pending
        @group = get_group
        Artifact.all.destroy!
        
        @response = multipart_post(resource(@group, :artifacts),
        {:artifact => Artifact.generate_attributes(:request_safe),
        :attachment => File.new(__FILE__)})
      end

      it "redirects to resource(@group, @artifact)" do
        @response.should redirect_to(resource(@group, Artifact.first), :message => {:notice => "artifact was successfully created"})
      end

      it "should upload the file to the server" do
        File.should be_file(Merb.root / 'public' / 'attachments' / Artifact.first.id.to_s / 'original' / File.basename(__FILE__))
      end
      
      after(:each) do
        FileUtils.rm_rf(Merb.root / 'public' / 'attachments' / Artifact.first.id.to_s)
      end

    end
  end

  describe "resource(@group, :artifacts, :new)" do
    before(:each) do
      @group = get_group
      @response = request(resource(@group, :artifacts, :new))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@group, @artifact)", :given => "an artifact exists" do
    describe "PUT" do
      before(:each) do
        pending
        @group = get_group
        @artifact = get_artifact
        
        @root = Merb.root / 'public' / 'attachments' / @artifact.id.to_s
        
        @response = multipart_put(resource(@group, @artifact),
        {:artifact => Artifact.generate_attributes(:request_safe),
        :attachment => File.new(__FILE__)})
      end

      it "should redirect to the artifact show action" do
        @response.should redirect_to(resource(@group, @artifact))
      end
      
      it "should upload the file to the server" do
        File.should be_file(@root / 'original' / File.basename(__FILE__))
      end
      
      after(:each) do
        FileUtils.rm_rf(@root)
      end
    end
    describe "a successful DELETE" do
      before(:each) do
        @group = get_group
        @artifact = get_artifact
        @response = request(resource(@group, @artifact), :method => "DELETE")
      end

      it "should redirect to the index action" do
        @response.should redirect_to(resource(@group, :artifacts))
      end

    end
  end

  describe "resource(@group, @artifact, :edit)", :given => "an artifact exists" do
    before(:each) do
      @group = get_group
      @artifact = get_artifact
      @response = request(resource(@group, @artifact, :edit))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

end

describe "resource(@group, :artifacts)" do
  describe "GET" do

    before(:each) do
      @group = Group.first
      @response = request(resource(@group, :artifacts))
    end

    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of artifacts" do
      pending
      @response.should have_xpath("//ul")
    end

  end

  describe "GET", :given => "an artifact exists" do
    before(:each) do
      @group = Group.first
      @response = request(resource(@group, :artifacts))
    end

    it "has a list of artifacts" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end

end


describe "resource(@group, @artifact)", :given => "an artifact exists" do

  describe "GET" do
    before(:each) do
      @group = Group.first
      @response = request(resource(@group, Artifact.first))
    end

    it "responds successfully" do
      @response.should be_successful
    end
  end

end

