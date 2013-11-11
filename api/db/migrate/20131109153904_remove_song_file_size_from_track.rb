class RemoveSongFileSizeFromTrack < ActiveRecord::Migration
  def up
    remove_column :tracks, :song_file_size
  end

  def down
    add_column :tracks, :song_file_size, :integer
  end
end
