class ListsController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  before_action :set_list, only: [:show, :edit, :update, :destroy, :add_todo]

  # GET /lists
  # GET /lists.json
  def index
    @lists = @user.lists
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @todo = @list.todos.new
    # byebug
    # @q = @list.todos.search(params[:q])
    # @todos = @q.result.where(done: false, list_id: @list.id)   # load all matching records
    # @dones = @q.result.where(done: true, list_id: @list.id)

    @todos = @list.todos.where(done: false)
    @dones = @list.todos.where(done: true)

    if @dones.length + @todos.length != 0
      @percentage = 100 * @dones.length / (@dones.length + @todos.length)
    else
      @percentage = 0
    end

    @status = 'progress-bar progress-bar-success progress-bar-striped active' if @percentage == 100
    @status = 'progress-bar progress-bar-info progress-bar-striped active' if @percentage < 100

  end

  # GET /lists/new
  def new
    @list = @user.lists.new
    @search_bar = true   # this will prevent search bar from showing on this page (confusing I know). it will throw error otherwise
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = @user.lists.create(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    if @list.name == 'Default'
      format.html { redirect_to @user.lists.find_by(name: 'Default'), data: { confirm: 'You can\'t delete your default list'} }
    else
      @list.destroy
      respond_to do |format|
        format.html { redirect_to @user.lists.find_by(name: 'Default') }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

    def set_list
      @list = @user.lists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :user_id)
    end
end
