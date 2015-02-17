# Cricketer

Cricketer is a Ruby gem for parsing cricket match JSON from ESPNCricinfo.com. It is not intended for commercial use.

Cricketer currently creates Ruby objects for some, but not all, of the JSON data available for a given match. These include information about the score, the current (or latest) status of the match, the players, the ground and some game details. Future versions will have more objects, but the current version provides the raw JSON of all match data published.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cricketer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cricketer

## Usage

To use Cricketer, you need to know the ID number of a match from espncricinfo.com. For example, the ID for [this match](http://www.espncricinfo.com/icc-cricket-world-cup-2015/engine/match/656399.html) is 656399. Pass that ID into the `Match` constructor:

```ruby
irb(main):001:0> require 'cricketer'
irb(main):002:0> match = Cricketer::Match.new(656399)
irb(main):003:0> match.description
=> "ICC Cricket World Cup, 1st Match, Pool A: New Zealand v Sri Lanka at Christchurch, Feb 14, 2015"
irb(main):004:0> match.current_status
=> "New Zealand won by 98 runs"
irb(main):005:0> match.team1
=> #<OpenStruct name="New Zealand", id="5", abbrev="NZ">
```

## Contributing

1. Fork it ( https://github.com/dwillis/cricketer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
