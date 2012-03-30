class TestcasesController < ApplicationController

  def new 
    problem_id = params[:problem_id]
    @problem = Problem.find(problem_id)

    respond_to do |format|
      format.html
      format.json { render json: @testcase }
    end
  end

  def index
    @problem_id = params[:problem_id]
    @testcases = Problem.find(@problem_id).testcases

    respond_to do |format|
      format.html
      format.json { render json: @testcases }
    end
  end

  def create
    @problem = Problem.find(params[:problem_id])
    @testcase = @problem.testcases.create(params[:testcase])
    redirect_to problem_path(@problem)
  end

  def destroy
    @testcase = Testcase.find(params[:id])
    @testcase.destroy

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.json { head :no_content }
    end
  end

end
