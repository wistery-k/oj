# -*- coding: utf-8 -*-
class SubmissionsController < ApplicationController

  require 'net/http'

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all.reverse
    @watch = params[:watch].to_i
    if @watch == 0 then 
      @watch = nil
    end
    if @watch then
      my_submission = (@submissions.select do |x| x.id == @watch end)[0]
      @watch = nil if my_submission && (not self.class.helpers.now_judging?(my_submission))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @submissions }
    end
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @submission = Submission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @submission }
    end
  end

  # GET /submissions/new
  # GET /submissions/new.json
  def new
    @submission = Submission.new
    @submission.problem = params[:problem].to_i if params[:problem]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @submission }
    end
  end

  # POST /submissions
  # POST /submissions.json
  def create
    params[:submission][:verdict] = 'pending'

    @submission = Submission.new(params[:submission])
    flg = @submission.save

    Thread.new do # TODO こんなんでいいのだろうか？ non-blocking
      Net::HTTP.get("localhost", "/submissions/judge/#{@submission.id}", port = 4000 )
    end       

    redirect_to :action => 'index', :watch => @submission.id
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to submissions_url }
      format.json { head :no_content }
    end
  end
end
