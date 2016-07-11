# coding: utf-8
require 'cgi'

# Sinatra
require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'
require 'rack/flash'

# Template for Sinatra
require 'slim'
require 'coffee-script'
require 'sass'

# Rails Assets
require 'rails-assets-skeleton-sass'
require 'rails-assets-font-awesome'

require_relative 'usb_device'

# メインとなる Sintra アプリケーション
class App < Sinatra::Base
  enable :sessions

  use Rack::Flash, sweep: true

  register Sinatra::AssetPipeline
  if defined?(RailsAssets)
    RailsAssets.load_paths.each do |path|
      settings.sprockets.append_path(path)
    end
  end

  before do
    @path_list = request.path_info.split('/')
  end

  get '/' do
    @usb_list = USBDevice.all
    if @usb_list.count == 0
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
    flash[:success] = '再起動を開始しました。'
    redirect '/'
  end

  # post '/eject' do
  #   system('/bin/sync')
  #   usb = USBDevice.find_by_device(@params[:eject])
  #   system('/usr/bin/udevil', 'umount', usb.device)
  #   redirect back
  # end

  # TODO
  delete '/usb/:name/?' do
    system('/bin/sync')
    usb = USBDevice.find_by_name(@params[:name])
    if usb
      system('/usr/bin/udevil', 'umount', usb.device)
      flash[:success] =
        "USB メモリ「#{usb.name}」の取り外し処理を行いました。\n" \
        "Raspberry Pi から USB メモリ を取り外してください。"
    else
      flash[:warning] = "指定された USB メモリが見つかりません。"
    end
    redirect '/'
  end

  get '/about' do
    @license_text = IO.read(File.join(settings.root, 'LICENSE'))
    slim :about
  end
end
