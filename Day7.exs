
defmodule Crab do

    def numerize([head | tail]) do
        [String.to_integer(head) | numerize(tail)]
    end

    def numerize([]) do
        []
    end

    def find_median(array) do
        array = Enum.sort(array)
        len = length(array)
        if rem(len,2) == 0 do
            (Enum.at(array, Integer.floor_div(len, 2) - 1) + Enum.at(array, Integer.floor_div(len, 2))) / 2
        else
            Enum.at(array, Integer.floor_div(len, 2))
        end
    end

    def find_mean([head | tail], sum, count) do
        find_mean(tail, head + sum, count)
    end

    def find_mean([], sum, count) do
        sum/count
    end

    def move_crabs([crab | rest], target_pos, fuel_used) do
        move_crabs(rest, target_pos, fuel_used + abs(crab - target_pos))
    end

    def move_crabs([], _, fuel_used) do
        fuel_used
    end

    def move_crabs2([crab | rest], target_pos, fuel_used) do
        move_crabs2(rest, target_pos, fuel_used + fuel_calc(abs(crab - target_pos)))
    end

    def move_crabs2([], _, fuel_used) do
        fuel_used
    end

    def fuel_calc(x) do
        if x == 0 do
            0
        else
            x + fuel_calc(x-1)
        end
    end


end








{:ok, data} = File.read("inputs/Day7.txt")
data = String.replace(data,"\n", "")
crabs = String.split(data,",")
crabs = Crab.numerize(crabs)
target = Crab.find_median(crabs)

IO.puts(Crab.move_crabs(crabs, target, 0))

target = Crab.find_mean(crabs, 0, length(crabs))

IO.puts(Crab.move_crabs2(crabs, floor(target), 0))
