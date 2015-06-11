class EcolCustomer < ActiveRecord::Base
  audited
  
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  validates_presence_of :code, :name, :is_enabled, :val_method, :token_1_type, :token_1_length, :val_token_1, :token_2_type,
  :token_2_length, :val_token_2, :token_3_type, :token_3_length, :val_token_3, :val_txn_date, :val_txn_amt, :val_ben_name, :val_rem_acct, 
  :return_if_val_fails, :credit_acct_no, :nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3, :rmtr_alert_on
  
  validates_uniqueness_of :code
  
  validates_inclusion_of :val_method, :in => %w( N W D )
  validates_inclusion_of :token_1_type, :token_2_type, :token_3_type, :in => %w( N SC RC IN )
  validates_inclusion_of :file_upld_mthd, :in => %w( F I ), :allow_blank => true
  validates_inclusion_of :nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3, :in => %w( N SC RC IN RN ORN ORA )
  validates_inclusion_of :rmtr_alert_on, :in => %w( N P R A )
  
  validates :code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 15, minimum: 1}
  validates :name, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 15, minimum: 1}
  validates :credit_acct_no, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 25, minimum: 1}
  validates :rmtr_pass_txt, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 500, minimum: 1}, :allow_blank => true
  validates :rmtr_return_txt, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 500, minimum: 1}, :allow_blank => true
  
  validate :val_tokens_should_be_N_if_val_method_is_N,
  :file_upld_mthd_is_mandatory_if_val_method_is_D,
  :same_value_cannot_be_selected_for_all_acct_tokens,
  :same_value_cannot_be_selected_for_all_nrtv_sufxs,
  :rmtr_pass_txt_is_mandatory_if_rmtr_alert_on_is_P_or_A,
  :rmtr_return_txt_is_mandatory_if_rmtr_alert_on_is_R_or_A,
  :nrtv_sufx_2_and_3_should_be_N_if_nrtv_sufx_1_is_N,
  :nrtv_sufx_3_should_be_N_if_nrtv_sufx_2_is_N
  
      
  def val_tokens_should_be_N_if_val_method_is_N
    if (self.val_method == "N" && (self.val_token_1 != "N" || self.val_token_2 != "N" || self.val_token_3 != "N" || self.val_txn_date != "N" || self.val_txn_amt != "N")) 
      errors[:base] << "If Validation Method is None, then all the Validation Account Tokens should also be N"
    end
  end
  
  def file_upld_mthd_is_mandatory_if_val_method_is_D
    if (self.val_method == "D" && self.file_upld_mthd.blank?)
      errors.add(:file_upld_mthd, "Can't be blank if Validation Method is Database Lookup")
    elsif (self.val_method != "D" && !(self.file_upld_mthd.blank?))
      errors.add(:file_upld_mthd, "Can't be selected as Validation Method is not Database Lookup")
    end
  end
  
  def same_value_cannot_be_selected_for_all_acct_tokens
    if ((self.token_1_type == self.token_2_type)  || (self.token_2_type == self.token_3_type) || (self.token_1_type == self.token_3_type))
      errors[:base] << "Can't allow same value for all tokens"
    end
  end
  
  def same_value_cannot_be_selected_for_all_nrtv_sufxs
    if (((self.nrtv_sufx_1 == self.nrtv_sufx_2) && ((self.nrtv_sufx_1 != "N") && (self.nrtv_sufx_2 != "N"))) || 
      ((self.nrtv_sufx_2 == self.nrtv_sufx_3) && ((self.nrtv_sufx_2 != "N") && (self.nrtv_sufx_3 != "N"))) || 
      ((self.nrtv_sufx_1 == self.nrtv_sufx_3) && ((self.nrtv_sufx_1 != "N") && (self.nrtv_sufx_3 != "N"))))
      errors[:base] << "Can't allow same value for all narration suffixes except for 'None'"
    end
  end
  
  def rmtr_pass_txt_is_mandatory_if_rmtr_alert_on_is_P_or_A
    if ((self.rmtr_alert_on == "P" || self.rmtr_alert_on == "A") && self.rmtr_pass_txt.blank?)
      errors.add(:rmtr_pass_txt, "Can't be blank if Send Alerts To Remitter On is On Pass or Always")
    end  
  end
  
  def rmtr_return_txt_is_mandatory_if_rmtr_alert_on_is_R_or_A 
    if ((self.rmtr_alert_on == "R" || self.rmtr_alert_on == "A") && self.rmtr_return_txt.blank?)
      errors.add(:rmtr_return_txt, "Can't be blank if Send Alerts To Remitter On is On Return or Always")
    end
  end
  
  def nrtv_sufx_2_and_3_should_be_N_if_nrtv_sufx_1_is_N
    if (self.nrtv_sufx_1 == "N" && (self.nrtv_sufx_2 != "N" || self.nrtv_sufx_3 != "N"))
      errors[:base] << "If Narrative Suffix 1 is None, then Narrative Suffix 2 & Narrative Suffix 3 should also be None"
    end
  end
  
  def nrtv_sufx_3_should_be_N_if_nrtv_sufx_2_is_N
    if (self.nrtv_sufx_2 == "N" && self.nrtv_sufx_3 != "N")
      errors[:base] << "If Narrative Suffix 2 is None, then Narrative Suffix 3 also should be None"
    end
  end
  
  def self.options_for_val_method
    [['None','N'],['Web Service','W'],['Database Lookup','D']]
  end
  
  def self.options_for_acct_tokens
    [['None','N'],['Sub Code','SC'],['Remitter Code','RC'],['Invoice Number','IN']]
  end
  
  def self.options_for_file_upld_mthd
    [['Full', 'F'],['Incremental','I']]
  end
  
  def self.options_for_nrtv_sufxs
    [['None','N'],['Sub Code','SC'],['Remitter Code','RC'],['Invoice Number','IN'],['Remitter Name','RN'],['Original Remitter Name','ORN'],['Original Remitter Account','ORA']]
  end
  
  def self.options_for_rmtr_alert_on
    [['Never','N'],['On Pass','P'],['On Return','R'],['Always','A']]
  end
  
end
