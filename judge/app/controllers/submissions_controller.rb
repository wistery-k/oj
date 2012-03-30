class SubmissionsController < ApplicationController
  def judge

    s = Submission.find(params[:id])
    s.verdict = self.class.helpers.judge(s.lang, s.code, Problem.find(s.problem).testcases)

    s.save

    redirect_to :controller => "problems", :action => "index"

  end
end
