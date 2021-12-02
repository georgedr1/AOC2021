

defmodule SubPath do
    def parseInstruction([head | tail], depth, pos) do
        if String.length(head)>1 do
            [dir | dist] = String.split(head)
            [dist | _] = dist
            dist = String.to_integer(dist)
            case {dir} do
                {"forward"} ->
                    parseInstruction(tail, depth, pos + dist)
                {"down"} ->
                    parseInstruction(tail, depth + dist, pos)
                {"up"} ->
                    parseInstruction(tail, depth - dist, pos)
            end
        else
             parseInstruction(tail, depth, pos)
        end
    end

    def parseInstruction([], depth, pos) do
        depth * pos
    end
end

defmodule SubAimPath do
    def parseInstruction([head | tail], depth, pos, aim) do
        if String.length(head)>1 do
            [dir | dist] = String.split(head)
            [dist | _] = dist
            dist = String.to_integer(dist)
            case {dir} do
                {"forward"} ->
                    parseInstruction(tail, depth + (aim * dist), pos + dist, aim)
                {"down"} ->
                    parseInstruction(tail, depth, pos, aim + dist)
                {"up"} ->
                    parseInstruction(tail, depth, pos, aim - dist)
            end
        else
             parseInstruction(tail, depth, pos, aim)
        end
    end

    def parseInstruction([], depth, pos, _) do
        depth * pos
    end
end



{:ok, data} = File.read("inputs/Day2.txt")
array = String.split(data,"\n")

IO.puts(SubPath.parseInstruction(array, 0, 0))
IO.puts(SubAimPath.parseInstruction(array, 0, 0, 0))