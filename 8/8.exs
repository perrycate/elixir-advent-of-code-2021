defmodule Day8 do
  def part1 do
    target_lengths = MapSet.new([2, 4, 3, 7])

    File.stream!("input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      String.split(line, " | ")
      |> Enum.drop(1)
    end)
    |> Stream.concat
    |> Stream.flat_map(&String.split(&1, " "))
    |> Stream.map(&String.length/1)
    |> Stream.filter(fn x -> MapSet.member?(target_lengths, x) end)
    |> Enum.count
  end

  def part2 do
    File.stream!("input")
    |> Stream.map(&decode_line/1)
    |> Enum.sum
  end

  def decode_line(line) do
    [digits | output] = line
                         |> String.trim
                         |> String.split(" | ")

    segs_by_num = primary_segments_by_num(digits)
    nums_by_seg = primary_nums_by_segment(digits)

    output
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(fn w -> to_number(w, segs_by_num, nums_by_seg) end)
    # Silly to convert back but I don't feel like changing existing code.
    |> Enum.map(&Integer.to_string/1) 
    |> List.to_string
    |> String.to_integer(10)
  end

  def to_number(word, primary_segments_by_num, primary_nums_by_segments) do
    segments = to_segments(word)
    case Map.get(primary_nums_by_segments, segments) do
      # Not a primary number.
      nil -> to_compound_number(segments, primary_segments_by_num, Enum.count(segments))
      # Is a primary number!
      num -> num
    end
  end

  def to_compound_number(segments, primary_segments, 5) do
    cond do
      MapSet.subset?(primary_segments[7], segments) -> 3
      MapSet.subset?(MapSet.difference(primary_segments[4], primary_segments[1]), segments) -> 5
      true -> 2
    end
  end

  def to_compound_number(segments, primary_segments, 6) do
    cond do
      !MapSet.subset?(primary_segments[1], segments) -> 6
      MapSet.subset?(MapSet.union(primary_segments[4], primary_segments[7]), segments) -> 9
      true -> 0
    end
  end

  def primary_segments_by_num(digits_str) do
    segment_sets = String.split(digits_str, " ")
                   |> Stream.map(&to_segments/1)
    %{
      1 => find_length(segment_sets, 2),
      4 => find_length(segment_sets, 4),
      7 => find_length(segment_sets, 3),
      8 => find_length(segment_sets, 7),
    }
  end

  def primary_nums_by_segment(digits_str) do
    segment_sets = String.split(digits_str, " ")
                   |> Stream.map(&to_segments/1)
    %{
      find_length(segment_sets, 2) => 1,
      find_length(segment_sets, 4) => 4,
      find_length(segment_sets, 3) => 7,
      find_length(segment_sets, 7) => 8,
    }
  end

  def find_length(words, len) do
    words |> Enum.find(fn w -> Enum.count(w) == len end)
  end

  def to_segments(word) do
    word |> String.graphemes |> MapSet.new
  end
end
