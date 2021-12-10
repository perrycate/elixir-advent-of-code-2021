defmodule Day4 do
  def part1 do
    {called_nums, boards} = parse("input")
    call_order_by_num = called_nums
                        |> Enum.with_index
                        |> Map.new

    winning_board = Enum.min_by(boards, &when_wins(&1, call_order_by_num))
    nums_called = when_wins(winning_board, call_order_by_num)

    # Calculate score.
    sum_of_uncalled_nums = winning_board
                           |> List.flatten
                           |> Enum.filter(&(call_order_by_num[&1] > nums_called))
                           |> Enum.sum

    sum_of_uncalled_nums * Enum.at(called_nums, nums_called)
  end

  def part2 do
    {called_nums, boards} = parse("input")
    call_order_by_num = called_nums
                        |> Enum.with_index
                        |> Map.new

    # The ONLY change from part1: max_by instead of min_by.
    winning_board = Enum.max_by(boards, &when_wins(&1, call_order_by_num))
    nums_called = when_wins(winning_board, call_order_by_num)

    # Calculate score.
    sum_of_uncalled_nums = winning_board
                           |> List.flatten
                           |> Enum.filter(&(call_order_by_num[&1] > nums_called))
                           |> Enum.sum

    sum_of_uncalled_nums * Enum.at(called_nums, nums_called)
  end

  def when_wins(board, call_order_by_num) do # Couldn't think of a name and felt like being silly.
    cols = Enum.zip(board)
           |> Enum.map(&Tuple.to_list/1)
    Enum.concat(board, cols)
    # When is each number called?
    |> Enum.map(&Enum.map(&1, fn n -> call_order_by_num[n] end))
    # When is the last number called in each row and column?
    |> Enum.map(&Enum.max/1)
    # When is the first row or column completed?
    |> Enum.min
  end

  def parse(filename) do
    input_stream = File.stream!(filename)
    [first_line] = input_stream |> Enum.take(1)
    call_order = first_line
                 |> String.trim
                 |> String.split(",")
                 |> Enum.map(&String.to_integer/1)

    boards = input_stream
             |> Stream.drop(2)
             |> Stream.map(&String.trim/1)
             |> Stream.map(&String.split(&1))
             |> Stream.map(fn strs -> Enum.map(strs, &String.to_integer/1) end)
             |> Enum.chunk_every(5, 6)

    {call_order, boards}
  end
end

