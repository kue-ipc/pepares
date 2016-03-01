# coding: utf-8
require "sinatra/base"
require "slim"
require "coffee-script"
require "sass"
require "rack_dav"
require "sinatra/reloader" if ENV['RACK_ENV'] == "development"

require_relative 'usb_device'

class MainApp < Sinatra::Base
  get "/" do
    @usbs = USBDevice.all
    slim :top
  end

  post "/shutdown" do
    @wait_secs = 3
    Thread.new do
      Thread.pass
      sleep @wait_secs
      system("/sbin/shutdown -h now")
    end
    slim :shutdown
  end

  post "/reboot" do
    @wait_secs = 3
    Thread.new do
      Thread.pass
      sleep @wait_secs
      system("/sbin/shutdown -r now")
    end
    slim :reboot
  end

  post "/eject" do
    system('/bin/sync')
    usb = USBDevice.find_by_device(@params[:eject])
    system("/usr/bin/devmon", "--eject", usb.device)
    redirect back
  end

  get "/about" do
    @envs = {}
    @envs["Rubyバージョン"] = RUBY_VERSION
    @envs["Gemの検索パス"] = Gem.path
    @envs["RACK_ENV"] = ENV['RACK_ENV']
    @envs["$:"] = $:
    slim :about
  end
end
