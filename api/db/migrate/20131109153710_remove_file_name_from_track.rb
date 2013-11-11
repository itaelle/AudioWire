class RemoveFileNameFromTrack < ActiveRecord::Migration
  def change
    remove_column :tracks, :song_file_name
  end

end
