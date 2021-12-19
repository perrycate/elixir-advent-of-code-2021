defmodule Day10 do
  @pairs %{"(" => ")", "{" => "}", "[" => "]", "<" => ">"}

  def part1 do
    parse("input")
    |> Stream.map(&check_syntax(&1, []))
    |> Stream.map(fn {char, _} -> char end)
    |> Stream.map(fn
      nil -> 0
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end)
    |> Enum.sum
  end

  def part2 do
    scores = parse("input")
    |> Stream.map(&check_syntax(&1, []))
    |> Stream.filter(fn {c, _} -> c == nil end)
    |> Stream.map(fn {_, pending} -> score(pending) end)
    |> Enum.sort

    Enum.at(scores, div(Enum.count(scores), 2))

  end

  def score(pending_chars) do
    char_scores = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}
    pending_chars
    |> Enum.reduce(0, fn c, acc -> (acc * 5) + char_scores[c] end)
  end

  # Returns the first illegal character in a line, or nil if all chars are legal.
  def check_syntax([c | next_chars], pending) when c in ["(", "{", "[", "<"] do
    check_syntax(next_chars, [@pairs[c] | pending])
  end
  def check_syntax([c | next_chars], [c | pending]), do: check_syntax(next_chars, pending) 
  def check_syntax([c | _], pending), do: {c, pending}  # Illegal character.
  def check_syntax([], pending), do: {nil, pending} # No illegal character found.

  def parse(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

end
