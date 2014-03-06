require 'spec_helper'

describe "LinkTests" do
  mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "MfgBatchx::Batch.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.rfq.sales_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'mfg_batchx_batches', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.rfq.sales_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_order', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'user_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_mfg_batch', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'mfg_batchx_step_qties', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "MfgBatchx::StepQty.scoped.order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'mfg_batchx_step_qties', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'mfg_batchx_step_qties', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @rfq = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id, :sales_id => @u.id)
      #@rfq1 = FactoryGirl.create(:jobshop_rfqx_rfq, :product_name => 'new name', :drawing_num => '12345', :customer_id => @cust.id, :sales_id => @u.id)
      @order = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq.id)
      #@order1 = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq1.id)
      @status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'mfg_batch_status', :name => 'started')
      @b = FactoryGirl.create(:mfg_batchx_batch, :rfq_id => @rfq.id, :order_id => @order.id)
      log = FactoryGirl.create(:commonx_log, :resource_name => 'mfg_batchx_batches', :resource_id => @b.id)
      @step = FactoryGirl.create(:mfg_batchx_step_qty, :batch_id => @b.id, :batch_status_id => @status.id)
        
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
  describe "GET /mfg_batchx_link_tests" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit batches_path
      #save_and_open_page
      page.should have_content('Batches')
      click_link "Edit"
      page.should have_content('Edit Batch')
      visit batches_path
      click_link @b.id.to_s
      page.should have_content('Batch Info')
      click_link 'New Log'
      page.should have_content('Log')
      visit batches_path(:order_id => @order.id)
      #save_and_open_page
      click_link 'New Batch'
      #save_and_open_page
      page.should have_content('New Batch')
    end
    
    it "works for step qty" do
      visit batches_path
      save_and_open_page
      page.should have_content('Step Product Qties')
      click_link "Step Product Qties"
      save_and_open_page
      page.should have_content('Next Step')
      click_link 'Next Step'
      save_and_open_page
      
      visit batches_path
      #save_and_open_page
      page.should have_content('Step Product Qties')
      click_link "Step Product Qties"
      #save_and_open_page
      page.should have_content('Edit')
      click_link 'Edit'
      save_and_open_page
    end
  end
end
