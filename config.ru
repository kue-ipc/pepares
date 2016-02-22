Gem.path << "./vendor/gems"
require './main.rb'
require './webdav.rb'

map "/usb" do
  run WebDAVApp
end

map "/" do
  run MainApp
end
