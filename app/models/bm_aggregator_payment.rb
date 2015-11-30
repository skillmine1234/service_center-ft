class BmAggregatorPayment < ActiveRecord::Base
  include Approval
  include BmApproval
  
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  has_one :bm_audit_log, :as => :bm_auditable
  
  validates_presence_of :cod_acct_no, :neft_sender_ifsc, :bene_acct_no, :bene_acct_ifsc, :status

  def self.form_values(attribute)
    case attribute
    when "cod_acct_no"
      BmRule.first.cod_acct_no
    when "bene_acct_no"
      BmRule.first.bene_acct_no
    when "customer_id"
      BmRule.first.customer_id
    when "bene_acct_ifsc"
      BmRule.first.bene_account_ifsc
    when "neft_sender_ifsc"
      BmRule.first.neft_sender_ifsc
    end
  end
end