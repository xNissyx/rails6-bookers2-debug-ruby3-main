class EventMailer < ApplicationMailer
  def send_notification(member, event)
    # 引数として、memberはメールを受け取るUserオブジェクト、
    # eventは送信されるイベントの情報が格納されたEventオブジェクトを取ります
    @group = event[:group]
    @title = event[:title]
    @content = event[:content]

    mail(
      from: ENV['MAIL_ADDRESS'],
      to:   member.email,
      subject: 'New Event Notice!!'
    )
  end

end
