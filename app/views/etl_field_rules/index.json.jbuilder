json.array!(@etl_field_rules) do |etl_field_rule|
  json.extract! etl_field_rule, :id, :extract_field, :transformation, :load_field, :active
  json.url etl_field_rule_url(etl_field_rule, format: :json)
end
