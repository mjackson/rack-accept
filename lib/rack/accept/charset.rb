module Rack::Accept

  # Represents an HTTP Accept-Charset header according to the HTTP 1.1
  # specification, and provides several convenience methods for determining
  # acceptable character sets.
  #
  # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html for more
  # information.
  class Charset

    include Header

    attr_reader :qvalues

    def initialize(header)
      @qvalues = parse(header)
    end

    # The name of this header.
    def name
      'Accept-Charset'
    end

    # The value of this header, built from its internal representation.
    def value
      join(@qvalues)
    end

    # Returns an array of all character set values that were specified in the
    # original header, in no particular order.
    def values
      @qvalues.keys
    end

    # Determines the quality factor (qvalue) of the given +charset+,
    # according to the specifications of the original header.
    def qvalue(charset)
      m = matches(charset)
      if m.empty?
        charset == 'iso-8859-1' ? 1 : 0
      else
        @qvalues[m.first]
      end
    end

    # Returns an array of character sets from the original header that match
    # the given +charset+, ordered by precedence.
    def matches(charset)
      values.select {|v|
        v == charset || v == '*'
      }.sort {|a, b|
        # "*" gets least precedence, any others should be equal.
        a == '*' ? 1 : (b == '*' ? -1 : 0)
      }
    end

    # Returns a string representation of this header.
    def to_s
      [name, value].join(': ')
    end

  end
end
