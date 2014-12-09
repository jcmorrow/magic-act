class EtlFieldRulesController < ApplicationController
  before_action :set_etl_field_rule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  # GET /etl_field_rules
  # GET /etl_field_rules.json
  def index
    @etl_field_rules = EtlFieldRule.where(etl_object_rule_id: params[:etl_object_rule_id])
  end

  # GET /etl_field_rules/1
  # GET /etl_field_rules/1.json
  def show
    @etl_field_rule = EtlFieldRule.find(params[:id])
    @etl_object_rule = EtlObjectRule.find(params[:etl_object_rule_id])
  end

  # GET /etl_field_rules/new
  def new
    @etl_field_rule = EtlFieldRule.new
    @etl_object_rule = EtlObjectRule.find(params[:etl_object_rule_id])
  end

  # GET /etl_field_rules/1/edit
  def edit
    @etl_field_rule = EtlFieldRule.find(params[:id])
    @etl_object_rule = EtlObjectRule.find(params[:etl_object_rule_id])
  end

  # POST /etl_field_rules
  # POST /etl_field_rules.json
  def create
    @etl_field_rule = EtlFieldRule.new(etl_field_rule_params)
    @etl_field_rule.etl_object_rule_id = params[:etl_object_rule_id]

    respond_to do |format|
      if @etl_field_rule.save
        format.html { redirect_to etl_object_rule_etl_field_rules_path(), notice: 'Etl field rule was successfully created.' }
        format.json { render :show, status: :created, location: @etl_field_rule }
      else
        format.html { render :new }
        format.json { render json: @etl_field_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /etl_field_rules/1
  # PATCH/PUT /etl_field_rules/1.json
  def update
    respond_to do |format|
      if @etl_field_rule.update(etl_field_rule_params)
        format.html { redirect_to etl_object_rule_etl_field_rule_url, notice: 'Etl field rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @etl_field_rule }
      else
        format.html { render :edit }
        format.json { render json: @etl_field_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etl_field_rules/1
  # DELETE /etl_field_rules/1.json
  def destroy
    @etl_field_rule.destroy
    respond_to do |format|
      format.html { redirect_to etl_field_rules_url, notice: 'Etl field rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_etl_field_rule
      @etl_field_rule = EtlFieldRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def etl_field_rule_params
      params.require(:etl_field_rule).permit(:extract_field, :transformation, :load_field, :active, :is_primary, :is_foreign_key)
    end
end
