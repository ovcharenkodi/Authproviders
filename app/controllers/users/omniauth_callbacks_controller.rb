class Users::OmniauthCallbacksController < ApplicationController
  def facebook
    @user = User.find_for_facebook_oauth request.env["omniauth.auth"]


    # puts "--------------------------------------------------------------------------"
    # # puts request.env["omniauth.auth"]
     
    #  puts request.env["omniauth.auth"]["uid"] 
    #  puts request.env["omniauth.auth"]["credentials"]["token"]

    # puts "----------------------------------------------------------------------------"

    # TODO  Получаем друзей пользователя и через параметры передаем их в вид.     


    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication, :params => ["asdasds"]
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def vkontakte
  	@user = User.find_for_vkontakte_oauth request.env["omniauth.auth"]
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Vkontakte"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end
end
