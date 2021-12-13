defmodule Octopus do

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
            [String.to_integer(head) | numerize(tail)]
        else
            numerize(tail)
        end
    end

    def numerize([]) do
        []
    end

    def print_board([head | tail]) do
        line = Integer.to_string(Enum.at(head, 0)) <> Integer.to_string(Enum.at(head, 1)) <> Integer.to_string(Enum.at(head, 2)) <> Integer.to_string(Enum.at(head, 3)) <> Integer.to_string(Enum.at(head, 4)) <> Integer.to_string(Enum.at(head, 5)) <> Integer.to_string(Enum.at(head, 6)) <> Integer.to_string(Enum.at(head, 7)) <> Integer.to_string(Enum.at(head, 8)) <> Integer.to_string(Enum.at(head, 9))
        IO.puts(line)
        print_board(tail)
    end

    def print_board([]) do
        IO.puts("\n")
    end

    def simulate_x_steps(data, steps, complete) do
        if steps == complete do
            0
        else
            {data, flashes} = simulate_step(data)
            #print_board(data)
            flashes + simulate_x_steps(data, steps, complete + 1)
        end
    end

    def find_synchrony(data, acc) do
        {data, flashes} = simulate_step(data)
        if flashes == 100 do
            acc + 1
        else
            find_synchrony(data, acc + 1)
        end
    end

    def simulate_step(data) do
        data = sim_phase1(data)
        data = sim_phase2(data)
        sim_cleanup_phase(data)
    end

    def sim_phase1([head | tail]) do
        [sim_p1_row(head) | sim_phase1(tail)]
    end

    def sim_phase1([]) do
        []
    end

    def sim_p1_row([head | tail]) do
        [head + 1 | sim_p1_row(tail)]
    end

    def sim_p1_row([]) do
        []
    end

    def sim_phase2(data) do
        {data, flash?} = sim_phase2_helper(data, 0, 0, false)
        if flash? do
            sim_phase2(data)
        else
            data
        end
    end

    def sim_phase2_helper(data, x, y, flash?) do
        if y == 10 do
            {data, flash?}
        else
            if  Enum.at(Enum.at(data, y), x) >= 10 do
                data = flash(data, x, y)
                if x == 9 do
                    sim_phase2_helper(data, 0, y + 1, true)
                else
                    sim_phase2_helper(data, x + 1, y, true)
                end
            else
                if x == 9 do
                    sim_phase2_helper(data, 0, y + 1, flash?)
                else
                    sim_phase2_helper(data, x + 1, y, flash?)
                end
            end
        end
    end

    def flash(data, x, y) do
        row = Enum.at(data, y)
        row = List.replace_at(row, x, -1000)
        row = flash_row(row, x)
        data = List.replace_at(data, y, row)
        case y do
            0 ->
                row = Enum.at(data, y + 1)
                List.replace_at(data, y + 1, flash_row(row, x))
            9 -> 
                row = Enum.at(data, y - 1)
                List.replace_at(data, y - 1, flash_row(row, x))
            _ ->
                row = Enum.at(data, y - 1)
                data = List.replace_at(data, y - 1, flash_row(row, x))
                row = Enum.at(data, y + 1)
                List.replace_at(data, y + 1, flash_row(row, x))
        end
    end

    def flash_row(row, x) do
        row = List.replace_at(row, x, Enum.at(row, x) + 1)
        case x do
            0 ->                 
                List.replace_at(row, x + 1, Enum.at(row, x + 1) + 1)                
            9 ->
                List.replace_at(row, x - 1, Enum.at(row, x - 1) + 1)
            _ ->
                row = List.replace_at(row, x - 1, Enum.at(row, x - 1) + 1)
                List.replace_at(row, x + 1, Enum.at(row, x + 1) + 1)
        end
    end

    def sim_cleanup_phase([head | tail]) do
        {row, row_flashes} = sim_c_row(head)
        {data, flashes} = sim_cleanup_phase(tail)
        {[row | data], row_flashes + flashes}
    end

    def sim_cleanup_phase([]) do
        {[], 0}
    end

    def sim_c_row([head | tail]) do
        {row, flashes} = sim_c_row(tail)
        if head < 0 do
            {[0 | row], flashes + 1}
        else
            {[head | row], flashes}
        end
    end

    def sim_c_row([]) do
        {[], 0}
    end

end

{:ok, data} = File.read("inputs/Day11.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")

data = Octopus.parse_input(data)

IO.puts(Octopus.simulate_x_steps(data, 100, 0))
IO.puts(Octopus.find_synchrony(data, 0))