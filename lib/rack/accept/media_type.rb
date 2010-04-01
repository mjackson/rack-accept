module Rack::Accept

  # Represents an HTTP Accept header according to the HTTP 1.1 specification,
  # and provides several convenience methods for determining acceptable media
  # types.
  #
  # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html for more
  # information.
  class MediaType

    include Header

    attr_reader :qvalues

    def initialize(header)
      @qvalues = parse(header)
    end

    # The name of this header.
    def name
      'Accept'
    end

    # The value of this header, built from its internal representation.
    def value
      join(@qvalues)
    end

    # Returns an array of all media type values that were specified in the
    # original header, in no particular order.
    def values
      @qvalues.keys
    end

    # Determines the quality factor (qvalue) of the given +media_type+,
    # according to the specifications of the original header.
    def qvalue(media_type)
      return 1 if @qvalues.empty?
      m = matches(media_type)
      return 0 if m.empty?
      @qvalues[m.first]
    end

    # Returns an array of media types from the original header that match
    # the given +media_type+, ordered by precedence.
    def matches(media_type)
      type, subtype, params = parse_media_type(media_type)
      values.select {|v|
        if v == media_type || v == '*/*'
          true
        else
          t, s, p = parse_media_type(v)
          t == type && (s == subtype || s == '*') && (p == params || p == '')
        end
      }.sort_by {|v|
        # Most specific gets precedence.
        v.length
      }.reverse
    end

    # Returns a string representation of this header.
    def to_s
      [name, value].join(': ')
    end

  end
end
