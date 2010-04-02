module Rack::Accept

  # Represents an HTTP Accept header according to the HTTP 1.1 specification,
  # and provides several convenience methods for determining acceptable media
  # types.
  #
  # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html for more
  # information.
  class MediaType

    include Header

    # The name of this header.
    def name
      'Accept'
    end

    # Determines the quality factor (qvalue) of the given +media_type+.
    def qvalue(media_type)
      return 1 if @qvalues.empty?
      m = matches(media_type)
      return 0 if m.empty?
      @qvalues[m.first]
    end

    # Returns an array of media types from this header that match the given
    # +media_type+, ordered by precedence.
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

  end
end
