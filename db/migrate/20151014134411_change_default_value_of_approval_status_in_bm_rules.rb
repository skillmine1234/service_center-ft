class ChangeDefaultValueOfApprovalStatusInBmRules < ActiveRecord::Migration[7.0]
  def change
    change_column :bm_rules, :approval_status, :string, :default => "U"
  end
end
