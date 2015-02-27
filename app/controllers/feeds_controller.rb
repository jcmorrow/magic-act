class FeedsController < ApplicationController
	skip_before_action :authenticate_admin!
	require 'action_kit_api'
	def actions
		api = ActionKitApi.new
		
		sql = 	"select distinct core_user.id, concat(ROUND(core_location.latitude, 2), ROUND(RAND()*100), 3) as latitude,
				    concat(ROUND(core_location.longitude, 2), ROUND(RAND()*100), 3) as longitude
				    from core_action join core_user on core_user.id = core_action.user_id JOIN core_location on core_user.id = core_location.user_id
				WHERE core_action.page_id in ( #{params[:id]} ) AND core_location.latitude != 0 AND core_location.longitude != 0
				group by core_user.id LIMIT 1000"
		response = api.query(sql)
		render json: response
	end

end
