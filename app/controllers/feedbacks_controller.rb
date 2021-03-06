class FeedbacksController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:index, :show, :destroy, :update]
  before_action :get_user_detail
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
      
  def get_user_detail
    @user = current_user
  end
  # GET /feedbacks
  def index
    #@feedbacks = Feedback.all
    @feedbacks = Feedback.order_by params[:order_by]
  end


  # GET /feedbacks/1
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  def create
  
    team_submissions = @user.one_submission_teams
      
    @feedback = Feedback.new(feedback_params)
    
    @feedback.timestamp = @feedback.format_time(now)
    @feedback.user = @user
    @feedback.team = @user.teams.first

    #error_string = ""

    if (@feedback.communication == 1 && @feedback.communication_comment.empty?) || (@feedback.responsibility == 1 && @feedback.responsibility_comment.empty?) || (@feedback.work_quality == 1 && @feedback.work_quality_comment.empty?) || (@feedback.team_support == 1 && @feedback.team_support_comment.empty?) || (@feedback.collaboration == 1 && @feedback.collab_comment.empty?)
     flash[:error] = "Can not give rating of one without explanation."
      render :new
    else

        
    if @feedback.communication && @feedback.responsibility && @feedback.work_quality && @feedback.team_support && @feedback.collaboration
      @feedback.rating = @feedback.converted_rating
      if team_submissions.include?(@feedback.team)
          redirect_to root_url, notice: 'You have already submitted feedback for this team this week.'
      elsif @feedback.save
        redirect_to root_url, notice: "Feedback was successfully created. Time created: #{@feedback.timestamp}"
      else
        render :new
      end
    else
      flash[:error] = "You have not filled out the required fields."
      render :new
    end
  end
end 

  # PATCH/PUT /feedbacks/1
  def update
    @feedback.rating = @feedback.converted_rating
    if @feedback.update(feedback_params)
      redirect_to @feedback, notice: 'Feedback was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /feedbacks/:id
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def feedback_params
      params.require(:feedback).permit(:rating, :comments, :priority, :collaboration, :collab_comment, :communication, :communication_comment, 
      :team_support, :team_support_comment, :responsibility, :responsibility_comment, :work_quality, :work_quality_comment, :responded)
    end
end
