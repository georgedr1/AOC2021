
defmodule Cavefloor do


    def parse([head | tail], map, row) do

        head = String.split(head, "")
        map = numerize(head, map, row, 0)
        parse(tail, map, row + 1)
    end

    def parse([], map, _row) do
        map
    end

    def numerize([head | tail], map, row, col) do
        if head != "" do
            map = Map.put(map, {row,col}, String.to_integer(head))
            numerize(tail, map, row, col + 1)
        else
            numerize(tail, map, row, col)
        end
    end

    def numerize([], map, _row, _col) do
        map
    end

    def find_lows(map, row, col, new_row) do
        to_check = Map.get(map, {row,col})
        if to_check != nil do
            if check_if_low(map, to_check, row, col) do
                
                [{row,col} | find_lows(map, row, col + 1, false)]
            else
                find_lows(map, row, col + 1, false)
            end
        else
            if new_row do
                []
            else
                find_lows(map, row + 1, 0, true)
            end
        end
    end

    def check_if_low(map, this, row, col) do
        above = Map.get(map, {row - 1,col})
        if above == nil || above > this do
            left = Map.get(map, {row,col - 1})
            if left == nil || left > this do
                right = Map.get(map, {row,col+1})
                if right == nil || right > this do
                    below = Map.get(map, {row + 1, col})
                    if below == nil || below > this do
                        true
                    else
                        false
                    end
                else
                    false
                end
            else 
                false
            end
        else
            false
        end
    end

    def score_lows([head | tail], map) do
        Map.get(map, head) + 1 + score_lows(tail, map)
    end

    def score_lows([], _map) do
        0
    end

    def find_basins([head | tail], map) do
        {row, col} = head
        basin = %{}
        basin = explore_basin(map, basin, row, col)
        size = map_size(basin)
        [size | find_basins(tail, map)]
    end    

    def find_basins([], _map) do
        []
    end

    def explore_basin(map, basin, row, col) do
        if Map.has_key?(basin, {row, col}) do
            basin
        else
            this = Map.get(map, {row,col})
            if this != nil && this != 9 do
                basin = Map.put(basin, {row, col}, true)
                basin = explore_basin(map, basin, row - 1, col) #up
                basin = explore_basin(map, basin, row + 1, col) #down
                basin = explore_basin(map, basin, row, col - 1) #left
                explore_basin(map, basin, row, col + 1) #right
            else
                basin
            end
        end
    end


    def mult_3_basins([head | tail], num) do
        if num == 3 do
            1
        else
            head * mult_3_basins(tail, num + 1)
        end
    end

end


{:ok, data} = File.read("inputs/Day9.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")

map = Cavefloor.parse(data, %{}, 0)

lows = Cavefloor.find_lows(map, 0, 0, true)
score = Cavefloor.score_lows(lows, map)
IO.puts(score)

basins = Cavefloor.find_basins(lows, map)
basins = Enum.sort(basins, &(&1 >= &2))
ans = Cavefloor.mult_3_basins(basins, 0)
IO.puts(ans)