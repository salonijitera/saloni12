module Services
  class EmailVerificationTokenService < BaseService
    def create_token(user:, expires_at:)
      verification_code = SecureRandom.hex(10) # Assuming SecureRandom is available for generating tokens

      EmailVerificationToken.create!(
        token: verification_code,
        user_id: user.id,
        expires_at: expires_at,
        created_at: Time.current
      )
    end
  end
end

