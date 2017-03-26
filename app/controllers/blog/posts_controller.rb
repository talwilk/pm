class Blog::PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Blog::Post.all
  end

  def show
  end

  private

  def set_post
    @post = Blog::Post.find(params[:id])
  end
end
