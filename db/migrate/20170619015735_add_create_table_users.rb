class AddCreateTableUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |i|
      i.string :name
      i.string :address
      i.string :password
      i.timestamps
      i.string :login_id
    end
  end
end
