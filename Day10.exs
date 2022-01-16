
defmodule Parser do

    def parse_chunks([head | tail], score, good_list) do
        {good, illegal_char, _rest} = scan_line(head, "")
        if good do
            parse_chunks(tail, score, [head | good_list])
        else
            #IO.puts(illegal_char)
            parse_chunks(tail, score + score_bad(illegal_char), good_list)
        end
    end

    def parse_chunks([], score, good_list) do
        {score, good_list}
    end
    
    def complete_chunks([head | tail], scores) do
        {score, _rest, _closed} = complete_line(head, 0)
        complete_chunks(tail, [score | scores])
    end

    def complete_chunks([], scores) do
        scores = Enum.sort(scores)
        len = length(scores)
        mid = div(len, 2)
        Enum.at(scores, mid)
    end

    def scan_line(line, chunk_start) do
        if line == nil do
            {true, nil, nil}
        else
            {char, rest} = String.split_at(line, 1)

            case char do
                n when n in ["(", "[", "{", "<"] ->
                    {good, illegal_char, rest} = scan_line(rest, char)
                    if good do
                        scan_line(rest, chunk_start)
                    else
                        {good, illegal_char, rest}
                    end
                ")" ->
                    if chunk_start == "(" do
                        {true, nil, rest}
                    else
                        {false, char, nil}
                    end
                "]" ->
                    if chunk_start == "[" do
                        {true, nil, rest}
                    else
                        {false, char, nil}
                    end  
                "}" ->
                    if chunk_start == "{" do
                        {true, nil, rest}
                    else
                        {false, char, nil}
                    end
                ">" ->
                    if chunk_start == "<" do
                        {true, nil, rest}
                    else
                        {false, char, nil}
                    end
                "" ->
                    {true, nil, nil}
                _ ->
                    IO.puts("oopsies")
            end
        end
    end

    def score_bad(char) do
        case char do
            ")" ->
                3
            "]" ->
                57
            "}" ->
                1197
            ">" ->
                25137
            true ->
                IO.puts("bad score")
        end
    end

    def complete_line(line, score) do
        if line == nil do
            {0, [], false}
        else
            {char, rest} = String.split_at(line, 1)

            case char do
                n when n in ["(", "[", "{", "<"] ->
                    {score, rest, closed} = complete_line(rest, score)
                    if closed do
                        complete_line(rest, score)
                    else
                        score = score_good(char, score)
                        {score, rest, closed}
                    end
                n when n in [")", "]", "}", ">"] ->
                    {0, rest, true}  
                _ ->
                    {0, [], false}
            end
        end
    end

    def score_good(char, score) do
        case char do
            "(" ->
                score * 5 + 1
            "[" ->
                score * 5 + 2
            "{" ->
                score * 5 + 3
            "<" ->
                score * 5 + 4
            true ->
                IO.puts("bad char in score")
        end
    end


end







{:ok, data} = File.read("inputs/Day10.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")
{score, good} = Parser.parse_chunks(data, 0, [])
IO.puts(score)

IO.puts(Parser.complete_chunks(good, []))