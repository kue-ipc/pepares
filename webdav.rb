# WebDAV Filter
require "rack_dav"

class WebDAVFilter
  def initialize(app, options = {})
    @app = app
    @options = {
      root: Dir.pwd,
      path: "/",
    }.merge(options)
    @path = @options[:path].dup.freeze
    @dav = RackDAV::Handler.new(:root => @options[:root])
  end

  def call(env)
    if env["PATH_INFO"].start_with?(@path)
      if env["REQUEST_METHOD"] == "PROPPATCH"
        body = "Forbidden\n"
        return [403, {
          "Content-Type" => "text/plain",
          "Content-Length" => body.size.to_s,
        }, [body]]
      else
        return @dav.call(env)
      end
    else
      return @app.call(env)
    end
  end
end
