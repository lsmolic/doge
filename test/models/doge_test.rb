require 'test_helper'

class DogeTest < ActiveSupport::TestCase

   test 'Doge has a name' do
	   doge = build(:doge, pet_name: 'inu')
	   doge.save
	   assert_equal doge.pet_name, 'inu'
   end

   test 'Doge has a description' do
	   doge = build(:doge)
	   doge.hair_style = 'long'
	   doge.save

	   assert_equal doge.hair_style, 'long'
   end

   test 'Doge can be found by hair type' do
	   not_a_color = '1111'

	   doge = build(:doge)
	   doge.hair_color = not_a_color
	   doge.save

	   create_list(:doge, 10)

	   doges = Doge.where("description->'$.hair.color' = :color", color: not_a_color)
	   puts 'Find doge by hair->color: ' + doges.to_sql

	   assert_equal doges.first.hair_color, doge.hair_color
   end

   test 'Doges can be sorted by color' do
	   ['red', 'blue', 'dark green', 'dark red', 'light blue'].each do |color|
		   doge = build(:doge)
		   doge.hair_color = color
		   doge.save
	   end

	   doges = Doge.order("description->'$.hair.color' ASC")
	   puts 'Doges ordered by hair->color: ' + doges.to_sql

	   assert_equal doges.first.hair_color, 'blue'
   end

   test 'Doges can be grouped by hair color' do
	   ['red', 'green', 'dark blue', 'red', 'red', 'dark blue'].each do |color|
		   doge = build(:doge)
		   doge.hair_color = color
		   doge.save
	   end

	   doge_hair_color_counts = Doge.select("count(description->'$.hair.color') as frequency")
			                            .group("description->'$.hair.color'")
			                            .order('frequency')
	   puts 'Doges grouped by hair color: ' + doge_hair_color_counts.to_sql

	   assert_equal doge_hair_color_counts.first.frequency, 1
   end

   test 'Doges hair color can be extracted into its own column' do
	   doge = build(:doge)
	   doge.hair_color = 'green'
	   doge.save

	   doge_hair_color = Doge.select("description->>'$.hair.color' AS color")
	   puts 'Doges grouped by hair color: ' + doge_hair_color.to_sql

	   assert_equal doge_hair_color.first.color, 'green'
   end

   test '-> leaves quotes around values, ->> extracts the value' do
	   doge = build(:doge)
	   doge.hair_color = 'green'
	   doge.save

	   single_path_operator = Doge.select("description->'$.hair.color' AS color").limit(1)
	   puts 'Single (->) in query : ' + single_path_operator.to_sql
	   assert_equal '"green"', single_path_operator.first.color

	   double_path_operator = Doge.select("description->>'$.hair.color' AS color").limit(1)
	   puts 'Double (->>) in query : ' + double_path_operator.to_sql
	   assert_equal 'green', double_path_operator.first.color
   end

   test 'JSON_EXTRACT will return NULL for rows that do not match' do
	   doge = build(:doge)
	   doge.hair_color = 'green'
	   doge.save

	   double_path_operator = Doge.select("description->>'$.hair.color' AS color").limit(1)
	   puts 'Double (->>) in query : ' + double_path_operator.to_sql
	   assert_equal double_path_operator.first.color, 'green'
   end

   test 'json schema validates presence of all keys on description' do
	   doge = build(:doge)
	   doge.hair_color = nil
	   assert doge.invalid?

	   doge = build(:doge)
	   doge.hair_style = nil
	   assert doge.invalid?

	   doge = build(:doge)
	   doge.breed = nil
	   assert doge.invalid?

	   doge = build(:doge)
	   doge.description['hair'] = 'string'
	   assert doge.invalid?
   end

end
