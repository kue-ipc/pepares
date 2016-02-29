# WebDAV Filter
require "rack_dav"

# hack rack_dav
# RackDAV::Controller#propfind
module RackDAV
  class Controller
    def propfind
      raise NotFound if not resource.exist?

      if not request_match("/d:propfind/d:allprop").empty?
        nodes = all_prop_nodes
      else
        nodes = request_match("/d:propfind/d:prop/*")
        nodes = all_prop_nodes if nodes.empty?
      end

      nodes.each do |n|
        # Don't allow empty namespace declarations
        # See litmus props test 3
        raise BadRequest if n.namespace.nil? && n.namespace_definitions.empty?

        # Set a blank namespace if one is included in the request
        # See litmus props test 16
        # <propfind xmlns="DAV:"><prop><nonamespace xmlns=""/></prop></propfind>
        if n.namespace.nil?
          nd = n.namespace_definitions.first
          if nd.prefix.nil? && nd.href.empty?
            n.add_namespace(nil, '')
          end
        end
      end

      multistatus do |xml|
        for resource in find_resources
          resource.path.gsub!(/\/\//, '/')
          xml.response do
            # The path must be finished with  "/" if resource is a collection
            url = "http://#{host}#{url_escape resource.path}"
            url += '/' if resource.collection? && ! url.end_with?('/')
            xml.href url
            propstats xml, get_properties(resource, nodes)
          end
        end
      end
    end
  end
end

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
# collections have no content
# ignore custom property
# ignore lock
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

  def set_custom_property(name, value)
    puts "#{name} = #{value}"
  end

  def get_custom_property(name)
    puts "#{name}"
    nil
  end

  def list_custom_properties
    []
  end
end
