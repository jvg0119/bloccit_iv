class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user # finds user based on token passed
  before_action :authorize_user # ensures user is an admin

  def show
    user = User.find(params[:id])
    render json: user, status: 200
  end

  def index
    users = User.all
    render json:  users, status: 200
  end



end
