class TodosController < ApplicationController
  before_action :set_user
  before_action :set_list
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :mark_done, :unmark_done]
  before_action :authenticate_user!
  # GET /todos
  # GET /todos.json

  # GET /todos/1
  # GET /todos/1.json

  def index
    @q = @user.todos.search(params[:q])
    @todos = @q.result.where(done: false).order(:deadline)   # load all matching records
    @dones = @q.result.where(done: true).order(:list_id)
  end

  def show
  end

  # GET /todos/new
  def new
    @todo = @list.todos.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  # POST /todos.json
  def create

    @todo = @list.todos.create(todo_params)
    @user.todos << @todo

    set_deadline(@todo)

    respond_to do |format|
      if @todo.save

        format.html { redirect_to list_path(@list) }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_deadline(todo)
    name = todo.name
    # get a statement in minutes or hours to make the deadline
    if deadline = /(in\s)*\d+\s*minutes*/.match(todo.name)
      minutes = /\d+/.match(deadline.to_s).to_s.to_i
      todo.deadline = Time.new + minutes.minutes
    elsif deadline = /(in\s)*\d+\s*hours*/.match(todo.name)
      hours = /\d+/.match(deadline.to_s).to_s.to_i
      todo.deadline = Time.new + hours.hours

    # get a direct hour:minute time statement: 6:30pm
    elsif deadline = /(at\s)*\d+:\d{2}\s*pm/.match(todo.name)
      hour = (/\d+:/.match(deadline.to_s).to_s).delete(':').to_i + 12
      hour = 12 if hour == 24
      minute = (/:\d\d/.match(deadline.to_s).to_s).delete(':').to_i
      todo.deadline = Time.new(Time.now.year, Time.now.month, Time.now.day, hour, minute)
    elsif deadline = /(at\s)*\d+:\d{2}\s*am/.match(todo.name)
      hour = (/\d+:/.match(deadline.to_s).to_s).delete(':').to_i
      hour = 0 if hour == 12
      # set day to tomorrow if deadline has already passed
      day = Time.now.day
      day = Time.now.day + 1 if hour <= Time.now.hour
      minute = (/:\d\d/.match(deadline.to_s).to_s).delete(':').to_i
      todo.deadline = Time.new(Time.now.year, Time.now.month, day, hour, minute)

    # get an hour statement, 9pm
    elsif deadline = /(at\s)*\d+\s*pm/.match(todo.name)
      hour = /\d+/.match(deadline.to_s).to_s.to_i + 12
      hour = 12 if hour == 24
      todo.deadline = Time.new(Time.now.year, Time.now.month, Time.now.day, hour)
    elsif deadline = /(at\s)*\d+\s*am/.match(todo.name)
      hour =  /\d+/.match(deadline.to_s).to_s.to_i
      hour = 0 if hour == 12
      # set day to tomorrow if deadline has already passed
      day = Time.now.day
      day = Time.now.day + 1 if hour <= Time.now.hour
      todo.deadline = Time.new(Time.now.year, Time.now.month, day, hour)

    elsif deadline = /(at\s)*noon/.match(todo.name)
      todo.deadline = Time.new(Time.now.year, Time.now.month, Time.now.day, 12)

    else # no deadline
      todo.deadline = nil
      deadline = ''
    end
    new_name = name.split(deadline.to_s).join
    todo.update_attribute(:name, new_name)
  end


  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)

        # if blank, set deadline to nil
        if @todo.deadline == '0001-01-01 00:00:00'
          @todo.update_attribute(:deadline, nil)
        end



        format.html { redirect_to @list }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to list_path(@list) }
      format.json { head :no_content }
    end
  end

  def destroy_dones
    @dones = @list.todos.where(done: true)
    @dones.destroy_all
    redirect_to @list
  end


  def mark_done
    respond_to do |format|
      if @todo.update_attribute(:done, true)
        format.html { redirect_to @list }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_all_done
    @todos = @list.todos
    respond_to do |format|

      @todos.each do |todo|
        todo.update_attribute(:done, true)
      end
      format.html { redirect_to @list }
      format.json { render :show, status: :ok, location: @todo }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @todo.errors, status: :unprocessable_entity }
      # end
    end
  end

  def unmark_done
    respond_to do |format|
      if @todo.update_attribute(:done, false)
        format.html { redirect_to @list }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

  def set_list
    @list = @user.lists.find(params[:list_id])
  end

  def set_todo
    @todo = @list.todos.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:name, :done, :deadline)
    end
end
