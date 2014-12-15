class 
  FieldRulesController < ApplicationController
  before_action :set_field_rule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  # GET /field_rules
  # GET /field_rules.json
  def index
    @object_rule = ObjectRule.find(params[:object_rule_id])
    @field_rules = FieldRule.where(object_rule_id: params[:object_rule_id])

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

  # GET /field_rules/1
  # GET /field_rules/1.json
  def show
    @field_rule = FieldRule.find(params[:id])
    @object_rule = ObjectRule.find(params[:object_rule_id])
  end

  # GET /field_rules/new
  def new
    @field_rule = FieldRule.new
    @object_rule = ObjectRule.find(params[:object_rule_id])
  end

  # GET /field_rules/1/edit
  def edit
    @field_rule = FieldRule.find(params[:id])
    @object_rule = ObjectRule.find(params[:object_rule_id])
  end

  # POST /field_rules
  # POST /field_rules.json
  def create
    @field_rule = FieldRule.new(field_rule_params)
    @field_rule.object_rule_id = params[:object_rule_id]

    respond_to do |format|
      if @field_rule.save
        format.html { redirect_to object_rule_field_rules_path(), notice: ' field rule was successfully created.' }
        format.json { render :show, status: :created, location: @field_rule }
      else
        format.html { render :new }
        format.json { render json: @field_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_rules/1
  # PATCH/PUT /field_rules/1.json
  def update
    respond_to do |format|
      if @field_rule.update(field_rule_params)
        format.html { redirect_to object_rule_field_rule_url, notice: ' field rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @field_rule }
      else
        format.html { render :edit }
        format.json { render json: @field_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_rules/1
  # DELETE /field_rules/1.json
  def destroy
    @field_rule.destroy
    respond_to do |format|
      format.html { redirect_to object_rule_field_rules_url, notice: ' field rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_rule
      @field_rule = FieldRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_rule_params
      params.require(:field_rule).permit(:extract_field, :transformation, :load_field, :active, :is_primary, :is_foreign_key)
    end
end
