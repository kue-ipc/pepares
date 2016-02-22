
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

/etc/default/unicorn
APP_ROOT=/var/www/pepares
bundle exec unicorn -c unicorn.rb -E production -D

nginx

```
upstream unicorn {
        server unix:/run/unicorn.sock;
}

server {
        root /var/www/pepares/public;
        location / {
                try_files $uri $uri/ @unicorn;
        }

        location @unicorn {
                proxy_pass http://unicorn;
        }    root /var/www/pepares/public
}
```
