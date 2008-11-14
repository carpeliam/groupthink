require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Group do
  it "should be invalid without a name" do
    group = Group.make :name => nil
    group.should_not be_valid
    group.name = Group.make.name
    group.should be_valid
  end
  
  it "should have a name 100chars or less" do
    group = Group.make :name => 'a' * 101
    group.should_not be_valid
    group.name = 'a' * 100
    group.should be_valid
  end
  
  it "should have a permalink" do
    group = Group.generate
    group.grouplink.should == Slugalizer.slugalize(group.name)
  end
  
  it "should have a unique permalink" do
    group = Group.generate
    group2 = Group.generate :name => group.name
    group2.grouplink.should == group.grouplink + '-2'
  end
  
  it "should be invalid without a leader" do
    group = Group.make :leader => nil
    group.should_not be_valid
    group.leader = group.users.first
    group.should be_valid
  end
  
  it "should delete all child categories when it's deleted" do
    cat = Category.generate
    cat.group.destroy
    Category.get(cat.id).should be_nil
  end
  
  it "should be valid if it has all attributes" do
    group = Group.make
    group.should be_valid
  end
  
  it "leader should be a member" do
    group = Group.make
    group.users.delete group.leader
    group.should_not be_valid
    group.users << group.leader
    group.should be_valid
  end

end
