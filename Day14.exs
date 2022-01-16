
defmodule Polymer do

    def parse_input([head | tail], map) do
        {head, parse_blank(tail, map)}
    end

    def parse_blank([_head | tail], map) do
        parse_rules(tail, map) 
    end

    def parse_rules([head | tail], map) do
        rule = Regex.named_captures(~r/(?<input>[[:upper:]]+) -> (?<result>[[:upper:]])/, head)
        input = Map.get(rule, "input")
        result = Map.get(rule, "result")

        map = Map.put(map, input, result)
        parse_rules(tail, map)        
    end

    def parse_rules([], map) do
        map
    end

    def polymerize([head | tail], rules, element_counts, steps) do
        if tail == [] do
            {_, element_counts} = Map.get_and_update(element_counts, head, fn c_v -> {c_v, c_v + 1} end)
            element_counts
        else
            [next | _] = tail
            pair = head <> next
            element_counts = polymerize_pair(pair, rules, element_counts, steps)
            polymerize(tail, rules, element_counts, steps)
        end
    end

    def polymerize_pair(pair, rules, element_counts, steps_left) do
        
        left = String.at(pair, 0)
        right = String.at(pair, 1)
        if steps_left == 0 do
            #IO.puts(pair)
            element_counts = Map.put_new(element_counts, left, 0)
            element_counts = Map.put_new(element_counts, right, 0)
            {_, element_counts} = Map.get_and_update(element_counts, left, fn c_v -> {c_v, c_v + 1} end)
            # {_, element_counts} = Map.get_and_update(element_counts, right, fn c_v -> {c_v, c_v + 1} end)
            element_counts
        else
            insert = Map.get(rules, pair)
            element_counts = polymerize_pair(left <> insert, rules, element_counts, steps_left - 1)
            element_counts = polymerize_pair(insert <> right, rules, element_counts, steps_left - 1)
            element_counts
        end
    end

end

{:ok, data} = File.read("inputs/Day14.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")
{start, rules} = Polymer.parse_input(data, %{})

start = String.graphemes(start)
counts_one = Polymer.polymerize(start, rules, %{}, 10)
counts_one = Map.values(counts_one)
max = Enum.max(counts_one)
min = Enum.min(counts_one)

IO.puts(max - min)

counts_two = Polymer.polymerize(start, rules, %{}, 40)
counts_two = Map.values(counts_two)
max = Enum.max(counts_two)
min = Enum.min(counts_two)

IO.puts(max - min)