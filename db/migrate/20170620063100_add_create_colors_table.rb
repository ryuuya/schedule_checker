class AddCreateColorsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :colors do |i|
      i.string :color_code
      i.string :color_name
      i.timestamps
    end
  end
end
