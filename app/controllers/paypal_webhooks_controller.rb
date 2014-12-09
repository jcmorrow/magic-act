class PaypalWebhooksController < ApplicationController
	def webhook
		render status: 200
	end
end