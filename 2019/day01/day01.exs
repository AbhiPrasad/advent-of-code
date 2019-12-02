defmodule Day01 do
  def part1, do: sum_fuel()
  def part2, do: sum_total_fuel()

  def read_file do
    {:ok, content} = File.read("input.txt")

    content
  end

  def parse_contents(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn n -> Float.parse(n) |> elem(0) end)
  end

  def fuel_from_mass(mass) do
    Float.floor(mass / 3) - 2
  end

  def sum_fuel do
    read_file()
    |> parse_contents
    |> Enum.map(&fuel_from_mass/1)
    |> Enum.sum
  end

  def get_total_fuel(mass, acc) do
    fuel_mass = fuel_from_mass(mass)
    if fuel_mass <= 0 do
      acc
    else
      get_total_fuel(fuel_mass, acc + fuel_mass)
    end
  end

  def sum_total_fuel do
    read_file()
    |> parse_contents
    |> Enum.map(fn (mass) -> get_total_fuel(mass, 0) end)
    |> Enum.sum
  end
end

# Tests

ExUnit.start()

defmodule Day01Test do
  use ExUnit.Case

  import Day01

  test "part one" do
    assert fuel_from_mass(12.0) == 2.0
    assert fuel_from_mass(14.0) == 2.0
    assert fuel_from_mass(1969.0) == 654.0
    assert fuel_from_mass(100756.0) == 33583.0
  end

  test "part two" do
    assert get_total_fuel(14.0, 0) == 2.0
    assert get_total_fuel(1969.0, 0) == 966.0
    assert get_total_fuel(100756.0, 0) == 50346.0
  end
end
