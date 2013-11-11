class RemoveContentTypeFromTrack < ActiveRecord::Migration
  def up
    remove_column :tracks, :song_content_type
  end

  def down
    add_column :tracks, :song_content_type, :string
  end
end
