class AddCreateColorsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :colors, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |i|
      i.string :color_code
      i.string :color_name
      i.timestamps
    end
  end
end
