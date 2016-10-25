require_relative 'spec_helper.rb'
require_relative '../lib/invoice_maker'

include InvoiceMaker

PDF_CONTENT_TYPE  = 'application/pdf'
JSON_CONTENT_TYPE = 'application/json'

@test_uri = "invoice-generator.com"

# 200
def stub_request_success
  pdf_response = File.open(File.join('fixtures', 'invoice.pdf'), 'r').read
  stub_request(:post, /#{@test_uri}/).to_return(:body => pdf_response, :status => 200, :headers => {'Content-Type'=>PDF_CONTENT_TYPE})
end

# 404
def stub_request_not_found
  stub_request(:post, /#{@test_uri}/).to_return(:body => "", :status => 404, :headers => {'Content-Type'=>PDF_CONTENT_TYPE})
end

# 503
def stub_request_error
  stub_request(:post, /#{@test_uri}/).to_return(:body => "", :status => 503, :headers => {'Content-Type'=>PDF_CONTENT_TYPE})
end

describe Invoice do
  before :each do
    @invoice = Invoice.new
    @data = JSON.parse(File.open(File.join('fixtures', 'invoice_in.json'), 'r').read)
    @data_appended = JSON.parse(File.open(File.join('fixtures', 'invoice_appended.json'), 'r').read)
    @item = {
      "name" => "Some other task",
      "quantity" => 2,
      "unit_cost" => 270.0
    }
  end

  it 'is an Invoice object' do
    expect(@invoice).to be_kind_of(Invoice)
  end

  it 'sets dest_dir for pdfs' do
    expect(@invoice.dest_dir).to eq("/tmp")
    @invoice.dest_dir = "/tmp2"
    expect(@invoice.dest_dir).to eq("/tmp2")
  end

  it 'sets invoice data' do
    @invoice.set(@data)
    expect(@invoice.data).to eq(@data)
  end

  it 'appends a line item to invoice data' do
    @invoice.set(@data)
    @invoice.append_item(@item)
    expect(@invoice.data).to eq(@data_appended)
  end

  it 'fails to append a line item to empty invoice data' do
    @invoice.set
    expect{ @invoice.append_item(@item) }.to raise_error(RuntimeError)
    expect(@invoice.data).to eq({})
  end

  it 'appends a line item to invoice data with no items array' do
    @invoice.set({"from" => "Me"})
    @invoice.append_item(@item)
    expect(@invoice.data).to eq({"from" => "Me", "items" => [@item]})
  end

  it 'appends a line item to invoice data with empty items array' do
    @invoice.set({"from" => "Me", "items" => []})
    @invoice.append_item(@item)
    expect(@invoice.data).to eq({"from" => "Me", "items" => [@item]})
  end

  it 'generates a pdf and saves as a file' do
    stub_request_success
    @invoice.set(@data)
    fname = @invoice.generate
    pdf_response = File.open(File.join('fixtures', 'invoice.pdf'), 'r').read
    pdf_results = File.open(fname, 'r').read
    expect(pdf_results).to eq(pdf_response)
  end

  it 'fails to generate and returns nil for not found response from api (404)' do
    stub_request_not_found
    @invoice.set(@data)
    fname = @invoice.generate
    expect(fname).to eq(nil)
  end

  it 'fails to generate and returns nil for error response from api (503)' do
    stub_request_error
    @invoice.set(@data)
    fname = @invoice.generate
    expect(fname).to eq(nil)
  end
end
