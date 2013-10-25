require "mfg_batchx/engine"

module MfgBatchx
  mattr_accessor :order_class, :rfq_class, :show_rfq_path
  
  def self.order_class
    @@order_class.constantize
  end
  
  def self.rfq_class
    @@rfq_class.constantize
  end
end
