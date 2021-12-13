
defmodule Parser do

    def parse_chunks([head | tail], score) do
        {good, illegal_char, _rest} = scan_line(head, "")
        if good do
            parse_chunks(tail, score)
        else
            #IO.puts(illegal_char)
            parse_chunks(tail, score + score(illegal_char))
        end
    end

    def parse_chunks([], score) do
        score
    end
    
    def complete_chunks([head | tail], score) do
        {good, illegal_char, _rest} = scan_line(head, "")
        if good do
            score += complete_line(head, "", 0)
            complete_chunks(tail, score)
        else
            #IO.puts(illegal_char)
            complete_chunks(tail, score)
        end
    end

    def complete_chunks([], score) do
        score
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

    def score(char) do
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

    def complete_line(line, chunk_start, score) do
        if line == nil do
            {score, nil}
        else
            {char, rest} = String.split_at(line, 1)

            case char do
                n when n in ["(", "[", "{", "<"] ->
                    {score, rest} = complete_line(rest, char, score)
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
                    case chunk_start do
                        "(" ->
                            score * 5 + 1
                        "[" ->
                            score * 5 + 2
                        "{" ->
                            score * 5 + 3
                        "<" ->
                            score * 5 + 4
                _ ->
                    IO.puts("oopsies")
            end
        end
    end


end







{:ok, data} = File.read("inputs/Day10.txt")
data = String.replace(data,"\r", "")
data = String.split(data, "\n")

IO.puts(Parser.parse_chunks(data, 0))