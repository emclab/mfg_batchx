require 'spec_helper'

module MfgBatchx
  describe StepQty do
    it "should be OK" do
      c = FactoryGirl.create(:mfg_batchx_step_qty)
      c.should be_valid
    end
    
    it "should reject 0 batch_id" do
      c = FactoryGirl.build(:mfg_batchx_step_qty, :batch_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil qty" do
      c = FactoryGirl.build(:mfg_batchx_step_qty, :qty => nil)
      c.should_not be_valid
    end
    
    it "should reject nil batch_status_id" do
      c = FactoryGirl.build(:mfg_batchx_step_qty, :batch_status_id => nil)
      c.should_not be_valid
    end
  end
end
