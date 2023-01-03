#!/usr/bin/env elixir

ex = ~s(
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
)

lines =
  File.read!("10.txt")
  # ex
  |> String.split("\n", trim: true)
  |> Stream.map(&String.split/1)
  |> Stream.map(&List.to_tuple/1)
  |> Enum.map_reduce(0, fn
    {a}, index -> {{index, a}, index + 1}
    {a, b}, index -> {{index, a, String.to_integer(b)}, index + 2}
  end)
  |> elem(0)

score = fn lines, cycle ->
  lines
  |> Enum.take_while(fn {index, _, _} -> index < cycle - 2 end)
  |> Enum.map(&elem(&1, 2))
  |> Enum.sum()
  |> then(&(&1 + 1))
  |> then(&(&1 * cycle))
end

adds = Enum.filter(lines, &(elem(&1, 1) == "addx"))

IO.inspect(
  Enum.sum([
    score.(adds, 20),
    score.(adds, 60),
    score.(adds, 100),
    score.(adds, 140),
    score.(adds, 180),
    score.(adds, 220)
  ]),
  label: "part 1"
)

# --- part 2 ---
lines =
  File.read!("10.txt")
  # ex
  |> String.split("\n", trim: true)
  |> Stream.map(&String.split/1)
  |> Stream.map(fn
    ["noop"] -> {"addx", 0}
    ["addx", v] -> [{"addx", 0}, {"addx", String.to_integer(v)}]
  end)
  |> Enum.to_list()
  |> List.flatten()

pixel = fn
  x, cycle when rem(cycle, 40) in (x - 1)..(x + 1) -> "#"
  _, _ -> " "
end

state =
  Enum.zip(0..239, lines)
  |> Enum.reduce(%{x: 1, display: ""}, fn
    {cycle, {"addx", v}}, state ->
      state
      |> Map.update!(:display, &(&1 <> pixel.(state.x, cycle)))
      |> Map.update!(:x, &(&1 + v))
  end)

IO.puts(
  "part 2:\n" <>
    (List.flatten(Regex.scan(~r/.{40}/, state.display))
     |> Enum.join("\n"))
)
