class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
    @object_rules = @job.object_rules
    @sub_job_groups = @job.sub_job_groups
  end

  # GET /jobs/new
  def new
    @job = Job.new
    @object_rules = ObjectRule.all
  end

  # GET /jobs/1/edit
  def edit
    @object_rules = ObjectRule.all
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: ' job was successfully created. Thanks Obama!' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: ' job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: ' job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def queryCount
    require 'action_kit_api'
    @job = Job.find(params[:id])
    actionKit = ActionKitApi.new
    count = actionKit.findUsersCountWhere(@job.query, nil).body.gsub('[', '').gsub(']', '')
    respond_to do |format|
      format.html {render plain: count} # You probably have something like this already
      format.js {render js: 'alert("Your query will return ' + count.to_s + ' ActionKit ' + 'user'.pluralize(count.to_i) + '");'} # Add this line
    end
  end

  def run
    @job = Job.find(params[:id])
    @job.run
    redirect_to @job, notice: 'Job Queued.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:is_scheduled, :query, object_rule_ids: [])
    end
end
