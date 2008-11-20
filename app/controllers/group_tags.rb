class GroupTags < Application
  # provides :xml, :yaml, :js
  before :get_group

  def index
    @group_tags = @group.group_tags.all
    display @group_tags
  end

  def show(id)
    @group_tag = GroupTag.get(id)
    raise NotFound unless @group_tag
    display @group_tag
  end

#  def new
#    only_provides :html
#    @group_tag = GroupTag.new
#    display @group_tag
#  end

  def edit(id)
    only_provides :html
    @group_tag = GroupTag.get(id)
    raise NotFound unless @group_tag
    display @group_tag
  end
  
  def publicize(id)
    @group_tag = GroupTag.get(id)
    @group_tag.publicize!
    @group_tag.save
  end

  def privatize(id)
    @group_tag = GroupTag.get(id)
    @group_tag.privatize!
    @group_tag.save
  end

#  def create(group_tag)
#    @group_tag = GroupTag.new(group_tag)
#    if @group_tag.save
#      redirect resource(@group_tag), :message => {:notice => "GroupTag was successfully created"}
#    else
#      message[:error] = "GroupTag failed to be created"
#      render :new
#    end
#  end

  def update(id, group_tag)
    @group_tag = GroupTag.get(id)
    raise NotFound unless @group_tag
    if @group_tag.update_attributes(group_tag)
       redirect resource(@group, @group_tag)
    else
      display @group_tag, :edit
    end
  end

#  def destroy(id)
#    @group_tag = GroupTag.get(id)
#    raise NotFound unless @group_tag
#    if @group_tag.destroy
#      redirect resource(:group_tags)
#    else
#      raise InternalServerError
#    end
#  end

  private
  def get_group
    @group = Group.first(:grouplink => params[:grouplink])
    raise NotFound unless @group
  end
end # GroupTags
