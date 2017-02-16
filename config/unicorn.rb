require 'pathname'
APP_PATH = Pathname.new(__FILE__).realpath.sub('/config/unicorn.rb', '').to_s

worker_processes 4
working_directory APP_PATH

listen 80, tcp_nopush: true

timeout 400

`mkdir -p #{APP_PATH}/tmp/pids`
pid APP_PATH + '/tmp/pids/unicorn.pid'

preload_app true
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

check_client_connection false

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
