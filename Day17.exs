

defmodule Cannon do

    def parse(input) do
        range = Regex.named_captures(~r/x=(?<x1>\d+)..(?<x2>\d+), y=(?<y1>[-]*\d+)..(?<y2>[-]*\d+)/, input)
        {_cv, range} = Map.get_and_update(range, "x1", fn c_v -> {c_v, String.to_integer(c_v)} end)
        {_cv, range} = Map.get_and_update(range, "x2", fn c_v -> {c_v, String.to_integer(c_v)} end)
        {_cv, range} = Map.get_and_update(range, "y1", fn c_v -> {c_v, String.to_integer(c_v)} end)
        {_cv, range} = Map.get_and_update(range, "y2", fn c_v -> {c_v, String.to_integer(c_v)} end)
        range
    end



    def in_range(x, y, range) do
        (x > Map.get(range, "x1") and x < Map.get(range, "x2")) and (y > Map.get(range, "y1") and y < Map.get(range, "y2"))
    end

    def s_range(x, y, range) do
        x > range.x2 or y < range.y1
    end

    # def step (x, y, v_x, v_y, max_y) do
    #     x = x + v_x
    #     y = y + v_y
    #     x_v = cond do x_v > 0 -> x_v - 1; x_v < 0 -> x_v + 1; x_v == 0 -> 0



      #  Regex.named_captures(~r/x=(?<x1>\d+)..(?<x2>\d+), y=(?<y1>[-]*\d+)..(?<y2>[-]*\d+)/, "target area: x=20..30, y=10..5")
end     

{:ok, data} = File.read("inputs/Day17s.txt")
data = String.replace(data,"\r\n", "")
range = Cannon.parse(data)


IO.puts(Cannon.in_range(25, -7, range))
