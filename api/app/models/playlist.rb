class Playlist < ActiveRecord::Base
  attr_accessible :title

  validates :title, presence: true, :length => {minimum: 5}, uniqueness: true

  has_many :relation_playlists
end
