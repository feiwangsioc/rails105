class Account::PostsController < ApplicationController

  before_action :authenticate_user!
  def index
    @posts = current_user.posts
  end
  
  def edit
    @post = current_user.Post.find(params[:id])
  end
  
  def destroy

  end 
  
end
