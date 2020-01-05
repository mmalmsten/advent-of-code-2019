# ----------------------------------------------------------------------
# Run using the following commands
# c("puzzle2-step1.exs")
# Puzzle.start
# ----------------------------------------------------------------------

defmodule Puzzle do
	def start do
		data = read_data()
		{has_two, has_three} = eval(data, 0, 0)
		IO.puts has_two * has_three
	end

	# ------------------------------------------------------------------
	# Read data from file
	# ------------------------------------------------------------------
	def read_data do
		{:ok, f} = File.read("puzzle2.txt")
		String.split(f, "\n")
	end

	# ------------------------------------------------------------------
	# Evaluate each box ID, sum results into has_two and has_three
	# ------------------------------------------------------------------
	def eval([], has_two, has_three) do {has_two, has_three} end
	def eval([h|t], has_two, has_three) do
		count = plot_count(h, %{})
		has_two1 = has_two + has(count, 2)
		has_three1 = has_three + has(count, 3)
		eval(t, has_two1, has_three1)
	end

	# ------------------------------------------------------------------
	# Check if a map contains the value n
	# ------------------------------------------------------------------
	def has(count, n) do 
		case Enum.member?(count, n) do
			true -> 1
			_ -> 0
		end
	end

	# ------------------------------------------------------------------
	# Plot string into a map containing info about how may time each
	# character is repeated
	# ------------------------------------------------------------------
	def plot_count("", count) do Map.values(count) end
	def plot_count(string, count) do
		{char, string1} = String.split_at(string, 1)
		Map.has_key?(count, char)
		count1 = case count[char] do
			nil -> Map.put(count, char, 1)
			val -> Map.put(count, char, val + 1)
		end
		plot_count(string1, count1)
	end

end
