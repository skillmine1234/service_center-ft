# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :qg_ecol_todays_neft_txn do
    sequence(:transfer_unique_no) {|n| "9" + "%03i" % "#{n}" }
    sequence(:ref_txn_no) {|n| "8" + "%03i" % "#{n}" }
    transfer_type "MyString"
    transfer_status "MyString"
    rmtr_ref "MyString"
    bene_account_ifsc "ASDF0123456"
    bene_account_no "MyString"
    bene_account_type "MyString"
    rmtr_account_ifsc "ASDF0123456"
    rmtr_account_no "MyString"
    rmtr_account_type "MyString"
    transfer_amt 1
    transfer_ccy "MyString"
    transfer_date "2016-01-11 04:32:59"
    rmtr_full_name "MyString"
    rmtr_address "MyString"
    bene_full_name "MyString"
  end
end
