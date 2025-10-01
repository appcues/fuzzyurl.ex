defmodule Fuzzyurl.UrlSuiteTest do
  use ExUnit.Case, async: true

  @matches File.read!("./test/matches.json") |> JSON.decode!()

  describe "URL test suite" do
    test "handles all positive matches" do
      for [mask, url] <- @matches["positive_matches"] do
        assert Fuzzyurl.matches?(mask, url), "'#{mask}' should match '#{url}'"
      end
    end

    test "handles all negative matches" do
      for [mask, url] <- @matches["negative_matches"] do
        refute Fuzzyurl.matches?(mask, url), "'#{mask}' should not match '#{url}'"
      end
    end
  end
end
