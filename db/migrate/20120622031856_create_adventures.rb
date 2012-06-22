class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|

      t.timestamps
    end
  end
end
