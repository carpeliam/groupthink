require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Artifact do

  it "should be invalid without a title" do
    artifact = Artifact.make :title => nil
    artifact.should_not be_valid
    artifact.title = Artifact.make.title
    artifact.should be_valid
  end
  
  it "should have  a title 100chars or less" do
    artifact = Artifact.make :title => 'a' * 101
    artifact.should_not be_valid
    artifact.title = 'a' * 100
    artifact.should be_valid
  end
  
  it "should be invalid without a description" do
    artifact = Artifact.make :description => nil
    artifact.should_not be_valid
    artifact.description = Artifact.make.description
    artifact.should be_valid
  end
  
  it "should have  a description 255chars or less" do
    artifact = Artifact.make :description => 'a' * 256
    artifact.should_not be_valid
    artifact.description = 'a' * 255
    artifact.should be_valid
  end
  
  it "should be invalid without a group" do
    artifact = Artifact.make :group => nil
    artifact.should_not be_valid
    group = Group.generate
    group.users << artifact.author
    artifact.group = group
    artifact.should be_valid
  end
  
  it "should be invalid without an author" do
    artifact = Artifact.make :author => nil
    artifact.should_not be_valid
    artifact.author = artifact.group.leader
    artifact.should be_valid
  end
  
  it "should be valid if it has all attributes" do
    artifact = Artifact.make
    artifact.should be_valid
  end
  
  it "should be versioned" do
    # this is good enough for me, let's not actually test dm-is-versioned
    Artifact.new.should respond_to(:versions)
  end
  
  it "should be created by someone in its group" do
    our_group = Group.make
    their_group = Group.make
    artifact = Artifact.make
    artifact.author = their_group.leader
    artifact.group = our_group
    artifact.should_not be_valid
    artifact.author = our_group.leader
    artifact.should be_valid
  end
  
  it "author can leave group after artifact is created and artifact will still be valid" do
    artifact = Artifact.generate
    artifact.group.users.delete artifact.author
    artifact.should be_valid
  end
  
  it "should support uploading files"

end
