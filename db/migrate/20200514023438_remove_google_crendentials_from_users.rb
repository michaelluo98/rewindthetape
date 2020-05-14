class RemoveGoogleCrendentialsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :google_credentials, :string
  end
end
