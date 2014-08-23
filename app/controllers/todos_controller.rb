class TodosController < ApplicationController
  before_action :set_user
  before_action :set_todo, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /todos
  # GET /todos.json
  def index
    # @todos = @user.todos.where(done: false)
    # @dones = @user.todos.where(done: true)
    @todo = Todo.new

    @q = @user.todos.search(params[:q])
    @todos = @q.result.where(done: false)   # load all matching records
    @dones = @q.result.where(done: true)

    # @todos = @search.relation # Retrieve the relation, to lazy-load in view
    # @todos = @search.paginate(:page => params[:page]) # Who doesn't love will_paginate?
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = @user.todos.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = @user.todos.create(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    @todo = @user.todos.find(params[:id])
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_path }
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
      format.html { redirect_to todos_url }
      format.json { head :no_content }
    end
  end

  def destroy_dones
    @dones = @user.todos.where(done: true)
    @dones.destroy_all
    redirect_to todos_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = @user.todos.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:name, :done)
    end
end
