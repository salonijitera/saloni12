json.status 200
json.message "Profile updated successfully."
json.user do
  json.id @user.id
  json.username @user.username
  json.email @user.email
  json.updated_at @user.updated_at.iso8601
end
