class Api::ShopsController < ApplicationController
  before_action :authenticate_user!

  def update
    begin
      shop_service = ShopService::Update.new(params[:id], shop_params[:shop_name], shop_params[:shop_description])
      authorize shop_service.shop, policy_class: ApplicationPolicy

      result = shop_service.execute
      if result[:error].present?
        render json: { error: result[:error] }, status: :not_found
      else
        render json: {
          status: 200,
          message: "Shop information updated successfully.",
          shop: result
        }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Shop not found." }, status: :not_found
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:shop_name, :shop_description)
  end

  def authenticate_user!
    # Method to authenticate user (implementation depends on authentication system used)
  end
end
