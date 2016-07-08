require 'open3'
require 'logger'

# Devmon
class Devmon
  def initialize(app, usb_dir, logger = Logger.new(STDOUT))
    @app = app
    @usb_dir = usb_dir
    @logger = logger
    run_devmon
  end

  def run_devmon
    cmd = [
      'devmon',
      '-s',
    ]
    stdin, stdout, stderr, wait_thr = Open3.popen3(*cmd)
    stdin.close_write
    Thread.start do
      out_log(stdout, Logger::INFO) do |line|
        if line.start_with?('Mounted')
          USBDevice.all_link(@usb_dir)
        end
      end
    end
    Thread.start do
      out_log(stderr, Logger::ERROR)
    end
    at_exit do
      wait_thr.join
      out_log(stdout, Logger::INFO)
      out_log(stderr, Logger::ERROR)
    end
  end

  def out_log(io, serverity = Logger::DEBUG)
    while (line = io.gets)
      line = line.chomp
      unless line.empty?
        @logger.log(serverity, line, 'devmon')
        yield line if block_given?
      end
    end
  end

  def call(env)
    @app.call(env)
  end
end
