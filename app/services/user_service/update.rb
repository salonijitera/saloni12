# frozen_string_literal: true

module UserService
  class Update < BaseService
    def execute(id:, email:, password_hash:)
      user = User.find_by(id: id)
      return { error: I18n.t('activerecord.errors.messages.not_found') } if user.nil?

      if email.blank?
        return { error: I18n.t('activerecord.errors.messages.blank') }
      end

      if User.exists?(email: email)
        return { error: I18n.t('activerecord.errors.messages.taken') }
      end

      password_regex = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/
      unless password_hash.match?(password_regex)
        return { error: I18n.t('activerecord.errors.models.user.attributes.password.invalid') }
      end

      encrypted_password = User.new(password: password_hash).encrypted_password
      user.update(email: email, password_hash: encrypted_password)

      { success: I18n.t('devise.registrations.updated') }
    rescue StandardError => e
      { error: e.message }
    end
  end
end
