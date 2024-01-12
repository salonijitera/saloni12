class EmailVerificationService < BaseService
  def verify_email(user_id, verification_code)
    user = User.find_by(id: user_id)
    raise 'User not found' unless user

    token = EmailVerificationToken.find_by(user_id: user_id, token: verification_code)
    raise 'Verification code is invalid or expired' if token.nil? || token.expires_at < Time.current

    User.transaction do
      user.update!(is_email_verified: true)
      token.destroy!
    end

    { message: 'Email successfully verified.' }
  rescue ActiveRecord::RecordNotFound => e
    { error: e.message }
  rescue => e
    { error: 'An unexpected error occurred.' }
  end
end

# Import the necessary models at the top of the file
# Note: In Rails, it is not necessary to explicitly require models, as they are loaded automatically.
# However, if for some reason you need to require them, you would do it like this:
# require_dependency 'app/models/user'
# require_dependency 'app/models/email_verification_token'
# But again, this is not typically necessary in a standard Rails application.

