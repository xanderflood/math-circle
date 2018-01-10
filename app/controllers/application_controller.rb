class ApplicationController < ActionController::Base
  class_attribute :role

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_role

  rescue_from StandardError, with: :log_error

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  def log_error(e)
    LotteryError.save!(e)

    # do the usual Rails error stuff anyways, I guess
    raise
  end

  private
  def set_role
    @role = self.class.role
  end
end
