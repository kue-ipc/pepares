require 'open3'
require 'logger'

# Devmon
class Devmon
  def initialize(app, logger = Logger.new(STDOUT))
    @app = app
    cmd = [
      'devmon',
      '-s',
    ]
    stdin, stdout, stderr, wait_thr = Open3.popen3(*cmd)
    stdin.close_write
    Thread.start do
      while (line = stdout.gets)
        logger.info(line.chomp)
      end
    end
    Thread.start do
      while (line = stderr.gets)
        logger.error(line.chomp)
      end
    end
    at_exit do
      wait_thr.join
      while (line = stdout.gets)
        logger.info(line.chomp)
      end
      while (line = stdout.gets)
        logger.info(line.chomp)
      end
    end
  end

  def call(env)
    @app.call(env)
  end
end
