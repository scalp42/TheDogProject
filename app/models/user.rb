require "digest"

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :posts
  
  email_regex = /\A[\w\d][\.\+\-\_\w\d]{0,61}[\w\d]?@[\w\d]{1,63}(\.[\w\d]{1,63}){1,254}\z/
  
  validates :name, :presence => true, 
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => email_regex }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :minimum => 8 }
                       
  before_save :encrypt_password
  
  def self.authenticate (email, password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(password)  
  end
  
  def has_password?(submitted)
    if self.encrypted_password == encrypt(submitted)
      true
    else
      false
    end 
  end
  
  private
   
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
   
  def encrypt_password
    self.salt = make_salt unless has_password?(self.password)
    self.encrypted_password = encrypt(self.password)
  end
  
  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end
  
  def secure_hash(string)
    Digest::SHA2.base64digest(string)
  end
end