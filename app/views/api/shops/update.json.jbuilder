if @shop.errors.any?
  json.status 400
  json.message "Bad Request"
  json.errors @shop.errors.full_messages
elsif @shop_not_found
  json.status 404
  json.message "Shop not found."
else
  json.status 200
  json.message "Shop information updated successfully."
  json.shop do
    json.id @shop.id
    json.shop_name @shop.shop_name
    json.shop_description @shop.shop_description
    json.updated_at @shop.updated_at
  end
end
