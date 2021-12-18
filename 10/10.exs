defmodule Day10 do
  @pairs %{"(" => ")", "{" => "}", "[" => "]", "<" => ">"}

  def part1 do
    parse("input")
    |> Stream.map(&find_illegal_char(&1, []))
    |> Stream.map(fn
      nil -> 0
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end)
    |> Enum.sum
  end

  # Returns the first illegal character in a line, or nil if all chars are legal.
  def find_illegal_char([c | next_chars], pending) when c in ["(", "{", "[", "<"] do
    find_illegal_char(next_chars, [@pairs[c] | pending])
  end
  def find_illegal_char([c | next_chars], [c | pending]), do: find_illegal_char(next_chars, pending) 
  def find_illegal_char([c | _], _), do: c # Illegal character.
  def find_illegal_char([], _), do: nil # No illegal character found.

  def parse(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

end
