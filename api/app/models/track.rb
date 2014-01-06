class Track < ActiveRecord::Base
  attr_accessible :album, :artist, :genre, :numberTrack, :time, :title, :song

  validates :title, presence: true
  belongs_to :user

  def as_json(options = {})
    super(options.merge({ except: [:created_at, :updated_at] }))
  end
end
