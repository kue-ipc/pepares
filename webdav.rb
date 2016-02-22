
require "rack_dav"

WebDAVApp = RackDAV::Handler.new(:root => "/var/www/dav/usb")
