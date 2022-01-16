
defmodule Chiton do

    defstruct visited: false, cost: 0, path_cost: 0


    def parse_input([head | tail]) do
        line = String.split(head, "")
        line = numerize(line)
        [line | parse_input(tail)]
    end

    def parse_input([]) do
        []
    end

    def numerize([head | tail]) do
        if head != "" do
            [%Chiton{cost: String.to_integer(head)} | numerize(tail)]
        else
            numerize(tail)
        end
    end

    def numerize([]) do
        []
    end

    def populate_empty_data(length, col) do
        if length = 0 do
            []
        else 
            [col | populate_empty_data(length-1)]
        end
    end

    def make_empty_col(length) do
        if length = 0 do
            []
        else 
            [0 | make_empty_col(length-1)]
        end
    end


    def print_board([head | tail]) do
        print_line(head)
        print_board(tail)
    end

    def print_board([]) do
        IO.puts("\n")
    end

    def print_line([head | tail]) do
        IO.write(Integer.to_string(head.cost))
        print_line(tail)
    end

    def print_line([]) do
        IO.write("\n")
    end

    def find_path(data, path_data, iter, max_iter, length) do
        if iter >= max_iter do
            hd(hd(path_data))
        end
    end
          
    def lazy_find_path(data, loc, prev, acc, len) do
        if loc == {len-1, len-1} do
            acc
        else 
            {x, y} = loc
            acc = acc + Enum.get(Enum.get(data, y), x)
        end
    end




end



{:ok, data} = File.read("inputs/Day15s.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")
data = Chiton.parse_input(data)

l = length(data)

# max_iter = 2 * l
# empty_col = ChitonPath.make_empty_col(l)
# empty_data = ChitonPath.populate_empty_data(l, empty_col)

Chiton.print_board(data)