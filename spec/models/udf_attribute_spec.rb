require 'spec_helper'

describe UdfAttribute do
  context 'association' do
    it { should have_one(:ecol_unapproved_record) }
    it { should belong_to(:unapproved_record) }
    it { should belong_to(:approved_record) }
  end

  context 'validation' do
    [:class_name, :attribute_name, :is_enabled].each do |att|
      it { should validate_presence_of(att) }
    end

    it do 
      udf_attribute = Factory(:udf_attribute,:approval_status => 'A')
      should validate_uniqueness_of(:attribute_name).scoped_to(:class_name,:approval_status)
    end

    it "should validate_unapproved_record" do 
      udf_attribute1 = Factory(:udf_attribute,:approval_status => 'A')
      udf_attribute2 = Factory(:udf_attribute, :approved_id => udf_attribute1.id)
      udf_attribute1.should_not be_valid
      udf_attribute1.errors_on(:base).should == ["Unapproved Record Already Exists for this record"]
    end

    context "validate_data_type" do 
      it "should return error if the data type is not present when the control type is TextBox" do 
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => nil)
        udf.should_not be_valid
        udf.errors_on(:data_type).should == ["should be present for TextBox control"]
        udf = Factory.build(:udf_attribute, :control_type => 'CheckBox', :data_type => nil)
        udf.should be_valid
        udf.errors_on(:data_type).should == []
      end
    end

    context "validate_options" do
      it "should return error in case of invalid format for options" do
        udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :select_options => "---\n name1: value1\n\r name2:value2")
        udf.should_not be_valid
        udf.errors_on(:select_options).should == ["not in the following format <br> \"name1\": \"value1\" <br> \"name2\": \"value2\" <br>"]
        udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :select_options => "---\n name1: value1")
        udf.should_not be_valid
        udf.errors_on(:select_options).should == ["not in the following format <br> \"name1\": \"value1\" <br> \"name2\": \"value2\" <br>"]
        udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :select_options => "\"name1\": \"value1\"\r\n\"name2\": \"value2\"")
        udf.should be_valid
      end
    end

    context "validate_constraint_input" do
      it "should retrn error in case all length and min_length and max_length are specified for string data type" do
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String', :length => 3, :min_length => 4, :max_length => 5)
        udf.should_not be_valid
        udf.errors_on(:data_type).should == ["Please specify Either Length or (min Length and max Length) for this data type"]
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String', :length => 3, :min_length => 4, :max_length => "")
        udf.should_not be_valid
        udf.errors_on(:data_type).should == ["Please specify Either Length or (min Length and max Length) for this data type"]
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String', :length => 3, :min_length => "", :max_length => "")
        udf.should be_valid
        udf.errors_on(:data_type).should == []
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String', :length => "", :min_length => 4, :max_length => "")
        udf.should be_valid
        udf.errors_on(:data_type).should == []
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String', :length => "", :min_length => 4, :max_length => 5)
        udf.should be_valid
        udf.errors_on(:data_type).should == []
        udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String', :length => "", :min_length => "", :max_length => 5)
        udf.should be_valid
        udf.errors_on(:data_type).should == []
      end
    end
  end

  context "type" do
    it "should return the type as boolean if control type is checkbox" do
      udf = Factory.build(:udf_attribute, :control_type => 'CheckBox')
      udf.type.should == "boolean"
    end

    it "should return the type as select if control type is dropdown" do
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown')
      udf.type.should == "select"
    end

    it "should return the type as date if data type is Date" do
      udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'Date')
      udf.type.should == "date"
    end

    it "should return the type as select if control type is dropdown" do
      udf = Factory.build(:udf_attribute, :control_type => 'TextBox', :data_type => 'String')
      udf.type.should == "string"
    end
  end

  context "regenerate_accessor_fields" do
    it "should return value for the symbol in hash" do
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :constraints => {:min_length => {:minimum => 6}})
      udf.regenerate_accessor_fields
      udf.min_length.should == 6
    end
  end

  context "construct_validate_hash" do
    it "should construct hash before save" do
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :constraints => {}, :min_length => 6)
      udf.construct_validate_hash
      udf.constraints.should == {:min_length => {:minimum => 6}}
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :constraints => {}, :length => 6)
      udf.construct_validate_hash
      udf.constraints.should == {:length => {:is => 6, :message => "should be of 6 characters"}}
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :constraints => {}, :max_length => 6)
      udf.construct_validate_hash
      udf.constraints.should == {:max_length => {:maximum => 6}}
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :constraints => {}, :min_value => 6)
      udf.construct_validate_hash
      udf.constraints.should == {:min_value => {:minimum => 6}}
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :constraints => {}, :max_value => 6)
      udf.construct_validate_hash
      udf.constraints.should == {:max_value => {:maximum => 6}}
    end
  end
  
  context "options_list" do 
    it "should return options in a hash" do 
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :select_options => "---\n name1: value1")
      udf.select_options_list.should == {"name1" => "value1"}
      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :select_options => nil)
      udf.select_options_list.should be_nil
    end
  end
  
  context "cross_field_validations" do
    it "should perform cross field validations" do
      udf = Factory.build(:udf_attribute, :is_enabled => 'Y', :label_text => nil)
      udf.save == false
      udf.errors_on(:label_text).should == ['Label_text is mandatory if is_enabled is Y']
      
      udf = Factory.build(:udf_attribute, :is_enabled => 'Y', :control_type => nil)
      udf.save == false
      udf.errors_on(:control_type).should == ['Control_type is mandatory if is_enabled is Y']

      udf = Factory.build(:udf_attribute, :control_type => 'DropDown', :max_length => 1, :min_length => 1)
      udf.save == false
      udf.errors_on(:control_type).should == ['Constraints cannot be entered if control_type is Dropdown']      
    end
  end
  
  context "options_for_attribute_name" do
    it  "should return options for attribute name" do
      UdfAttribute.options_for_attribute_name.should ==  [['udf1','udf1'],['udf2','udf2'],['udf3','udf3'],['udf4','udf4'],
      ['udf5','udf5'],['udf6','udf6'],['udf7','udf7'],['udf8','udf8'],['udf9','udf9'],['udf10','udf10'],
      ['udf11','udf11'],['udf12','udf12'],['udf13','udf13'],['udf14','udf14'],['udf15','udf15'],['udf16','udf16'],
      ['udf17','udf17'],['udf18','udf18'],['udf19','udf19'],['udf20','udf20']]   
    end
  end

  context "default_scope" do 
    it "should only return 'A' records by default" do 
      udf_attribute1 = Factory(:udf_attribute, :approval_status => 'A') 
      udf_attribute2 = Factory(:udf_attribute)
      UdfAttribute.all.should == [udf_attribute1]
      udf_attribute2.approval_status = 'A'
      udf_attribute2.save!
      UdfAttribute.all.should == [udf_attribute1,udf_attribute2]
    end
  end    

  context "create_ecol_unapproved_records" do 
    it "should create ecol_unapproved_record if the approval_status is 'U' and there is no previous record" do
      udf_attribute = Factory(:udf_attribute)
      udf_attribute.reload
      udf_attribute.ecol_unapproved_record.should_not be_nil
      record = udf_attribute.ecol_unapproved_record
      udf_attribute.min_length = '6'
      udf_attribute.save
      udf_attribute.ecol_unapproved_record.should == record
    end

    it "should not create ecol_unapproved_record if the approval_status is 'A'" do
      udf_attribute = Factory(:udf_attribute, :approval_status => 'A')
      udf_attribute.ecol_unapproved_record.should be_nil
    end
  end        

  context "remove_ecol_unapproved_records" do 
    it "should remove ecol_unapproved_record if the approval_status is 'A' and there is unapproved_record" do
      udf_attribute = Factory(:udf_attribute)
      udf_attribute.reload
      udf_attribute.ecol_unapproved_record.should_not be_nil
      record = udf_attribute.ecol_unapproved_record
      udf_attribute.min_length = '6'
      udf_attribute.save
      udf_attribute.ecol_unapproved_record.should == record
      udf_attribute.approval_status = 'A'
      udf_attribute.save
      udf_attribute.remove_ecol_unapproved_records
      udf_attribute.reload
      udf_attribute.ecol_unapproved_record.should be_nil
    end
  end  

  context "approve" do 
    it "should approve unapproved_record" do 
      udf_attribute = Factory(:udf_attribute, :approval_status => 'U')
      udf_attribute.approve.should == ""
      udf_attribute.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      udf_attribute = Factory(:udf_attribute, :approval_status => 'A')
      udf_attribute2 = Factory(:udf_attribute, :approval_status => 'U', :approved_id => udf_attribute.id, :approved_version => 6)
      udf_attribute2.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      udf_attribute1 = Factory(:udf_attribute, :approval_status => 'A')
      udf_attribute2 = Factory(:udf_attribute, :approval_status => 'U')
      udf_attribute1.enable_approve_button?.should == false
      udf_attribute2.enable_approve_button?.should == true
    end
  end
end