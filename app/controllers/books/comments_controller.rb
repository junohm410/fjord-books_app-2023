# frozen_string_literal: true

class Books::CommentsController < CommentsController
  def create
    @commentable = Book.find(params[:book_id])
    super
  end

  def destroy
    @commentable = Book.find(params[:book_id])
    super
  end
end
