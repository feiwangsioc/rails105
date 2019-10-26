class WelcomeController < ApplicationController
  def index
    
    flash[:notice] = "good morning sir" 
    
  end 
  
end
