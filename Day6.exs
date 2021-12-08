
defmodule Fish do

    def numerize([head | tail]) do
        [String.to_integer(head) | numerize(tail)]
    end

    def numerize([]) do
        []
    end

    def map([head | tail], map) do
        val = Map.get(map, head)
        val = if val == nil, do: 0, else: val
        map = Map.put(map, head, val + 1)
        map(tail, map)
    end

    def map([], map) do
        map
    end       


    def simulate_spawning([head | tail], prev, day) do
        if head == 0 do
            simulate_spawning(tail, [6, 8] ++ prev, day)
        else
            simulate_spawning(tail, [head - 1 | prev], day)
        end
    end

    def simulate_spawning([], prev, day) do
        if day == 80 do
            length(prev)
        else
            simulate_spawning(prev, [], day + 1)
        end
    end

    def better_simulate_spawning(fish_map, day, goal) do
        if day == goal do
            fish = Map.values(fish_map)
            sum(fish)
        else
            new_map = sim_day(fish_map, %{}, 8)
            better_simulate_spawning(new_map, day + 1, goal)
        end

    end

    def sim_day(map, new_map, to_update) do
        cond do
            to_update == 0 ->
                a = Map.get(map, 0)
                b = Map.get(new_map, 6)

                a = if a == nil, do: 0, else: a
                b = if b == nil, do: 0, else: b

                new_map = Map.put(new_map, 8, a)
                Map.put(new_map, 6, a + b)
            true ->
                sim_day(map, Map.put(new_map, to_update - 1, Map.get(map, to_update)), to_update - 1)
        end
    end

    def sum([head | tail]) do
        if head == nil do
            sum(tail)
        else
            head + sum(tail)
        end
    end

    def sum([]) do
        0
    end






end


defmodule Benchmark do
    def measure(function) do
      function
      |> :timer.tc
      |> elem(0)
      |> Kernel./(1_000_000)
    end
  end



{:ok, data} = File.read("inputs/Day6.txt")
data = String.replace(data,"\n", "")
fish = String.split(data,",")
fish = Fish.numerize(fish)
fish_map = Fish.map(fish, %{})

IO.puts(Fish.simulate_spawning(fish, [], 1))

{time, ans} = :timer.tc(fn -> Fish.better_simulate_spawning(fish_map, 0, 256) end)
IO.puts("answer:")
IO.puts(ans)
IO.puts("ran in:")
IO.puts(time)
