#!/usr/bin/env elixir

ex = ~s(
30373
25512
65332
33549
35390
)

lines =
  File.read!("08.txt")
  # ex
  |> String.split("\n", trim: true)

map =
  lines
  |> Enum.with_index(fn line, row ->
    line
    |> String.graphemes()
    |> Enum.with_index(fn ch, col ->
      {{row, col}, ch |> String.to_integer()}
    end)
  end)
  |> List.flatten()
  |> Map.new()

visibles =
  Enum.reduce(1..(length(lines) - 2), 0, fn j, acc ->
    Enum.reduce(1..(length(lines) - 2), acc, fn i, a ->
      top = Enum.map(0..(j - 1), &map[{&1, i}])
      bottom = Enum.map((j + 1)..(length(lines) - 1), &map[{&1, i}])
      left = Enum.map(0..(i - 1), &map[{j, &1}])
      right = Enum.map((i + 1)..(length(lines) - 1), &map[{j, &1}])
      curr = map[{j, i}]

      if Enum.all?(top, &(curr > &1)) ||
           Enum.all?(bottom, &(curr > &1)) ||
           Enum.all?(left, &(curr > &1)) ||
           Enum.all?(right, &(curr > &1)),
         do: a + 1,
         else: a
    end)
  end)

defmodule AOC08 do
  def take_until(coll, f, acc \\ [])

  def take_until([], _, acc), do: acc

  def take_until([h | t], f, acc) do
    if f.(h),
      do: acc ++ [h],
      else: take_until(t, f, acc ++ [h])
  end
end

scenic =
  Enum.reduce(1..(length(lines) - 2), [], fn j, acc ->
    Enum.reduce(1..(length(lines) - 2), acc, fn i, a ->
      top = Enum.map(0..(j - 1), &map[{&1, i}]) |> Enum.reverse()
      bottom = Enum.map((j + 1)..(length(lines) - 1), &map[{&1, i}])
      left = Enum.map(0..(i - 1), &map[{j, &1}]) |> Enum.reverse()
      right = Enum.map((i + 1)..(length(lines) - 1), &map[{j, &1}])
      curr = map[{j, i}]

      ct = AOC08.take_until(top, &(&1 >= curr)) |> length()
      cb = AOC08.take_until(bottom, &(&1 >= curr)) |> length()
      cl = AOC08.take_until(left, &(&1 >= curr)) |> length()
      cr = AOC08.take_until(right, &(&1 >= curr)) |> length()
      # IO.inspect({{top, ct}, {bottom, cb}, {left, cl}, {right, cr}, curr})
      [ct * cb * cl * cr | a]
    end)
  end)

IO.inspect(
  visibles + 2 * (length(lines) + length(lines) - 2),
  label: "part 1"
)

IO.inspect(
  Enum.max(scenic),
  label: "part 2"
)
