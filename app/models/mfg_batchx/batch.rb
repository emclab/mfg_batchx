module MfgBatchx
  class Batch < ActiveRecord::Base
    attr_accessor :void_noupdate, :completed_noupdate, :batch_status_noupdate, :customer_name, :order_id_noupdate, :wf_comment, :id_noupdate
    attr_accessible :brief_note, :finish_date, :last_updated_by_id, :order_id, :qty, :qty_produced, :rfq_id, :start_date, :wfid, :completed, 
                    :void, :batch_status_id, :wf_state,
                    :customer_name, :order_id_noupdate,
                    :as => :role_new 
    attr_accessible :brief_note, :completed, :finish_date, :last_updated_by_id, :order_id, :qty, :qty_produced, :rfq_id, :start_date, :wfid, 
                    :void, :batch_status_id, :wf_state,
                    :void_noupdate, :completed_noupdate, :batch_status_noupdate, :customer_name, :order_id_noupdate, :wf_comment, :id_noupdate,
                    :as => :role_update
    
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
    validates_presence_of :batch_status_id, :start_date
  end
end
