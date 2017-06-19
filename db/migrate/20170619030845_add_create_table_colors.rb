class AddCreateTableColors < ActiveRecord::Migration[5.1]
  def change
    create_table :color do |i|
      i.string :color_code
      i.timestamps
    end
  end
end
