# Pepares 簡易ペーパーレス会議システム

## システム要件
* サポートするハードウェアとOS
    * Paspberry Pi 2 B または Paspberry Pi 3 B
    * Raspbien Jessie
* 動作するであろうと環境
    * UNIX/Linux 環境
    * Ruby 2.1 以上
* CSSを更新する場合
    * Node.js + npm + Bower

## Raspberry Pi の設定

### 必要なパッケージのインストール

```
sudo apt-get install ruby bundler nodejs zlib1g-dev
bundle install --path vendor/bundle
```

rake
bundler

ruby-sinatra
ruby-sinatra-contrib
ruby-slim
ruby-sass
ruby-coffee-script
unicorn

(rack_dav用)
ruby-rack
ruby-nokogiri




bower install
ruby css_build
use framework
* [Skeleton](http://getskeleton.com/) 2.0.4


bundle install --path=vendor/bundle --without=development

sudo apt-get install unicorn \
ruby-sinatra \
ruby-sinatra-contrib \
ruby-slim \
ruby-sass \
ruby-coffee-script \
ruby-rack \
ruby-nokogiri
ruby-filesystem

/etc/default/unicorn
```
CONFIGURED=yes
APP_ROOT=/var/www/pepares
UNICORN_OPTS="-D -c $CONFIG_RB -E production"
```

bundle exec unicorn -c unicorn.rb -E production -D

nginx

```
upstream unicorn {
        server unix:/run/unicorn.sock;
}

server {
        root /var/www/pepares/public;
        location / {
                try_files $uri @unicorn;
        }

        location @unicorn {
                proxy_pass http://unicorn;
        }    root /var/www/pepares/public
}
```

gem install -i vendor -N --ignore-dependencies

sudo mkdir /var/log/unicorn
