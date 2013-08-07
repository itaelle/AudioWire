class AddAttachmentSongToTracks < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.attachment :song
    end
  end

  def self.down
    drop_attached_file :tracks, :song
  end
end
