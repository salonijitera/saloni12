# frozen_string_literal: true

module ShopService
  class Update < BaseService
    attr_reader :id, :name, :address

    def initialize(id, name, address)
      @id = id
      @name = name
      @address = address
    end

    def execute
      validate_presence_of_fields
      shop = Shop.find(id)
      shop.update!(name: name, address: address)
      { message: 'Shop information has been updated successfully.' }
    rescue ActiveRecord::RecordNotFound
      { error: 'Shop not found.' }
    rescue StandardError => e
      { error: e.message }
    end

    private

    def validate_presence_of_fields
      raise 'Name cannot be blank' if name.blank?
      raise 'Address cannot be blank' if address.blank?
    end
  end
end
