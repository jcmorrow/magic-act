class ObjectRulesController < ApplicationController
  before_action :set_object_rule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  require 'action_kit_api'

  # GET /object_rules
  # GET /object_rules.json
  def index
    @object_rules = ObjectRule.includes(:field_rules).all
  end

  # GET /object_rules/1
  # GET /object_rules/1.json
  def show
    @object_rule = ObjectRule.includes(:field_rules).find(params[:id])
    salesforce = Restforce.new
    actionkit = ActionKitApi.new
    
    @actionKitFields = []
    @salesForceFields = []
    actionkit.query("SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '#{@object_rule.extract_object}'").each do |field|
      @actionKitFields.push(field[0])
    end
    salesforce.describe(@object_rule.load_object)[:fields].each do |field|
      @salesForceFields.push(field[:name])
    end
    gon.push(:actionKitFields => @actionKitFields,
             :salesForceFields => @salesForceFields)
  end

  # GET /object_rules/new
  def new
    @object_rule = ObjectRule.new

    salesforce = Restforce.new
    actionkit = ActionKitApi.new

    @object_rules = ObjectRule.all
    actionKitTables = []
    salesForceObjects = []
    actionkit.query("SELECT TABLE_NAME FROM information_schema.tables WHERE table_name LIKE 'core%'").each do |table|
      actionKitTables.push(table[0])
    end
    salesforce.describe.each do |object|
      salesForceObjects.push(object[:name])
    end
    gon.push(:actionKitTables => actionKitTables,
             :salesForceObjects => salesForceObjects)
  end

  # GET /object_rules/1/edit
  def edit
  end

  # POST /object_rules
  # POST /object_rules.json
  def create
    @object_rule = ObjectRule.new(object_rule_params)

    respond_to do |format|
      if @object_rule.save
        format.html { redirect_to object_rule_field_rules_path(@object_rule, notice: ' object rule was successfully created.') }
        format.json { render :show, status: :created, location: @object_rule }
      else
        format.html { render :new }
        format.json { render json: @object_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /object_rules/1
  # PATCH/PUT /object_rules/1.json
  def update
    respond_to do |format|
      if @object_rule.update(object_rule_params)
        format.html { redirect_to @object_rule, notice: ' object rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @object_rule }
      else
        format.html { render :edit }
        format.json { render json: @object_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /object_rules/1
  # DELETE /object_rules/1.json
  def destroy
    @object_rule.destroy
    respond_to do |format|
      format.html { redirect_to object_rules_url, notice: ' object rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #VISUALIZER

  def explore
    salesforce = Restforce.new
    actionkit = ActionKitApi.new
    @object_rules = ObjectRule.all
    actionKitTables = []
    salesForceObjects = []
    actionkit.query("SELECT TABLE_NAME FROM information_schema.tables WHERE table_name LIKE 'core%'").each do |table|
      actionKitTables.push(table[0])
    end
    salesforce.describe.each do |object|
      salesForceObjects.push(object[:name])
    end
    gon.push(:actionKitTables => actionKitTables,
             :salesForceObjects => salesForceObjects)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_object_rule
      @object_rule = ObjectRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def object_rule_params
      params.require(:object_rule).permit(:load_object, :extract_object, :active, :is_primary, :custom_from_clause)
    end
end
