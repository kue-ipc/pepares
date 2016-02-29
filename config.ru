Gem.path << "./vendor/gems"
require_relative 'main'
require_relative 'webdav'
use Rack::Auth::Basic do |username, password|
  username == "pepares" && password == "pepares"
end
use Rack::CommonLogger
use WebDAVFilter, root: "/var/www/dav", path: "/usb"
run MainApp
