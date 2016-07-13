# WebDAV Filter
require 'rack_dav'

# USBResource
# collections have no content
# ignore custom property
# ignore lock
class USBResource < RackDAV::FileResource
  # 除外するフォルダ名
  EXCLUDE_NAMES = [
    'System Volume Information',
    '$RECYCLE.BIN',
    'Desktop.ini',
    'Thumbs.db',
  ].freeze

  def put
    raise RackDAV::HTTPStatus::Forbidden unless changable?
    super
  end

  def move
    raise RackDAV::HTTPStatus::Forbidden unless changable?
    super
  end

  def delete
    raise RackDAV::HTTPStatus::Forbidden unless changable?
    super
  end

  def make_collection
    raise RackDAV::HTTPStatus::Forbidden unless changable?
    super
  end

  def changable?
    path =~ %r<\A/usb/[^/]+/[^/]>
  end

  def children
    super.reject { |res| EXCLUDE_NAMES.include?(res.name) }
  end

  def get_property(name)
    if collection?
      case name
      when 'getcontentlength' then '0'
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
    puts name.to_s
    nil
  end

  def list_custom_properties
    []
  end
end

# HACK: rack_dav
# RackDAV::Controller#propfind
module RackDAV
  # Overwrite RackDAV::Controller
  class Controller
    # Original code is RackDAV https://github.com/georgi/rack_dav
    # Copyright (c) 2009 Matthias Georgi <http://www.matthias-georgi.de>
    # see license: https://github.com/georgi/rack_dav/blob/master/LICENSE
    def propfind
      raise NotFound unless resource.exist?

      if !request_match('/d:propfind/d:allprop').empty?
        nodes = all_prop_nodes
      else
        nodes = request_match('/d:propfind/d:prop/*')
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
          n.add_namespace(nil, '') if nd.prefix.nil? && nd.href.empty?
        end
      end

      multistatus do |xml|
        for resource in find_resources
          resource.path.gsub!(/\/\//, '/')
          xml.response do
            # The path must be finished with  "/" if resource is a collection
            url = "http://#{host}#{url_escape resource.path}"
            url += '/' if resource.collection? && !url.end_with?('/')
            xml.href url
            propstats xml, get_properties(resource, nodes)
          end
        end
      end
    end
  end
end

# WebDAVを処理するRackアプリケーション
class WebDAVFilter
  def initialize(app, root: Dir.pwd, path: '/')
    @app = app
    @path = path
    @webdav = RackDAV::Handler.new(root: root, resource_class: USBResource)
    @path_top_r = /\A#{@path}\/[^\/]*\/?\z/
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path_info.start_with?(@path)
      if req.path_info =~ @path_top_r
        # トップディレクトリは特別
        if req.delete?
          @app.call(env)
        else
          @webdav.call(env)
        end
      else
        # リバースプロキシ経由の場合は'HTTP_HOST'が正しくないと動作しない
        if (forwarded_hosts = env['HTTP_X_FORWARDED_HOST'])
          env['HTTP_HOST'] = forwarded_hosts.split(/,\s?/).last
        end
        @webdav.call(env)
      end
    else
      @app.call(env)
    end
  end
end
