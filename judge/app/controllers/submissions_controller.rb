class SubmissionsController < ApplicationController

  class Cpp

    def nw str
      str.strip.gsub(/[\r\n\t ]+/, ' ')
    end

    def initialize
      @a_out = "/tmp/a.out"
    end

    # string -> bool
    def compile code
      cmd = "cat <<END | g++ -x c++ -std=c++0x -O2 -o #{@a_out} - 
#{code}
END"
      File.write("/home/kfujima/log.txt", cmd)
      return system(cmd)
    end

    # testcase -> assoc
    def test time_limit, memory_limit, t
      tl = Integer(time_limit * 1000)
      ml = Integer(memory_limit * 2**20)

      res = Sandbox.exec(@a_out, t.input, tl, ml)
      
      if res[:verdict] == 'OK'
        res[:verdict] = (nw(t.output) == nw(res[:output])) ? 'AC' : 'WA'
      end

      return res
    end

  end
  
  def judge

    submission = Submission.find(params[:id])
    problem = Problem.find(submission.problem)

    tester = Cpp.new
    unless tester.compile(submission.code) then
      submission.verdict = 'compile error'
    else
      submission.verdict = 'AC'

      problem.testcases.each_with_index do |testcase, i|
        res = tester.test(problem.time_limit, problem.memory_limit, testcase)
        res[:testcase_id] = i
        submission.testresults.create(res)
        if(res[:verdict] != 'AC') then
          submission.verdict = "#{res[:verdict]} on case ##{i}"
          break
        end
      end
    end

    submission.save

    redirect_to :controller => "problems", :action => "index"

  end

end
