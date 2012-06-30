# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  image           :string(255)
#  linkedin_id     :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :linkedin_id, :image, :image_cache,:crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar
  
  has_many :microposts, dependent: :destroy
  mount_uploader :image, ImageUploader

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  validates :name, presence: true
  validates :name, length: { maximum: 50 }
  validates :email, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, :unless => :isCropped? 
  validates :password_confirmation, presence: true, :unless => :isCropped? 
  
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
 
  def crop_avatar
    image.recreate_versions! if crop_x.present?
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def isLinkedIn?
    !self.linkedin_id.blank?
  end
  
  private

    def create_remember_token
      # Create the token.
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
    def isCropped?
     self.crop_x.present?
    end
end
