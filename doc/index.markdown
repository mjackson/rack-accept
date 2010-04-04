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

[rfc]: http://www.w3.org/Protocols/rfc2616/rfc2616.html
[sec14]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
[sec14-1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
[sec14-2]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2
[sec14-3]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
[sec14-4]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
[rack]: http://rack.rubyforge.org/
[test]: http://github.com/mjijackson/rack-accept/tree/master/test/
[rubygems]: http://rubygems.org/
