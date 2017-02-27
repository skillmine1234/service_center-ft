require 'spec_helper'

describe InwardRemittanceHelper do
  
  # context 'find_inward_remittance' do
  #   it 'should return inward remittances' do
  #     inward_remittances = Factory(:inward_remittance,:status_code => 'IN_PROCESS')
  #     val = InwardRemittance
  #     find_inward_remittances(val,{:status => 'IN_PROCESS'}).should == [inward_remittances]
  #     find_inward_remittances(val,{:status => 'COMPLETED'}).should == []
  #
  #     inward_remittances = Factory(:inward_remittance,:notify_status => 'IN_PROCESS')
  #     val = InwardRemittance
  #     find_inward_remittances(val,{:notify_status => 'IN_PROCESS'}).should == [inward_remittances]
  #     find_inward_remittances(val,{:notify_status => 'COMPLETED'}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance,:req_no => 'R1234')
  #     find_inward_remittances(val,{:request_no => 'R1234'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:request_no => 'r1234'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:request_no => 'r12'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:request_no => 'R12'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:request_no => '4321R'}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance,:partner_code => 'PARTNER1')
  #     find_inward_remittances(val,{:partner_code => 'PARTNER1'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:partner_code => 'PART'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:partner_code => 'part'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:partner_code => 'PARTNER2'}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance,:bank_ref => '123444')
  #     find_inward_remittances(val,{:bank_ref => '123444'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:bank_ref => '123443'}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance, :rmtr_full_name => "AABBCC DDEE")
  #     find_inward_remittances(val,{:rmtr_full_name => "AABBCC DDEE"}).should == [inward_remittance]
  #     find_inward_remittances(val, {:rmtr_full_name => "AACCC DDEE"}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance,:req_transfer_type => 'IMPS')
  #     find_inward_remittances(val,{:req_transfer_type => 'IMPS'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:req_transfer_type => 'NEFT'}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance,:req_transfer_type => 'FT')
  #     find_inward_remittances(val,{:req_transfer_type => 'FT'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:req_transfer_type => 'NEFT'}).should == []
  #
  #     inward_remittance = Factory(:inward_remittance,:transfer_type => 'NEFT')
  #     find_inward_remittances(val,{:transfer_type => 'NEFT'}).should == [inward_remittance]
  #     find_inward_remittances(val,{:transfer_type => 'IMPS'}).should == []
  #
  #     inward_remittance = [Factory(:inward_remittance, :transfer_amount => '10000')]
  #     inward_remittance << Factory(:inward_remittance, :transfer_amount => '9000')
  #     inward_remittance << Factory(:inward_remittance, :transfer_amount => '8000')
  #     find_inward_remittances(val,{:from_amount => '8000', :to_amount => '10000'}).should == inward_remittance
  #     find_inward_remittances(val,{:from_amount => '10000', :to_amount => '12000'}).should == [inward_remittance[0]]
  #
  #     inward_remittance = [Factory(:inward_remittance, :req_timestamp => '2015-04-25')]
  #     inward_remittance << Factory(:inward_remittance, :req_timestamp => '2015-04-26')
  #     inward_remittance << Factory(:inward_remittance, :req_timestamp => '2015-04-27')
  #     find_inward_remittances(val,{:from_date => '2015-04-25', :to_date => '2015-04-27'}).should == inward_remittance
  #     find_inward_remittances(val,{:from_date => '2015-04-28', :to_date => '2015-04-30'}).should == []
  #   end
  # end

  context "find_logs" do
    it "should return the logs" do
      transaction = Factory(:inward_remittance)
      log =  Factory(:inw_audit_step, :inw_auditable_type => 'InwardRemittance', :inw_auditable_id => transaction.id, :step_name => 'NOTIFY')
      find_logs({:step_name => 'NOTIFY'},transaction).should == transaction.audit_steps
      find_logs({:step_name => 'RETURN'},transaction).should == []
    end
  end
end