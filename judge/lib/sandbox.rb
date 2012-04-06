module Sandbox

  require 'open3'

  def exec (cmd, input, time_limit, memory_limit)

    if not (defined? SANDBOX_PATH)
      raise 'SANDBOX_PATH is not defined. please define in the file config/initializers/constants.rb.'
    end
    
    cmd = [SANDBOX_PATH, time_limit, memory_limit, cmd].join(' ')
    stdin, stdout, stderr = *Open3.popen3(cmd)

    stdin.puts input
    stdin.close
    verdict, cpu, mem = stderr.read.split
    
    return {
      :output => stdout.read, 
      :verdict => verdict, 
      :cpu => cpu.to_i, 
      :memory => mem.to_i
    }
  end

  module_function :exec

end
