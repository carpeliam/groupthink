require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Document do
  before(:each) do
    Document.all.destroy!
    GroupTag.all.destroy!
    Tag.all.destroy!
    Tagging.all.destroy!
  end
  
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
    group = Group.generate
    group.users << doc.author
    doc.group = group
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

  it "should create a grouptag after it's tagged" do
    group = get_group
    doc = get_document
    doc.category_list = 'sex, drugs, rock and roll'
    doc.save
    GroupTag.count.should == 3
    gtags = GroupTag.all
    gtags.each{|gt| gt.group.should == group }
    gtags.map{|gt| gt.tag.name }.sort.should == ['drugs', 'rock and roll', 'sex']
  end
  
  it "should remove grouptags after they aren't relevant" do
    doc = get_document
    doc.category_list = 'sex, drugs, rock and roll'
    doc.save
    doc.category_list = 'rock and roll, awesome'
    doc.save
    GroupTag.count.should == 2
    gtags = GroupTag.all
    gtags.map{|gt| gt.tag.name }.sort.should == ['awesome', 'rock and roll']
  end
  
  it "should only remove grouptags in this group" do
    group = get_group
    doc = get_document
    doc.category_list = 'my, categories'
    doc.save
    d2 = Document.generate
    d2.category_list = 'their, categories'
    d2.save
    GroupTag.count.should == 4
    Tag.count.should == 3
    doc.category_list = 'my, list, changed'
    doc.save
    GroupTag.count.should == 5
    group.group_tags.count.should == 3
    d2.group.group_tags.count.should == 2
    group.group_tags.map{|gt| gt.tag.name }.sort.should == ['changed', 'list', 'my']
    d2.group.group_tags.map{|gt| gt.tag.name }.sort.should == ['categories', 'their']
  end
end
