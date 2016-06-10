require 'open3'
require 'logger'

# Devmon
class Devmon
  def initialize(app, logger = Logger.new(STDOUT))
    @app = app
    cmd = [
      'devmon',
      '-s',
      '--exec-on-drive',
      'echo %d %f %l',
    ]
    stdin, stdout, stderr, wait_thr = Open3.popen3(*cmd)
    stdin.close_write
    Thread.start do
      begin
        while (line = stdout.gets)
          logger.info(line.chomp)
        end
      ensure
        wait_thr.join
        while (line = stdout.gets)
          logger.info(line.chomp)
        end
      end
    end
    Thread.start do
      begin
        while (line = stderr.gets)
          logger.error(line.chomp)
        end
      ensure
        wait_thr.join
        while (line = stdout.gets)
          logger.info(line.chomp)
        end
      end
    end
  end

  def call(env)
    @app.call(env)
  end
end
