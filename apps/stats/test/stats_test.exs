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

  test "solve sample 64630 11735 14216 99233 14470 4978 73429 38120 51135 67060" do
    s = "64630 11735 14216 99233 14470 4978 73429 38120 51135 67060"
    assert Stats.solve(s) == {43900.6, 44627.5, 4978}
  end

end
