class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :recoverable

  has_many :friendships
  has_many :friends, :through => :friendships

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :token_authenticatable

  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  attr_protected :reset_password_token_valid_until, :username
  has_many :tracks, dependent: :destroy
  has_many :playlists, dependent: :destroy

  validates :email, presence: true, uniqueness: true, :email_format => {:message => 'format is invalid'}
  validates :password, presence: true, :on => :create
  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  def as_json(options = {})
    super(options.merge({ except: [:reset_password_token_valid_until, :created_at, :updated_at, :delete_at] }))
  end

end
