class AddEmailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :spotify_email, :string
    add_column :users, :google_email, :string
  end
end
