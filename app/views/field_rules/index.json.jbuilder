json.array!(@field_rules) do |field_rule|
  json.extract! field_rule, :id, :extract_field, :transformation, :load_field, :active
  json.url field_rule_url(field_rule, format: :json)
end
