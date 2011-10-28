require 'spec_helper'

describe "LayoutLinks" do
  
  it "should default to home at '/'" do
    get '/'
    response.should have_selector("title",:content => "Home")
  end

  it "should show a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector("title",:content => "Contact")
  end

  it "should show an About page at '/about'" do
    get '/about'
    response.should have_selector("title",:content => "About")
  end

  it "should show a Signup page at '/signup" do
    get '/signup'
    response.should have_selector("title",:content => "Sign Up")
  end

  it "should show a Signin page at '/signin" do
    get '/signin'
    response.should have_selector("title",:content => "Sign In")
  end
end
