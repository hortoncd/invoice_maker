# InvoiceMaker

![](https://github.com/hortoncd/invoice_maker/workflows/Ruby/badge.svg)

A gem to do the basic work of creating a PDF invoice using https://invoice-generator.com.  Inspired by
the article here:
https://gelato.io/blog/minimum-viable-ruby-api-client-with-invoiced-and-httparty.

API documentation lives at https://github.com/Invoiced/invoice-generator-api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'invoice_maker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invoice_maker

## Usage

Require the gem, and optionally include the module for simplicity
```ruby
require 'invoice_maker'

include InvoiceMaker
```

The gem relies on general options for the invoice being set with the 'set' method.  This can include all the line items, or they can be added individually after initial options are set.

The basic data can include any of the options documented in the API documentation referenced above.

```ruby
data = {
  "from": "My Great Company, Inc. ®\nMy Street Address\nMy City, State 00000",
  "to": "My Great Customer\nATTN: The Dude\nCust Address\nCust Street Address\nCust City, State 11111",
  "logo": "http://placekitten.com/320/140",
  "number": 1,
  "date": "2016-10-24",
  "items": [
    {
      "name": "Some awesome task",
      "quantity": 1,
      "unit_cost": 270.0
    }
  ],
  "notes": "Thank you so much for your business!"
}
```

Instantiate an object and add the data, followed by adding any line items as necessary.
```ruby
i = Invoice
i.set(data)

item = {
  "name": "Some additional awesome task",
  "quantity": 2,
  "unit_cost": 270.0
}

i.append_item(item)
```
Optionally set a destination directory for the generated PDF invoice.  Default is "/tmp".
```ruby
i.dest_dir = "/somedir"
```

Once all data is set, generate the PDF invoice.  The filename will be returned from the call to generate.
```ruby
fname = i.generate
puts fname
```

`examples/usage.rb` is a sample script that loads data from a json file and generates a sample invoice.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hortoncd/invoice_maker.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
