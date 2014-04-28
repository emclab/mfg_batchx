module MfgBatchx
  class Batch < ActiveRecord::Base
    attr_accessor :void_noupdate, :completed_noupdate, :batch_status_noupdate, :customer_name, :order_id_noupdate, :wf_comment, :id_noupdate
    attr_accessible :brief_note, :finish_date, :last_updated_by_id, :order_id, :qty, :qty_produced, :rfq_id, :start_date, :batch_num, :completed, 
                    :void, :batch_status_id, :wf_state,
                    :customer_name, :order_id_noupdate,
                    :as => :role_new 
    attr_accessible :brief_note, :completed, :finish_date, :last_updated_by_id, :order_id, :qty, :qty_produced, :rfq_id, :start_date, :batch_num, 
                    :void, :batch_status_id, :wf_state,
                    :void_noupdate, :completed_noupdate, :batch_status_noupdate, :customer_name, :order_id_noupdate, :wf_comment, :id_noupdate,
                    :as => :role_update
    
    attr_accessor :customer_id_s, :start_date_s, :id_s, :end_date_s, :time_frame_s, :batch_num_s, :order_id_s, :drawing_num_s, :rfq_id_s, :completed_s, :finish_date_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s, :time_frame_s, :batch_num_s, :order_id_s, :drawing_num_s, :rfq_id_s, :completed_s, 
                    :finish_date_s, :id_s,
                    :as => :role_search_stats
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :rfq, :class_name => MfgBatchx.rfq_class.to_s
    belongs_to :order, :class_name => MfgBatchx.order_class.to_s
    belongs_to :batch_status, :class_name => 'Commonx::MiscDefinition'
    has_many :step_qties, :class_name => 'MfgBatchx::StepQty'
    #accepts_nested_attributes_for :step_qties, :reject_if => proc {|i| i['qty'].blank? }
    
    validates :order_id, :rfq_id, :presence => true,
                         :numericality => {:greater_than => 0}
    validates :qty, :presence => true,
                    :numericality => {:greater_than => 0, :message => I18n.t('Qty > 0')}   
    validates :qty_produced, :numericality => {:greater_or_equal_to => 0}, :if => 'qty_produced.present?'
    validates :start_date, :finish_date, :presence => true  #:batch_status_id,
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'mfg_batchx')
      eval(wf) if wf.present?
    end
  end
end
