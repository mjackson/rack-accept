module Rack::Accept

  # Implements the Rack middleware interface.
  class Context

    attr_reader :app

    def initialize(app)
      @app = app
      yield self if block_given?
    end

    # Inserts a new Rack::Accept::Request object into the environment before
    # handing the request to the app immediately downstream.
    def call(env)
      env['rack-accept.request'] ||= Request.new(env)
      @app.call(env)
    end

  end
end
