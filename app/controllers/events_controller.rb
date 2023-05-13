class EventsController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    @title = params[:title]
    @content = params[:content]
    
    event = {
      :group => @group,
      :title => @title,
      :content => @content
    }
    
    @group.users.each do |member|
      EventMailer.send_notification(member, event).deliver_now
    end
    
    render "sent"
  end

  def new
    @group = Group.find(params[:group_id])
  end
end
