class PasswordValidator
  PASSWORD_FORMAT = /\A
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
    .{8,}              # Must be at least 8 characters long
  \z/x

  def self.valid?(password_hash)
    password_hash.match(PASSWORD_FORMAT).present?
  end
end

# Note: The actual password encryption and comparison should be handled elsewhere, this class is for format validation only.
