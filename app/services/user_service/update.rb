
# frozen_string_literal: true

module UserService
  class Update < BaseService
    def execute(id:, username:, email:)
      user = User.find_by(id: id)
      return { error: 'User not found.', status: 404 } if user.nil?

      if username.blank?
        return { error: 'Username is required.', status: 400 }
      end

      email_validator = EmailValidator.new
      unless email_validator.validate_each(user, :email, email)
        return { error: 'Invalid email format.', status: 400 }
      end

      if User.exists?(username: username) && user.username != username
        return { error: 'Username is already in use by another user.', status: 409 }
      end

      if User.exists?(email: email) && user.email != email
        return { error: 'Email is already in use by another user.', status: 409 }
      end

      user.update(username: username, email: email)

      {
        status: 200,
        message: 'Profile updated successfully.',
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          updated_at: user.updated_at.iso8601
        }
      }
    rescue StandardError => e
      { error: e.message, status: 500 }
    end
  end
end
