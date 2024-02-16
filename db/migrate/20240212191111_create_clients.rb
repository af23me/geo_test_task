class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :api_key, null: false, index: { unique: true }
      t.integer :language, null: false, default: 0

      t.timestamps
    end
  end
end
