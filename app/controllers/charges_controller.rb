class ChargesController < ApplicationController
  def new
    @stripe_btn_data = {
    key: "#{ Rails.configuration.stripe[:publishable_key] }",
    description: "Blocipedia Premium Membership",
    amount: default_amt
    }
  end
  
  def create
    #Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
    
    #Creates a Stripe Charge object
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: default_amt,
      description: "Blocipedia Premium Membership - #{current_user.email}",
      currency: 'usd'
    )
    
    #Upgrade user role to premium
    current_user.premium!
    
    flash[:notice] = "Thank you for your payment, #{current_user.email}. You are now a premium user!"
    redirect_to(root_path)
    
    #Handles errors
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end
  
  def downgrade
    #Make all wikis for current user public
    @user = current_user
    user_wikis = @user.wikis
    
    user_wikis.each do |wiki|
      wiki.private = false
      wiki.save
    end
    
    #Change user_role to standard
    current_user.standard!
    flash[:notice] = "Your account has been updated. You are now a standard user."
    redirect_to(root_path)
  end
  
  private
  def default_amt
    15_00
  end
end
