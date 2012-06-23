module Rack::Accept
  # Represents an HTTP Accept header according to the HTTP 1.1 specification,
  # and provides several convenience methods for determining acceptable media
  # types.
  #
  # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
  class MediaType
    include Header

    attr_accessor :extensions

    # The name of this header.
    def name
      'Accept'
    end

    # Determines the quality factor (qvalue) of the given +media_type+.
    def qvalue(media_type)
      return 1 if @qvalues.empty?
      m = matches(media_type)
      return 0 if m.empty?
      normalize_qvalue(@qvalues[m.first])
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
          t == type && (s == '*' || s == subtype) && (p == '' || params_match?(params, p))
        end
      }.sort_by {|v|
        # Most specific gets precedence.
        v.length
      }.reverse
    end

  private

    def initialize(header)
      @extensions = {}
      header.to_s.split(',').each do |raw_media_type|
        params = { 'q' => 1 }
        parts = raw_media_type.split(';')
        media_type = parts.shift.strip.downcase
        parts.each do |part|
          pair = part.split('=', 2)
          pair[0].strip.downcase
          pair[1].strip
          params[pair[0]] = pair[0] == 'q' ? normalize_qvalue(pair[1]).to_f : pair[1]
        end
        @extensions[media_type] = params
      end

      @qvalues = {}
      @extensions.each do |k, v|
        @qvalues[k] = v['q']
      end
    end

    # Returns true if all parameters and values in +match+ are also present in
    # +params+.
    def params_match?(params, match)
      return true if params == match
      parsed = parse_range_params(params)
      parsed == parsed.merge(parse_range_params(match))
    end
  end
end
