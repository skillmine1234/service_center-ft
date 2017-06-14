class FtApbsIncomingRecords < ActiveRecord::Migration
  def change
  	create_table :ft_apbs_incoming_records, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
          t.integer :incoming_file_record_id, :comment => "the foreign key to the incoming_files table" 
          t.string :file_name, :limit => 100, :comment => "the name of the incoming_file"            
          t.number :apbs_trans_code, :limit => 4, :comment => "the transaction code for apbs"
          t.string :dest_bank_iin, :limit => 15, :comment => "destination bank name"
          t.string :dest_acctype, :limit => 4, :comment => "destination account type"
          t.string :ledger_folio_num, :limit => 6, :comment => "alphanumeric ledger folio particulars"
          t.string :bene_aadhar_num, :limit => 20, :comment => "aadhar number of the beneficiary"
          t.string :bene_acct_name, :limit => 50, :comment => "beneficiary account holder name"
          t.string :sponser_bank_iin, :limit => 15, :comment => "6 digit sponsor bank IIN"
          t.string :user_num, :limit => 10, :comment => "user number allotted by NPCI"
          t.string :user_name, :limit => 30, :comment => "name of the government dept or agency"
          t.string :user_credit_ref, :limit => 20, :comment => "user defined reference number ledger folio number or unique identification num given by user"
          t.string :amount, :limit => 20, :comment => "amount in rupees"
          t.string :item_seq_num, :limit => 20, :comment => "APBS item sequence number to be allocated ny NPCI"
          t.string :checksum, :limit => 20, :comment => "checksum total generated by NPCI"
          t.string :success_flag, :limit => 10, :comment => "flag for items credited (1) and returned uncredited (0)"
          t.string :filler, :limit => 10, :comment => "used for internal purpose"
          t.string :reason_code, :limit => 20, :comment => "reason for not crediting the item"
          t.string :dest_bank_acctnum, :limit => 20, :comment => "dest bank account number"          
          t.index([:incoming_file_record_id,:file_name], :unique => true, :name => 'ft_apbs_incoming_records_01')  
    end
  end
end
