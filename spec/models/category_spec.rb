require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Category do

  it "should require a name" do
    cat = Category.make :name => nil
    cat.should_not be_valid
    cat.name = "yeah, it's the name"
    cat.should be_valid
  end
  
  it "should be invalid without a group" do
    cat = Category.make :group => nil
    cat.should_not be_valid
    cat.group = Group.make
    cat.should be_valid
  end
  
  it "should delete all child documents when it's deleted" do
    doc = Document.generate
    doc.category.destroy
    Document.get(doc.id).should be_nil
  end
  
  it "should inherit the group from its parent" do
    parent = Category.generate
    child = parent.children.create :name => 'child'
    child.group.should == parent.group
  end

end
