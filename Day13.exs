

defmodule Manual do

    def parse([head | tail], points) do
        cond do
            String.contains?(head, ",") ->
                pt = String.split(head, ",")
                x = String.to_integer(Enum.at(pt,0))
                y = String.to_integer(Enum.at(pt,1))
                points = add_point(points, x, y)
                
                parse(tail, points)
            String.contains?(head, "fold") ->
                {points, parse_folds([head | tail])}
            true ->
                parse(tail, points)
        end
    end

    def parse_folds([head | tail]) do
        head = String.split(head, " ")
        [Enum.at(head, 2) | parse_folds(tail)]
    end
         
    def parse_folds([]) do
        []
    end

    def fold_all([head | tail], points) do
        points = fold(head, points)
        fold_all(tail, points)
    end

    def fold_all([], points) do
        points
    end

    def fold(fold, points) do
        fold = String.split(fold, "=")
        val = String.to_integer(Enum.at(fold, 1))
        if Enum.at(fold, 0) == "x" do
            fold_x(val, points)
        else
            fold_y(val, points)
        end
    end

    def fold_x(x_val, points) do
        columns = Map.keys(points)
        check_for_fold_x(columns, x_val, points)
    end

    def check_for_fold_x([head | tail], x_val, points) do
        if head > x_val do
            new = 2 * x_val - head
            {y_map, points} = Map.pop(points, head)
            y_vals = Map.keys(y_map)
            points = add_column(y_vals, new, points)
            check_for_fold_x(tail, x_val, points)
        else   
            check_for_fold_x(tail, x_val, points)
        end
    end

    def check_for_fold_x([], _x_val, points) do
        points
    end

    def fold_y(y_val, points) do
        columns = Map.keys(points)
        check_for_fold_y(columns, y_val, points)
    end

    def check_for_fold_y([x | tail], y_val, points) do
        y_map = Map.get(points, x)
        y_vals = Map.keys(y_map)
        y_map = check_column_for_fold_y(y_vals, y_val, y_map)
        points = Map.put(points, x, y_map)
        check_for_fold_y(tail, y_val, points)
    end

    def check_for_fold_y([], _y_val, points) do
        points
    end

    def check_column_for_fold_y([head | tail], y_val, y_map) do
        if head > y_val do
            new = 2 * y_val - head
            y_map = Map.delete(y_map, head)
            y_map = Map.put(y_map, new, "#")
            check_column_for_fold_y(tail, y_val, y_map)
        else
            check_column_for_fold_y(tail, y_val, y_map)
        end
    end

    def check_column_for_fold_y([], _y_val, y_map) do
        y_map
    end

    def add_column([y | y_vals], x, points) do
        add_column(y_vals, x, add_point(points, x, y))
    end

    def add_column([], _x, points) do
        points
    end

    def add_row([x | x_vals], y, points) do
        add_column(x_vals, y, add_point(points, x, y))
    end

    def add_row([], _y, points) do
        points
    end

    def add_point(map, x, y) do
        col = Map.get(map, x)
        col = if col == nil, do: %{}, else: col
        col = Map.put(col, y, "#")
        map = Map.put(map, x, col)
        map
    end

    def count_points(map) do
        x_vals = Map.keys(map)
        count_points(x_vals, map)
    end
    
    def count_points([head | tail], map) do
        y_vals = Map.keys(Map.get(map, head))
        length(y_vals) + count_points(tail, map)
    end
    
    def count_points([], _map) do
        0
    end

    def print_points(points) do
        x_vals = Map.keys(points)
        x_max = Enum.max(x_vals)
        y_max = Enum.max(y_max(x_vals, points))
        loop(points, Enum.to_list(0..x_max), y_max)
    end
    
    def y_max([head | tail], points) do
        y_vals = Map.keys(Map.get(points, head))
        y_max = Enum.max(y_vals)
        [y_max | y_max(tail, points)]
    end

    def y_max([], _points) do
        []
    end

    def loop(points, [x | rest], y_max) do
        y_map = Map.get(points, x)
        y_map = if y_map == nil, do: %{}, else: y_map
        y_map = loop_slice(y_map, Enum.to_list(0..y_max))
        Map.put(points, x, y_map)
        IO.write("\n")
        loop(points, rest, y_max)
    end
    
    def loop(points, [], _y_max) do
        points
    end

    def loop_slice(y_map, [y | rest]) do
        y_map = Map.put_new(y_map, y, ".")
        IO.write(Map.get(y_map, y))
        loop_slice(y_map, rest)
    end
    
    def loop_slice(y_map, []) do
        y_map
    end
        
        

end



{:ok, data} = File.read("inputs/Day13.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")

{points, folds} = Manual.parse(data, %{})


one_fold = Manual.fold(Enum.at(folds, 0), points)
IO.puts(Manual.count_points(one_fold))

points = Manual.fold_all(folds, points)
IO.puts(Manual.count_points(points))

Manual.print_points(points)