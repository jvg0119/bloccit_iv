class PostsController < ApplicationController
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
    # @post = @topic.posts.new # does not matter if associated or not
    @post = Post.new
  end

  def create
    # these 2 are also OK
    # @topic = Topic.find(params[:topic_id])
    # @post = @topic.posts.new

    @post = Post.new
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]

    @topic = Topic.find(params[:topic_id])
    @post.topic = @topic

    if @post.save
      flash[:notice] = "Your post was saved successfully!"
      #redirect_to post_path(@post) # w/o nesting
      #redirect_to topic_post_path(@topic, @post)
      redirect_to [@topic, @post] #shortcut
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
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]

    if @post.update(title: @post.title, body: @post.body)
      flash[:notice] = "Post was updated successfully!"
    #  byebug
    #  redirect_to @post # w/o nesting
      redirect_to [@post.topic, @post]
    #  redirect_to [@topic, @post]
    else
      flash[:error] = "There was a problem updating post. Please try again."
      render[:edit]
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "The post was deleted."
      # redirect_to posts_path
      #redirect_to(@post.topic)  # topic show page
      redirect_to(topic_path(@post.topic))
    else
      flash[:error] = "There was an error deleting the post. Please try again."
      render :show
    end
  end

end
