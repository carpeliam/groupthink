class Documents < Application
  before :ensure_authenticated, :exclude => [:index, :show, :diff]
  # provides :xml, :yaml, :js
  before :get_group

  def index
    @documents = (@group.nil?) ? Document.all : @group.documents
    display @documents
  end

  def show(id)
    @version = @document = Document.get(id)
    raise NotFound unless @document
    if params[:version]
      version = params[:version].to_i
      raise NotFound unless (1..@document.versions.size).include? version
      @version = @document.versions[version - 1]
    end
    display @document
  end
  
  def diff(id)
    show(id)
  end

  def new
    only_provides :html
    @document = Document.new
    display @document
  end

  def edit(id)
    only_provides :html
    @document = Document.get(id)
    raise NotFound unless @document
    display @document
  end

  def create(document)
    @document = @group.documents.new(document)
    @document.author = session.user
    if @document.save
      redirect resource(@group, @document), :message => {:notice => "Document was successfully created"}
    else
      message[:error] = "Document failed to be created"
      render :new
    end
  end

  def update(id, document)
    @document = Document.get(id)
    raise NotFound unless @document
    @document.author = session.user
    if @document.update_attributes(document)
       redirect resource(@group, @document)
    else
      display @document, :edit
    end
  end

  def destroy(id)
    @document = Document.get(id)
    raise NotFound unless @document
    if @document.destroy
      redirect resource(@group, :documents)
    else
      raise InternalServerError
    end
  end
  
  def delete(id)
    show(id)
  end
  
  private
  def get_group
    @group = Group.get(params[:group_id])
    raise NotFound unless @group
  end

end # Documents
