#!/usr/bin/env elixir

ex = ~s(
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
)

file = File.read!("04.txt")

lines =
  file
  |> String.split("\n", trim: true)

ranges =
  lines
  |> Enum.map(fn l ->
    [r1, r2 | _] = l |> String.split(",", trim: true)
    [sr1a, sr1b] = r1 |> String.split("-", trim: true) |> Enum.map(&String.to_integer/1)
    [sr2a, sr2b] = r2 |> String.split("-", trim: true) |> Enum.map(&String.to_integer/1)
    {sr1a..sr1b, sr2a..sr2b}
  end)

IO.inspect(
  ranges
  |> Enum.count(fn {r1, r2} ->
    Enum.all?(r1, &(&1 in r2)) or Enum.all?(r2, &(&1 in r1))
  end),
  label: "part 1"
)

IO.inspect(
  ranges
  |> Enum.count(fn {r1, r2} ->
    Enum.any?(r1, &(&1 in r2)) or Enum.any?(r2, &(&1 in r1))
  end),
  label: "part 2"
)
