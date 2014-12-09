class DownloadsController < ApplicationController
	before_action :authenticate_admin!
	def secureGet
		job = EtlSubJob.find(params[:sub_job_id])
		files = Hash[ 'extract' => job.extract_file,
						  'transform' => job.transform_file,
						  'load' => job.load_file]
		if(files.has_key?(params[:file_type]))
			file = files[params[:file_type]]
		end
		redirect_to(file.s3_object.url_for(:get, {:expires => 10.seconds}).to_s)
	end
end
