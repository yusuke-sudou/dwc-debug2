class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def show
    @book = Book.find(params[:id])
    @user = @book.user # または、本と関連付けられたユーザーを取得する方法
    @new_book = Book.new
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def create
    @user = current_user
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      flash[:notice] = "投稿に失敗しました"
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      flash[:notice] = "投稿に失敗しました"
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    user = book.user
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
end
