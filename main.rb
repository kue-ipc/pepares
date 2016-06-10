# coding: utf-8
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'
require 'rack_dav'
require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'

require_relative 'usb_device'

class MainApp < Sinatra::Base
  get '/' do
    @usbs = USBDevice.all
    p @usbs
    slim :top
  end

  post '/shutdown' do
    @wait_secs = 3
    Thread.new do
      Thread.pass
      sleep @wait_secs
      system('/usr/bin/sudo /sbin/shutdown -h now')
    end
    slim :shutdown
  end

  post '/reboot' do
    @wait_secs = 3
    Thread.new do
      Thread.pass
      sleep @wait_secs
      system('/usr/bin/sudo /sbin/shutdown -r now')
    end
    slim :reboot
  end

  post '/eject' do
    system('/bin/sync')
    usb = USBDevice.find_by_device(@params[:eject])
    system('/usr/bin/udevil', 'umount', usb.device)
    redirect back
  end

  get '/about' do
    @license_text = IO.read(File.join(settings.root, 'LICENSE.md'))
    slim :about
  end
end
