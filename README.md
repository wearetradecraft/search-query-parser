# SearchQueryParser

A Simple parser of query for the searching.

It behaves somply like as follows:

- parses 2 style of query, **key:value** and simple text format.
 - key and value that is separated by '**:**'.
 - all queries are seprated by space.

```ruby
q = SearchQueryParser.parse('name:Michel age:16 tag1 tag2')
q.fields['name']  # => ['Michel']
q.fields['age']   # => ['16']
q.texts           # => ['tag1', 'tag2']
```

- By using quote "**"**", that can be ignoring space and separator char.

```ruby
q = SearchQueryParser.parse('"this is tag" "not:key_value"')
q.texts           # => ['this is tag', 'not:key_value']

q = SearchQueryParser.parse('tags:"tag1 tag2 tag3"')
q.fields['tags']  # => ['tag1 tag2 tag3']
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'search-query-parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search-query-parser

## TODO

- Escaping reserved chars
- Quering AND/OR/NOT
- Range query
- Use Lexer/Parser

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takumakanari/search-query-parser-ruby.
