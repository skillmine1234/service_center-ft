require 'spec_helper'

describe Group do
  context "model_list" do 
    it "should return array of model list" do 
      group = Factory(:group,:name => 'inward-remittance')
      group.model_list.should == ['Partner','Bank','PurposeCode','WhitelistedIdentity','InwIdentity','InwardRemittance', 'InwRemittanceRule','InwUnapprovedRecord']
      group = Factory(:group,:name => 'e-collect')
      group.model_list.should == ['EcolUnapprovedRecord','EcolRule','EcolCustomer','EcolRemitter','EcolTransaction','UdfAttribute','IncomingFile','EcolFetchStatistic']
    end
  end
end
