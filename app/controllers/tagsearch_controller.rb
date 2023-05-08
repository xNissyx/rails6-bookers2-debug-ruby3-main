class TagsearchController < ApplicationController
  before_action :authenticate_user!

  def search
    @word = params[:word]
    @books = Book.where("tag LIKE ?", "%#{@word}%")
    # モデル名.where(カラム名: 条件)
  end
end
