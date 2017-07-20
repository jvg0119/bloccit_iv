class PostsController < ApplicationController
  before_action :require_sign_in, except: [:show]

  # def index
  #   @posts = Post.all
  # end

  def show
    @post = Post.find(params[:id])
    #  @topic = Topic.find(params[:topic_id])
    #  @post = @topic.posts.find(params[:id])
    #  raise
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    # @topic = Topic.find(params[:topic_id])
  end

  def create
    #raise
    # @topic = Topic.find(params[:topic_id])
    # @post = @topic.posts.new

    # @post = Post.new
    # @post.title = params[:post][:title]
    # @post.body = params[:post][:body]
    #
    # @topic = Topic.find(params[:topic_id])
    # @post.topic = @topic
    # @post.user = current_user

    # @topic = Topic.find(params[:topic_id])
    # @post = @topic.posts.new(params[:post]) # forbidden mass assignment

    # this is the long way
    # @post = @topic.posts.new(params.require(:post).permit(:title, :body))
    # @post.user = current_user

    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.new(post_params) # proper use of strong parameters
    @post.user = current_user

    if @post.save
      flash[:notice] = "Your post was saved successfully!"
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:notice] = "Post was updated successfully!"
      redirect_to [@post.topic, @post]
    else
      flash[:error] = "There was a problem updating post. Please try again."
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "The post was deleted."
      # redirect_to posts_path
      redirect_to(@post.topic)
    else
      flash[:error] = "There was an error deleting the post. Please try again."
      render :show
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end

end
