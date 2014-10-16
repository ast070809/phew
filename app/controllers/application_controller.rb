class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  has_mobile_fu

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :adjust_format_for_mobile

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end


  def adjust_format_for_mobile
    if is_mobile_device?
        if request.format == :js
            request.format = :mobilejs
        else
            request.format = :mobile
        end
    end
  end
end

