class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    if @post.save
      flash[:notice] = "Your post was saved successfully!"
      redirect_to post_path(@post)
    else
      flash[:notice] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    if @post.update(title: @post.title, body: @post.body)
      flash[:notice] = "Post was updated successfully!"
    #  byebug
      redirect_to @post
    else
      flash[:error] = "There was a problem updating post. Please try again."

      render[:edit]
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy

      flash[:notice] = "The post was deleted."
      redirect_to posts_path
    #  byebug
    else
      flash[:error] = "There was an error deleting the post. Please try again."
      render :show
    end
  end

end
