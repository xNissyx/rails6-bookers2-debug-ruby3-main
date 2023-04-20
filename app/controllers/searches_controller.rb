class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    range = params[:range]
    if range == "User"
      @users = User.looks(params[:method],params[:word])
    else
      @books = Book.looks(params[:method],params[:word])
    end
  end
end
