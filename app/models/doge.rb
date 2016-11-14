require 'json-schema'

class Doge < ActiveRecord::Base

	DESCRIPTION_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'doge_description.json_schema').to_s

	validate :json_attributes_conform_to_schemas


	# http://stackoverflow.com/questions/1716601/what-role-do-activerecord-model-constructors-have-in-rails-if-any
	def after_initialize
		self.description = {
				breed: nil,
		    hair: {
				    color: nil,
		        style: nil
		    }
		}
	end

	def breed
		self.description['breed']
	end

	def breed=(breed)
		self.description['breed'] = breed
	end

	def hair_color
		self.description['hair']['color']
	end

	def hair_color=(hair_color)
		self.description['hair']['color'] = hair_color
	end

	def hair_style
		self.description['hair']['style']
	end

	def hair_style=(hair_style)
		self.description['hair']['style'] = hair_style
	end

	private

	def json_attributes_conform_to_schemas
		JSON::Validator.fully_validate_json(DESCRIPTION_JSON_SCHEMA, self.description.to_json).each do |error|
			self.errors.add(:base, error)
		end
	end

end
