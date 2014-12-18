# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = Admin.new
admin.approved = true
admin.email = ENV['devise_admin_username']
admin.password = ENV['devise_admin_password']
admin.password_confirmation = ENV['devise_admin_password']
admin.save!



ObjectRule.create(
				  :extract_object => "core_user", 
				  :load_object => "Akid__c", 
				  :is_primary => "true", 
				  :active => 'true',
				  :custom_from_clause => "",
				  :name => "ActionKit User to SalesForce Contact")

ObjectRule.create(
				  :extract_object => "core_transaction", 
				  :load_object => "Opportunity", 
				  :is_primary => "false", 
				  :active => 'true',
				  :custom_from_clause => " FROM core_transaction JOIN core_order ON core_order.id = core_transaction.order_id LEFT JOIN core_orderrecurring on core_order.id = core_orderrecurring.order_id JOIN core_action ON core_action.id = core_order.action_id JOIN core_page ON core_page.id = core_action.page_id ",
				  :name => "ActionKit Transaction to Opportunity")

FieldRule.create(
				  :extract_field => "core_user.email",
				  :transformation => "", 
				  :load_field => "Email__c",
				  :active => "true",
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false")


FieldRule.create(
				  :extract_field => "core_user.first_name", 
				  :transformation => "", 
				  :load_field => "First_Name__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_user.last_name", 
				  :transformation => "", 
				  :load_field => "Last_Name__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_user.city", 
				  :transformation => "", 
				  :load_field => "City__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "if( length( core_user.state ), core_user.state, core_user.region )", 
				  :transformation => "", 
				  :load_field => "State_Province__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "if( core_user.zip, concat_ws( '-', core_user.zip, if( length( core_user.plus4 ), core_user.plus4, null ) ), core_user.postal )", 
				  :transformation => "", 
				  :load_field => "Zip_Postal__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_user.country", 
				  :transformation => "", 
				  :load_field => "Country__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "( select coalesce( group_concat( phone order by core_phone.id desc separator ', ' ), '' ) from core_phone where core_phone.user_id = core_user.id )", 
				  :transformation => "", 
				  :load_field => "Phone__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_user.subscription_status ", 
				  :transformation => 'value == "subscribed" ? 1 : 0', 
				  :load_field => "Is_Subscribed__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "concat_ws( ', ', if( length( core_user.address1 ), core_user.address1, null ), if( length( core_user.address2 ), core_user.address2, null ) )", 
				  :transformation => "", 
				  :load_field => "Street_Address__c", 
				  :object_rule_id => "1", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_user.id", 
				  :transformation => "", 
				  :load_field => "Name", 
				  :object_rule_id => "1", 
				  :is_primary => "true", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_order.user_id", 
				  :transformation => "", 
				  :load_field => "Akid__c", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "true", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => " concat( ( select core_page.title from core_page where core_action.page_id = core_page.id ), ' (', core_action.page_id , ')' )", 
				  :transformation => "", 
				  :load_field => "Name", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_transaction.created_at", 
				  :transformation => "", 
				  :load_field => "CloseDate", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_transaction.amount_converted", 
				  :transformation => "", 
				  :load_field => "Amount", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_transaction.trans_id", 
				  :transformation => "", 
				  :load_field => "transaction_id__c", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "if( core_orderrecurring.id is not null, 'True', 'False' )", 
				  :transformation => 'value == "True" ? 1:0', 
				  :load_field => "Is_recurring__c", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_transaction.status", 
				  :transformation => 'Closed Won" if value == "completed"', 
				  :load_field => "StageName", 
				  :object_rule_id => "2", 
				  :is_primary => "false", 
				  :is_foreign_key => "false", 
				  :active => 'true')
FieldRule.create(
				  :extract_field => "core_transaction.id", 
				  :transformation => "", 
				  :load_field => "OrderNumber__c", 
				  :object_rule_id => "2", 
				  :is_primary => "true", 
				  :is_foreign_key => "false", 
				  :active => 'true')