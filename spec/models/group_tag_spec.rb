require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe GroupTag do

  it "should be private by default" do
    g = GroupTag.new
    g.state.should == 'private'
  end

  it "should should transition to public" do
    g = GroupTag.new
    g.publicize!
    g.state.should == 'public'
  end

  it "should should transition back to private" do
    g = GroupTag.new
    g.publicize!
    g.privatize!
    g.state.should == 'private'
  end
end
