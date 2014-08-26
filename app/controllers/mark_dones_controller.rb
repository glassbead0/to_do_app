class MarkDonesController < ApplicationController
  def update # mark one as done
    @user = current_user
    @todo = @user.todos.find(params[:id])
    respond_to do |format|
      if @todo.update_attribute(:done, true)
        format.html { redirect_to todos_path }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def index # mark all as done
    @user = current_user
    @todos = @user.todos
    respond_to do |format|

      @todos.each do |todo|
        todo.update_attribute(:done, true)
      end
        format.html { redirect_to todos_path }
        format.json { render :show, status: :ok, location: @todo }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @todo.errors, status: :unprocessable_entity }
      # end
    end
  end
end
