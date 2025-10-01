defmodule Fuzzyurl.MatchTest do
  use ExUnit.Case, async: true
  import Fuzzyurl.Match
  doctest Fuzzyurl.Match

  describe "fuzzy_match" do
    test "returns 0 for full wildcard" do
      assert fuzzy_match("*", "lol") == 0
      assert fuzzy_match("*", "*") == 0
      assert fuzzy_match("*", nil) == 0
    end

    test "returns 1 for exact match" do
      assert fuzzy_match("asdf", "asdf") == 1
    end

    test "handles *.example.com" do
      assert fuzzy_match("*.example.com", "api.v1.example.com") == 0
      assert fuzzy_match("*.example.com", "example.com") == nil
    end

    test "handles **.example.com" do
      assert fuzzy_match("**.example.com", "api.v1.example.com") == 0
      assert fuzzy_match("**.example.com", "example.com") == 0
      assert fuzzy_match("**.example.com", "zzzexample.com") == nil
    end

    test "handles path/*" do
      assert fuzzy_match("path/*", "path/a/b/c") == 0
      assert fuzzy_match("path/*", "path") == nil
    end

    test "handles path/**" do
      assert fuzzy_match("path/**", "path/a/b/c") == 0
      assert fuzzy_match("path/**", "path") == 0
      assert fuzzy_match("path/**", "pathzzz") == nil
    end

    test "returns nil for bad matches with no wildcards" do
      assert fuzzy_match("asdf", "oh no") == nil
    end
  end

  describe "match" do
    test "returns 0 for full wildcard" do
      assert match(Fuzzyurl.mask(), Fuzzyurl.new()) == 0
    end

    test "returns 8 for full exact match" do
      fu = Fuzzyurl.new("a", "b", "c", "d", "e", "f", "g", "h")

      assert match(fu, fu) == 8
    end

    test "returns 1 for one exact match" do
      mask = %{Fuzzyurl.mask() | hostname: "example.com"}
      url = %Fuzzyurl{hostname: "example.com", protocol: "http", path: "/index.html"}

      assert match(mask, url) == 1
    end

    test "infers protocol from port" do
      mask = %{Fuzzyurl.mask() | port: "80"}
      url = %Fuzzyurl{protocol: "http"}

      assert match(mask, url) == 1
      assert match(mask, %Fuzzyurl{url | port: "443"}) == nil
    end

    test "infers port from protocol" do
      mask = %{Fuzzyurl.mask() | protocol: "https"}
      url = %Fuzzyurl{port: "443"}

      assert match(mask, url) == 1
      assert match(mask, %Fuzzyurl{url | protocol: "http"}) == nil
    end
  end

  describe "matches?" do
    test "returns true on matches" do
      assert matches?(Fuzzyurl.mask(), Fuzzyurl.new()) == true
    end

    test "returns false on non-matches" do
      assert matches?(Fuzzyurl.mask(port: "666"), Fuzzyurl.new()) == false
    end
  end

  describe "match_scores" do
    test "returns all zeroes for full wildcard" do
      scores =
        match_scores(Fuzzyurl.mask(), Fuzzyurl.new())
        |> Map.from_struct()
        |> Map.values()

      assert Enum.any?(scores, fn x -> x != 0 end) == false
    end
  end
end
