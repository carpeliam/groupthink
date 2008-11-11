require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Document do
  it "should be invalid without a title" do
    doc = Document.make :title => nil
    doc.should_not be_valid
    doc.title = Document.make.title
    doc.should be_valid
  end
  
  it "should have a title 100chars or less" do
    doc = Document.make :title => 'a' * 101
    doc.should_not be_valid
    doc.title = 'a' * 100
    doc.should be_valid
  end
  
  it "should be invalid without a body" do
    doc = Document.make :body => nil
    doc.should_not be_valid
    doc.body = Document.make.body
    doc.should be_valid
  end
  
  it "should be invalid without a group" do
    doc = Document.make :group => nil
    doc.should_not be_valid
    g = Group.generate
    g.users << doc.author
    doc.group = g
    doc.should be_valid
  end
  
  it "should be invalid without an author" do
    doc = Document.make :author => nil
    doc.should_not be_valid
    doc.author = doc.group.leader
    doc.should be_valid
  end
  
  it "should be valid if it has all attributes" do
    doc = Document.make
    doc.should be_valid
  end
  
  it "should be versioned" do
    # this is good enough for me, let's not actually test dm-is-versioned
    Document.new.should respond_to(:versions)
  end
  
  it "should be created by someone in its group" do
    our_group = Group.make
    their_group = Group.make
    doc = Document.make
    doc.author = their_group.leader
    doc.group = our_group
    doc.should_not be_valid
    doc.author = our_group.leader
    doc.should be_valid
  end
  
  it "author can leave group after doc is created and doc will still be valid" do
    doc = Document.generate
    doc.group.users.delete doc.author
    doc.should be_valid
  end

end
