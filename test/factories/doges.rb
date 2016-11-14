FactoryGirl.define do

	# http://stackoverflow.com/questions/25205545/building-a-json-stub-using-factorygirl
	factory :doge_hair, class: OpenStruct do
		style { ['long', 'wirey', 'short', 'simply terrible'].sample(1).first }
		color { FFaker::Color.name }
	end

	factory :doge_description, class: OpenStruct do
		breed { BREEDS.sample(1).first }
		hair { build(:doge_hair).marshal_dump }
	end

	factory :doge do
		pet_name { FFaker::Name.name }
		description { build(:doge_description).marshal_dump }
	end
end

