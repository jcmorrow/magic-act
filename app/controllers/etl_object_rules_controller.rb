class EtlObjectRulesController < ApplicationController
  before_action :set_etl_object_rule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  require 'actionkitapi'

  # GET /etl_object_rules
  # GET /etl_object_rules.json
  def index
    salesforce = Restforce.new
    actionkit = ActionKitApi.new
    @etl_object_rules = EtlObjectRule.all
    @object_details = []
    @etl_object_rules.each do |rule|
      @object_details.push({:extract_object_name => rule.extract_object.gsub('core_', ''), :extract_object => actionkit.get("/#{rule.extract_object.gsub('core_', '')}/schema"), :load_object_name => rule.load_object, :load_object =>  salesforce.describe(rule.load_object)})
    end
  end

  # GET /etl_object_rules/1
  # GET /etl_object_rules/1.json
  def show
    @etl_object_rule = EtlObjectRule.includes(:etl_field_rules).find(params[:id])
  end

  # GET /etl_object_rules/new
  def new
    @etl_object_rule = EtlObjectRule.new
  end

  # GET /etl_object_rules/1/edit
  def edit
  end

  # POST /etl_object_rules
  # POST /etl_object_rules.json
  def create
    @etl_object_rule = EtlObjectRule.new(etl_object_rule_params)

    respond_to do |format|
      if @etl_object_rule.save
        format.html { redirect_to @etl_object_rule, notice: 'Etl object rule was successfully created.' }
        format.json { render :show, status: :created, location: @etl_object_rule }
      else
        format.html { render :new }
        format.json { render json: @etl_object_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /etl_object_rules/1
  # PATCH/PUT /etl_object_rules/1.json
  def update
    respond_to do |format|
      if @etl_object_rule.update(etl_object_rule_params)
        format.html { redirect_to @etl_object_rule, notice: 'Etl object rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @etl_object_rule }
      else
        format.html { render :edit }
        format.json { render json: @etl_object_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etl_object_rules/1
  # DELETE /etl_object_rules/1.json
  def destroy
    @etl_object_rule.destroy
    respond_to do |format|
      format.html { redirect_to etl_object_rules_url, notice: 'Etl object rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def explore
    actionkit = ActionKitApi.new
    metaforce = Metaforce::Metadata::Client.new :username => ENV['SALESFORCE_USERNAME'], :password => ENV['SALESFORCE_PASSWORD'], :security_token => ENV['SALESFORCE_SECURITY_TOKEN']
    metaforce.describe[:metadata_objects]
    render plain: metaforce.list(:type => 'CustomObject')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_etl_object_rule
      @etl_object_rule = EtlObjectRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def etl_object_rule_params
      params.require(:etl_object_rule).permit(:load_object, :extract_object, :active, :is_primary)
    end
end
