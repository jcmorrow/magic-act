require 'json'
require 'httparty'

class ActionKitApi
	def initialize
		@options = { 
		    	:basic_auth => {:username => ENV['akUsername'], :password => ENV['akPassword'] },
		    	:headers => { "Content-Type" => "application/json"},
			}
		@base_url = 'https://' + ENV['actionKitUrl'] + '/rest/v1'
	end
	def get(url, options = Hash.new)
		com_opt = @options.merge(options)
		com_url = @base_url + url
		return HTTParty.get(com_url, @options)
	end
	def delete(url, options = Hash.new)
		com_opt = @options.merge(options)
		com_url = @base_url + url
		return HTTParty.delete(com_url, com_opt)
	end
	def put(url, options)
		result = JSON.parse(HTTParty.put(@base_url + url, @options).body)
		return result
	end
	def post(url, body, options = nil)
		options = @options
		options.store('body', body)
		result = HTTParty.post(@base_url + url, @options)
		return result
	end
	def query(sql)
	  	post_options = @options
	  	post_options[:body] = {:query => sql}.to_json
	  	return post('/report/run/sql/', post_options)
	end
	def report(slug, params)
		post_options = @options
		params.store(:format, 'json')
		post_options[:body] = params.to_json
		return post('/report/run/' + slug + '?format=json', post_options)
	end
	def findUsersWhere(where, limit)
		select = "select distinct core_user.id as user_id, core_user.email as Email__c, core_user.first_name as FirstName__c, core_user.last_name as LastName__c, concat_ws( ', ', if( length( core_user.address1 ), core_user.address1, null ), if( length( core_user.address2 ), core_user.address2, null ) ) as streetAddress__c, core_user.city as City__c, 				    if( core_user.zip, concat_ws( '-', core_user.zip, if( length( core_user.plus4 ), core_user.plus4, null ) ), core_user.postal ) as Zip_Postal__c, core_user.country as Country__c, core_user.subscription_status as Is_Subscribed__c, ( select coalesce( group_concat( phone order by core_phone.id desc separator ', ' ), '' ) from core_phone where core_phone.user_id = core_user.id ) as Phone__c from core_user "
		if(!limit.nil?)
			composedQuery = select + where + " group by core_user.id  order by uuid() LIMIT #{limit}"
		else
			composedQuery = select + where + " group by core_user.id  order by uuid()"
		end
		return query(composedQuery)
	end
	def findUsersCountWhere(where, limit)
		select = "SELECT count(distinct core_user.id) from core_user "
		composedQuery = select + where
		puts composedQuery
		return query(composedQuery)
	end
	def findDonors(startDate, endDate)
		sql =  "select distinct core_order.user_id as Name,
				    core_user.email as email__c,
				    core_user.first_name as firstName__c,
				    core_user.last_name as lastName__c,
				    concat_ws( ', ', if( length( core_user.address1 ), core_user.address1, null ), if( length( core_user.address2 ), core_user.address2, null ) ) as streetAddress__c,
				    core_user.city as user_city_current,
				    if( length( core_user.state ), core_user.state, core_user.region ) as state_province__c,
				    if( core_user.zip, concat_ws( '-', core_user.zip, if( length( core_user.plus4 ), core_user.plus4, null ) ), core_user.postal ) as zip_postal__c,
				    core_user.country as country__c,
				    if(exists ( select * from core_user where core_user.id = core_order.user_id and core_user.subscription_status = 'subscribed' ), 'true', 'false') as is_subscribed__c,
				    ( select coalesce( group_concat( phone order by core_phone.id desc separator ', ' ), '' ) from core_phone where core_phone.user_id = core_order.user_id and core_phone.type = 'home' ) as phone__c
				from core_order
				    left join core_user on core_user.id = core_order.user_id
				    left join core_orderrecurring on core_order.id = core_orderrecurring.order_id
				where core_order.created_at between timestamp('#{startDate.year}-#{startDate.month}-#{startDate.day}') and timestamp('#{endDate.year}-#{endDate.month}-#{endDate.day}', '23:59:59')
				group by core_order.id"
		return query(sql)
	end
	def findDonorsSQL(startDate, endDate)
		sql =  "select distinct core_order.user_id as Name,
				    core_user.email as email__c,
				    core_user.first_name as firstName__c,
				    core_user.last_name as lastName__c,
				    concat_ws( ', ', if( length( core_user.address1 ), core_user.address1, null ), if( length( core_user.address2 ), core_user.address2, null ) ) as streetAddress__c,
				    core_user.city as user_city_current,
				    if( length( core_user.state ), core_user.state, core_user.region ) as state_province__c,
				    if( core_user.zip, concat_ws( '-', core_user.zip, if( length( core_user.plus4 ), core_user.plus4, null ) ), core_user.postal ) as zip_postal__c,
				    core_user.country as country__c,
				    if(exists ( select * from core_user where core_user.id = core_order.user_id and core_user.subscription_status = 'subscribed' ), 'true', 'false') as is_subscribed__c,
				    ( select coalesce( group_concat( phone order by core_phone.id desc separator ', ' ), '' ) from core_phone where core_phone.user_id = core_order.user_id and core_phone.type = 'home' ) as phone__c
				from core_order
				    left join core_user on core_user.id = core_order.user_id
				    left join core_orderrecurring on core_order.id = core_orderrecurring.order_id
				where core_order.created_at between timestamp('#{startDate.year}-#{startDate.month}-#{startDate.day}') and timestamp('#{endDate.year}-#{endDate.month}-#{endDate.day}', '23:59:59')
				group by core_order.id"
		return sql
	end
	def findDonations(startDate, endDate)
		sql = 	"select core_order.id as order_id,
				    core_order.user_id,
				    date( core_order.created_at ) as created_at_d,
				    core_order.total_converted as total_converted_cur,
				    concat( ( select core_page.title from core_page where core_action.page_id = core_page.id ), ' (', core_action.page_id , ')' ) as page_title_id,
				    if( core_order.status in ('pending','failed'), 'failed', if( core_order.status = 'reversed', 'reversed', if( core_order.status != 'completed', core_order.status, if( core_orderrecurring.id is null, 'completed', if( core_orderrecurring.status = 'active', 'active', if( core_orderrecurring.status like 'cancel%', 'canceled', if( core_orderrecurring.status in ('pending','failed'), 'failed', core_orderrecurring.status ) ) ) ) ) ) ) as overall_status,
				    if( core_orderrecurring.id is not null, 'Recurring', 'One-Time' ) as is_recurring
				from core_order
				    left join core_action on core_action.id = core_order.action_id
				    left join core_orderrecurring on core_order.id = core_orderrecurring.order_id
				where core_order.updated_at between timestamp( '#{startDate.year}-#{startDate.month}-#{startDate.day}' ) and timestamp( '#{endDate.year}-#{endDate.month}-#{endDate.day}', '23:59:59' )
				group by core_order.id"
		return query(sql)
	end
	def findDonationsSQL(startDate, endDate)
		sql = 	"select core_order.id as order_id,
				    core_order.user_id,
				    date( core_order.created_at ) as created_at_d,
				    core_order.total_converted as total_converted_cur,
				    concat( ( select core_page.title from core_page where core_action.page_id = core_page.id ), ' (', core_action.page_id , ')' ) as page_title_id,
				    if( core_order.status in ('pending','failed'), 'failed', if( core_order.status = 'reversed', 'reversed', if( core_order.status != 'completed', core_order.status, if( core_orderrecurring.id is null, 'completed', if( core_orderrecurring.status = 'active', 'active', if( core_orderrecurring.status like 'cancel%', 'canceled', if( core_orderrecurring.status in ('pending','failed'), 'failed', core_orderrecurring.status ) ) ) ) ) ) ) as overall_status,
				    if( core_orderrecurring.id is not null, 'Recurring', 'One-Time' ) as is_recurring
				from core_order
				    left join core_action on core_action.id = core_order.action_id
				    left join core_orderrecurring on core_order.id = core_orderrecurring.order_id
				where core_order.updated_at between timestamp( '#{startDate.year}-#{startDate.month}-#{startDate.day}' ) and timestamp( '#{endDate.year}-#{endDate.month}-#{endDate.day}', '23:59:59' )
				group by core_order.id"
		return sql
	end
	def findUsers(filter, criteria)
		return get("/user/?"+filter+'='+URI::escape(criteria), @options)
	end
	def findUserByAKID(akid)
		return JSON.parse(get("/user/"+akid, @options).body)
	end
	def users
		get("/2.2/users/", @options)
	end
end