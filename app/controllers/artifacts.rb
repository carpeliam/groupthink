class Artifacts < Application
  # provides :xml, :yaml, :js
  before :get_category

  def index
    @artifacts = @category.artifacts
    display @artifacts
  end

  def show(id)
    @artifact = Artifact.get(id)
    raise NotFound unless @artifact
    if params[:version]
      version = params[:version].to_i
      raise NotFound unless (1..@artifact.versions.size).include? version
      @version = @artifact.versions[version - 1]
    end
    display @artifact
  end

  def diff(id)
    show(id)
  end

  def new
    only_provides :html
    @artifact = @category.artifacts.new
    display @artifact
  end

  def edit(id)
    only_provides :html
    @artifact = Artifact.get(id)
    raise NotFound unless @artifact
    display @artifact
  end

  def create(artifact)
    @artifact = @category.artifacts.new(artifact)
    @artifact.author = session.user
    @artifact.attachment = params[:attachment]
    if @artifact.save
      #TODO replace group with @category.group when DM works
      group = Group.get @category.group.id
      redirect resource(group, @category, @artifact), :message => {:notice => "Artifact was successfully created"}
    else
      message[:error] = "Artifact failed to be created"
      render :new
    end
  end

  def update(id, artifact)
    @artifact = Artifact.get(id)
    raise NotFound unless @artifact
    @artifact.attachment = params[:attachment]
    if @artifact.update_attributes(artifact)
      #TODO replace @group with @category.group when DM works
      @group = Group.get @category.group.id
      redirect resource(@group, @category, @artifact)
    else
      display @artifact, :edit
    end
  end

  def destroy(id)
    @artifact = Artifact.get(id)
    raise NotFound unless @artifact
    if @artifact.destroy
      #TODO replace @group with @category.group when DM works
      @group = Group.get @category.group.id
      redirect resource(@group, @category, :artifacts)
    else
      raise InternalServerError
    end
  end

  private
  def get_category
    @category = Category.get(params[:category_id])
    raise NotFound unless @category
  end

end # Artifacts

