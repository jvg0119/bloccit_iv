class VotesController < ApplicationController
  before_action :require_sign_in
  #before_action :set_vote

  # def up_vote
  #   #raise
  #   @post = Post.find(params[:post_id]) # finds the post that's being voted
  #   @vote = @post.votes.where(user_id: current_user.id ).first
  #           # @post.votes is the number of votes on this post
  #           # .where(user_id: current_user) # by this user (the current_user)
  #           # it can only be 1 or 0 votes because user can only vote on a post once
  #   if @vote  # if the current_user has voted on this post
  #     @vote.update_attribute(:value, 1) # his vote is updating the value to 1 (whether it's 1 or -1 it now becomes 1)
  #   else # current_user has not voted on this post
  #     @vote = @post.votes.create(value: 1, user: current_user) # create a vote for this post w/ the current_user
  #   end
  #   redirect_back(fallback_location: root_path)
  # end
  #
  # def down_vote
  #   @post = Post.find(params[:post_id])
  #   @vote = @post.votes.where(user_id: current_user.id).first
  #   if @vote
  #     @vote.update_attribute(:value, -1) # value will now become -1 whether it was 1 or -1
  #   else
  #     @vote = @post.votes.create(value: -1, user: current_user) # creates a vote w/ value -1
  #   end
  #   redirect_back(fallback_location: root_path)
  # end


  def up_vote
    update_vote(1)
    redirect_back(fallback_location: root_path)
  end

  def down_vote
    update_vote(-1)
    redirect_back(fallback_location: root_path)
  end

  private

  def update_vote(new_value)
    @post = Post.find(params[:post_id]) # finds the post that's being voted
    @vote = @post.votes.where(user_id: current_user.id ).first
    if @vote
      @vote.update_attribute(:value, new_value) # value will now become -1 whether it was 1 or -1
    else
      @vote = @post.votes.create(value: new_value, user: current_user) # creates a vote w/ value -1
    end
  end

end
