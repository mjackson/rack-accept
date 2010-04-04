require 'rack'

module Rack::Accept

  # The current version of rack-accept.
  VERSION = [0, 3]

  # Returns the current version of rack-accept as a string.
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
