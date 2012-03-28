module SubmissionsHelper

  def normalize_whitespaces str
    str.strip.gsub(/[\r\n\t ]+/, ' ')
  end

  def judge (lang, code, testcases)
    
    case lang
    when 'c++', 'C++'
      
      compile = "cat <<END | g++ -x c++ -std=c++0x -O2 -o /tmp/a.out -
#{code}
END"
      
      return 'compile error' unless system(compile)
      
      ok = testcases.all? do |testcase|
        answer = testcase.output
        output = `cat <<END | /tmp/a.out
#{testcase.input}
END`
        File.write("/home/kfujima/log.txt", output)
        (normalize_whitespaces answer) == (normalize_whitespaces output)
      end
      
      return ok ? 'AC' : "WA" 
    else
      return 'unknown lang'
    end
  end

end
