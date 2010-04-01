module Rack::Accept

  # Contains methods that are useful for working with Accept-style HTTP
  # headers. The +MediaType+, +Charset+, +Encoding+, and +Language+ classes
  # all mixin this module.
  module Header

    # Parses the value of an Accept-style request header into a hash of
    # acceptable values and their respective quality factors (qvalues). The
    # +join+ method may be used on the resulting hash to obtain a header
    # string that is the semantic equivalent of the one provided.
    def parse(header)
      qvalues = {}

      header.to_s.split(/,\s*/).map do |part|
        m = /^([^\s,]+?)(?:;\s*q=(\d+(?:\.\d+)?))?$/.match(part) # From WEBrick

        if m
          qvalues[m[1]] = (m[2] || 1).to_f
        else
          raise "Invalid header value: #{part.inspect}"
        end
      end

      qvalues
    end
    module_function :parse

    # Returns a string suitable for use as the value of an Accept-style HTTP
    # header from the map of acceptable values to their respective quality
    # factors (qvalues). The +parse+ method may be used on the resulting string
    # to obtain a hash that is the equivalent of the one provided.
    def join(qvalues)
      qvalues.map {|k, v| k + (v == 1 ? '' : ";q=#{v}") }.join(', ')
    end
    module_function :join

    # Parses a media type string into its relevant pieces. The return value
    # will be an array with three values: 1) the content type, 2) the content
    # subtype, and 3) the media type parameters. An empty array is returned if
    # no match can be made.
    def parse_media_type(media_type)
      m = media_type.to_s.match(/^([a-z*]+)\/([a-z*-]+)(?:;([a-z0-9=]+))?$/)
      m ? [m[1], m[2], m[3] || ''] : []
    end
    module_function :parse_media_type

    module PublicInstanceMethods
      # Returns the quality factor (qvalue) of the given +value+. This method
      # is the only method that must be overridden in child classes in order
      # for them to be able to use all other methods of this module.
      def qvalue(value)
        1
      end

      # Determines if the given +value+ is acceptable (does not have a qvalue
      # of 0) according to this header.
      def accept?(value)
        qvalue(value) != 0
      end

      # Returns a copy of the given +values+ array, sorted by quality factor
      # (qvalue). Each element of the returned array is itself an array
      # containing two objects: 1) the value's qvalue and 2) the original
      # value.
      #
      # It is important to note that when performing this sort the order of
      # the original values is preserved so long as the qvalue for each input
      # value is the same. This expectation can be useful for example when
      # trying to determine which of a variety of options has the highest
      # qvalue. If the user prefers using one option over another (for any
      # number of reasons), he should put it first in +values+. He may then
      # use the first result with confidence that it is both most acceptable
      # to the user and most convenient for him as well.
      def sort(values)
        values.map {|v| [ qvalue(v), v ] }.sort.reverse
      end

      # Determines the most preferred value to use of those provided in
      # +values+. See the documentation for +sort+ for more information on
      # exactly how the sorting is done.
      #
      # If +keep_unacceptables+ is false (the default) the return value of this
      # method will be +false+ if no values are acceptable. Otherwise, the most
      # acceptable value will be returned.
      def best_of(values, keep_unacceptables=false)
        s = sort(values)
        s.reject! {|q, v| q == 0 } unless keep_unacceptables
        s.first && s.first[1]
      end
    end

    include PublicInstanceMethods

  end
end
