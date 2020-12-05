defmodule AOC.DayTwo do


  def first_puzzle(passwords) do
    passwords
    |> Enum.filter(fn line ->
      [rules, <<letter::bytes-size(1), ":">>, password] = String.split(line)
      [min, max ] = String.split(rules, "-") |> Enum.map(& String.to_integer(&1))
      nb = password |> String.graphemes |> Enum.count(& &1 == letter)

      min <= nb and nb <= max
    end)
    |> Enum.count
  end

  def second_puzzle(passwords) do
    passwords
    |> Enum.filter(fn line ->
      [rules, <<letter::bytes-size(1), ":">>, password] = String.split(line)
      candidate_letters =
        String.split(rules, "-")
        |> Enum.map(& String.at(password, String.to_integer(&1)-1))

      Enum.count(candidate_letters, & &1 == letter) == 1
    end)
    |> Enum.count
  end

end

passwords =
  File.read!("inputs/day_02")
  |> String.split("\n", trim: true)

AOC.DayTwo.first_puzzle(passwords) |> IO.inspect
AOC.DayTwo.second_puzzle(passwords) |> IO.inspect
