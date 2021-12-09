
defmodule Display do

    def count_knowns([head | tail]) do
        data = String.split(head, " | ")
        numbers = String.split(Enum.at(data, 1), " ")
        count = check_knowns(numbers)
        count + count_knowns(tail)
    end

    def count_knowns([]) do
        0
    end

    def check_knowns([head | tail]) do
        cond do
            String.length(head) == 2 -> # one
                check_knowns(tail) + 1
            String.length(head) == 3 -> # seven
                check_knowns(tail) + 1
            String.length(head) == 4 -> # four
                check_knowns(tail) + 1
            String.length(head) == 7 -> # eight
                check_knowns(tail) + 1
            true ->
                check_knowns(tail)
        end
    end

    def check_knowns([]) do
        0
    end

    def sum_outputs([head | tail]) do
        data = String.split(head, " | ")
        cipher = String.split(Enum.at(data, 0), " ")
        output = String.split(Enum.at(data, 1), " ")

        decode(output, cipher, 1000) + sum_outputs(tail)
    end

    def sum_outputs([]) do
        0
    end

    def decode([head | tail], cipher, place) do
        cond do
            String.length(head) == 2 -> # one
                decode(tail, cipher, place/10) + (1 * place)
            String.length(head) == 3 -> # seven
                decode(tail, cipher, place/10) + (7 * place)
            String.length(head) == 4 -> # four
                decode(tail, cipher, place/10) + (4 * place)
            String.length(head) == 7 -> # eight
                decode(tail, cipher, place/10) + (8 * place)
            String.length(head) == 5 -> # two, three, five
                cond do
                    contains(head, 1, cipher) -> # three
                        decode(tail, cipher, place/10) + (3 * place)
                    has_x_in_common(head, 4, 3, cipher) -> # five
                        decode(tail, cipher, place/10) + (5 * place)
                    true -> # two
                        decode(tail, cipher, place/10) + (2 * place)
                end                
            String.length(head) == 6 -> # zero, six, nine
                cond do
                    contains(head, 4, cipher) -> # nine
                        decode(tail, cipher, place/10) + (9 * place)
                    contains(head, 7, cipher) -> # zero
                        decode(tail, cipher, place/10)
                    true -> # six
                        decode(tail, cipher, place/10) + (6 * place)
                end
        end
    end

    def decode([], _cipher, _place) do
        0
    end

    def contains(string, num, cipher) do
        num = get_num(cipher, num)
        contains(string, num)
    end

    def contains(string, num) do
        cond do
            num == "" ->
                true
            String.contains?(string, String.at(num, 0)) ->
                contains(string, String.replace(num, String.at(num,0), ""))
            true ->
                false
        end
    end

    def has_x_in_common(string, num, x, cipher) do
        num = get_num(cipher, num)
        has_x(string, num, x, 0)
    end

    def has_x(string, num, count, acc) do
        cond do
            count == acc ->
                true
            num == "" ->
                false
            String.contains?(string, String.at(num, 0)) ->
                has_x(string, String.replace(num, String.at(num,0), ""), count, acc + 1)
            true ->
                has_x(string, String.replace(num, String.at(num,0), ""), count, acc)
        end
    end

    def get_num([head | tail], num) do
        case num do
            1 ->
                if String.length(head) == 2 do
                    head
                else
                    get_num(tail, num)
                end
            4 ->
                if String.length(head) == 4 do
                    head
                else
                    get_num(tail, num)
                end
            7 ->
                if String.length(head) == 3 do
                    head
                else
                    get_num(tail, num)
                end
            8 ->
                if String.length(head) == 7 do
                    head
                else
                    get_num(tail, num)
                end
            true ->
                IO.puts("not defined")
        end
    end


        



end



{:ok, data} = File.read("inputs/Day8.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")


IO.puts(Display.count_knowns(data)) 
IO.puts(Display.sum_outputs(data))