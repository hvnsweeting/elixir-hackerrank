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

  test "Qualtiles of 3 7 8 5 12 14 21 13 18 is 6, 12, 16" do
    qs = Stats.quantiles([3,7,8,5,12,14,21,13,18])
    assert qs|> Tuple.to_list |> Enum.all?(&Kernel.is_integer/1) == true
    assert qs == {6, 12, 16}
  end

  test "Standard deviation of 10 40 30 50 20 is 14.1" do
    assert Stats.stdev([10, 40, 30, 50, 20]) == 14.1
  end

  test "solve sample 64630 11735 14216 99233 14470 4978 73429 38120 51135 67060" do
    s = "64630 11735 14216 99233 14470 4978 73429 38120 51135 67060"
    assert Stats.solve(s) == {43900.6, 44627.5, 4978}
  end

end
