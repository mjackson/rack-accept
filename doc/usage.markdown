Usage
-----

Rack::Accept implements the Rack middleware interface and may be used with any
Rack-based application. Simply insert the Rack::Accept module in your Rack
middleware pipeline and access the [Request][req] object in the
"rack-accept.request" environment key, as in the following example:

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

Rack::Accept can also construct automatic [406][406] responses if you set up
the types of media, character sets, encoding, or languages your server is able
to serve ahead of time. If you pass a configuration block to your `use`
statement it will yield the [Context][ctx] object that is used for that
invocation.

    require 'rack/accept'

    use(Rack::Accept) do |context|
      # We only ever serve content in English or Japanese from this site, so if
      # the user doesn't accept either of these we will respond with a 406.
      context.languages = %w< en jp >
    end

    app = ...

    run app

__Note:__ You should think carefully before using Rack::Accept in this way.
Many user agents are careless about the types of Accept headers they send, and
depend on apps not being too picky. Instead of automatically sending a 406, you
should probably only send one when absolutely necessary.

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
correct. It just puts emphasis on the convenience of using this library so you
don't have to worry about these kinds of details.

[req]: api/classes/Rack/Accept/Request.html
[406]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.7
[ctx]: api/classes/Rack/Accept/Context.html
[sec14-3]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
