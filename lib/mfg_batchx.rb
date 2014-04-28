require "mfg_batchx/engine"

module MfgBatchx
  mattr_accessor :order_class, :rfq_class, :show_rfq_path, :warehouse_checkin_path, :warehouse_item_class, :customer_class
  
  def self.order_class
    @@order_class.constantize
  end
  
  def self.rfq_class
    @@rfq_class.constantize
  end
  
  def self.warehouse_item_class
    @@warehouse_item_class.constantize
  end
  
  def self.customer_class
    @@customer_class.constantize
  end
end
