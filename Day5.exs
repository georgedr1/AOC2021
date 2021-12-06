
defmodule Vents do

    def find_overlaps([line | rest], map, count) do
        {x1, x2, y1, y2} = parse_line(line)
        {new_map, new_count} = add_line(x1, x2, y1, y2, map, count)
        find_overlaps(rest, new_map, new_count)
    end

    def find_overlaps([], _, count) do
        count
    end

    def parse_line(line) do
        line = String.split(line, " -> ")

        point1 = Enum.at(line, 0)
        point2 = Enum.at(line, 1)

        point1 = String.split(point1, ",")
        x1 = String.to_integer(Enum.at(point1, 0))
        y1 = String.to_integer(Enum.at(point1, 1))

        point2 = String.split(point2, ",")
        x2 = String.to_integer(Enum.at(point2, 0))
        y2 = String.to_integer(Enum.at(point2, 1))

        {x1, x2, y1, y2}
    end

    def add_line(x1, x2, y1, y2, map, count) do
        cond do
            x1 == x2 ->
                x_map = Map.get(map, x1)
                x_map = if x_map == nil, do: %{}, else: x_map

                sign = if y1 < y2, do: 1, else: -1
                y_vals = Enum.to_list(y1..y2//sign)

                {x_map, new_count} = add_x_line(y_vals, x_map, count)
                {_, map} = Map.get_and_update(map, x1, fn current -> {current, x_map} end)
                {map, new_count}
            y1 == y2 ->
                sign = if x1 < x2, do: 1, else: -1
                x_vals = Enum.to_list(x1..x2//sign)
                add_y_line(x_vals, y1, map, count)
            true ->
                y_sign = if y1 < y2, do: 1, else: -1
                y_vals = Enum.to_list(y1..y2//y_sign)

                x_sign = if x1 < x2, do: 1, else: -1
                x_vals = Enum.to_list(x1..x2//x_sign)

                add_diag_line(x_vals, y_vals, map, count)
        end
    end

            

    def add_x_line([y | y_vals], x_map, count) do       
        {old, x_map} = Map.get_and_update(x_map, y, fn current_value -> if current_value == nil, do: {current_value, 1}, else: {current_value, current_value + 1} end)
        count = if old == 1, do: count + 1, else: count
        add_x_line(y_vals, x_map, count)
    end

    def add_x_line([], x_map, count) do
        {x_map, count}
    end

    def add_y_line([x | x_vals], y, map, count) do
        x_map = Map.get(map, x)
        if x_map == nil do
            x_map = %{y => 1}
            map = Map.put(map, x, x_map)
            add_y_line(x_vals, y, map, count)
        else
            {old, x_map} = Map.get_and_update(x_map, y, fn current_value -> if current_value == nil, do: {current_value, 1}, else: {current_value, current_value + 1} end)
            count = if old == 1, do: count + 1, else: count
            map = Map.put(map, x, x_map)
            add_y_line(x_vals, y, map, count)
        end
    end
    def add_y_line([], _y, map, count) do
        {map, count}
    end

    def add_diag_line([x | x_vals], [y | y_vals], map, count) do
        x_map = Map.get(map, x)
        if x_map == nil do
            x_map = %{y => 1}
            map = Map.put(map, x, x_map)
            add_diag_line(x_vals, y_vals, map, count)
        else
            {old, x_map} = Map.get_and_update(x_map, y, fn current_value -> if current_value == nil, do: {current_value, 1}, else: {current_value, current_value + 1} end)
            count = if old == 1, do: count + 1, else: count
            map = Map.put(map, x, x_map)
            add_diag_line(x_vals, y_vals, map, count)
        end
    end

    def add_diag_line([], [], map, count) do
        {map, count}
    end

end





{:ok, data} = File.read("inputs/Day5.txt")
data = String.replace(data, "\r", "")
lines = String.split(data,"\n")

IO.puts(Vents.find_overlaps(lines, %{}, 0))