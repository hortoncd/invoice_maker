#!/usr/bin/env ruby

require 'invoice_maker'
include InvoiceMaker

i = Invoice.new
puts "i is an instance of an #{i.class} class."
puts

data = JSON.parse(File.open(File.join(File.dirname(__FILE__), 'invoice_in.json'), 'r').read)
puts "data is the JSON that will be sent to the api to generate the invoice:"
puts data
puts

i.set(data)
fname = i.generate

puts "After generation, we have a pdf file name, or 'nil' to indicate and error:"
if fname
  puts fname
else
  puts "Failed to generate invoice."
end
