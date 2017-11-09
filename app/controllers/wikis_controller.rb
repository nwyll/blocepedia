class WikisController < ApplicationController
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
   @wiki = Wiki.new(wiki_params)
   @wiki.user = current_user
 
    if @wiki.save
      redirect_to @wiki, notice: "Wiki was saved successfully."
    else
      flash.now[:alert] = "Error creating wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    
    #list current collaborators
    @collaborators = Wiki.find(params[:id]).collaborating_users
  end
  
  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @wiki.assign_attributes(wiki_params)
    
    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error in saving. Please try again."
      render :edit
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end
  
  def my_wikis
    @user = current_user
    @my_wikis = @user.wikis
  end
  
  def remove_collaborators
    @collaborators = Wiki.find(params[:id]).collaborating_users
    #remove selected collaborators from the @collaborators from array
    @collaborators = @collaborators - params[collaborator_ids]
    
    flash[:notice] = "Collaborators updated."
    render :edit
  end
  
  def add_collaborators
    #users who are not current collaborators
    @potential_collaborators = User.all - @collaborators
    
    
    
  end
  
  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
