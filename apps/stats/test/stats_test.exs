defmodule StatsTest do
  use ExUnit.Case
  doctest Stats

  test "mean of 1 2 3 4 is 2.5" do
    assert Stats.mean([1,2,3,4]) == 2.5
  end
  test "mean of 1 3 6 is 3.3" do
    assert Stats.mean([1,3,6]) == 3.3
  end

  test "median of 1 3 2 is 2" do
    assert Stats.median([1,3,2]) == 2
  end

  test "median of 1 4 2 3 is 2.5" do
    assert Stats.median([1,4,2,3]) == 2.5
  end

  test "mode of 1 3 2 2 2 is 2" do
    assert Stats.mode([1,3,2,2,2]) == 2
  end

  test "mode of 1 3 3 2 2 is 2, as the smallest" do
    assert Stats.mode([1,3,3,2,2]) == 2
  end
  test "weighted mean of 10 40 30 50 20 w 1 2 3 4 5 is 32.0" do
    assert Stats.weighted_mean([10, 40, 30, 50, 20], \
            [1, 2, 3, 4, 5]) == 32.0
  end

  test "Quartiles of 3 7 8 5 12 14 21 13 18 is 6, 12, 16" do
    qs = Stats.quartiles([3,7,8,5,12,14,21,13,18])
    assert qs == {6, 12, 16}
  end

  test "Quartile dataset" do
    assert Stats.quartiles([6, 12, 8, 10 , 20, 16], [5, 4, 3, 2, 1, 5]) == {7.0, 11.0, 16.0}
  end
  test "Interquartile range of 6 12 8 10 20 16, freqs: 5 4 3 2 1 5\
        is 9.0" do
    iqr = Stats.interquartile_range([6, 12, 8, 10 , 20, 16], [5, 4, 3, 2, 1, 5])
    assert is_float(iqr)
    assert iqr == 9.0
  end

  test "Interquartile range of last testcase is 30.0" do
    iqr = Stats.interquartile_range([10,40,30,50,20], [1,2,3,4,5])
    assert iqr == 30.0
  end

  test "take 0 from [1,2,3], freqs: [4,4,4] is 1" do
    assert Stats.take([1,2,3], [4, 4, 4], 0) == 1
  end

  test "take 3 from [1,2,3], freqs: [4,4,4] is 1" do
    assert Stats.take([1,2,3], [4, 4, 4], 3) == 1
  end

  test "take 4 from [1,2,3], freqs: [4,4,4] is 2" do
    assert Stats.take([1,2,3], [4, 4, 4], 4) == 2
  end

  test "take 5 from [1,2,3], freqs: [4,4,4] is 2" do
    assert Stats.take([1,2,3], [4, 4, 4], 5) == 2
  end

  test "quartile index" do
    assert Stats.quartiles_index([4, 4, 4]) == [{2,3}, {5, 6}, {8,9}]
  end
  test "quartile index odd" do
    assert Stats.quartiles_index([4, 1, 4]) == [{1, 2}, {4, 4}, {6,7}]
  end

  test "median are same " do
    dataset = Stats.gen_dataset([6,12,8,10,20,16], [5,4,3,2,1,5])
    assert Stats.median([6,12,8,10,20,16], [5,4,3,2,1,5]) == Stats.median(dataset)
  end

  test "Standard deviation of 10 40 30 50 20 is 14.1" do
    assert Stats.stdev([10, 40, 30, 50, 20]) == 14.1
  end

  test "2 to the power of 3 is 8" do
    assert Stats.pow(2, 3) == 8
    assert Stats.pow(2, 4) == 16
  end

  test "Poisson(3, 2) is 0.180" do
    assert Float.round(Stats.poisson_prob(3, 2), 3) == 0.18
  end
  test "Poisson(5, 2.5) is 0.067" do
    assert Float.round(Stats.poisson_prob(5, 2.5), 3) == 0.067
  end

  @doc """
  https://www.hackerrank.com/challenges/s10-poisson-distribution-2
  """
  test "Expectation of X squared" do
    assert Float.round(160 + 40 * (0.88 + (0.88 * 0.88)), 3) == 226.176
    assert Float.round(128 + 40 * (1.55 + (1.55 * 1.55)), 3) == 286.1
  end

  @doc """
  https://www.hackerrank.com/challenges/s10-normal-distribution-1/tutorial
  """
  test "The cumulative distribution function of X - norm dist " do
    assert Float.round(Stats.normal_dist_func(19.5, 20, 2), 3) == 0.401
    assert Float.round(Stats.normal_dist_func(22, 20, 2) - Stats.normal_dist_func(20, 20, 2), 3) == 0.341
  end

  @doc """
  https://www.hackerrank.com/challenges/s10-normal-distribution-2
  """
  test "The cumulative distribution function of X - norm dist 2" do
    assert Float.round(100*(1-Stats.normal_dist_func(80, 70, 10)), 2) == 15.87
    assert Float.round(100*(1-Stats.normal_dist_func(60, 70, 10)), 2) == 84.13
    assert Float.round(100*(Stats.normal_dist_func(60, 70, 10)), 2) == 15.87
  end

end
