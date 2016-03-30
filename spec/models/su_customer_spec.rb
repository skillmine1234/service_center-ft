require 'spec_helper'

describe SuCustomer do
  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
    it { should have_one(:su_unapproved_record) }
    it { should belong_to(:unapproved_record) }
    it { should belong_to(:approved_record) }
  end
  
  context 'validation' do
    [:account_no, :customer_id, :pool_account_no, :pool_customer_id].each do |att|
      it { should validate_presence_of(att) }
    end
    
    [:customer_id].each do |att|
      it { should validate_numericality_of(att) }
    end

    it do 
      su_customer = Factory(:su_customer, :approval_status => 'A')
      should validate_uniqueness_of(:customer_id).scoped_to(:approval_status)   
    end
  end
  
  context "default_scope" do 
    it "should only return 'A' records by default" do 
      su_customer1 = Factory(:su_customer, :approval_status => 'A') 
      su_customer2 = Factory(:su_customer, :account_no => '1234567891')
      SuCustomer.all.should == [su_customer1]
      su_customer2.approval_status = 'A'
      su_customer2.save
      SuCustomer.all.should == [su_customer1,su_customer2]
    end
  end    

  context "su_unapproved_records" do 
    it "oncreate: should create su_unapproved_record if the approval_status is 'U'" do
      su_customer = Factory(:su_customer)
      su_customer.reload
      su_customer.su_unapproved_record.should_not be_nil
    end

    it "oncreate: should not create su_unapproved_record if the approval_status is 'A'" do
      su_customer = Factory(:su_customer, :approval_status => 'A')
      su_customer.su_unapproved_record.should be_nil
    end

    it "onupdate: should not remove su_unapproved_record if approval_status did not change from U to A" do
      su_customer = Factory(:su_customer)
      su_customer.reload
      su_customer.su_unapproved_record.should_not be_nil
      record = su_customer.su_unapproved_record
      # we are editing the U record, before it is approved
      su_customer.account_no = '1234567892'
      su_customer.save
      su_customer.reload
      su_customer.su_unapproved_record.should == record
    end
    
    it "onupdate: should remove su_unapproved_record if the approval_status changed from 'U' to 'A' (approval)" do
      su_customer = Factory(:su_customer)
      su_customer.reload
      su_customer.su_unapproved_record.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      su_customer.approval_status = 'A'
      su_customer.save
      su_customer.reload
      su_customer.su_unapproved_record.should be_nil
    end
    
    it "ondestroy: should remove su_unapproved_record if the record with approval_status 'U' was destroyed (approval) " do
      su_customer = Factory(:su_customer)
      su_customer.reload
      su_customer.su_unapproved_record.should_not be_nil
      record = su_customer.su_unapproved_record
      # the approval process destroys the U record, for an edited record 
      su_customer.destroy
      SuUnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      su_customer = Factory(:su_customer, :approval_status => 'U')
      su_customer.approve.should == ""
      su_customer.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      su_customer = Factory(:su_customer, :approval_status => 'A')
      su_customer1 = Factory(:su_customer, :approval_status => 'U', :approved_id => su_customer.id, :approved_version => 6)
      su_customer1.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      su_customer1 = Factory(:su_customer, :approval_status => 'A')
      su_customer2 = Factory(:su_customer, :approval_status => 'U')
      su_customer1.enable_approve_button?.should == false
      su_customer2.enable_approve_button?.should == true
    end
  end
  
end
