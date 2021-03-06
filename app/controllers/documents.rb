class Documents < Application
  before :ensure_authenticated, :exclude => [:index, :show, :diff]
  provides :xml, :yaml, :js, :json
  before :get_category

  def index
    @documents = (@category.nil?) ? Document.all : @category.documents
    opts = request.xhr? ? {:template => 'documents/xhr_index', :layout => false} : {}
    display @documents, opts
  end

  def show(id)
    @version = @document = Document.get(id)
    raise NotFound unless @document
    if params[:version]
      version = params[:version].to_i
      raise NotFound unless (1..@document.versions.size).include? version
      @version = @document.versions[version - 1]
    end
    opts = request.xhr? ? {:template => 'documents/xhr_show', :layout => false} : {}
    display @document, opts
  end
  
  def diff(id)
    show(id)
  end

  def new
    only_provides :html
    @document = @category.documents.new
    display @document
  end

  def edit(id)
    only_provides :html
    @document = Document.get(id)
    raise NotFound unless @document
    display @document
  end

  def create(document)
    @document = @category.documents.new(document)
    @document.author = session.user
    if @document.save
      #TODO replace group with @category.group when DM works
      group = Group.get @category.group.id
      redirect resource(group, @category, @document),
        :message => {:notice => "Document was successfully created"}
    else
      message[:error] = "Document failed to be created"
      render :new
    end
  end
  
  def watch(id)
    @document = Document.get(id)
    Watch.create(:watcher => session.user, :watchable => @document)
      #TODO replace group with @category.group when DM works
      group = Group.get @category.group.id
    redirect resource(group, @category, @document),
      :message => {:notice => 'Looks successful, I think'}
  end

  def update(id, document)
    @document = Document.get(id)
    raise NotFound unless @document
    @document.author = session.user
    if @document.update_attributes(document)
      #TODO replace group with @category.group when DM works
      group = Group.get @category.group.id
      redirect resource(group, @category, @document)
    else
      display @document, :edit
    end
  end

  def destroy(id)
    @document = Document.get(id)
    raise NotFound unless @document
    if @document.destroy
      #TODO replace group with @category.group when DM works
      group = Group.get @category.group.id
      Merb.logger.info content_type
      case content_type
      when :json
        # FIXME escape the title
        render({:message => "#{@document.title} deleted successfully."}.to_json)
      else
        redirect resource(group, @category, :documents),
          :message => {:notice => 'Deleted successfully.'}
      end
    else
      raise InternalServerError
    end
  end
  
  def delete(id)
    show(id)
  end
  
  private
  def get_category
    @category = Category.get(params[:category_id])
    raise NotFound unless @category
  end

end # Documents
