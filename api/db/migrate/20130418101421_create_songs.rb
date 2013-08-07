class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :band
      t.integer :duration
      t.string :category

      t.timestamps
    end
  end
end
