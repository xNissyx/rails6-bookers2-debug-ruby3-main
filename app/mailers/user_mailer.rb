class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  # :fromヘッダーにこのクラスのすべてのメッセージで使う値を1つ設定しています。
  
  def welcome_email
    @user = User.find(params[:id])
    @url = 'http://example.com/login'
    mail(to: @user.email, subject: "私の素敵なサイトへようこそ！")
    # mail: 実際のメールメッセージです。ここでは:toヘッダーと:subjectヘッダーを渡しています。
  end
end
