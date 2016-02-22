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

task :server do
  sh "unicorn -c unicorn.rb -E development -D"
end
