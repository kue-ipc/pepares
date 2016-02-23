require "rake"
require "rake/clean"
require "sass"

def scss_compile(scss, css)
  open(css, "wb") do |io|
    io.write(Sass::Engine.new(
      IO.read(scss),
      syntax: :scss,
      load_paths: [File.dirname(scss)],
      style: :compressed
    ).render)
  end
end

Encoding.default_external = "UTF-8"
namespace :css do
  CSSS = FileList["public/css/skeleton.min.css"]
  CLEAN << FileList["bower_components/*", ".sass-cache/*"]
  CLOBBER << CSSS

  desc "CSSのセットアップ"
  task :build => :css_build

  task :css_build => CSSS

  task :bower_install do
    sh "bower install skeleton-sass"
  end

  file "bower_components/skeleton-sass/skeleton_template.scss" => :bower_install

  file "public/css/skeleton.min.css" => "bower_components/skeleton-sass/skeleton_template.scss" do |t|
    scss_compile(t.source, t.name)
  end
end

desc "簡易サーバ実行"
task :server do
  sh "rackup"
end

namespace :pi do
  desc "Raspberry Piでのセットアップ"
  task :build => :gem_install

  task :gem_install do
    install_dir = "vendor/gems"
    gems_dir = "gems"
    gem_list = [
      "rack_dav-0.4.1.gem",
      "ffi-xattr-0.1.2.gem",
    ]
    gem_list.each do |gem_file|
      sh "gem install " +
          "-i #{install_dir} " +
          "-N --ignore-dependencies " +
          "#{gems_dir}/#{gem_file}"
    end
  end
end
