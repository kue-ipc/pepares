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
    @dav = RackDAV::Handler.new(:root => @options[:root],
        resource_class: USBResource)
  end

  def call(env)
    if env["PATH_INFO"].start_with?(@path)
      if (forwarded_hosts = env["HTTP_X_FORWARDED_HOST"])
        env["HTTP_HOST"] = forwarded_hosts.split(/,\s?/).last
      end
      @dav.call(env)
    else
      @app.call(env)
    end
  end
end

# USBResource
# ignore lock
# ignore patch
class USBResource < RackDAV::FileResource
  def get_property(name)
    if collection?
      case name
      when 'getcontentlength' then "0"
      when 'getcontenttype'   then nil
      else super
      end
    else
      super
    end
  end

    # def property_names
  #   if stat.directory?
  #     super - %w(getcontenttype)
  #   else
  #     super
  #   end
  # end
end
