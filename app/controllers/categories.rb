class Categories < Application
  before :ensure_authenticated, :exclude => [:index, :show]
  # provides :xml, :yaml, :js
  before :get_group

  def index
    @categories = @group.categories
    display @categories
  end

  def show(id)
    @category = Category.get(id)
    raise NotFound unless @category
    display @category
  end

  def new
    only_provides :html
    @category = @group.categories.new
    display @category
  end

  def edit(id)
    only_provides :html
    @category = Category.get(id)
    raise NotFound unless @category
    display @category
  end

  def create(category)
    @category = @group.categories.new(category)
    if @category.save
      redirect resource(@group, @category),
        :message => {:notice => "Category was successfully created"}
    else
      message[:error] = "Category failed to be created"
      render :new
    end
  end

  def update(id, category)
    @category = Category.get(id)
    raise NotFound unless @category
    if @category.update_attributes(category)
       redirect resource(@group, @category)
    else
      display @category, :edit
    end
  end

  def destroy(id)
    @category = Category.get(id)
    raise NotFound unless @category
    if @category.destroy
      redirect resource(@group, :categories)
    else
      raise InternalServerError
    end
  end

  private
  def get_group
    @group = Group.get(params[:group_id])
    raise NotFound unless @group
  end
end # Categories
