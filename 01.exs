#!/usr/bin/env elixir

ex = ~s(
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
)

file = File.read!("01.txt")

elves = file |> String.split("\n\n", trim: true)

totals =
  Enum.map(elves, fn e ->
    e
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end)

# part 1
IO.inspect(
  totals
  |> Enum.max()
)

# part 2
IO.inspect(
  totals
  |> Enum.sort()
  |> Enum.reverse()
  |> Enum.take(3)
  |> Enum.sum()
)
