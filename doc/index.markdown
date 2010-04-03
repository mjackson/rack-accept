__Rack::Accept__ is a suite of tools for Ruby/Rack applications that eases the
complexity of building and interpreting the Accept* family of [HTTP request
headers][rfc].

Some features of the library are:

  * Strict adherence to [RFC 2616][rfc], specifically [section 14][sec14]
  * Full support for the [Accept][sec14-1], [Accept-Charset][sec14-2],
    [Accept-Encoding][sec14-3], and [Accept-Language][sec14-4] HTTP request
    headers
  * May be used as [Rack][rack] middleware or standalone
  * A comprehensive [test suite][test] that covers many edge cases

Installation
------------

Using [RubyGems][rubygems]:

    $ sudo gem install rack-accept

From a local copy:

    $ git clone git://github.com/mjijackson/rack-accept.git
    $ rake package && sudo rake install

Usage
-----

Rack::Accept implements the Rack middleware interface and may be used with any
Rack-based application. Simply insert the Rack::Accept module in your Rack
middleware pipeline and access the [Rack::Accept::Request][req] object in the
"rack-accept.request" environment key, as in the following example:

    require 'rack/accept'

    use Rack::Accept

    app = lambda {|env|
      accept = env['rack-accept.request']
      response = Rack::Response.new

      if accept.media_type?('text/html')
        response['Content-Type'] = 'text/html'
        response.write "<p>Hello. You accept text/html!</p>"
      else
        response['Content-Type'] = 'text/plain'
        response.write "Apparently you don't accept text/html. Too bad."
      end

      response.finish
    }

    run app

Additionally, Rack::Accept may be used outside of a Rack context to provide
any Ruby app the ability to construct and interpret Accept headers.

    require 'rack/accept'

    mtype = Rack::Accept::MediaType.new
    mtype.qvalues = { 'text/html' => 1, 'text/*' => 0.8, '*/*' => 0.5 }
    mtype.to_s # => "Accept: text/html, text/*;q=0.8, */*;q=0.5"

    cset = Rack::Accept::Charset.new('unicode-1-1, iso-8859-5;q=0.8')
    cset.best_of(%w< iso-8859-5 unicode-1-1 >)  # => "unicode-1-1"
    cset.accept?('iso-8859-1')                  # => true

The very last line in this example may look like a mistake to someone not
familiar with the intricacies of [the spec][sec14-3], but it's actually
correct. It just puts emphasis on the convenience of using this library.

[rfc]: http://www.w3.org/Protocols/rfc2616/rfc2616.html
[sec14]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
[sec14-1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
[sec14-2]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2
[sec14-3]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
[sec14-4]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
[rack]: http://rack.rubyforge.org/
[test]: http://github.com/mjijackson/rack-accept/tree/master/test/
[rubygems]: http://rubygems.org/
[req]: api/classes/Rack/Accept/Request.html
