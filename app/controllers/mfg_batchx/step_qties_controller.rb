require_dependency "mfg_batchx/application_controller"

module MfgBatchx
  class StepQtiesController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Step Qties')
      @step_qties = params[:mfg_batchx_step_qties][:model_ar_r]
      @step_qties = @batch.step_qties if @batch
      @step_qties = @step_qties.page(params[:page]).per_page(@max_pagination)
      #@erb_code = find_config_const('batch_index_view', 'mfg_batchx')
    end
  
    def new
      @title = t('New Step Qty')
      @step_qty = MfgBatchx::StepQty.new()
      #@erb_code = find_config_const('batch_new_view', 'mfg_batchx')
    end
  
    def create
      @step_qty = MfgBatchx::StepQty.new(params[:step_qty], :as => :role_new)
      @step_qty.last_updated_by_id = session[:user_id]
      if @step_qty.save
        redirect_to step_qties_path(batch_id: @step_qty.batch_id), :notice => t('Successfully Saved!') #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @batch = MfgBatchx::Batch.find_by_id(params[:batch][:batch_id]) if params[:batch].present? && params[:batch][:batch_id].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Step Qty')
      @step_qty = MfgBatchx::StepQty.find_by_id(params[:id])
      #@erb_code = find_config_const('batch_edit_view', 'mfg_batchx')
    end
  
    def update
      @step_qty = MfgBatchx::StepQty.find_by_id(params[:id])
      @step_qty.last_updated_by_id = session[:user_id]
      if @step_qty.update_attributes(params[:step_qty], :as => :role_update)
        redirect_to step_qties_path(batch_id: @step_qty.batch_id), :notice => t('Successfully Updated!') #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    protected
    def load_parent_record
      @batch = MfgBatchx::Batch.find_by_id(params[:batch_id]) if params[:batch_id].present?
      @batch = MfgBatchx::Batch.find_by_id(MfgBatchx::StepQty.find_by_id(params[:id]).batch_id) if params[:id].present?
    end
  end
end
