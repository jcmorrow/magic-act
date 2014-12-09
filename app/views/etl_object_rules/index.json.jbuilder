json.array!(@etl_object_rules) do |etl_object_rule|
  json.extract! etl_object_rule, :id, :load_field, :extract_field, :active
  json.url etl_object_rule_url(etl_object_rule, format: :json)
end
