class VisualizationsController < ApplicationController
	before_action :authenticate_admin!
	def index

	end
	def query
		require 'actionkitapi'
		actionkit = ActionKitApi.new
		render plain: actionkit.query(params[:query])
	end
end