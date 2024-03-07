def reduce(collection, start = :not_provided)
  counter = 1
  operands = collection
  operands.unshift(start) unless start == :not_provided
  result = operands[0]

  loop do
    element = operands[counter]
    result = yield(result, element)
    counter += 1
    break if counter == operands.size
  end

  result
end

p reduce(['a', 'b', 'c']) { |acc, value| acc += value }     # => 'abc'
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value } # => [1, 2, 'a', 'b']