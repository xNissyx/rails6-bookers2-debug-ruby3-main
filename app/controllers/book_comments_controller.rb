class BookCommentsController < ApplicationController
  before_action :set_book_comment, only: %i(create destroy)

  def create
    book_comment = current_user.book_comments.new(book_comment_params)
    book_comment.book_id = @book.id
    book_comment.save
  end

  def destroy
    book_comment = current_user.book_comments.find(params[:id])
    book_comment.destroy
  end

   private

    def set_book_comment
       @book = Book.find(params[:book_id])
       @book_comments = @book.book_comments
    end

    def book_comment_params
      params.require(:book_comment).permit(:body)
    end
end
