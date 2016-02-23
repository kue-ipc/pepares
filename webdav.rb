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
      if (forwarded_hosts = env["HTTP_X_FORWARDED_HOST"])
        env["HTTP_HOST"] = forwarded_hosts.split(/,\s?/).last
      end
      return @dav.call(env)
    else
      return @app.call(env)
    end
  end
end
