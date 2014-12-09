class HomeController < ApplicationController
	before_action :authenticate_admin!
	def index
		@etl_jobs = EtlJob.all.reverse
		@etl_object_rules = EtlObjectRule.all.reverse
	end
end
