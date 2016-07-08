# coding: utf-8
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'
require 'rack/flash'
require 'sinatra/asset_pipeline'
require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'
require 'rails-assets-skeleton-sass'
require 'cgi'

require_relative 'usb_device'

# メインとなる Sintra アプリケーション
class App < Sinatra::Base
  enable :method_override
  enable :sessions
  use Rack::Flash
  register Sinatra::AssetPipeline
  if defined?(RailsAssets)
    RailsAssets.load_paths.each do |path|
      settings.sprockets.append_path(path)
    end
  end

  get '/' do
    @usbs = USBDevice.all
    if @usbs.count == 0
      flash[:info] = 'USB メモリ が 認識されていません。 ' \
        'Rasberry Pi に USB メモリ を挿入し、ページを再読み込みしてください。'
    end
    slim :top
  end

  post '/shutdown' do
    @wait_secs = 3
    # Thread.new do
    #   Thread.pass
    #   sleep @wait_secs
    #   system('/usr/bin/sudo /sbin/shutdown -h now')
    # end
    # slim :shutdown
    flash[:success] = 'シャットダウンを開始しました。'
    redirect '/'
  end

  post '/reboot' do
    @wait_secs = 3
    # Thread.new do
    #   Thread.pass
    #   sleep @wait_secs
    #   system('/usr/bin/sudo /sbin/shutdown -r now')
    # end
    flash[:success] = '再起動を開始しました。。'
    redirect '/'
  end

  post '/eject' do
    system('/bin/sync')
    usb = USBDevice.find_by_device(@params[:eject])
    system('/usr/bin/udevil', 'umount', usb.device)
    redirect back
  end

  # TODO
  delete '/usb/:id' do
    system('/bin/sync')
    usb = USBDevice.find_by_device(@params[:id])
    system('/usr/bin/udevil', 'umount', usb.device)
    redirect back
  end

  get '/about' do
    @license_text = IO.read(File.join(settings.root, 'LICENSE.md'))
    slim :about
  end
end
