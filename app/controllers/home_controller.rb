class HomeController < ApplicationController
	before_action :authenticate_admin!
	def index
		@jobs = Job.all.reverse
		@object_rules = ObjectRule.all.reverse
	end
end
