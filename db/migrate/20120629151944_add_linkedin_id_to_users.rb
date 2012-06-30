class AddLinkedinIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_id, :string
  end
end
