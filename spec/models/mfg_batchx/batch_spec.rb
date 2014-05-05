require 'spec_helper'

module MfgBatchx
  describe Batch do
    it "should be OK" do
      c = FactoryGirl.create(:mfg_batchx_batch)
      c.should be_valid
    end
    
    it "should reject 0 order_id" do
      c = FactoryGirl.build(:mfg_batchx_batch, :order_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 rfq_id" do
      c = FactoryGirl.build(:mfg_batchx_batch, :rfq_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:mfg_batchx_batch, :qty => 0)
      c.should_not be_valid
    end
    
   it "should reject nil finish date" do
      c = FactoryGirl.build(:mfg_batchx_batch, :finish_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:mfg_batchx_batch, :start_date => nil)
      c.should_not be_valid
    end
    
    it "should allow nil batch_num" do
      c = FactoryGirl.build(:mfg_batchx_batch, :batch_num => nil)
      c.should be_valid
    end
    
    it "should reject dup batch_num" do
      c = FactoryGirl.create(:mfg_batchx_batch, :batch_num => '1234')
      c1 = FactoryGirl.build(:mfg_batchx_batch, :batch_num => c.batch_num)
      c1.should be_valid
    end
  end
end
