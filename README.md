# CoAspects

Easily attach [aspector](https://github.com/gcao/aspector) aspects via
annotations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'co_aspects'
```

And then execute:

    $ bundle

## Usage

To start using the annotations, first tell the class that you want them:

```ruby
class MyClass
  aspects_annotations!

  ...
end
```

Then you can attach any aspect to a given method via the analogous annotation:

```ruby
class MyClass
  ...

  _rescue_and_notify
  def important!
    ...
  end
end
```

The aspect attached to a method is the camelized version of the annotation
followed by "Aspect". For example, the `_rescue_and_notify` will attach the
`RescueAndNotifyAspect` aspect.

Several aspects can be attached to the same method, and the same aspect can be
attached to different methods.

### Arguments

Aspects can receive hash arguments and a block if it needs some dynamic
information from the call. These hash arguments and block must be passed via the
annotation:

```ruby
class Quoter
  ...

  _stats_increment as: 'ws.quoteapp' { |quote| key(quote) }
  def save_quote(quote)
    ...
  end
end
```

The `StatsIncrementAspect`, for example, can receive an alias to override the
default StatsD prefix key, and a block to include a dynamic part at the end of
the StatsD key.

Each aspect defines which arguments it supports and if it support a block.

## Aspects

For documentation on the available aspects, refer to each aspect class located
in the [aspects
directory](https://github.com/comparaonline/co_aspects/tree/master/lib/co_aspects/aspects).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Deployment

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub
[Issues](https://github.com/comparaonline/co_aspects).

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

