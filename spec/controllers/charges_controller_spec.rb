require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  let(:user) { create(:user) }
  let(:private_wiki) { create(:wiki, private: true, user: user) }
  
  before do
    sign_in(user)
  end
  
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "POST #create" do
    it "changes user role to premium" do
      post :create
      expect(user.role).to eq("premium")
    end
  end
  
  describe "POST #downgrade" do
    it "changes user role to standard" do
      post :downgrade
      expect(user.role).to eq("premium")
    end
    
    it "changes all user wikis to public" do
      post :downgrade
      expect(private_wiki.private).to be false
    end
  end
end
