require 'spec_helper'

describe Ic001IncomingRecord do
  context 'association' do
    it { should belong_to(:incoming_file_record) }
    it { should belong_to(:incoming_file) }
  end
end