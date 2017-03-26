class SuperAdmin::BlogController < SuperAdmin::BaseController
  before_action :set_post, only:[:edit, :update, :destroy]

  def index
    @posts = Blog::Post.all
  end

  def new
    @post = Blog::Post.new
  end

  def create
    @post = Blog::Post.new(post_params)

    if @post.save
      redirect_to super_admin_blog_index_path, notice: t(:new_post_successfully_created)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to super_admin_blog_index_path, notice: t(:post_successfully_update)
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      redirect_to super_admin_blog_index_path, notice: t(:blog_post_deleted)
    else
      redirect_to super_admin_blog_index_path, notice: t(:blog_post_could_not_be_deleted)
    end
  end

  private

  def post_params
    params.require(:blog_post).permit(:title, :content, :cover_image).merge(user_id: current_super_admin.id)
  end

  def set_post
    @post = Blog::Post.find(params[:id])
  end
end
