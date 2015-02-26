class FeedsController < ApplicationController
	skip_before_action :authenticate_admin!
	require 'action_kit_api'
	def actions
		api = ActionKitApi.new
		
		sql = 	"select ROUND(core_location.latitude, 2),
				    ROUND(core_location.longitude, 2)
				from core_user
				    left join core_location on core_user.id = core_location.user_id
				WHERE core_location.latitude != 0 AND core_location.longitude != 0 AND exists( select * from core_action where core_action.user_id = core_user.id and core_action.page_id in ( #{params[:id]} ) )
				group by core_user.id LIMIT 1000"
		response = api.query(sql)
=begin
		response_array = CSV.parse(response)
		response_objects = []
		response_array.each_with_index do |row, i|
			if(i > 0)
				donation = {response_array[0][0] => row[0].strip, response_array[0][1] => row[1], response_array[0][2] => row[2], response_array[0][3] => row[3], response_array[0][4] => row[4] }
				if(donation['custom_field_anonymous'] == 'on')
					donation['first_name_current'] = 'Anonymous';
				end
				response_objects.push(donation)
			end
		end
=end
		render json: response
	end

end
