class MarkDonesController < ApplicationController
  before_action :set_user_and_list

  def mark_done
    @todo = @list.todos.find(params[:id])
    respond_to do |format|
      if @todo.update_attribute(:done, true)
        format.html { redirect_to list_path(@list) }
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
        format.html { redirect_to list_path(@list) }
        format.json { render :show, status: :ok, location: @todo }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @todo.errors, status: :unprocessable_entity }
      # end
    end
  end

  def unmark_done
    @todo = @user.todos.find(params[:id])
    respond_to do |format|
      if @todo.update_attribute(:done, false)
        format.html { redirect_to todos_path }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user_and_list
    @user = current_user
    @list = @user.lists.find(params[:id])
  end
end
