require 'spec_helper'

describe BmUnapprovedRecordsHelper do
  context "filter_records" do 
    it "should return records" do
      bm_unapproved_record = Factory(:bm_unapproved_record, :bm_approvable_type => 'BmRule')
      filter_records(EcolUnapprovedRecord).should eq([{:record_type=>"BmRule", :record_count=>1}, {:record_type=>"BmBiller", :record_count=>0}])
    end
  end
end
