module Rack::Accept

  # Represents an HTTP Accept-Language header according to the HTTP 1.1
  # specification, and provides several convenience methods for determining
  # acceptable content languages.
  #
  # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html for more
  # information.
  class Language

    include Header

    attr_reader :qvalues

    def initialize(header)
      @qvalues = parse(header)
    end

    # The name of this header.
    def name
      'Accept-Language'
    end

    # The value of this header, built from its internal representation.
    def value
      join(@qvalues)
    end

    # Returns an array of all language values that were specified in the
    # original header, in no particular order.
    def values
      @qvalues.keys
    end

    # Determines the quality factor (qvalue) of the given +language+,
    # according to the specifications of the original header.
    def qvalue(language)
      return 1 if @qvalues.empty?
      m = matches(language)
      return 0 if m.empty?
      @qvalues[m.first]
    end

    # Returns an array of languages from the original header that match
    # the given +language+, ordered by precedence.
    def matches(language)
      values.select {|v|
        v == language || v == '*' || (language.match(/^(.+?)-/) && v == $1)
      }.sort {|a, b|
        # "*" gets least precedence, any others are compared based on length.
        a == '*' ? -1 : (b == '*' ? 1 : a.length <=> b.length)
      }.reverse
    end

    # Returns a string representation of this header.
    def to_s
      [name, value].join(': ')
    end

  end
end
