defmodule AOC.DayFive do

  @row_range 0..127
  @col_range 0..7

  def solve_part_one(seats) do
    seats
    |> Enum.sort_by(&Kernel.elem(&1, 1), &>/2)
    |> Enum.sort_by(&Kernel.elem(&1, 0), &>/2)
    |> List.last
    |> decode()
    |> Kernel.elem(1)
  end

  def solve_part_two(seats) do
    seats
    |> Enum.map(&decode/1)
    |> Enum.sort_by(&Kernel.elem(&1, 1))
    |> Enum.reduce_while(0, &find_missing_seat/2)
  end

  def parse(<<row::bytes-size(7), column::bytes-size(3)>>), do: {row, column}

  def decode({row, col}) do
    [row_nb] = Enum.reduce(String.graphemes(row), @row_range, &reduce_range/2)
    [col_nb] = Enum.reduce(String.graphemes(col), @col_range, &reduce_range/2)
    append_seat_id({row_nb, col_nb})
  end

  def reduce_range(letter, range) do
    range_half_count = trunc(Enum.count(range)/2)
    case letter in ["F", "L"] do
      true -> Enum.slice(range, 0, range_half_count)
      false -> Enum.slice(range, range_half_count, range_half_count)
    end
  end

  def append_seat_id({row_nb, col_nb}), do: {{row_nb, col_nb}, (8*row_nb)+col_nb}

  def find_missing_seat({_, id}, acc) when (id-acc) == 2, do: {:halt, id-1}
  def find_missing_seat({_, id}, _acc), do:  {:cont, id}

end

seats =
  File.read!("inputs/day_05")
  |> String.split("\n", trim: true)
  |> Enum.map(& AOC.DayFive.parse(&1))

seats |> AOC.DayFive.solve_part_one() |> IO.inspect
seats |> AOC.DayFive.solve_part_two() |> IO.inspect
