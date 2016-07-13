# frozen_string_literal: true
require 'rake'
require 'rake/clean'
require 'sinatra/asset_pipeline/task'

require_relative 'app'

Encoding.default_external = 'UTF-8'

Sinatra::AssetPipeline::Task.define! App

desc "簡易サーバ実行"
task :server do
  sh 'rackup -o 0.0.0.0'
end

# namespace :pi do
#   desc "Raspberry Piでのセットアップ"
#   task build: :gem_install
#
#   task :gem_install do
#     install_dir = 'vendor/gems'
#     gems_dir = 'gems'
#     gem_list = [
#       'rack_dav-0.4.1.gem',
#       'ffi-xattr-0.1.2.gem'
#     ]
#     gem_list.each do |gem_file|
#       sh 'gem install ' \
#          "-i #{install_dir} " \
#          '-N --ignore-dependencies ' \
#          "#{gems_dir}/#{gem_file}"
#     end
#   end
# end
