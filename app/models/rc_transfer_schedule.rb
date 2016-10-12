class RcTransferSchedule < ActiveRecord::Base  
  include Approval
  include RcTransferApproval

  self.table_name = "rc_transfer_schedule"

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

  validates_presence_of :code, :debit_account_no, :bene_account_no, :is_enabled

  validates :code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 20}
  validates_numericality_of :debit_account_no, :bene_account_no, :message => 'Invalid format, expected format is : {[0-9]}', length: {maximum: 20}
  validates :app_code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 15}, :allow_blank => true
  validates :notify_mobile_no, :numericality => {:only_integer => true}, length: {maximum: 10, minimum: 10}, :allow_blank => true

  validates_uniqueness_of :code, :scope => :approval_status

  before_save :to_downcase

  def to_downcase
    unless self.frozen?
      self.code = self.code.downcase unless self.code.nil?
    end
  end 
end
