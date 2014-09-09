module ListsHelper

  def set_urgency_color(todo)
    @urgency_color = 'info'
    if todo.deadline
      @seconds_left = todo.deadline - Time.now
      if @seconds_left < 0
        @urgency_color = 'overdue'
      elsif @seconds_left < 600
        @urgency_color = 'danger'
      elsif @seconds_left < 3600
        @urgency_color = 'warning'
      else
        @urgency_color = 'info'
      end
    end
  end

end
