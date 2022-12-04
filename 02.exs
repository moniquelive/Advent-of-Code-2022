#!/usr/bin/env elixir

ex = ~s(
A Y
B X
C Z
)

file = File.read!("02.txt")

# 0 = lost
# 3 = tie
# 6 = won

plays =
  file
  |> String.split("\n", trim: true)
  |> Enum.map(&(String.split(&1) |> List.to_tuple()))

points = %{
  # 1 = X,A = rock
  # 2 = Y,B = paper
  # 3 = Z,C = scissor
  "A" => 1,
  "B" => 2,
  "C" => 3,
  "X" => 1,
  "Y" => 2,
  "Z" => 3
}

score = fn
  1, 2 -> 0
  2, 3 -> 0
  3, 1 -> 0
  1, 3 -> 6
  2, 1 -> 6
  3, 2 -> 6
  x, x -> 3
end

scores =
  plays
  |> Enum.map(fn {p1, p2} -> {points[p1], points[p2]} end)
  |> Enum.map(fn {p1, p2} -> {p1 + score.(p1, p2), p2 + score.(p2, p1)} end)

IO.inspect(
  scores
  |> Enum.map(&elem(&1, 1))
  |> Enum.sum(),
  label: "part 1"
)

should = fn
  # X = lose
  # Y = draw
  # Z = win
  1, "X" -> 3
  2, "X" -> 1
  3, "X" -> 2
  1, "Z" -> 2
  2, "Z" -> 3
  3, "Z" -> 1
  x, "Y" -> x
end

scores2 =
  plays
  |> Enum.map(fn {p1, p2} -> {points[p1], should.(points[p1], p2)} end)
  |> Enum.map(fn {p1, p2} -> {p1 + score.(p1, p2), p2 + score.(p2, p1)} end)

IO.inspect(
  scores2
  |> Enum.map(&elem(&1, 1))
  |> Enum.sum(),
  label: "part 2"
)
