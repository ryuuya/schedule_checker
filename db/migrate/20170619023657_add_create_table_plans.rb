class AddCreateTablePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |i|
      i.string :title
      i.text :detail
      i.integer :color_id
      i.datetime :start_at
      i.datetime :end_at
      i.integer :user_id
      i.timestamps
    end
  end
end
