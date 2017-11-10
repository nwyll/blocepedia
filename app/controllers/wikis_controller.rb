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
    @collaborators = @wiki.collaborating_users
    
    #list users who are not current collaborators
    @new_collaborators = User.all - @wiki.collaborating_users
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
    @collaborating_wikis = @user.collaborating_wikis
  end
  
  def remove_collaborators
    @wiki = Wiki.find(params[:id])
    #remove selected collaborators from the @collaborators from params array - how to find the collaborator record with ths user and wiki
    @wiki.collaborating_users = @wiki.collaborating_users - User.find(params[:collaborator_ids])
    @wiki.save
    
    flash[:notice] = "Collaborators removed."
    redirect_to edit_wiki_path(@wiki)
  end
  
  def add_collaborators
    @wiki = Wiki.find(params[:id])
    #add selected collaborators from params array
    @wiki.collaborating_users = @wiki.collaborating_users + User.find(params[:new_collaborator_ids])
    @wiki.save
    
    flash[:notice] = "Collaborators added."
    redirect_to edit_wiki_path(@wiki)
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
