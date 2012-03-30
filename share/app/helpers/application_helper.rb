module ApplicationHelper
  def hbr (target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, '<br />')
  end

  def problem_link problem_id 
    begin
      problem = Problem.find(problem_id)
      link_to "#{problem_id} - #{problem.title}", problem_path(problem)
    rescue
      "problem has been deleted"
    end
  end
end
