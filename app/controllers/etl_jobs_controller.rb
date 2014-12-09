class EtlJobsController < ApplicationController
  before_action :set_etl_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  # GET /etl_jobs
  # GET /etl_jobs.json
  def index
    @etl_jobs = EtlJob.all
  end

  # GET /etl_jobs/1
  # GET /etl_jobs/1.json
  def show
    @etl_job = EtlJob.find(params[:id])
    @etl_object_rules = @etl_job.etl_object_rules
    @etl_sub_job_groups = @etl_job.sub_job_groups
  end

  # GET /etl_jobs/new
  def new
    @etl_job = EtlJob.new
    @etl_object_rules = EtlObjectRule.all
  end

  # GET /etl_jobs/1/edit
  def edit
    @etl_object_rules = EtlObjectRule.all
  end

  # POST /etl_jobs
  # POST /etl_jobs.json
  def create
    @etl_job = EtlJob.new(etl_job_params)
    respond_to do |format|
      if @etl_job.save
        format.html { redirect_to @etl_job, notice: 'Etl job was successfully created.' }
        format.json { render :show, status: :created, location: @etl_job }
      else
        format.html { render :new }
        format.json { render json: @etl_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /etl_jobs/1
  # PATCH/PUT /etl_jobs/1.json
  def update
    respond_to do |format|
      if @etl_job.update(etl_job_params)
        format.html { redirect_to @etl_job, notice: 'Etl job was successfully updated.' }
        format.json { render :show, status: :ok, location: @etl_job }
      else
        format.html { render :edit }
        format.json { render json: @etl_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etl_jobs/1
  # DELETE /etl_jobs/1.json
  def destroy
    @etl_job.destroy
    respond_to do |format|
      format.html { redirect_to etl_jobs_url, notice: 'Etl job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def queryCount
    require 'actionkitapi'
    @etl_job = EtlJob.find(params[:id])
    actionKit = ActionKitApi.new
    count = actionKit.findUsersCountWhere(@etl_job.query, nil).body.gsub('[', '').gsub(']', '')
    respond_to do |format|
      format.html {render plain: count} # You probably have something like this already
      format.js {render js: 'alert("Your query will return ' + count.to_s + ' ActionKit ' + 'user'.pluralize(count.to_i) + '");'} # Add this line
    end
  end

  def run
    @etl_job = EtlJob.find(params[:id])
    @etl_job.run
    redirect_to @etl_job, notice: 'Job Queued.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_etl_job
      @etl_job = EtlJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def etl_job_params
      params.require(:etl_job).permit(:query, etl_object_rule_ids: [])
    end
end
