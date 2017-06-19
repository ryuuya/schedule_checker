# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# coding: utf-8

User.create(:name => 'hiroyuki', :address => 'Tokyo', :password => 'hata', :login_id => 'hatahiroyuki')
Plan.create(:title => '打ち合わせ', :detail => '日高さんと打ち合わせ', :color_id => 1, :user_id => 1)

Color.create(:color_code => '87CEEB')
Color.create(:color_code => 'FFB6C1')
Color.create(:color_code => 'FF6347')
Color.create(:color_code => 'FFD700')
Color.create(:color_code => '7CFC00')
Color.create(:color_code => 'DA70D6')
Color.create(:color_code => '32CD32')

