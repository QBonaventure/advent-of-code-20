defmodule AOC.DayFour do

  @required_fields ~w(byr iyr eyr hgt hcl ecl pid)
  @eye_colors ~w(amb blu brn gry grn hzl oth)

  def resolve(passports_data), do: Enum.reduce(passports_data, {0, %{}}, &parse_data/2)

  def parse_data("", {nb_of_valid, %{} = current_pass}) do
    case valid?(current_pass) do
      true -> {nb_of_valid+1, %{}}
      false -> {nb_of_valid, %{}}
    end
  end

  def parse_data(data_line, {nb_of_valid, %{} = current_pass}), do:
    {nb_of_valid, extract_and_merge(current_pass, data_line)}

  def extract_and_merge(current_passport, data), do:
    String.split(data)
    |> Enum.map(fn <<code::bytes-size(3), ":", value::binary>> -> {code, value} end)
    |> Map.new()
    |> Map.merge(current_passport)

  def valid?(%{} = passport_data) do
    @required_fields
    |> Enum.all?(& Map.has_key?(passport_data, &1))
    |> case do
      false -> false
      true -> Enum.all?(passport_data, &check_data/1)
    end
  end

  def check_data({"cid", _}), do: true
  def check_data({"byr", year}), do: check_integer_range(year, 1920..2002)
  def check_data({"iyr", year}), do: check_integer_range(year, 2010..2020)
  def check_data({"eyr", year}), do: check_integer_range(year, 2020..2030)
  def check_data({"ecl", color}) when color in @eye_colors, do: true
  def check_data({"hgt", <<height::bytes-size(3), "cm">>}), do: check_integer_range(height, 150..193)
  def check_data({"hgt", <<height::bytes-size(2), "in">>}), do: check_integer_range(height, 59..76)
  def check_data({"pid", <<pid::bytes-size(9)>>}), do: integer?(pid)
  def check_data({"hcl", <<"#", hex::bytes-size(6)>>}), do: is_hex?(hex)
  def check_data(_), do: false

  def check_integer_range(year, range) do
    case Integer.parse(year) do
      {year, ""} -> year in range
      _ -> false
    end
  end

  def is_hex?(hex), do: Regex.match?(~r/^[a-f0-9]+$/i, hex)

  def integer?(integer) do
    case Integer.parse(integer) do
      {_number, ""} -> true
      _ -> false
    end
  end

end


passport_data =
  File.read!("inputs/day_04")
  |> String.split("\n", trim: false)

AOC.DayFour.resolve(passport_data)  |> IO.inspect
