require 'spec_helper'

module MfgBatchx
  describe BatchesController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @rfq = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id, :sales_id => @u.id)
      @rfq1 = FactoryGirl.create(:jobshop_rfqx_rfq, :product_name => 'new name', :drawing_num => '12345', :customer_id => @cust.id, :sales_id => @u.id)
      @order = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq.id)
      @order1 = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq1.id)
      @status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'mfg_batch_status', :name => 'started')
      
    end
    
    render_views
  
    describe "GET 'index'" do
      it "returns all batches" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MfgBatchx::Batch.where(:void => false).order('start_date DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq.id, :order_id => @order.id, :batch_status_id => @status.id)
        o1 = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq1.id, :order_id => @order1.id, :batch_status_id => @status.id)
        get 'index', {:use_route => :mfg_batchx}
        assigns(:batches).should =~ [o, o1]
      end
      
      it "should return batches for the rfq" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MfgBatchx::Batch.where(:void => false).order('start_date DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq.id, :order_id => @order.id, :batch_status_id => @status.id)
        o1 = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq1.id, :order_id => @order1.id, :batch_status_id => @status.id)
        get 'index', {:use_route => :mfg_batchx, :rfq_id => @rfq1.id}
        assigns(:batches).should =~ [o1]
      end
      
      it "should return batches for the order" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MfgBatchx::Batch.where(:void => false).order('start_date DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq.id, :order_id => @order.id, :batch_status_id => @status.id)
        o1 = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq1.id, :order_id => @order1.id, :batch_status_id => @status.id)
        get 'index', {:use_route => :mfg_batchx, :order_id => @order.id}
        assigns(:batches).should =~ [o]
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :mfg_batchx, :order_id => @order.id}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:mfg_batchx_batch, :order_id => @order.id, :batch_status_id => @status.id)
        get 'create', {:use_route => :mfg_batchx, :order_id => @order.id, :batch => q}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:mfg_batchx_batch, :rfq_id => nil)
        get 'create', {:use_route => :mfg_batchx, :order_id => @order1.id, :batch => q}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_batchx_batch, :order_id => @order.id, :batch_status_id => @status.id)
        get 'edit', {:use_route => :mfg_batchx, :id => q.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_batchx_batch, :order_id => @order1.id, :batch_status_id => @status.id)
        get 'update', {:use_route => :mfg_batchx, :id => q.id, :batch => {:brief_note => 'steel 201'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_batchx_batch, :order_id => @order.id, :batch_status_id => @status.id)
        get 'update', {:use_route => :mfg_batchx, :id => q.id, :batch => {:qty => 0}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.rfq.sales_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_batchx_batch, :order_id => @order.id, :batch_status_id => @status.id)
        get 'show', {:use_route => :mfg_batchx, :id => q.id}
        response.should be_success
      end
    end
  end
end
