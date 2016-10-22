require_relative 'spec_helper.rb'
require_relative '../lib/invoice_maker'

include InvoiceMaker

describe Invoice do
  before :each do
    @invoice = Invoice.new
  end

  it 'is an Invoice object' do
    expect(@invoice).to be_kind_of(Invoice)
  end
end
