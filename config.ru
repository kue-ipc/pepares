Gem.path << "./vendor/gems"
require './main.rb'
require './webdav.rb'

use WebDAVFilter, root: "/var/www/dav", path: "/usb"
run MainApp
