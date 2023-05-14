class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    # Deviseではsign_inというメソッドが存在しており、これはユーザーをログイン状態にするものです。
      # def self.guest
      #   find_or_created_by!(name: "guestuser", email: "guest@example.com", password: SecureRandom.urlsafe_base64)
      # end
    redirect_to user_path(user), notice: 'guestuserでログインしました。'
  end
end