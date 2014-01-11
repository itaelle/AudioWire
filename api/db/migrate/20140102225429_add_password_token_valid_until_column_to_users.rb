class AddPasswordTokenValidUntilColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_token_valid_until, :datetime, :null => true
  end
end
