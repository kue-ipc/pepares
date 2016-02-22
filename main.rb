# coding: utf-8
require "sinatra/base"
require "slim"
require "coffee-script"
require "sass"

require "sinatra/reloader" if ENV['RACK_ENV'] == "development"

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

  get "/about" do
    @envs = {}
    @envs["Rubyバージョン"] = RUBY_VERSION
    @envs["Gemの検索パス"] = Gem.path
    @envs["RACK_ENV"] = ENV['RACK_ENV']
    slim :about
  end
end
