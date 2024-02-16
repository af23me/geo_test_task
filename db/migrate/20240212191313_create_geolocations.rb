class CreateGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geolocations do |t|
      t.string :ip, null: false, index: { unique: true }
      t.string :search_value, null: false
      t.string :hostname
      t.integer :ip_type, null: false
      t.string :continent_code, null: false
      t.string :continent_name, null: false
      t.string :country_code, null: false
      t.string :country_name, null: false
      t.string :region_code, null: false
      t.string :region_name, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false

      t.timestamps
    end
  end
end
