#!/usr/bin/env elixir

ex = ~s(
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
)

file = File.read!("03.txt")

score = fn s ->
  c = s |> String.to_charlist() |> hd

  if c in ?A..?Z,
    do: 27 + c - ?A,
    else: 1 + c - ?a
end

lines =
  file
  |> String.split("\n", trim: true)

split =
  lines
  |> Enum.map(
    &{&1 |> String.slice(0, div(String.length(&1), 2)),
     &1 |> String.slice(div(String.length(&1), 2)..-1)}
  )
  |> Enum.flat_map(fn {a, b} ->
    ma = a |> String.codepoints() |> MapSet.new()
    mb = b |> String.codepoints() |> MapSet.new()
    ma |> MapSet.intersection(mb) |> MapSet.to_list()
  end)
  |> Enum.map(&score.(&1))

IO.inspect(split |> Enum.sum(),
  label: "part 1"
)

split =
  lines
  |> Enum.chunk_every(3)
  |> Enum.flat_map(fn [a, b, c | _] ->
    ma = a |> String.codepoints() |> MapSet.new()
    mb = b |> String.codepoints() |> MapSet.new()
    mc = c |> String.codepoints() |> MapSet.new()
    ma |> MapSet.intersection(mb) |> MapSet.intersection(mc) |> MapSet.to_list()
  end)
  |> Enum.map(&score.(&1))

IO.inspect(split |> Enum.sum(),
  label: "part 2"
)
