class Api::UsersController < Api::BaseController
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

  private

  def validate_registration_params(params)
    raise ArgumentError, "Username is required." if params[:username].blank?
    raise ArgumentError, "Invalid email format." unless EmailValidator.valid?(params[:email])
    raise ArgumentError, "Password must be at least 8 characters long." unless PasswordValidator.valid?(params[:password])
  end
end
