defmodule Solution do
  def count_increases(filename) do
    filename
    |> read_depths
    |> do_count_increases
  end

  def count_window_increases(filename, window_size) do
    depths = read_depths(filename)

    0..(window_size-1)
    |> Enum.map(fn i -> Stream.drop(depths, i) end)
    |> Enum.zip
    |> Enum.map(&Tuple.sum/1)
    |> do_count_increases

  end

  def read_depths(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def do_count_increases(depths) do
    depths
    |> Enum.reduce({2147483647, 0}, &process_depth/2) # Start depth is big enough, whatever.
  end

  # Only increment acc if depth > prev_depth.
  def process_depth(depth, {prev_depth, acc}) when depth > prev_depth do
    {depth, acc+1}
  end
  def process_depth(depth, {_, acc}), do: {depth, acc}

end



# 1, 3, 4, 2, 6, 9
#    1, 3, 4, 2, 6, 9
#       1, 3, 4, 2, 6, 9
