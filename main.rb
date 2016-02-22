
require "sinatra/base"
require "slim"
require "coffee-script"
require "sass"

p ENV['RACK_ENV']
require "sinatra/reloader"

class MainApp < Sinatra::Base
  get "/" do
    slim :top
  end

  post "/shutdown" do
    # system("/sbin/shutdown -h now")
    slim :shutdown
  end

  post "/reboot" do
    # system("/sbin/shutdown -h now")
    slim :shutdown
  end

  post "/eject" do
    # system("/usr/bin/udevil unmount /dev/sda1")
    slim :eject
  end
end
