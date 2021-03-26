module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的に記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    # まずはsession[:user_id]情報を確認してsessionにユーザー情報がある場合に@current_userをセットする
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      
    # session[:user_id]に情報がない場合、cookies情報を確認してcookiesにユーザー情報がある場合@current_userをセットする
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

# チェックボックスがチェックされたらリメンバーする
  def remember_me(user)
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
