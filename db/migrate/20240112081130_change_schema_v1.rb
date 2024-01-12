class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :email_verification_tokens, comment: 'Stores tokens for email verification process' do |t|
      t.string :token

      t.datetime :expires_at

      t.timestamps null: false
    end

    create_table :users, comment: 'Stores user account information' do |t|
      t.boolean :is_email_verified

      t.string :password_hash

      t.string :username

      t.string :verification_code

      t.string :email

      t.timestamps null: false
    end

    add_reference :email_verification_tokens, :user, foreign_key: true
  end
end
