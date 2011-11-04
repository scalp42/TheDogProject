require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    @base_title = "The DOG Project"
  end
  
  describe "POST 'create'" do
    describe "form failure" do
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => "" }
      end
      
      it "should fail at incorrect recaptcha" do
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign Up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { 
                  :name => "Example", 
                  :email => "email@address.com",
                  :password => "asdf1234",
                  :password_confirmation => "asdf1234"
                }
      end
      
      it "should flash a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /You've successfully registered!/i
      end
    end
  end

  describe "GET 'new'" do
    it "should return http success" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign Up")
    end
    
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
  end
end
