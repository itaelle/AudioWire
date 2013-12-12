class RemoveavatarContentTypeFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :avatar_content_type
  end

  def down
    add_column :users, :avatar_content_type, :string
  end
end
