def each(collection)
  counter = 0
  loop do
    yield(collection[counter])
    counter += 1
    break if counter == collection.size
  end

  collection
end

p [1, 2, 3].each{|num| "do nothing"}.select{ |num| num.odd? }     # => [1, 3]s