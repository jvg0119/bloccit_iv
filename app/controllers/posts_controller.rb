class PostsController < ApplicationController
  before_action :require_sign_in, except: [:show]
  before_action :authorized_user, except: [:show, :new, :create, :edit, :update]
  before_action :moderator_user, only: [:edit, :update]
  # for the assignment cp 40 Authorization
  # added before_action :moderator_user
  # made sure it did not conflict with authorize_user

  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.new(post_params)
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

  def authorized_user
    post = Post.find(params[:id])
    unless post.user == current_user || current_user.admin?
      flash[:alert] = "You are not authorized to do this action."
      redirect_to [post.topic, post]
    end
  end

  def moderator_user
    post = Post.find(params[:id])
    unless (post.user == current_user) || current_user.moderator? || current_user.admin?
      flash[:alert] = "You are not authorized to do this action."
      redirect_to [post.topic, post]
    end
  end

end
