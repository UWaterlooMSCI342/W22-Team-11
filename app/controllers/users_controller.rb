class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, except: [:new, :create, :update, :edit]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /signup
  def new
    if logged_in? 
      redirect_to root_url 
    end 
    
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  def create    
    final_user_params = user_params.except(:team_code)
        
    @user = User.new(final_user_params)
    @user.valid?

    #team_code is blank
    if user_params[:team_code].nil? or user_params[:team_code].size==0 
      @user.errors.add :teams, :invalid, message: "cannot be blank" 
    else
      if user_params[:team_code] == Option.first.admin_code
        @user.is_admin = true
        @user.valid?
      else
        @user.is_admin = false
        @user.valid?
        team = Team.find_by(team_code: user_params[:team_code])

        #team_code is not valid 
        if team.nil?
          @user.errors.add :teams, :invalid, message: "code does not exist"
        else 
          if team.capacity >= team.number_of_users + 1
            @user.teams = [team]
          else
            @user.errors.add :teams, :invalid, message: "is full. If you believe this is an error, please contact your professor."
          end
        end    
      end
    end 

    if @user.errors.size == 0
      @user.save
      log_in @user
      redirect_to root_url, notice: 'User was successfully created.'
    else    
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = current_user
    if @user.update_attribute(:first_name, params[:user][:first_name]) && @user.update_attribute(:last_name, params[:user][:last_name])
      flash[:message] = 'Profile successfully updated!'
      redirect_to root_path
    else 
      flash[:error] = 'Profile could not be updated!'
      redirect_to edit_user_path(@user)
    end
  end

  # DELETE /users/1
  def destroy
    if current_user.is_admin?
      if @user == current_user
        log_out
      end
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    else
      redirect_to root_url, notice: 'You do not have permission to delete users.'
    end
  end
  
  def confirm_delete
    @user = User.find(params[:id])
    
  end 

  def reset_student_pass
    @user = User.find(params[:id])
    new_password = @user.generate_random_pass(10)
    @user.reset_pass(new_password)
    if @user.password == new_password
      flash[:message] = 'Password successfully updated to: ' + new_password
    else 
      flash[:error] = 'Password could not be reset!'
    end 
    redirect_to user_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    # Only allow a trusted parameter "white list" through.
    # Should use later (ignoring this for now)
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :team_code)
    end

end
