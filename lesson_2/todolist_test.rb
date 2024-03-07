require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todolist_copy'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(@todos.size, @list.size)
  end

  def test_first
    assert_equal(@todos.first, @list.first)
  end

  def test_last
    assert_equal(@todos.last, @list.last)
  end

  def test_shift
    temp_todos = @todos.clone
    temp_list = @list.clone
    assert_equal(temp_todos.shift, temp_list.shift)
    assert_equal(temp_todos, temp_list.to_a)
  end

  def test_pop
    temp_todos = @todos.clone
    temp_list = @list.clone
    assert_equal(temp_todos.pop, temp_list.pop)
    assert_equal(temp_todos, temp_list.to_a)
  end

  # Solution did not use question mark for done?, assuming naming ocnvention
  # to differentiate from methods returning booleans
  def test_done_question
    @list.mark_all_done
    assert_equal(true,@list.done?)
    @todo1.undone!
    assert_equal(false,@list.done?)
    @list.mark_all_undone
  end

  def test_add_type_error
    assert_raises(TypeError) { @list.add(1) }
  end

  def test_shovel
    temp_list = @list.clone
    new_todo = Todo.new("check shovel method")
    temp_list << new_todo
    assert_equal(new_todo, temp_list.last)
  end

  def test_add
    temp_list = @list.clone
    new_todo = Todo.new("check shovel method")
    temp_list.add(new_todo)
    assert_equal(new_todo, temp_list.last)
  end

  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_raises(IndexError) { @list.item_at(4) }
  end

  #Solution tested other todos to make sure they were still false, good test
  def test_mark_done_at
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)

    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_mark_undone_at
    @list.mark_all_done
    @list.mark_undone_at(0)
    assert_equal(false, @todo1.done?)

    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    @todo1.undone!
    @todo2.undone!
    @todo3.undone!
  end

  def test_done!
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    @list.add(@todo1)
    assert_equal(@todo1, @list.remove_at(3))
    assert_equal(@todos,@list.to_a)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_one_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    @todo1.done!
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
    @list.mark_all_undone
  end

  def test_each
    test_case = []
    @list.each { |todo| test_case << todo }
    assert_equal(@todos, test_case)
  end

  def test_each_return_object
    assert_equal(@list, @list.each { })
  end

  def test_select
    selection = @list.select { |todo| todo.title = "Clean room" }
    assert_equal(@todo2, selection.first)
    assert_instance_of(TodoList, selection)
    refute_same(@list, selection)
  end
end