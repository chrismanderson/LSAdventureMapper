class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string      :title
      t.string      :city
      t.string      :state
      t.integer     :zipcode
      t.text        :description
      t.text        :details
      t.integer     :price
      t.float    :latitude
      t.float   :longitude
      t.boolean     :sold_out
      t.date        :expiration
      t.timestamps
    end
  end
end
