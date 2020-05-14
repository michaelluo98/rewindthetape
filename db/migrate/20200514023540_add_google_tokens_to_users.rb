class AddGoogleTokensToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :google_access, :string
    add_column :users, :google_refresh, :string
  end
end
