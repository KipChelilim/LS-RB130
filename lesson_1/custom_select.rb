def select(collection)
  counter = 0
  result = []
  loop do
    element = collection[counter]
    test_result = yield(element)
    result << element if test_result
    counter += 1
    break if counter == collection.size
  end

  result
end

array = [1, 2, 3, 4, 5]

p select(array) { |num| num.odd? }      # => [1, 3, 5]
p select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
p select(array) { |num| num + 1 }       # => [1, 2, 3, 4, 5], because "num + 1" evaluates to true