module MfgBatchx
  class StepQty < ActiveRecord::Base
    attr_accessor :ontime_indicator_noupdate
    attr_accessible :batch_id, :batch_status_id, :brief_note, :qty, :last_updated_by_id, :ontime_indicator,
                    :as => :role_new
    attr_accessible :batch_status_id, :brief_note, :qty, :ontime_indicator,
                    :ontime_indicator_noupdate,
                    :as => :role_update  
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :batch, :class_name => 'MfgBatchx::Batch' 
    belongs_to :batch_status, :class_name => 'Commonx::MiscDefinition'  
    
    validates :batch_id, :batch_status_id, :presence => true,
                         :numericality => {:greater_than => 0}
    validates :qty, :presence => true,
                    :numericality => {:greater_than_or_equal_to => 0, :message => I18n.t('Qty >= 0')}    
    validates :ontime_indicator, :presence => true         
  end
end
