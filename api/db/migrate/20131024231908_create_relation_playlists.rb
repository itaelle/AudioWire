class CreateRelationPlaylists < ActiveRecord::Migration
  def change
    create_table :relation_playlists do |t|
      t.integer :track_id
      t.integer :playlist_id

      t.timestamps
    end
  end
end
