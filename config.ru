Gem.path << "./vendor/gems"
require './main.rb'
require './webdav.rb'

use Rack::Auth::Basic do |username, password|
  username == "pepares" && password == "pepares"
end
use Rack::CommonLogger
use WebDAVFilter, root: "/var/www/dav", path: "/usb"
run MainApp
