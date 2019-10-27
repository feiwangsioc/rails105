class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  
  #before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
    
  def index
    @groups= Group.all
  end 
  
  def new
    @group = Group.new
  end 
  
  def show
    @group = Group.find(params[:id]) 
    @posts = @group.posts.order("created_at DESC")
  end 
  
  def edit
    find_group_and_check_permission
    
  end 
  
  def update
    find_group_and_check_permission 
    
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update success"
    else 
      render :edit 
    end 
  end 
  
  def destroy
    find_group_and_check_permission
    
    @group.destroy
    redirect_to groups_path, alert: "Delete success"
  end 
  
  def create
    @group = Group.new(group_params)
    @group.user = current_user
    
    if @group.save
    
    redirect_to groups_path
    else 
     render :new
    end 
    
  end 
  
  private
  def group_params
    params.require(:group).permit(:title, :description)
  end 
  
  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alter: "No permission"
    end 
  end 
end
