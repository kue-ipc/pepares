# unicorn for Pepares
worker_process 2
working_directory "/var/www/pepares/"
listen "/run/pepares.sock"
timeout 30
pid "/run/pepares.pid"
stderr_path "/var/log/pepares.log"
stdout_path "/var/log/pepares.log"
preload_app true
