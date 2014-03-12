require_dependency "mfg_batchx/application_controller"

module MfgBatchx
  class BatchesController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Production Batches')
      @batches = params[:mfg_batchx_batches][:model_ar_r]
      @batches = @batches.where(:rfq_id => @rfq.id) if @rfq
      @batches = @batches.where(:order_id => @order.id) if @order
      @qty_total = @batches.sum('qty') if @order && @batches
      @qty_produced_total = @batches.sum('qty_produced') if @order && @batches
      @batches = @batches.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('batch_index_view', 'mfg_batchx')
    end
  
    def new
      @title = t('New Batch')
      @batch = MfgBatchx::Batch.new()
      @erb_code = find_config_const('batch_new_view', 'mfg_batchx')
    end
  
    def create
      @batch = MfgBatchx::Batch.new(params[:batch], :as => :role_new)
      @batch.last_updated_by_id = session[:user_id]
      if @batch.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @rfq = MfgBatchx.rfq_class.find_by_id(params[:batch][:rfq_id]) if params[:batch].present? && params[:batch][:rfq_id].present?
        @order = MfgBatchx.order_class.find_by_id(params[:batch][:order_id]) if params[:batch].present? && params[:batch][:order_id].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Batch')
      @batch = MfgBatchx::Batch.find_by_id(params[:id])
      @erb_code = find_config_const('batch_edit_view', 'mfg_batchx')
    end
  
    def update
      @batch = MfgBatchx::Batch.find_by_id(params[:id])
      @batch.last_updated_by_id = session[:user_id]
      if @batch.update_attributes(params[:batch], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Batch Info')
      @batch = MfgBatchx::Batch.find_by_id(params[:id])
      @erb_code = find_config_const('batch_show_view', 'mfg_batchx')
    end
    
    protected
    def load_parent_record
      @rfq = MfgBatchx.rfq_class.find_by_id(params[:rfq_id]) if params[:rfq_id].present?
      @rfq = MfgBatchx.rfq_class.find_by_id(MfgBatchx.order_class.find_by_id(params[:order_id]).rfq_id) if params[:order_id].present?
      @order = MfgBatchx.order_class.find_by_id(params[:order_id]) if params[:order_id].present?
      @rfq = MfgBatchx.rfq_class.find_by_id(MfgBatchx::Batch.find_by_id(params[:id]).rfq_id) if params[:id].present?
      @order = MfgBatchx.order_class.find_by_id(MfgBatchx::Batch.find_by_id(params[:id]).order_id) if params[:id].present?
    end
  end
end
