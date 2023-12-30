class AddUniqueIndexOnAccountNoAndApprovalStatusInSmBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_index "sm_bank_accounts", ["account_no", "approval_status"], name: "sm_bank_accounts_02", unique: true
  end
end
