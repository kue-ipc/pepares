require 'logger'

require_relative 'main'
require_relative 'webdav'
require_relative 'devmon'

case ENV['RACK_ENV']
when 'development'
  log = Logger.new(STDOUT)
  log.level = Logger::DEBUG
when 'production'
  log_dir = File.expand_path('log', File.dirname(__FILE__))
  log = Logger.new(File.join(log_dir, 'pepares.log'), 2)
  log.level = Logger::INFO
when 'test'
  log = Logger.new(STDERR)
  log.lever = Logger::WARNING
end

use Rack::Logger
use Rack::CommonLogger, log
use Rack::Auth::Basic do |username, password|
  username == 'pepares' && password == 'pepares'
end
use Devmon, log
use WebDAVFilter, root: '/var/www/dav', path: '/usb'
run MainApp
