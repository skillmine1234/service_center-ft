class CreateFtApbsIncomingFiles < ActiveRecord::Migration
  def change
    create_table :ft_apbs_incoming_files, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
    	 t.string :file_name, :limit => 50, :comment => 'the name of the incoming file'
        t.index([:file_name], :unique => true, :name => 'ft_apbs_incoming_files_01')
    end
  end
end
