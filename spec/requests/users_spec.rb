require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a user exists" do
  User.generate if User.count(:login.not => 'liam') == 0
end

given "user is admin" do
  pending "authz"
end

context "when logged in", :given => "a user is logged in" do
  describe "resource(:users)" do
    describe "POST when logged in" do
      before(:each) do
        @response = request(resource(:users), :method => "POST", 
          :params => { :user => User.generate_attributes})
      end
      
      it "renders with a message, you're already logged in" do
        pending "let's not be able to create a new user if we're already logged in"
      end
    end
  end # resource(:users)

  describe "resource(@user, :edit)" do
    describe "edit ourselves" do
      before(:each) do
        @response = request(resource(get_user, :edit))
      end
      
      it "responds successfully" do
        @response.should be_successful
      end
    end
    
    describe "edit someone else", :given => "a user exists" do
      before(:each) do
        @response = request(resource(User.first(:login.not => get_user.login), :edit))
      end
      
      it "should scold us" do
        pending "authz"
      end
      it "should fail" do
        pending "authz"
      end
    end
  end # resource(@user, :edit)
  
  describe "resource(@user)" do
    describe "GET profile page" do
      before(:each) do
        @response = request(resource(User.first))
      end
      
      it "responds successfully" do
        @response.should be_successful
      end
    end # GET
    
    describe "PUT" do
      describe "ourselves" do
        before(:each) do
          @user = get_user
          @response = request(resource(@user), :method => "PUT", 
            :params => { :user => User.generate_attributes.merge(:login => @user.login) })
        end
      
        it "redirect to our profile" do
          @response.should redirect_to(resource(@user))
        end
      end
      
      describe "someone else" do
        it "should scold us" do
          pending "authz"
        end
        it "should fail" do
          pending "authz"
        end
      end
    end # PUT

    describe "DELETE" do
      describe "ourselves" do
        before(:each) do
          @response = request(resource(get_user), :method => "DELETE")
        end

        it "should redirect to the index action" do
          @response.should redirect_to(resource(:users))
        end
         
        it "should log you out" do
          pending "how do we get the session?"
          @response.session.should_not be_authenticated
        end
      end
      
      describe "someone else" do
        it "should scold you" do
          pending "authz"
        end
        it "should fail" do
          pending "authz"
        end
      end
      
    end # DELETE
  end # resource(@user)
  
end

context "when not logged in" do
  describe "resource(:users)" do
    describe "GET" do
      
      before(:each) do
        @response = request(resource(:users))
      end
      
      it "redirects you to home page" do
        pending "authz"
      end
    end
    
    describe "a successful POST" do
      before(:each) do
        User.all.destroy!
        @response = request(resource(:users), :method => "POST", 
          :params => { :user => User.generate_attributes})
      end
      
      it "redirects to login page" do
        @response.should redirect_to(url(:login), :message => {:notice => "user was successfully created"})
      end
    end
  end
  
  describe "resource(:users, :new)" do
    before(:each) do
      @response = request(resource(:users, :new))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe "resource(@user, :edit)", :given => "a user exists" do
    before(:each) do
      @response = request(resource(User.first, :edit))
    end
    
    it "scolds us" do
      pending "do we have messages like this yet?"
    end
    
    it "fails" do
      @response.should_not be_successful
    end
  end # resource(@user, :edit)
  
  describe "resource(@user)", :given => "a user exists" do
    describe "GET" do
      before(:each) do
        @response = request(resource(User.first))
      end
    
      it "responds successfully" do
        @response.should be_successful
      end
    end

    describe "PUT" do
      before(:each) do
        @user = User.first
        @response = request(resource(@user), :method => "PUT", 
          :params => { :user => User.generate_attributes.merge(:login => @user.login) })
      end
      
      it "should scold us" do
        pending
      end
      it "should fail" do
        @response.should_not be_successful
      end
    end # PUT

    describe "DELETE" do
      before(:each) do
        @response = request(resource(User.first), :method => "DELETE")
      end
      
      it "should scold you" do
        pending
      end
      it "should fail" do
        @response.should_not be_successful
      end
    end # DELETE
  end # resource(@user)
  
end # when not logged in

context "when admin", :given => "user is admin" do
  describe "resource(:users)" do
    describe "GET" do
      
      before(:each) do
        @response = request(resource(:users))
      end
      
      it "responds successfully" do
        pending "well it does, but this is only because it does regardless"
        @response.should be_successful
      end

      it "contains a list of users" do
        pending "haven't decided what this should look like yet"
        @response.should have_xpath("//ul/li")
      end
    end
  end
end # when admin
