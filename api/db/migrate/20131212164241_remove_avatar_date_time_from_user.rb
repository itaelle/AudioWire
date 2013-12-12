class RemoveAvatarDateTimeFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :avatar_updated_at
  end

  def down
    add_column :users, :avatar_updated_at, :datetime
  end
end
