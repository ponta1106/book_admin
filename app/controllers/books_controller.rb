class BooksController < ApplicationController
  protect_from_forgery except: [:destroy]
  before_action :set_book, only: [:show, :destroy]

  def show
    respond_to do |format|
      format.html
      format.json { render json: @book }
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { head :no_content }
    end
  end
  
  def set_book
    @book = Book.find(params[:id])
  end
end
