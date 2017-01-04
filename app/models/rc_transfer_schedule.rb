class RcTransferSchedule < ActiveRecord::Base  
  include Approval
  include RcTransferApproval

  self.table_name = "rc_transfer_schedule"
  
  store :udf1, accessors: [:udf1_name, :udf1_type, :udf1_value], coder: JSON
  store :udf2, accessors: [:udf2_name, :udf2_type, :udf2_value], coder: JSON
  store :udf3, accessors: [:udf3_name, :udf3_type, :udf3_value], coder: JSON
  store :udf4, accessors: [:udf4_name, :udf4_type, :udf4_value], coder: JSON
  store :udf5, accessors: [:udf5_name, :udf5_type, :udf5_value], coder: JSON

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  belongs_to :rc_transfer, :foreign_key => 'code', :primary_key => 'rc_transfer_code'
  belongs_to :rc_app

  validates_presence_of :code, :debit_account_no, :bene_account_no, :is_enabled

  validates :code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }, length: {maximum: 20}
  validates :debit_account_no, :bene_account_no, format: {with: /\A[0-9]+\z/, :message => 'Invalid format, expected format is : {[0-9]}' }, length: {minimum: 15, maximum: 20}
  validates :notify_mobile_no, :numericality => {:only_integer => true}, length: {minimum: 10, maximum: 10}, allow_blank: true

  validates_uniqueness_of :code, :scope => :approval_status

  def next_run_at_value
    next_run_at.nil? ? Time.zone.now.try(:strftime, "%d/%m/%Y %I:%M%p") : next_run_at.try(:strftime, "%d/%m/%Y %I:%M%p")
  end
end
