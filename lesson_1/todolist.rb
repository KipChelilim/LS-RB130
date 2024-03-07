# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError, "Can only add Todo objects" unless todo.is_a?(Todo)
    todos.push(todo)
  end

  alias :<< :add

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def to_a
    todos.clone
  end

  def done?
    todos.all?(&:done?)
  end

  def item_at(index)
    todos.fetch(index)
  end

  def mark_done_at(index)
    item_at(index).done!
  end

  def mark_undone_at(index)
    item_at(index).undone!
  end

  def done!
    todos.each { |todo| todo.done! }
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(index)
    item_at(index)
    todos.delete_at(index)
  end

  def to_s
    header = "---- Today's Todos ----"
    ([header] + todos).join("\n")
  end

  def each
    counter = 0
    loop do
      yield(todos[counter])
      counter += 1
      break if counter == todos.size
    end
    self
  end

  def select
    result = TodoList.new(title)
    each do |todo|
      result.add(todo) if yield(todo)
    end
    result
  end

  # Used `TodoList#each` and return, but that's not really intuitive. Purpose
  # here is to select, so using `TodoList#select` makes more sense. Updated to
  # match solution
  def find_by_title(todo_title)
    select { |todo| todo.title == todo_title }.first
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  # Need the && to short circuit if title is not found or else you'll call
  # #done! on `nil` and error out. Missed that the first pass through
  def mark_done(todo_title)
    find_by_title(todo_title) && find_by_title(todo_title).done!
  end

  def mark_all_done
    each(&:done!)
  end

  def mark_all_undone
    each(&:undone!)
  end

  private

  attr_accessor :todos
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

p list.find_by_title("buy juice")
p list.find_by_title("Clean room")
puts list
list.mark_all_done
puts list
list.mark_all_undone
puts list
p list.mark_done("Buy milk")
puts list
puts list.all_done
puts list.all_not_done
