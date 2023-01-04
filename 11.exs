#!/usr/bin/env elixir

ex = ~s(
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
)

monkeys =
  File.read!("11.txt")
  # ex
  |> String.split("\n\n")
  |> Enum.map(
    &(String.split(&1, "\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(fn s -> String.trim(s) end))
  )
  |> Enum.map(&List.to_tuple/1)
  |> Enum.map(fn {items, operation, test, iftrue, iffalse} ->
    %{
      items:
        items
        |> String.split(":")
        |> tl()
        |> hd()
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1),
      operation: operation |> String.split(" = ") |> tl() |> hd(),
      test: Regex.run(~r/\d+/, test) |> hd() |> String.to_integer(),
      iftrue: Regex.run(~r/\d+/, iftrue) |> hd() |> String.to_integer(),
      iffalse: Regex.run(~r/\d+/, iffalse) |> hd() |> String.to_integer(),
      rounds: 0
    }
  end)
  |> Stream.zip(0..1000)
  |> Map.new(&{elem(&1, 1), elem(&1, 0)})

scores =
  Enum.reduce(1..20, monkeys, fn _n, monkeys ->
    # foreach monkey
    Enum.reduce(0..(map_size(monkeys) - 1), monkeys, fn i, monkeys ->
      # foreach item
      Enum.reduce(monkeys[i].items, monkeys, fn item, monkeys ->
        {new_worry, _} = Code.eval_string(monkeys[i].operation, [old: item], __ENV__)
        new_worry = div(new_worry, 3)

        throw_to =
          if rem(new_worry, monkeys[i].test) == 0, do: monkeys[i].iftrue, else: monkeys[i].iffalse

        monkeys
        |> update_in([throw_to, :items], &(&1 ++ [new_worry]))
        |> update_in([i, :rounds], &(&1 + 1))
      end)
      |> update_in([i, :items], fn _ -> [] end)
    end)
  end)

IO.inspect(
  scores
  |> Map.values()
  |> Enum.sort(&(&1.rounds > &2.rounds))
  |> Enum.take(2)
  |> Enum.map(& &1.rounds)
  |> Enum.product(),
  label: "part 1",
  charlists: :as_lists
)

mod_by = monkeys |> Map.values() |> Enum.map(& &1.test) |> Enum.product()

scores =
  Enum.reduce(1..10_000, monkeys, fn _n, monkeys ->
    # foreach monkey
    Enum.reduce(0..(map_size(monkeys) - 1), monkeys, fn i, monkeys ->
      # foreach item
      Enum.reduce(monkeys[i].items, monkeys, fn item, monkeys ->
        {new_worry, _} = Code.eval_string(monkeys[i].operation, [old: item], __ENV__)
        new_worry = rem(new_worry, mod_by)

        throw_to =
          if rem(new_worry, monkeys[i].test) == 0, do: monkeys[i].iftrue, else: monkeys[i].iffalse

        monkeys
        |> update_in([throw_to, :items], &(&1 ++ [new_worry]))
        |> update_in([i, :rounds], &(&1 + 1))
      end)
      |> update_in([i, :items], fn _ -> [] end)
    end)
  end)

IO.inspect(
  scores
  |> Map.values()
  |> Enum.sort(&(&1.rounds > &2.rounds))
  |> Enum.take(2)
  |> Enum.map(& &1.rounds)
  |> Enum.product(),
  label: "part 2",
  charlists: :as_lists
)
