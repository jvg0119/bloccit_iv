class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      create_session(user) #session[:user_id] = user.id
      flash[:notice] = "Welcome #{user.name}."
      redirect_to root_url
    else
      flash.now[:alert] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    destroy_session(current_user) # session[:user_id] = nil
    flash[:notice] = "You've been signed out, come back soon!"
    redirect_to root_path
  end

end
