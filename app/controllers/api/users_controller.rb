class Api::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:register]
  before_action :set_user, only: [:update]
  before_action :authorize_user, only: [:update]

  def register
    begin
      validate_registration_params(params)

      result = UserService.new.register(
        username: params[:username],
        email: params[:email],
        password_hash: PasswordValidator.hash_password(params[:password])
      )

      render json: {
        status: 201,
        message: "User registered successfully.",
        user: result[:user]
      }, status: :created
    rescue ArgumentError => e
      render json: { message: e.message }, status: :bad_request
    rescue ActiveRecord::RecordNotUnique
      render json: { message: "Username or email is already in use." }, status: :conflict
    rescue => e
      render json: { message: "An unexpected error occurred on the server." }, status: :internal_server_error
    end
  end

  def update
    update_service = UserService::Update.new
    result = update_service.execute(id: params[:id], username: user_params[:username], email: user_params[:email])

    if result[:error].present?
      render json: { error: result[:error] }, status: error_status(result[:error])
    else
      render json: {
        status: 200,
        message: "Profile updated successfully.",
        user: {
          id: @user.id,
          username: @user.username,
          email: @user.email,
          updated_at: @user.updated_at.iso8601
        }
      }, status: :ok
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: "User not found." }, status: :not_found if @user.nil?
  end

  def authorize_user
    authorize @user, policy_class: ApplicationPolicy
  end

  def user_params
    params.permit(:username, :email)
  end

  def error_status(error)
    case error
    when "User not found." then :not_found
    when "Username is required.", "Invalid email format." then :bad_request
    when "The username or email is already in use by another user." then :conflict
    else :internal_server_error
    end
  end

  def validate_registration_params(params)
    raise ArgumentError, "Username is required." if params[:username].blank?
    raise ArgumentError, "Invalid email format." unless EmailValidator.valid?(params[:email])
    raise ArgumentError, "Password must be at least 8 characters long." unless PasswordValidator.valid?(params[:password])
  end
end
