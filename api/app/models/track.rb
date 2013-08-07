class Track < ActiveRecord::Base
  has_attached_file :song
  
  validates_attachment_content_type :song, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3']
  validates_attachment_size :song, :less_than => 10.megabytes

  attr_accessible :album, :artist, :genre, :numberTrack, :time, :title, :song

  belongs_to :user
end
