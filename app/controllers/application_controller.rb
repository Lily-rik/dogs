class ApplicationController < ActionController::Base
  # devise機能（ログインなど）がが使われる場合、その前にconfigure_permitted_parametersが実行される
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_users_path
    when User
      about_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_registration_path
    end
  end

  protected

  # ユーザ登録（sign_up）の際に、ユーザ名や電話番号（name,telephone_number）などのデータ操作が許可される
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_name, :telephone_number])
  end
end
