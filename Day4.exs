defmodule Bingo do

    def format_boards([board | rest]) do
        board = String.replace(board, "\n", " ")
        board = String.replace(board, "  ", " ")
        board = String.split(board, " ")
        #print(board)
        #IO.puts("------------------")
        [board] ++ format_boards(rest)
    end

    def format_boards([]) do
        []
    end

    def print([head | tail]) do
        IO.puts(head)
        print(tail)
    end
    
    def print([]) do
    end

    def print_board([board | rest]) do
        print(board)
        IO.puts("---------------")
        print_board(rest)
    end

    def print_board([]) do
    end

    def play_to_win([call | toCall], boards) do
        
        IO.puts(call)
        #IO.puts("+++++++++++++++++++++++++")
      
        {score, boards} = mark_boards(boards, call, [], 0)
        if score > 0 do
            score
        else
            #print_board(boards)
            play_to_win(toCall, boards)
        end
    end

    def play_to_win([], _) do
        "ya goofed"
    end

    def play_to_lose([call | toCall], boards) do
        IO.puts(call)

        {score, boards} = mark_boards(boards, call, [], 0)
        if boards == [] do
            score
        else
            #print_board(boards)
            play_to_lose(toCall, boards)
        end
    end

    def play_to_lose([], _) do
        "ya goofed"
    end

    def mark_boards([board | rest], call, prev, score) do
        pos = Enum.find_index(board, fn x -> x == call end)
        if pos != nil do
            board = List.replace_at(board, pos, "O")
            this_score = check_board(board, pos, call)
            if this_score > 0 do
                mark_boards(rest, call, prev, this_score)
            else
                mark_boards(rest, call, [board | prev], score)
            end
        else
            mark_boards(rest, call, [board | prev], score)
        end
    end

    def mark_boards([], _, boards, score) do
        {score, boards}
    end

    def check_board(board, pos, call) do
        score = 0
        # check diag right, which don't count
        # score = if rem(pos, 6) == 0 do
        #     if Enum.at(board, 0) == "O" && Enum.at(board, 6) == "O"  && Enum.at(board, 12) == "O" && Enum.at(board, 18) == "O" && Enum.at(board, 24) == "O" do
        #         print(board)
        #         score_board(board, call, 0)
        #     else
        #         score
        #     end
        # else
        #     score
        # end

        # check diag left, which don't count
        # score = if score == 0 && rem(pos, 4) == 0 do
        #     if Enum.at(board, 4) == "O" && Enum.at(board, 8) == "O"  && Enum.at(board, 12) == "O" && Enum.at(board, 16) == "O" && Enum.at(board, 20) == "O" do
        #         print(board)
        #         score_board(board, call, 0)
        #     else
        #         score
        #     end
        # else
        #     score
        # end
        
        # check column
        col = rem(pos, 5)
        score = if Enum.at(board, col) == "O" && Enum.at(board, col + 5) == "O"  && Enum.at(board, col + 10) == "O" && Enum.at(board, col + 15) == "O" && Enum.at(board, col + 20) == "O" do
            #print(board)
            score_board(board, call, 0)
        else
            score
        end

        # check row
        row = Integer.floor_div(pos, 5) * 5
        score = if Enum.at(board, row) == "O" && Enum.at(board, row + 1) == "O"  && Enum.at(board, row + 2) == "O" && Enum.at(board, row + 3) == "O" && Enum.at(board, row + 4) == "O" do
            #print(board)
            score_board(board, call, 0)
        else
            score
        end

        score
    end


    def score_board([head | tail], call, acc) do
        if head != "O" && head != "" do
            score_board(tail, call, acc + String.to_integer(head))
        else
            score_board(tail, call, acc)
        end
    end

    def score_board([], call, acc) do
        String.to_integer(call) * acc
    end


end










{:ok, data} = File.read("inputs/Day4.txt")
data = String.replace(data, "\r", "")
[calls | boards] = String.split(data,"\n\n", parts: 2)
calls = String.split(calls, ",")
boards = String.split(Enum.at(boards,0), "\n\n")
boards = Bingo.format_boards(boards)

IO.puts(Bingo.play_to_win(calls, boards))
IO.puts(Bingo.play_to_lose(calls, boards))