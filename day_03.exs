defmodule AOC.DayThree do

  def resolve(map_section, rules) do
    rules
    |> Enum.map(&analyze_section_with_rules(map_section, &1))
    |> Enum.reduce(1, &Kernel.elem(&1, 1)*&2)
  end


  def analyze_section_with_rules(map_section, {_x, _y} = rules) do
    {_, _, _, result} = Enum.reduce(map_section, {rules, {0,0}, 0, 0}, &analyze_row/2)
    {rules, result}
  end


  def analyze_row(tree_row, {{_x, y} = rules, {start_x, start_y}, row_number, trees}) do
    case Integer.mod(row_number, y) do
      0 ->
        trees = if String.at(tree_row, start_x) == "#" do trees+1 else trees end
        {rules, {next_x(start_x, rules, tree_row), start_y+1}, row_number+1, trees}
      _ ->
        {rules, {start_x, start_y+1}, row_number+1, trees}
    end
  end

  def next_x(current_x, {x, _}, tree_row) do
    next_x = current_x + x
    String.length(tree_row)
    |> correct_out_of_bound_x(next_x)
  end

  def correct_out_of_bound_x(tree_row_width, x) when tree_row_width - x > 0, do: x
  def correct_out_of_bound_x(tree_row_width, x), do: -(tree_row_width-x)

end


map_section =
  File.read!("inputs/day_03.txt")
  |> String.split("\n", trim: true)

first_puzzle_rules =
  [
    {3, 1}
  ]
second_puzzle_rules =
  [
    {1, 1},
    {3, 1},
    {5, 1},
    {7, 1},
    {1, 2}
  ]

AOC.DayThree.resolve(map_section, first_puzzle_rules)  |> IO.puts
AOC.DayThree.resolve(map_section, second_puzzle_rules) |> IO.puts
