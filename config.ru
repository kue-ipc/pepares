Gem.path << "./vendor/gems"
require './main.rb'
require './webdav.rb'

use Rack::CommonLogger
use WebDAVFilter, root: "/var/www/dav", path: "/usb"
run MainApp
