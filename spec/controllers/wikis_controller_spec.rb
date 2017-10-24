require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:standard_user) { create(:user) }
  let(:premium_user) { create(:user, email: 'user2@bloc.io', role: :premium) }
  let(:admin) { create(:user, email: 'admin@bloc.io', role: :admin) }
  let(:standard_wiki) { create(:wiki, user: standard_user) }
  let(:premium_wiki) { create(:wiki, private: true, user: premium_user) }
  
  context "standard user" do
    before do
      sign_in(standard_user)
    end
    
    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it "assigns standard_wiki to @public_wikis" do
        get :index
        expect(assigns(:public_wikis)).to eq([standard_wiki])
      end
    end
  
    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: standard_wiki.id }
        expect(response).to have_http_status(:success)
      end
  
      it "renders the #show view" do
        get :show, params: { id: standard_wiki.id }
        expect(response).to render_template :show
      end
  
      it "assigns standard_wiki to @wiki" do
        get :show, params: { id: standard_wiki.id }
        expect(assigns(:wiki)).to eq(standard_wiki)
      end
    end
  
    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
   
      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
   
      it "instantiates @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end
      
    describe "POST create" do
      it "increases the number of Wikis by 1" do
        expect{ post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: false } } }.to change(Wiki,:count).by(1)
      end
  
      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: false } }
        expect(assigns(:wiki)).to eq Wiki.last
      end
  
      it "redirects to the new wiki" do
        post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: false } }
        expect(response).to redirect_to(Wiki.last) 
      end
    end
  
    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: standard_wiki.id }
        expect(response).to have_http_status(:success)
      end
  
      it "renders the #edit view" do
        get :edit, params: { id: standard_wiki.id }
        expect(response).to render_template :edit
      end
  
      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: standard_wiki.id }
        wiki_instance = assigns(:wiki)
  
        expect(wiki_instance.id).to eq standard_wiki.id
        expect(wiki_instance.title).to eq standard_wiki.title
        expect(wiki_instance.body).to eq standard_wiki.body
        expect(wiki_instance.private).to eq standard_wiki.private
      end
      
      it "does not allow a user to edit a wiki they did not create" do
        sign_out(standard_user)
        other_user = create(:user, email: 'test@bloc.io')
        sign_in(other_user)
        
        get :edit, params: { id: standard_wiki.id }
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        
        put :update, params: { id: standard_wiki.id, wiki: { title: new_title, body: new_body } }
  
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq standard_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
        expect(updated_wiki.private).to eq standard_wiki.private
      end
  
      it "redirects to the updated wiki" do
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        
        put :update, params: { id: standard_wiki.id, wiki: { title: new_title, body: new_body } }
        expect(response).to redirect_to(standard_wiki)
      end
      
       it "does not allow a user to update a wiki they did not create" do
        sign_out(standard_user)
        other_user = create(:user, email: 'test@bloc.io')
        sign_in(other_user)
        
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        
        put :update, params: { id: standard_wiki.id, wiki: { title: new_title, body: new_body } }
        expect(response).to redirect_to(root_path)
      end
    end
      
    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: standard_wiki.id }
        count = Wiki.where({id: standard_wiki.id}).size
        expect(count).to eq 0
      end
  
      it "redirects to wiki index" do
        delete :destroy, params: { id: standard_wiki.id }
        expect(response).to redirect_to(wikis_path)
      end
      
       it "does not allow a user to delete a wiki they did not create" do
        sign_out(standard_user)
        other_user = create(:user, email: 'test@bloc.io')
        sign_in(other_user)
        
        delete :destroy, params: { id: standard_wiki.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  context "premium user" do
    before do
      sign_in(premium_user)
    end
    
    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it "assigns premium_wiki to @private_wikis" do
        get :index
        expect(assigns(:private_wikis)).to eq([premium_wiki])
      end
    end
  
    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: premium_wiki.id }
        expect(response).to have_http_status(:success)
      end
  
      it "renders the #show view" do
        get :show, params: { id: premium_wiki.id }
        expect(response).to render_template :show
      end
  
      it "assigns premium_wiki to @wiki" do
        get :show, params: { id: premium_wiki.id }
        expect(assigns(:wiki)).to eq(premium_wiki)
      end
    end
  
    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
   
      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
   
      it "instantiates @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end
      
    describe "POST create" do
      it "increases the number of Wikis by 1" do
        expect{ post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: true } } }.to change(Wiki,:count).by(1)
      end
  
      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: true } }
        expect(assigns(:wiki)).to eq Wiki.last
      end
  
      it "redirects to the new wiki" do
        post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: true } }
        expect(response).to redirect_to(Wiki.last) 
      end
    end
  
    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: premium_wiki.id }
        expect(response).to have_http_status(:success)
      end
  
      it "renders the #edit view" do
        get :edit, params: { id: premium_wiki.id }
        expect(response).to render_template :edit
      end
  
      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: premium_wiki.id }
        wiki_instance = assigns(:wiki)
  
        expect(wiki_instance.id).to eq premium_wiki.id
        expect(wiki_instance.title).to eq premium_wiki.title
        expect(wiki_instance.body).to eq premium_wiki.body
        expect(wiki_instance.private).to eq premium_wiki.private
      end
      
      it "does not allow a user to edit a wiki they did not create" do
        sign_out(premium_user)
        other_user = create(:user, email: 'test2@bloc.io', role: :premium)
        sign_in(other_user)
        
        get :edit, params: { id: premium_wiki.id }
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        new_privacy_setting = false
  
        put :update, params: { id: premium_wiki.id, wiki: { title: new_title, body: new_body, private: new_privacy_setting } }
  
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq premium_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
        expect(updated_wiki.private).to eq new_privacy_setting
      end
  
      it "redirects to the updated wiki" do
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        new_privacy_setting = false
  
        put :update, params: { id: premium_wiki.id, wiki: { title: new_title, body: new_body, private: new_privacy_setting } }
        expect(response).to redirect_to(premium_wiki)
      end
      
      it "does not allow a user to update a wiki they did not create" do
        sign_out(premium_user)
        other_user = create(:user, email: 'test2@bloc.io', role: :premium)
        sign_in(other_user)
        
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        new_privacy_setting = false
  
        put :update, params: { id: premium_wiki.id, wiki: { title: new_title, body: new_body, private: new_privacy_setting } }
        expect(response).to redirect_to(root_path)
      end
    end
      
    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: premium_wiki.id }
        count = Wiki.where({id: premium_wiki.id}).size
        expect(count).to eq 0
      end
  
      it "redirects to wiki index" do
        delete :destroy, params: { id: premium_wiki.id }
        expect(response).to redirect_to(wikis_path)
      end
      
      it "does not allow a user to delete a wiki they did not create" do
        sign_out(premium_user)
        other_user = create(:user, email: 'test2@bloc.io', role: :premium)
        sign_in(other_user)
        
        delete :destroy, params: { id: premium_wiki.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  context "admin" do
    before do
      sign_in(admin)
    end
    
    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: standard_wiki.id }
        expect(response).to have_http_status(:success)
      end
  
      it "renders the #show view" do
        get :show, params: { id: standard_wiki.id }
        expect(response).to render_template :show
      end
  
      it "assigns my_wiki to @wiki" do
        get :show, params: { id: standard_wiki.id }
        expect(assigns(:wiki)).to eq(standard_wiki)
      end
    end
  
    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
   
      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
   
      it "instantiates @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end
      
    describe "POST create" do
      it "increases the number of Wikis by 1" do
        expect{ post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: false } } }.to change(Wiki,:count).by(1)
      end
  
      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: false } }
        expect(assigns(:wiki)).to eq Wiki.last
      end
  
      it "redirects to the new wiki" do
        post :create, params: { wiki: { title: "New Wiki Title", body: "New wiki body", private: false } }
        expect(response).to redirect_to(Wiki.last) 
      end
    end
  
    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: standard_wiki.id }
        expect(response).to have_http_status(:success)
      end
  
      it "renders the #edit view" do
        get :edit, params: { id: standard_wiki.id }
        expect(response).to render_template :edit
      end
  
      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: standard_wiki.id }
        wiki_instance = assigns(:wiki)
  
        expect(wiki_instance.id).to eq standard_wiki.id
        expect(wiki_instance.title).to eq standard_wiki.title
        expect(wiki_instance.body).to eq standard_wiki.body
        expect(wiki_instance.private).to eq standard_wiki.private
      end
    end
    
    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        new_privacy_setting = true
  
        put :update, params: { id: standard_wiki.id, wiki: { title: new_title, body: new_body, private: new_privacy_setting } }
  
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq standard_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
        expect(updated_wiki.private).to eq new_privacy_setting
      end
  
      it "redirects to the updated wiki" do
        new_title = "New Wiki Title"
        new_body = "New wiki body"
        new_privacy_setting = true
  
        put :update, params: { id: standard_wiki.id, wiki: { title: new_title, body: new_body, private: new_privacy_setting } }
        expect(response).to redirect_to(standard_wiki)
      end
    end
      
    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: standard_wiki.id }
        count = Wiki.where({id: standard_wiki.id}).size
        expect(count).to eq 0
      end
  
      it "redirects to wiki index" do
        delete :destroy, params: { id: standard_wiki.id }
        expect(response).to redirect_to(wikis_path)
      end
    end
  end
end
