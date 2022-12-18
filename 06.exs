#!/usr/bin/env elixir

defmodule AOC06 do
  def match4(_ch, [a, b, c, d | _] = acc)
      when a not in [b, c, d] and
             b not in [a, c, d] and
             c not in [a, b, d] and
             d not in [a, b, c],
      do: {:halt, length(acc)}

  def match4(ch, acc),
    do: {:cont, [ch | acc]}

  def match14(_ch, [a, b, c, d, e, f, g, h, i, j, k, l, m, n | _] = acc)
      when a not in [b, c, d, e, f, g, h, i, j, k, l, m, n] and
             b not in [a, c, d, e, f, g, h, i, j, k, l, m, n] and
             c not in [a, b, d, e, f, g, h, i, j, k, l, m, n] and
             d not in [a, b, c, e, f, g, h, i, j, k, l, m, n] and
             e not in [a, b, c, d, f, g, h, i, j, k, l, m, n] and
             f not in [a, b, c, d, e, g, h, i, j, k, l, m, n] and
             g not in [a, b, c, d, e, f, h, i, j, k, l, m, n] and
             h not in [a, b, c, d, e, f, g, i, j, k, l, m, n] and
             i not in [a, b, c, d, e, f, g, h, j, k, l, m, n] and
             j not in [a, b, c, d, e, f, g, h, i, k, l, m, n] and
             k not in [a, b, c, d, e, f, g, h, i, j, l, m, n] and
             l not in [a, b, c, d, e, f, g, h, i, j, k, m, n] and
             m not in [a, b, c, d, e, f, g, h, i, j, k, l, n] and
             n not in [a, b, c, d, e, f, g, h, i, j, k, l, m],
      do: {:halt, length(acc)}

  def match14(ch, acc),
    do: {:cont, [ch | acc]}
end

#ex = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

file = File.read!("06.txt")

after_fun = fn
  [] -> {:cont, []}
  acc -> {:cont, to_string(acc), []}
end

IO.inspect(
  file
  |> String.codepoints()
  |> Enum.chunk_while([], &AOC06.match4/2, after_fun)
  |> hd()
  |> String.to_integer(),
  label: "part 1"
)

IO.inspect(
  file
  |> String.codepoints()
  |> Enum.chunk_while([], &AOC06.match14/2, after_fun)
  |> hd()
  |> String.to_integer(),
  label: "part 2"
)
