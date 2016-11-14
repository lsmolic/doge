class CreateDoges < ActiveRecord::Migration
  def change
	  create_table :doges do |t|
		  t.column 'pet_name', :string
		  t.column 'description', :json
		  t.timestamps null: false
	  end
  end
end
