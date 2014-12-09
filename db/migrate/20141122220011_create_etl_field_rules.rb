class CreateEtlFieldRules < ActiveRecord::Migration
  def change
    create_table :etl_field_rules do |t|
      t.string :extract_field
      t.text :transformation
      t.string :load_field
      t.boolean :active

      t.timestamps
    end
  end
end
