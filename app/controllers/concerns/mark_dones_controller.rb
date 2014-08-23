class MarkDonesController < ApplicationController
  def update
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
end
