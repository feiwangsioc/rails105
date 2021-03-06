class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  
  #before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
    
  def index
    @groups= Group.all
  end 
  
  def new
    @group = Group.new
  end 
  
  def show
    @group = Group.find(params[:id]) 
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
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
    current_user.join!(@group)
    redirect_to groups_path
    else 
     render :new
    end 
    
  end 
  
   def join
    @group = Group.find(params[:id])
   
     if !current_user.is_member_of?(@group)
       current_user.join!(@group)
       flash[:notice] = "Welcome to our group"
     else
       flash[:warning] = "You are already our group member"
     end
   
     redirect_to group_path(@group)
   end
   
   def quit
     @group = Group.find(params[:id])
   
     if current_user.is_member_of?(@group)
       current_user.quit!(@group)
       flash[:alert] = "已退出本讨论版！"
     else
       flash[:warning] = "你不是本讨论版成员，怎么退出 XD"
     end
   
     redirect_to group_path(@group)
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
