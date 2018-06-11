module SearchQueryParser

  QUOTE = '"'.freeze
  MODE_IN_KEY = 1.freeze
  MODE_IN_VALUE = 2.freeze

  class Query
    attr_reader :fields, :texts

    def initialize()
      @fields = {} # key=[value1, value2 ..]
      @texts = []  # [value1, value2 ..]
    end
  end

  class QueryParseError < StandardError
    def initialize(query, cause)
      super "Can not parse '#{query}': #{cause}"
    end
  end

  class Buffer

    def initialize
      @query = Query.new
      @key_buf, @value_buf = [], []
    end

    def append_to_key(v)
      @key_buf << v
    end

    def append_to_value(v)
      @value_buf << v
    end

    def is_key_empty?
      @key_buf.empty?
    end

    def is_value_empty?
      @value_buf.empty?
    end

    def apply!
      if @value_buf.size > 0
        key = @key_buf.join('')
        @query.fields[key] ||= []
        @query.fields[key] << @value_buf.join('')
      elsif @key_buf.size > 0
        @query.texts << @key_buf.join('')
      end
      @key_buf, @value_buf = [], []
      @query
    end
  end

  def parse(query, key_value_separator: ':', field_separator: ' ')
    buffer, mode, in_quote =  Buffer.new, MODE_IN_KEY, false

    dest = Query.new
    query.strip.split('').each do |c|
      if c == key_value_separator && !in_quote
        raise QueryParseError.new(query, "section maybe starts with \"#{key_value_separator}\"") if buffer.is_key_empty?
        raise QueryParseError.new(query, "section maybe not in 'key:value' format") unless buffer.is_value_empty?
        mode = MODE_IN_VALUE
      elsif c == field_separator && !in_quote
        buffer.apply!; mode = MODE_IN_KEY
      elsif c == QUOTE
        in_quote = !in_quote
        unless in_quote
          buffer.apply!; mode = MODE_IN_KEY
        end
      else
        mode == MODE_IN_KEY ? buffer.append_to_key(c) : buffer.append_to_value(c)
      end
    end
    raise QueryParseError.new(query, "qyoted phrase is not closed") if in_quote
    buffer.apply!
  end

  module_function :parse
end
