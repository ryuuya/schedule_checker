class AddCreateTableUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |i|
      i.string :name
      i.string :address
      i.string :password
      i.timestamps
      i.string :login_id
    end
  end
end
