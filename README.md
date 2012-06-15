# Rack::Accept

**Rack::Accept** is a suite of tools for Ruby/Rack applications that eases the
complexity of building and interpreting the Accept* family of HTTP request
headers.

Some features of the library are:

  * Strict adherence to RFC 2616, specifically section 14
  * Full support for the Accept, Accept-Charset, Accept-Encoding, and
    Accept-Language HTTP request headers
  * May be used as Rack middleware or standalone
  * A comprehensive test suite that covers many edge cases

## Installation

**Using RubyGems:**

    $ sudo gem install rack-accept

**From a local copy:**

    $ git clone git://github.com/mjijackson/rack-accept.git
    $ cd rack-accept
    $ rake package && sudo rake install

## Usage

**Rack::Accept** implements the Rack middleware interface and may be used with any
Rack-based application. Simply insert the `Rack::Accept` module in your Rack
middleware pipeline and access the `Rack::Accept::Request` object in the
`rack-accept.request` environment key, as in the following example.

```ruby
require 'rack/accept'

use Rack::Accept

app = lambda do |env|
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
end

run app
```

**Rack::Accept** can also construct automatic 406 responses if you set up the types
of media, character sets, encoding, or languages your server is able to serve
ahead of time. If you pass a configuration block to your `use` statement it will
yield the `Rack::Accept::Context` object that is used for that invocation.

```ruby
require 'rack/accept'

use(Rack::Accept) do |context|
  # We only ever serve content in English or Japanese from this site, so if
  # the user doesn't accept either of these we will respond with a 406.
  context.languages = %w< en jp >
end

app = ...

run app
```

**Note:** _You should think carefully before using Rack::Accept in this way.
Many user agents are careless about the types of Accept headers they send, and
depend on apps not being too picky. Instead of automatically sending a 406, you
should probably only send one when absolutely necessary._

Additionally, **Rack::Accept** may be used outside of a Rack context to provide
any Ruby app the ability to construct and interpret Accept headers.

```ruby
require 'rack/accept'

mtype = Rack::Accept::MediaType.new
mtype.qvalues = { 'text/html' => 1, 'text/*' => 0.8, '*/*' => 0.5 }
mtype.to_s # => "Accept: text/html, text/*;q=0.8, */*;q=0.5"

cset = Rack::Accept::Charset.new('unicode-1-1, iso-8859-5;q=0.8')
cset.best_of(%w< iso-8859-5 unicode-1-1 >)  # => "unicode-1-1"
cset.accept?('iso-8859-1')                  # => true
```

The very last line in this example may look like a mistake to someone not
familiar with the intricacies of the spec, but it's actually correct. It
just puts emphasis on the convenience of using this library so you don't
have to worry about these kinds of details.

## Four-letter Words

  - Spec: [http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html)
  - Code: [http://github.com/mjijackson/rack-accept](http://github.com/mjijackson/rack-accept)
  - Bugs: [http://github.com/mjijackson/rack-accept/issues](http://github.com/mjijackson/rack-accept/issues)
  - Docs: [http://mjijackson.com/rack-accept](http://mjijackson.com/rack-accept)

## License

Copyright 2012 Michael Jackson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
