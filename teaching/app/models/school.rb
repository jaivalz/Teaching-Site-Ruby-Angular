class School < ActiveRecord::Base
  def change
    create_table :schools do |t|
      t.string :name
      t.string :thumbnail
      
      t.timestamps null: false
    end
  end
end
