class TestcasesController < ApplicationController

  def create
    @problem = Problem.find(params[:problem_id])
    @comment = @problem.testcases.create(params[:testcase])
    redirect_to problem_path(@problem)
  end

end
