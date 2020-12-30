file = File.open("/Users/madde/Sites/advent-of-code-2019/input/puzzle8.txt")
data = file.read
file.close

width = 25
height = 6
layer_length = width * height

fewest_zero_digits = nil
fewest_zero_digits_layer = nil

n = 0
while data.length >= layer_length * (n + 1)
	layer = data[layer_length * n, layer_length]
	zero_digits = 0
	for l in layer.split('')
		if l == "0" 
			zero_digits += 1 
		end
	end
	if fewest_zero_digits == nil || zero_digits <= fewest_zero_digits
		fewest_zero_digits_layer = layer
		fewest_zero_digits = zero_digits
	end
	n += 1
end

one_digits = 0
two_digits = 0
for l in fewest_zero_digits_layer.split('')
	if l == "1" 
		one_digits += 1
	elsif l == "2" 
		two_digits += 1
	end
end

puts one_digits * two_digits