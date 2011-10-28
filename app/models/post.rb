class Post < ActiveRecord::Base
  belongs_to :user
  
  validates :content, :length => { :maximum => 5000 }
end
