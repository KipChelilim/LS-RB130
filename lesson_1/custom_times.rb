def times(number)
  counter = 0
  loop do
    yield(counter)
    counter += 1
    break if counter == number
  end

  number
end

def test
  times(5) do |num|
    puts num
  end
end

p test