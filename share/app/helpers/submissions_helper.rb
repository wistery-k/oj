module SubmissionsHelper

  def colorize_verdict str 
    def make (color, str)
      "<span style=\"color:#{color};\">#{str}</span>"
    end
    def makeb (color, str)
      "<span style=\"color:#{color}; font-weight:bold\">#{str}</span>"
    end
    str.gsub(/AC/, makeb('#59ea3a', 'AC'))
       .gsub(/WA/, makeb("#a600a6", 'WA'))
       .gsub(/compile error/, make("#05213d", 'compile error'))
  end

  def now_judging? submission 
    /^pending|testing #\d$/ =~ submission.verdict
  end

end
