#!/usr/bin/env elixir

defmodule AOC05 do
  def push(st, val), do: [val | st]
  def pop([hd | tl]), do: {hd, tl}
  def top([hd | _]), do: hd

  def move(acc, _f, _t, 0), do: acc

  def move(acc, f, t, c) do
    {top, st_from} = pop(acc[f])
    st_to = push(acc[t], top)

    acc
    |> Map.update!(f, fn _ -> st_from end)
    |> Map.update!(t, fn _ -> st_to end)
    |> move(f, t, c - 1)
  end

  def move2(acc, f, t, c) do
    els = Enum.take(acc[f], c)
    st_from = Enum.drop(acc[f], c)
    st_to = els ++ acc[t]

    acc
    |> Map.update!(f, fn _ -> st_from end)
    |> Map.update!(t, fn _ -> st_to end)
  end
end

ex = ~s(
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
)

file = File.read!("05.txt")

[setup, movements] =
  file
  |> String.split("\n\n", trim: true)
  |> Enum.map(&String.split(&1, "\n", trim: true))

setup = setup |> Enum.reverse() |> tl |> Enum.reverse()

stacks =
  Enum.map(setup, &Enum.with_index(String.codepoints(&1)))
  |> Enum.flat_map(&Enum.filter(&1, fn {c, p} -> c != " " and rem(p - 1, 4) == 0 end))
  |> Enum.map(fn {c, i} -> {c, div(i - 1, 4) + 1} end)
  |> Enum.reverse()
  |> Enum.reduce(%{}, fn {c, i}, acc ->
    st = Map.get(acc, i, [])
    Map.put(acc, i, AOC05.push(st, c))
  end)

IO.inspect(setup, label: "setup")
IO.inspect(movements, label: "movements")
IO.inspect(stacks, label: "stacks")

IO.inspect(
  movements
  |> Enum.reduce(stacks, fn cmd, acc ->
    cap = Regex.named_captures(~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/, cmd)

    AOC05.move(
      acc,
      String.to_integer(cap["from"]),
      String.to_integer(cap["to"]),
      String.to_integer(cap["count"])
    )
  end)
  |> Enum.map(fn {_, st} -> AOC05.top(st) end)
  |> Enum.join(),
  label: "part 1"
)

IO.inspect(
  movements
  |> Enum.reduce(stacks, fn cmd, acc ->
    cap = Regex.named_captures(~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/, cmd)

    AOC05.move2(
      acc,
      String.to_integer(cap["from"]),
      String.to_integer(cap["to"]),
      String.to_integer(cap["count"])
    )
  end)
  |> Enum.map(fn {_, st} -> AOC05.top(st) end)
  |> Enum.join(),
  label: "part 2"
)
