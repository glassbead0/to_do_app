class UsersController < ApplicationController
  def todo_list
    @user = current_user
    @todos = @user.todos.where(done: false)
    @dones = @user.todos.where(done: true)
    @todo = Todo.new
  end
end
