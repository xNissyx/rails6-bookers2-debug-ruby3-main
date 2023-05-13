class Users::RegistrationsController < Devise::RegistrationsController
  # ユーザーの新規登録処理はdeviseのregistrations_controllerのcreateアクションに定義されています。
  # そして、UserMailerを呼び出す記述をcreateアクションに加えるには、「オーバーライド」が必要です。
  def create
    super
    # superクラス(devise)のcreateアクションを呼ぶ
    UserMailer.welcome_email.deliver_later
    # UserMailerクラスのwelcome_emailメソッドを呼んでる
    # withに渡されるキーの値は、メーラーアクションでは単なるparamsになります。
    # つまり、with(user: @user, account: @user.account)と書けば、
    # メーラーアクションでparams[:user]やparams[:account]を使えるようになります。ちょうどコントローラのparamsと同じ要領です。
  end
  # オーバーライド！！
  
  def destroy
    # 論理削除処理
    soft_delete(current_user)
    # Deviceの論理削除後の後処理
    respond_with_navigational do
      # 強制ログアウト
      sign_out current_user
      # ログアウト後のページ遷移
      redirect_to root_path
    end
  end
  
  private
  
  def soft_delete(user)
    # 同じメールアドレスでも登録できるように、
    # メールアドレスを“hoge@example.com_deleted_**********”に変更する
    deleted_email = user.email + '_deleted_' + Time.current.to_i.to_s
    user.assign_attributes(email: deleted_email, deleted_at: Time.current)

    # 通常メールアドレスが変更されると通知メールが飛ぶので、
    # その通知メールをキャンセルする
    user.skip_email_changed_notification!

    # 保存処理
    user.save
  end
end