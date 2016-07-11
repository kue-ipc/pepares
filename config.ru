
Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

app_root_dir = File.expand_path(File.dirname(__FILE__))
log_dir = File.expand_path('log', app_root_dir)
tmp_dir = File.expand_path('tmp', app_root_dir)
usb_dir = File.expand_path('usb', tmp_dir)
Dir.mkdir(log_dir) unless FileTest.directory?(log_dir)
Dir.mkdir(tmp_dir) unless FileTest.directory?(tmp_dir)
Dir.mkdir(usb_dir) unless FileTest.directory?(usb_dir)

require 'logger'

require_relative 'app'
require_relative 'webdav'
require_relative 'devmon'

case ENV['RACK_ENV']
when 'development'
  log = Logger.new(STDOUT)
  log.level = Logger::DEBUG
when 'production'
  log = Logger.new(File.join(log_dir, 'pepares.log'), 2)
  log.level = Logger::INFO
when 'test'
  log = Logger.new('/dev/null')
end

# use Rack::Logger
# use Rack::CommonLogger, log
use Rack::MethodOverride
use Rack::Auth::Basic do |username, password|
  username == 'pepares' && password == 'pepares'
end

use Devmon, usb_dir, log
use WebDAVFilter, root: tmp_dir, path: '/usb'
run App
