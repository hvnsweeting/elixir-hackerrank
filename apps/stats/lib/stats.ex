defmodule Stats do
  @moduledoc """
  Basic statistics functions
  For https://www.hackerrank.com/challenges/s10-basic-statistics
  """
  require Integer
  def mean(numbers) do
    Float.round(Enum.sum(numbers) / length(numbers), 1)
  end

  def weighted_mean(numbers, weights) do
    numerator = Enum.zip(numbers, weights) |> Enum.map(fn ({x, y}) -> x * y end) |> Enum.sum
    denominator = weights |> Enum.sum
    Float.round(numerator/denominator, 1)
  end

  def quartiles_index(freqs) do
    {q2left, q2right} = median_index(freqs)
    n = Enum.sum(freqs)
    {q1, q3} = if q2left == q2right do
        # ODD
        q1 = median_index(0, q2left)
        q3 = median_index(q2right+1, n)
        {q1, q3}
    else
        q1 = median_index(0, q2left+1)
        q3 = median_index(q2right, n)
        {q1, q3}
    end

    [q1, {q2left, q2right}, q3]
  end

  @doc """
  Calculates quartiles that divides data into 4 equal groups
  https://www.hackerrank.com/challenges/s10-quartiles
  A.K.A Day 1 in 10 days of statistics (s10).
  """
  def quartiles(numbers) do
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

    {median(lower_half), median(numbers), median(upper_half)}
  end
  def quartiles(numbers, freqs) do
    [q1, q2, q3] = quartiles_index(freqs)
    {takemed(numbers, freqs, q1), takemed(numbers, freqs, q2), takemed(numbers, freqs, q3)}
  end


  @doc """
  Calculates interquartile range
  https://www.hackerrank.com/challenges/s10-interquartile-range
  """
  def interquartile_range(numbers, freqs) do
    {q1, _, q3} = quartiles(numbers, freqs)
    q3 - q1
  end

  @doc """
  Generates dataset from numbers and frequencies, might use a lot of memory.
  """
  def gen_dataset(numbers, freqs) do
    Enum.zip(numbers, freqs)
              |> Enum.map(fn {n, times} -> List.duplicate(n, times) end)
              |> Enum.concat
  end

  @doc """
  Calculate index of two medians given the frequencies of data.
  """
  def median_index(start, stop) do
    n = stop - start
    if Integer.is_even(n) do
      {start + div(n, 2) - 1, start + div(n, 2)}
    else
      {start + div(n, 2), start + div(n, 2)}
    end
  end

  def median_index(n) when is_integer(n) do
    median_index(0, n)
  end

  def median_index(freqs) do
    n_points = Enum.sum(freqs)
    median_index(n_points)
  end

  def take(numbers, freqs, n) do
    # TODO handle IndexError for n
    Enum.zip(numbers, freqs)
    |> Enum.sort
    |> Enum.reduce_while(n+1, fn {n, f}, acc -> if f < acc, do: {:cont, acc - f}, else: {:halt, n} end)
  end

  def takemed(numbers, freqs, {left, right}) do
    mid1 = take(numbers, freqs, left)
    mid2 = take(numbers, freqs, right)
    (mid1 + mid2) / 2
  end

  def median(numbers, freqs) do
    {left, right} = median_index(freqs)
    takemed(numbers, freqs, {left, right})
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

  def skip_input() do
      _ = String.to_integer(String.trim(IO.gets ""))
  end

  def input() do
      String.trim(IO.gets "") |> String.split |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def pow(n, k) do
    _pow(n, k, 1)
  end

  defp _pow(_, 0, acc) do
    acc
  end
  defp _pow(n, k, acc) do
    _pow(n, k-1, acc * n)
  end

  def factorial(n) do
    fact(n, 1)
  end

  defp fact(0, acc) do
    acc
  end
  defp fact(n, acc) do
    fact(n-1, acc * n)
  end

  def choose(x, n) do
    factorial(n) / (factorial(x) * factorial(n-x))
  end

  @doc """
  Given ratio s to f, calculates probability of success.
  """
  def success_prob_from_ratio(s, f) do
    s / (s+f)
  end

  @doc """
  Calculates probability for binomial random variable
  Using binomial distribution probability mass function.
  """
  def binomial_pmf(successes, trials, success_prob) do
    choose(successes, trials) * pow(success_prob, successes) * pow(1-success_prob, trials - successes)
  end

  def neg_binomial_pmf(successes, trials, success_prob) do
    choose(successes-1, trials-1) * pow(success_prob, successes) * pow(1-success_prob, trials - successes)
  end

  def geometric_dist(trials, success_prob) do
    pow(1-success_prob, trials-1) * success_prob
  end

  @doc """
  Calculates P(k, lambda) - Poisson probability
    k - the actual number of successes
    lambda - the average number of successes
  """
  def poisson_prob(actual, average) do
    pow(average, actual) * :math.exp(-average) / factorial(actual)
  end

  def normal_dist_func(x, mean, stddev) do
    1/2 * (1 + :math.erf((x - mean)/(stddev*:math.sqrt(2))))
  end
end
