require 'spec_helper'
require 'digest'

describe User do
  before(:each) do
    @attr = { 
              :name => "Example", 
              :email => "email@address.com",
              :password => "asdf1234",
              :password_confirmation => "asdf1234"
            }
  end
  
  it "should create an instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name = User.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end
  
  it "should not accept names longer than 50 characters" do
    long = "a" * 51 
    long_name = User.new(@attr.merge(:name => long))
    long_name.should_not be_valid
  end
  
  it "should require the e-mail address" do
    no_email = User.new(@attr.merge(:name => ""))
    no_email.should_not be_valid
  end
  
  it "should reject duplicate e-mail addresses and case-insensitive" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should accept valid e-mail addresses" do
    addresses =  %w[user@email.com user.name@email.com user.name@email.com.au UsEr@the.foo.org]
    addresses.each do |address|
      valid_email = User.new(@attr.merge(:email => address))
      valid_email.should be_valid
    end
  end
  
  it "should reject invalid e-mail addresses" do
    addresses =  %w[user@email,com 1!user.name@email.com user@.name@email.com.au UsEr@the.foo.]
    addresses.each do |address|
      valid_email = User.new(@attr.merge(:email => address))
      valid_email.should_not be_valid
    end
  end
  
  describe "password validations" do
    it "should require a password" do
      no_pass = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      no_pass.should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      no_confirm = User.new(@attr.merge(:password_confirmation => "invalid"))
      no_confirm.should_not be_valid
    end
    
    it "should require a length of at least 8" do
      pass_length = "a" * 7
      short_pass = User.new(@attr.merge(:password => pass_length, :password_confirmation => pass_length))
      short_pass.should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)  
    end
    
    it "should have the encrypted_password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank 
    end
        
    describe "has_password? method" do
      it "should return true if passwords are valid" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should return false if passwords are invalid" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "user authenticator" do
      it "should return 'nil' on email/password mismatch" do
        wrong_pass = User.authenticate(@attr[:email], "invalid")
        wrong_pass.should be_nil
      end
      
      it "should return 'nil' on unregistered email" do
        wrong_email = User.authenticate("wrong@email.com", @attr[:password])
        wrong_email.should be_nil
      end
      
      it "should return an instance of the User on correct email/password pair" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end
end
