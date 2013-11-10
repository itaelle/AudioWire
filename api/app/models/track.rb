class Track < ActiveRecord::Base
  attr_accessible :album, :artist, :genre, :numberTrack, :time, :title, :song

  validates :title, presence: true
  belongs_to :user
end
