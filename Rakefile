class Cmd
  @@base_dir = File.dirname(__FILE__)

  def self.cd_sh(dir, cmd); cd dir; sh cmd; end

  def self.start(app_name, port = 3000)
      cd_sh "#{@@base_dir}/#{app_name}", "rails s -d -p #{port}"
  end

  def self.stop(app_name)
    cd_sh "#{@@base_dir}/#{app_name}", "kill -9 `cat tmp/pids/server.pid`"
  end

  def self.test(app_name)
    cd_sh "#{@@base_dir}/#{app_name}", "rake"
  end
end

namespace :web do
  desc "start web"
  task :start do; Cmd.start("web", 3000); end
  
  desc "stop web"
  task :stop do; Cmd.stop("web"); end
  
  desc "test myapp"
  task :test do; Cmd.test("web"); end
end

namespace :judge do
  desc "run judge"
  task :start do; Cmd.start("judge", 4000); end
  
  desc "stop judge"
  task :stop do; Cmd.stop("judge"); end
  
  desc "test judge"
  task :test do; Cmd.test("judge"); end
end

desc "run all applications"
task :start => ['web:start', 'judge:start'] do; end

desc "stop all applications"
task :stop => ['web:stop', 'judge:stop'] do; end

desc "test all applications"
task :test => ['web:test', 'judge:test'] do; end
