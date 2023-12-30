class CreatePendingInwardRemittances < ActiveRecord::Migration[7.0]
  def change
    create_table :pending_inward_remittances do |t|#, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.integer :inward_remittance_id, :limit => 30, :null => false
      t.string :broker_uuid, :limit => 255, :null => false

      t.timestamps null: false
    end
  end
end
