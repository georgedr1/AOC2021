
t1 = :erlang.timestamp()
defmodule Count do
    def increase([head | tail], prev, acc) do
        a = String.to_integer(head)
        if a > prev do
            increase(tail, a, acc+1)
        else
            increase(tail, a, acc)
        end
    end

    def increase([], _, acc) do
        acc
    end

    def increase3([head | tail], a, b, c, acc) do
        d = String.to_integer(head)
        cond do
            c > 0 ->
                if a + b + c < b + c + d do
                    increase3(tail, b, c, d, acc + 1)
                else
                    increase3(tail, b, c, d, acc)
                end
            b > 0 ->
                increase3(tail, a, b, d, acc)
            a > 0 ->
                increase3(tail, a, d, 0, acc)
            true ->
                increase3(tail, d, 0, 0, acc)
        end
    end

    def increase3([], _, _, _, acc) do
        acc
    end
end



{:ok, data} = File.read("inputs/Day1.txt")
array = String.split(data)

IO.puts(Count.increase(array, 1000, 0))
IO.puts(Count.increase3(array, 0, 0, 0, 0))

t2 = :erlang.timestamp()
IO.puts(Float.to_string(:timer.now_diff(t2, t1)/1000) <> " ms")

    
