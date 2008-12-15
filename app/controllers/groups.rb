class Groups < Application
  before :ensure_authenticated, :exclude => [:index, :show]
  # provides :xml, :yaml, :js

  def index
    @groups = Group.paginate :page => (params[:page] or 1)
    display @groups
  end

  def show(grouplink)
    @group = Group.first(:grouplink => grouplink)
    raise NotFound unless @group
    display @group
  end

  def new
    only_provides :html
    @group = Group.new
    display @group
  end

  def edit(grouplink)
    only_provides :html
    @group = Group.first(:grouplink => grouplink)
    raise NotFound unless @group
    display @group
  end

  def create(group)
    @group = Group.new(group)
    @group.users << session.user
    @group.leader = session.user
    if @group.save
      @group.reload # :/ otherwise slug won't be set correctly
      redirect resource(@group), :message => {:notice => "Group was successfully created"}
    else
      message[:error] = "Group failed to be created"
      render :new
    end
  end

  def update(grouplink, group)
    @group = Group.first(:grouplink => grouplink)
    raise NotFound unless @group
    if @group.update_attributes(group)
      @group.reload
      redirect resource(@group)
    else
      display @group, :edit
    end
  end
  
  def join(grouplink)
    @group = Group.first(:grouplink => grouplink)
    raise NotFound unless @group
    @group.users << session.user
    redirect resource(@group), :message => (@group.save) ?
        {:notice => "You were successfully added to the group"} :
        {:error => "Sorry, that didn't work out"}
  end

  def leave(grouplink)
    @group = Group.first(:grouplink => grouplink)
    raise NotFound unless @group
    @group.users.delete session.user
    redirect resource(@group), :message => (@group.save) ?
        {:notice => "Sorry to see you go"} :
        {:error => "Looks like you're stuck here"}
  end

  def destroy(grouplink)
    @group = Group.first(:grouplink => grouplink)
    raise NotFound unless @group
    if @group.destroy
      redirect resource(:groups)
    else
      raise InternalServerError
    end
  end

end # Groups
