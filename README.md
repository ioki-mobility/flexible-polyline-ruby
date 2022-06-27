# FlexiblePolyline

The flexible polyline encoding from heremaps is a lossy compressed representation of a list of coordinate pairs or coordinate triples.

It achieves that by:

   1. Reducing the decimal digits of each value.
   2. Encoding only the offset from the previous point.
   3. Using variable length for each coordinate delta.
   4. Using 64 URL-safe characters to display the result.

For more information, visit: https://github.com/heremaps/flexible-polyline

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flexible_polyline', github: 'ioki-mobility/flexible_polyline'
```

And then execute:

    $ bundle install

## Usage

Encode:
```ruby
 FlexiblePolyline::Encoder.encode(third_dim: 1, precision: 8, third_dim_precision: 8, positions: [[-96.628241002595274, 34.155307026461529, 228.390420353746407]])
```
=> 
"B4gBnq_r-_R-suzyrGm_vgqxqB"

Decode:
```ruby
FlexiblePolyline::Decoder.decode('B4gBnq_r-_R-suzyrGm_vgqxqB')
```

=> 
```json
{"header": {"precision": 8, "third_dim": 1, "third_dim_precision": 8}, "positions": [[-96.628241, 34.15530703, 228.39042035]]} 
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ioki-mobility/flexible_polyline.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
