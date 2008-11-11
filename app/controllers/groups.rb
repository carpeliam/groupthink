class Groups < Application
  before :ensure_authenticated, :exclude => [:index, :show]
  # provides :xml, :yaml, :js

  def index
    @groups = Group.all
    display @groups
  end

  def show(id)
    @group = Group.get(id)
    raise NotFound unless @group
    display @group
  end

  def new
    only_provides :html
    @group = Group.new
    display @group
  end

  def edit(id)
    only_provides :html
    @group = Group.get(id)
    raise NotFound unless @group
    display @group
  end

  def create(group)
    @group = Group.new(group)
    @group.users << session.user
    @group.leader = session.user
    if @group.save
      redirect resource(@group), :message => {:notice => "Group was successfully created"}
    else
      message[:error] = "Group failed to be created"
      render :new
    end
  end

  def update(id, group)
    @group = Group.get(id)
    raise NotFound unless @group
    if @group.update_attributes(group)
       redirect resource(@group)
    else
      display @group, :edit
    end
  end
  
  def join(id)
    @group = Group.get(id)
    raise NotFound unless @group
    @group.users << session.user
    redirect resource(@group), :message => (@group.save) ?
        {:notice => "You were successfully added to the group"} :
        {:notice => "Sorry, that didn't work out"}
  end

  def leave(id)
    @group = Group.get(id)
    raise NotFound unless @group
    @group.users.delete session.user
    redirect resource(@group), :message => (@group.save) ?
        {:notice => "Sorry to see you go"} :
        {:notice => "Looks like you're stuck here"}
  end

  def destroy(id)
    @group = Group.get(id)
    raise NotFound unless @group
    if @group.destroy
      redirect resource(:groups)
    else
      raise InternalServerError
    end
  end

end # Groups
