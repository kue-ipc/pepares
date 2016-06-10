require 'logger'

require_relative 'main'
require_relative 'webdav'
require_relative 'devmon'

log_dir = File.expand_path('log', File.dirname(__FILE__))

use Rack::Logger
use Rack::CommonLogger, Logger.new(File.join(log_dir, 'access.log'), 2)
use Rack::Auth::Basic do |username, password|
  username == 'pepares' && password == 'pepares'
end
use Devmon, Logger.new(File.join(log_dir, 'devmon.log'), 2)
use WebDAVFilter, root: '/var/www/dav', path: '/usb'
run MainApp
