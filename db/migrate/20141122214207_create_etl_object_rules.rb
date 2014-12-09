class CreateEtlObjectRules < ActiveRecord::Migration
  def change
    create_table :etl_object_rules do |t|
      t.string :load_field
      t.string :extract_field
      t.boolean :active

      t.timestamps
    end
  end
end
