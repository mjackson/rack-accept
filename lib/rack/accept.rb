require 'rack'

# HTTP Accept* for Ruby/Rack.
#
# http://mjijackson.com/rack-accept
module Rack::Accept
  VERSION = [0, 4, 2]

  # Returns the current version of Rack::Accept as a string.
  def self.version
    VERSION.join('.')
  end

  # Enables Rack::Accept to be used as a Rack middleware.
  def self.new(app, &block)
    Context.new(app, &block)
  end

  autoload :Charset,    'rack/accept/charset'
  autoload :Context,    'rack/accept/context'
  autoload :Encoding,   'rack/accept/encoding'
  autoload :Header,     'rack/accept/header'
  autoload :Language,   'rack/accept/language'
  autoload :MediaType,  'rack/accept/media_type'
  autoload :Request,    'rack/accept/request'
  autoload :Response,   'rack/accept/response'
end
