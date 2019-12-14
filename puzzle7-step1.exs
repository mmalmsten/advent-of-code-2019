defmodule Puzzle do

	def start do
		{:ok, data} = File.read("/Users/madde/Sites/advent-of-code-2019/input/puzzle5.txt")
		program = init_data(%{}, 0, String.split(data, ","))
		run(program, 0)
	end

	def init_data(map, _, []) do map end
	def init_data(map, x, [h|t]) do
		init_data(Map.put(map, x, String.to_integer(h)), x + 1, t)
	end

	def run(_, :done) do :ok end
	def run(program, n) do
		instruction = plot_optcode(Integer.to_string(Map.get(program, n)))
		case instruction do

			# Exit
			<<_::binary-size(3),"99">> -> run(program, :done)

            # Adds together numbers read from two positions and stores the result in a third position
			<<_::binary-size(1),p2::binary-size(1),p1::binary-size(1),_::binary-size(1),"1">> -> 
				program1 = Map.put(program, Map.get(program, n + 3), 
					mode(program, p1, n + 1) + mode(program, p2, n + 2))
				run(program1, n + 4)

            # Works exactly like opcode 1, except it multiplies the two inputs instead of adding them
			<<_::binary-size(1),p2::binary-size(1),p1::binary-size(1),_::binary-size(1),"2">> -> 
				program1 = Map.put(program, Map.get(program, n + 3), 
					mode(program, p1, n + 1) * mode(program, p2, n + 2))
				run(program1, n + 4)

			# Takes a single integer as input and saves it to the position given by its only parameter
			<<_::binary-size(4),"3">> -> 
				input = 5
				program1 = Map.put(program, Map.get(program, n + 3), input)
				run(program1, n + 2)

			# Outputs the value of its only parameter
			<<_::binary-size(2),p1::binary-size(1),_::binary-size(1),"4">> -> 
				IO.puts(mode(program, p1, n + 1))
				run(program, n + 2)

			# If the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
			<<_::binary-size(1),p2::binary-size(1),p1::binary-size(1),_::binary-size(1),"5">> -> 
				case mode(program, p1, n + 1) do
					0 -> run(program, n + 3)
					_ -> run(program, mode(program, p2, n + 2))
				end

			# If the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
			<<_::binary-size(1),p2::binary-size(1),p1::binary-size(1),_::binary-size(1),"6">> -> 
				case mode(program, p1, n + 1) do
					0 -> run(program, mode(program, p2, n + 2))
					_ -> run(program, n + 3)
				end

			# If the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
			<<_::binary-size(1),p2::binary-size(1),p1::binary-size(1),_::binary-size(1),"7">> -> 
				program1 = case mode(program, p1, n + 1) < mode(program, p2, n + 2) do
					true -> Map.put(program, Map.get(program, n + 3), 1)
					false -> Map.put(program, Map.get(program, n + 3), 0)
				end
				run(program1, n + 4)


			# If the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
			<<_::binary-size(1),p2::binary-size(1),p1::binary-size(1),_::binary-size(1),"8">> -> 
				program1 = case mode(program, p1, n + 1) == mode(program, p2, n + 2) do
					true -> Map.put(program, Map.get(program, n + 3), 1)
					false -> Map.put(program, Map.get(program, n + 3), 0)
				end
				run(program1, n + 4)

		end
	end

	def plot_optcode(code) do 
		case String.length(code) do
			l when l == 5 -> code
			l when l < 5 -> plot_optcode(<<"0",code::binary>>)
		end
	end

	def mode(program, "1", pos) do Map.get(program, pos) end
	def mode(program, "0", pos) do mode(program, "1", Map.get(program, pos)) end

end