class CreateSspBanks < ActiveRecord::Migration
  def change
    create_table :ssp_banks, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :customer_code, limit: 15, null: false,  comment: 'the unique code for the bank'
      t.string :debit_account_url, limit: 100, comment: 'the debit account url'
      t.string :reverse_debit_account_url, limit: 100, comment: 'the debit account url'
      t.string :get_status_url, limit: 100, comment: 'the status url'      
      t.string :get_account_status_url, limit: 100, comment: 'the account status url'      
      t.string :http_username, limit: 100, comment: 'the http_username for the bank'
      t.string :http_password, limit: 255, comment: 'the http_password for the bank'
      t.integer :settings_cnt, comment: 'the count of settings for the bank'
      t.string :setting1, comment: 'the setting 1 for the bank'
      t.string :setting2, comment: 'the setting 2 for the bank'
      t.string :setting3, comment: 'the setting 3 for the bank'
      t.string :setting4, comment: 'the setting 4 for the bank'
      t.string :setting5, comment: 'the setting 5 for the bank'
      t.datetime :created_at, null: false, comment: "the timestamp when the record was created"
      t.datetime :updated_at, null: false, comment: "the timestamp when the record was last updated"
      t.string :created_by, limit: 20, comment: "the person who creates the record"
      t.string :updated_by, limit: 20, comment: "the person who updates the record"
      t.integer :lock_version, null: false, default: 0, comment: "the version number of the record, every update increments this by 1"
      t.string :last_action, limit: 1, default: 'C', null: false, comment: "the last action (create, update) that was performed on the record"
      t.string :approval_status, limit: 1, default: 'U', null: false, comment: "the indicator to denote whether this record is pending approval or is approved"
      t.integer :approved_version, comment: "the version number of the record, at the time it was approved"
      t.integer :approved_id, comment: "the id of the record that is being updated"
      t.string :app_code, limit: 50, null: false, comment: 'the app_code for the bank'
      t.string :is_enabled, limit: 1, :null => false, :default => 'Y', comment: 'the flag which indicates whether this bank is enabled or not'
      t.index([:customer_code, :app_code, :approval_status], unique: true, name: 'ssp_banks_01')
    end
  end
end
