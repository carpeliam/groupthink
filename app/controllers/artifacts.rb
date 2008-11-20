class Artifacts < Application
  before :ensure_authenticated, :exclude => [:index, :show, :diff]
  # provides :xml, :yaml, :js
  before :get_group

  def index
    @artifacts = @group.artifacts
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
    @artifact = @group.artifacts.new
    display @artifact
  end

  def edit(id)
    only_provides :html
    @artifact = Artifact.get(id)
    raise NotFound unless @artifact
    display @artifact
  end

  def create(artifact)
    @artifact = @group.artifacts.new(artifact)
    @artifact.author = session.user
    @artifact.attachment = params[:attachment]

    if @artifact.save
      redirect resource(@group, @artifact), :message => {:notice => "Artifact was successfully created"}
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
      redirect resource(@group, @artifact)
    else
      display @artifact, :edit
    end
  end

  def destroy(id)
    @artifact = Artifact.get(id)
    raise NotFound unless @artifact
    if @artifact.destroy
      redirect resource(@group, :artifacts)
    else
      raise InternalServerError
    end
  end

  private
  def get_group
    @group = Group.first(:grouplink => params[:grouplink])
    raise NotFound unless @group
  end

end # Artifacts

