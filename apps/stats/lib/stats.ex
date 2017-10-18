defmodule Stats do
  @moduledoc """
  Basic statistics functions
  For https://www.hackerrank.com/challenges/s10-basic-statistics
  """

  def mean(numbers) do
    Float.round(Enum.sum(numbers) / length(numbers), 1)
  end

  def weighted_mean(numbers, weights) do
    numerator = Enum.zip(numbers, weights) |> Enum.map(fn ({x, y}) -> x * y end) |> Enum.sum
    denominator = weights |> Enum.sum
    Float.round(numerator/denominator, 1)
  end

  @doc """
  Calculates quantiles that divides data into 4 equal groups
  https://www.hackerrank.com/challenges/s10-quartiles
  A.K.A Day 1 in 10 days of statistics (s10).
  """
  def quantiles(numbers) do
  # TODO refactor
    len = length(numbers)
    sorted = numbers |> Enum.sort
    mid = div(len, 2)

    {lower_half, upper_half } = if rem(len, 2) == 0 do
      lower_half = Enum.slice(sorted, 0..(mid-1))
      upper_half = Enum.slice(sorted, mid..-1)
      {lower_half, upper_half}
    else
      lower_half = Enum.slice(sorted, 0..(mid-1))
      upper_half = Enum.slice(sorted, (mid+1)..-1)
      {lower_half, upper_half}
    end

    {trunc(median(lower_half)), trunc(median(numbers)), trunc(median(upper_half))}
  end

  def median(numbers) do
    len = length(numbers)
    sorted = numbers |> Enum.sort
    if rem(len, 2) == 0 do
      (Enum.at(sorted, div(len, 2) - 1) + Enum.at(sorted, div(len, 2)))/2
    else
      Enum.at(sorted, div(len, 2))
    end
  end

  def mode(numbers) do
    numbers |> Enum.sort |> Enum.chunk_by(fn x -> x end)
            |> Enum.max_by(fn lst -> length(lst) end) |> Enum.at(0)
  end

  @doc """
  Calculates standard deviation
  https://www.hackerrank.com/challenges/s10-standard-deviation
  """
  def stdev(numbers) do
    mu = mean(numbers)
    numerator = numbers |> Enum.map(fn n -> (n - mu) * (n - mu) end) |> Enum.sum
    result = :math.sqrt(numerator / length(numbers))
    Float.round(result, 1)
  end

  def solve(numbers) do
    numbers = numbers |> String.split |> Enum.map(fn x -> String.to_integer(x) end)
    {mean(numbers), median(numbers), mode(numbers)}
  end

  def main() do
      _ = String.to_integer(String.trim(IO.gets ""))
      data = String.trim(IO.gets "")
      {r1, r2, r3} = solve(data)
      IO.puts(r1)
      IO.puts(r2)
      IO.puts(r3)
  end
end

# Stats.main()
