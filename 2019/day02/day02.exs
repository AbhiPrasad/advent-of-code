defmodule Day02 do
  def part1, do: get_output(12, 2)
  def part2, do: generate_custom_output()

  defp read_file do
    {:ok, content} = File.read("input.txt")

    content
  end

  defp parse_contents(content) do
    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def update_values(intcodes, index, operator) do
    first_position = Enum.at(intcodes, index + 1)
    second_position = Enum.at(intcodes, index + 2)
    third_position = Enum.at(intcodes, index + 3)

    first_value = Enum.at(intcodes, first_position)
    second_value = Enum.at(intcodes, second_position)
    third_value = apply(Kernel, operator, [first_value, second_value])

    intcodes
    |> List.replace_at(third_position, third_value)
    |> parse_opcodes(index + 4)
  end

  def parse_opcodes(intcodes, index \\ 0) do
    opcode = Enum.at(intcodes, index)

    cond do
      opcode == 1 -> update_values(intcodes, index, :+)
      opcode == 2 -> update_values(intcodes, index, :*)
      opcode == 99 -> intcodes
    end
  end

  def get_output(noun, verb) do
    read_file()
    |> parse_contents
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> parse_opcodes(0)
    |> Enum.at(0)
  end

  def traverse_products(cartesian_product) do
    [head | tail] = cartesian_product
    [noun, verb] = head

    output = get_output(noun, verb)

    if output == 19690720 do
      100 * noun + verb
    else
      traverse_products(tail)
    end
  end

  def generate_custom_output do
    cartesian_product = for n <- 0..99, v <- 0..99, do: [n, v]
    
    traverse_products(cartesian_product)
  end
end

ExUnit.start()

defmodule Day02Test do
  use ExUnit.Case

  import Day02

  test "part one" do
    assert parse_opcodes([1,0,0,0,99]) == [2,0,0,0,99]
    assert parse_opcodes([2,3,0,3,99]) == [2,3,0,6,99]
    assert parse_opcodes([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
    assert parse_opcodes([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
  end
end
