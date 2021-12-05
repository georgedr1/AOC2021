defmodule Parser do
    def count([head | tail], acc) do
        acc = parse(String.graphemes(head), acc)
        count(tail, acc)
    end

    def count([], acc) do
        finish(acc, "", "")
    end

    def print([head | tail]) do
        IO.puts(head)
        print(tail)
    end

    def print([]) do
    end

    def parse([head | tail], []) do
        #head = String.first(data)
        #tail = String.slice(data, 1..100)
        if tail == ["\r"] or tail == [] do
            if head == "1" do
                [1]
            else
               [-1]
            end
        else
            if head == "1" do
                [1] ++ parse(tail, [])
            else
                [-1] ++ parse(tail, [])
            end
        end
    end

    def parse([head | tail], [accHead | accTail]) do
        #head = String.first(data)
        #tail = String.slice(data, 1..100)
        if tail == ["\r"] or tail == [] do
            if head == "1" do
                [accHead + 1]
            else
                [accHead - 1]
            end
        else
            if head == "1" do
                [accHead + 1] ++ parse(tail, accTail)
            else                
                [accHead - 1] ++ parse(tail, accTail)
            end
        end
    end



    def finish([head | tail], g, e) do
        cond do
            head > 0 ->
                g1 = g <> "1"
                e1 = e <> "0"
                finish(tail, g1, e1)
            true ->
                g1 = g <> "0"
                e1 = e <> "1"
                finish(tail, g1, e1)
        end
        
       
    end

    def finish([], g, e) do
        {String.to_integer(g, 2), String.to_integer(e, 2)}
    end
end

defmodule Parser2 do
    def most(array, place) do
        keep = common(array, place, 0, 1)      
        arr = trim(array, place, keep)
        if length(arr) > 1 do
            most(arr, place + 1)
        else
            [head | _] = arr
            head
        end
    end

    def least(array, place) do
        remove = common(array, place, 0, 1)
        keep = if remove == "1", do: "0", else: "1"
        arr = trim(array, place, keep)
        if length(arr) > 1 do
            least(arr, place + 1)
        else
            [head | _] = arr
            head
        end
    end

    def common([head | tail], place, count, bias) do
        if String.at(head, place) == "1" do
            common(tail, place, count + 1, bias)
        else
            common(tail, place, count - 1, bias)
        end
    end

    def common([], _, count, bias) do
        if count + bias > 0 do
            "1"
        else
            "0"
        end
    end

    def trim([head | tail], place, keep) do
        if String.at(head, place) == keep do
            [head] ++ trim(tail, place, keep)
        else
            trim(tail, place, keep)
        end
    end

    def trim([], _, _) do
        []
    end

end



{:ok, data} = File.read("inputs/Day3.txt")
#array = String.split("00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010","\n")
String.replace(data, "\r", "")
array = String.split(data,"\n")



{g, e} = Parser.count(array, [])
IO.puts(g)
IO.puts(e)
IO.puts(g*e)

oxy = Parser2.most(array, 0)
carbon = Parser2.least(array, 0)

oxy = String.to_integer(String.trim_trailing(oxy),2)
carbon = String.to_integer(String.trim_trailing(carbon),2)
IO.puts(oxy*carbon)