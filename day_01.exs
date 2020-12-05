defmodule AOC.DayOne do

  def first_puzzle(my_expenses) do
    my_expenses =  prepare_list(my_expenses, 2)
    my_expenses_count = Enum.count(my_expenses)
    Enum.reduce_while(my_expenses, 0, fn expense_one, acc ->
      my_expenses
      |> Enum.slice(acc..my_expenses_count)
      |> Enum.find(& expense_one+&1 == 2020)
      |> continue?({expense_one, acc})
    end)
    |> Integer.to_string
    |> congratulate_for_one
  end


  def second_puzzle(my_expenses) do
    my_expenses =  prepare_list(my_expenses, 3)
    my_expenses_count = Enum.count(my_expenses)
    Enum.reduce_while(my_expenses, 0, fn expense_one, acc ->
      my_expenses
      |> Enum.slice(acc..my_expenses_count)
      |> Enum.reduce_while(acc+1, fn expense_two, acc_two ->
        Enum.slice(my_expenses, acc_two..my_expenses_count)
        |> Enum.find(& expense_one+expense_two+&1 == 2020)
        |> continue?({[expense_one, expense_two], acc_two})
      end)
      |> case do
        acc_two when acc_two < 500 ->
          {:cont, acc+1}
        result ->
          {:halt, result}
      end
    end)
    |> Integer.to_string
    |> congratulate_for_two
  end


  def continue?(nil, {_expense_one, acc}), do: {:cont, acc+1}
  def continue?(expense_three, {[expense_one, expense_two], _acc}), do:
    {:halt, expense_one*expense_two*expense_three}
  def continue?(expense_two, {expense_one, _acc}), do:
    {:halt, expense_one*expense_two}

  def prepare_list(list, numbers_to_find) do
    sorted_list = Enum.sort(list)
    lowest_value = Enum.sum(Enum.slice(sorted_list, 0..(numbers_to_find-2)))
    sorted_list |> Enum.reject(& &1+lowest_value > 2020)
  end

  def congratulate_for_one(solution), do:
    IO.puts ~s(Congratulations! The solution to puzzle 1 of day one is: "#{solution}")
  def congratulate_for_two(solution), do:
    IO.puts ~s(Congratulations! The solution to puzzle 2 of day one is: "#{solution}")

end

my_expenses =
  File.read!("inputs/day_01")
  |> String.split("\n", trim: true)

AOC.DayOne.my_expenses |> AOC.DayOne.first_puzzle()
AOC.DayOne.my_expenses |> AOC.DayOne.second_puzzle()
