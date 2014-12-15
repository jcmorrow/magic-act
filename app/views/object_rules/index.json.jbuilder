json.array!(@object_rules) do |object_rule|
  json.extract! object_rule, :id, :load_field, :extract_field, :active
  json.url object_rule_url(object_rule, format: :json)
end
