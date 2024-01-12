class UserService < BaseService
  def register(username:, email:, password_hash:)
    raise ArgumentError, 'Username cannot be blank' if username.blank?
    raise ArgumentError, 'Email cannot be blank' if email.blank?
    validate_password_hash(password_hash)

    user = User.find_by(email: email)
    raise ArgumentError, 'Email has already been taken' if user.present?

    user = User.create!(
      username: username,
      email: email,
      password_hash: password_hash,
      is_email_verified: false,
      created_at: Time.current
    )

    verification_code = generate_verification_code
    EmailVerificationToken.create!(
      token: verification_code,
      user_id: user.id,
      expires_at: 24.hours.from_now,
      created_at: Time.current
    )

    send_verification_email(email, verification_code)

    { message: 'Please check your email to verify your account.' }
  end

  private

  def validate_password_hash(password_hash)
    # Assuming there's a method or regex to validate password security
    raise ArgumentError, 'Password does not meet security requirements' unless password_hash_valid?(password_hash)
  end

  def generate_verification_code
    SecureRandom.hex(10)
  end

  def send_verification_email(email, verification_code)
    # Assuming there's a method to send emails
    UserMailer.verification_email(email, verification_code).deliver_now
  end
end
