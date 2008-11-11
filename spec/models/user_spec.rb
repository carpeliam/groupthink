require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do
  
  it "should be invalid without a login" do
    user = User.make :login => nil
    user.should_not be_valid
    user.login = Faker::Internet.user_name
    user.should be_valid
  end
  
  it "should require logins to be unique" do
    user = User.generate
    user2 = User.make :login => user.login
    user2.should_not be_valid
    user2.login += ' but not'
    user2.should be_valid
  end
  
  # merb-auth responsible for password checking
  
  it "should be valid if it has all attributes" do
    user = User.make
    user.should be_valid
  end

end
