require 'spec_helper'

describe SessionsController do
  describe '#new' do
    subject { get :new }

    it 'redirects to facebook login path' do
      subject
      response.should redirect_to("/auth/facebook")
    end
  end

  describe '#create' do
    let (:user) { FactoryGirl.create(:user) }

    subject do 
      User.should_receive(:from_omniauth).and_return(user)
      get :create, provider: "facebook"
    end

    it "sets the user's id in the session" do
      subject
      session[:user_id].should == user.id
    end

    it 'redirects to root path with a notice' do
      subject
      response.should redirect_to(root_url)
      flash[:notice].should == 'Signed in!'
    end
  end

  describe '#destroy' do
    let (:user) { FactoryGirl.create(:user) }

    subject do
      session[:user_id] = user.id
      get :destroy
    end

    it "unsets the user's id from the session" do
      subject
      session[:user_id].should == nil
    end

    it 'redirects to root path with a notice' do
      subject
      response.should redirect_to(root_url)
      flash[:notice].should == 'Signed out!'
    end
  end
end