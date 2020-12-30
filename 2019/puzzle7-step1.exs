# ----------------------------------------------------------------------
# Not working yet...
# ----------------------------------------------------------------------

defmodule Puzzle do

# ----------------------------------------------------------------------
# Start loop/2 in new process. Start run/2
# ----------------------------------------------------------------------
	def start do
		Application.ensure_all_started(:inets)
		Application.ensure_all_started(:ssl)
		pid = spawn fn -> loop(0) end
		run(pid, 0)
	end

# ----------------------------------------------------------------------
# Receive all final output signals from amplifier E's. Update result if
# a higher output signal is received. Return result when all output
# signals are received
# ----------------------------------------------------------------------
	def loop(result, 50000) do result end
	def loop(result, n) do
		receive do
			{:ok, response} -> 
				IO.puts(response)
				case response > result do
					true -> loop(response, n + 1)
					_ -> loop(result, n + 1)
				end
		end
	end

# ----------------------------------------------------------------------
# Loop possible phase setting sequences
# ----------------------------------------------------------------------
	def run(_, 50000) do :ok end
	def run(pid, n) do 
		list = String.splitter(String.pad_leading(
			to_string(n), 5, "0"), "", trim: true) |> Enum.take(5)
		run(pid, list, 0)
		run(pid, n + 1)
	end

# ----------------------------------------------------------------------
# Run phase setting sequence. Send the final output signal from 
# amplifier E to loop/2
# ----------------------------------------------------------------------
	def run(pid, [], response) do send(pid, {:ok, response}) end
	def run(pid, [h|t], input) do 
		{:ok, {{'HTTP/1.1', 200, 'OK'}, _, response}} =
			:httpc.request(:get, 
				{'http://localhost:3000/7/#{h}-#{input}', []}, [], [])
		run(pid, t, response)
	end

end