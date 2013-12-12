class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :friendships
  has_many :friends, :through => :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :token_authenticatable #, :validatable

  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :first_name, :last_name
  has_many :tracks, dependent: :destroy
  has_many :playlists, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, :on => :create
  validates :username, presence: true, uniqueness: true
end
