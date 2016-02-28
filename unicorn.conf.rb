# unicorn for Pepares
worker_processes 4
working_directory "/var/www/pepares/"
listen "/run/unicorn.sock"
timeout 30
pid "/run/unicorn.pid"
stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"
preload_app true
