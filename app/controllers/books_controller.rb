class BooksController < ApplicationController
  before_action :set_book, only: %i(show edit update destroy)

  def show
    @user = @book.user
    @book_comments = @book.book_comments
    
    # 閲覧数(ReadCount)の作成
    current_user.read_counts.create(book_id: @book.id)
    # 省略せず書くと
    # read_count = ReadCount.new(user_id: current_user.id, book_id: @book.id)
    # read_count.save
  end

  def index
    @book = Book.new
    
    if params[:latest]
      @books = Book.latest
    elsif params[:evaluation_count]
      @books = Book.evaluation_count
    else
      @books = Book.with_favorites_count
    end
    # to  = Time.current.at_end_of_day
    # from  = (to - 6.day).at_beginning_of_day
    # @books = Book.all.sort {|a,b| 
    #   b.favorites.where(created_at: from...to).size <=> 
    #   a.favorites.where(created_at: from...to).size
    # }
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private
  
  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :body, :evaluation, :tag)
  end
end
