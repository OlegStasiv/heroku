module SessionsHelper

  def sign_in(user)
    remember_token = User.new_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:token, User.encrypt(remember_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(token: remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:token,
                                  User.encrypt(User.new_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

end
