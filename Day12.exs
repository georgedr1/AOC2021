

defmodule Cave do

    def parse([head | tail], map) do
        pair = String.split(head, "-")
        {_cv, map} = Map.get_and_update(map, Enum.at(pair, 0), fn c_v -> if c_v == nil, do: {c_v, [Enum.at(pair,1)]}, else: {c_v, [Enum.at(pair,1) | c_v]} end)
        {_cv, map} = Map.get_and_update(map, Enum.at(pair, 1), fn c_v -> if c_v == nil, do: {c_v, [Enum.at(pair,0)]}, else: {c_v, [Enum.at(pair,0) | c_v]} end)
        parse(tail, map)
    end

    def parse([], map) do
        map
    end

    def find_paths(map, at, visited) do
        branches = Map.get(map, at)
        explore_branches(branches, map, visited)
    end

    def explore_branches([head | tail], map, visited) do
        case head do
            "end" ->
                1 + explore_branches(tail, map, visited)
            "start" ->
                0 + explore_branches(tail, map, visited)
            _ ->
                if MapSet.member?(visited, head) do
                    0 + explore_branches(tail, map, visited)
                else
                    if String.downcase(head) == head do 
                        find_paths(map, head, MapSet.put(visited, head)) + explore_branches(tail, map, visited)
                    else
                        find_paths(map, head, visited) + explore_branches(tail, map, visited)
                    end
                end
        end
    end

    def explore_branches([], _map, _visited) do
        0
    end

    def find_paths2(map, at, visited, twiced) do
        branches = Map.get(map, at)
        explore_branches2(branches, map, visited, twiced)
    end

    def explore_branches2([head | tail], map, visited, twiced) do
        case head do
            "end" ->
                1 + explore_branches2(tail, map, visited, twiced)
            "start" ->
                0 + explore_branches2(tail, map, visited, twiced)
            _ ->
                val = Map.get(visited, head)
                case val do
                    2 ->
                        0 + explore_branches2(tail, map, visited, twiced)
                    1 ->
                        if twiced do
                            0 + explore_branches2(tail, map, visited, twiced)
                        else
                            find_paths2(map, head, Map.put(visited, head, 2), true) + explore_branches2(tail, map, visited, twiced)
                        end
                    nil ->
                        if String.downcase(head) == head do 
                            find_paths2(map, head, Map.put(visited, head, 1), twiced) + explore_branches2(tail, map, visited, twiced)
                        else
                            find_paths2(map, head, visited, twiced) + explore_branches2(tail, map, visited, twiced)
                        end
                end
        end
    end

    def explore_branches2([], _map, _visited, _) do
        0
    end

    def print_trace([head | tail]) do
        IO.puts(head)
        print_trace(tail)
    end

    def print_trace([]) do
        IO.puts("\n")
    end



end





{:ok, data} = File.read("inputs/Day12.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")

map = Cave.parse(data, %{})
IO.puts(Cave.find_paths(map, "start", MapSet.new()))
IO.puts(Cave.find_paths2(map, "start", %{}, false))