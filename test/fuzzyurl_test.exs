defmodule FuzzyurlTest do
  use ExUnit.Case, async: true
  doctest Fuzzyurl

  describe "new/8" do
    test "returns the correct Fuzzyurl" do
      fu = %Fuzzyurl{
        protocol: "1",
        username: "2",
        password: "3",
        hostname: "4",
        port: "5",
        path: "6",
        query: "7",
        fragment: "8"
      }

      assert Fuzzyurl.new("1", "2", "3", "4", "5", "6", "7", "8") == fu
    end
  end

  describe "new/0" do
    test "returns a blank Fuzzyurl" do
      assert %Fuzzyurl{} == Fuzzyurl.new()
    end
  end

  describe "new/1 with kwlist or map" do
    test "returns the correct Fuzzyurl" do
      fu = %Fuzzyurl{hostname: "example.com"}

      assert Fuzzyurl.new(hostname: "example.com") == fu
      assert Fuzzyurl.new(%{hostname: "example.com"}) == fu
    end
  end

  describe "from_string" do
    test "creates Fuzzyurl from string" do
      fu = %Fuzzyurl{protocol: "http", hostname: "example.com", path: "/index.html"}

      assert Fuzzyurl.from_string("http://example.com/index.html") == fu
    end

    test "raises on invalid input" do
      assert_raise ArgumentError, fn ->
        Fuzzyurl.from_string("http:\\\\blah")
      end
    end
  end

  describe "to_string" do
    test "creates string from Fuzzyurl" do
      fu = Fuzzyurl.new(protocol: "http", hostname: "example.com")

      assert Fuzzyurl.to_string(fu) == "http://example.com"
    end
  end

  describe "mask/0" do
    test "creates the correct Fuzzyurl" do
      fu = %Fuzzyurl{
        protocol: "*",
        username: "*",
        password: "*",
        hostname: "*",
        port: "*",
        path: "*",
        query: "*",
        fragment: "*"
      }

      assert Fuzzyurl.mask() == fu
    end
  end

  describe "mask/1" do
    test "creates the correct Fuzzyurl" do
      fu = %Fuzzyurl{
        protocol: "*",
        username: "*",
        password: "*",
        hostname: "example.com",
        port: "*",
        path: "*",
        query: "*",
        fragment: "*"
      }

      assert Fuzzyurl.mask(hostname: "example.com") == fu
      assert Fuzzyurl.mask(%{hostname: "example.com"}) == fu
    end
  end

  describe "with" do
    test "creates the correct Fuzzyurl" do
      fu = %Fuzzyurl{
        protocol: "*",
        username: "*",
        password: "*",
        hostname: "example.com",
        port: "*",
        path: "*",
        query: "*",
        fragment: "*"
      }

      fu2 = %Fuzzyurl{
        protocol: "http",
        username: "*",
        password: "*",
        hostname: "example.com",
        port: "*",
        path: "/foo",
        query: "*",
        fragment: "*"
      }

      assert Fuzzyurl.with(fu, protocol: "http", path: "/foo") == fu2
      assert Fuzzyurl.with(fu, %{protocol: "http", path: "/foo"}) == fu2
    end
  end

  describe "match" do
    test "is delegated" do
      assert Fuzzyurl.match(Fuzzyurl.mask(), Fuzzyurl.new()) == 0
    end
  end

  describe "matches?" do
    test "is delegated" do
      assert Fuzzyurl.matches?(Fuzzyurl.mask(), Fuzzyurl.new()) == true
    end
  end

  describe "match_scores" do
    test "is delegated" do
      assert Fuzzyurl.match_scores(Fuzzyurl.mask(), Fuzzyurl.new()) == %Fuzzyurl{
               fragment: 0,
               hostname: 0,
               password: 0,
               path: 0,
               port: 0,
               protocol: 0,
               query: 0,
               username: 0
             }
    end
  end

  describe "best_match" do
    test "is delegated" do
      assert Fuzzyurl.best_match([Fuzzyurl.mask()], Fuzzyurl.new()) == %Fuzzyurl{
               fragment: "*",
               hostname: "*",
               password: "*",
               path: "*",
               port: "*",
               protocol: "*",
               query: "*",
               username: "*"
             }
    end
  end

  describe "best_match_index" do
    test "is delegated" do
      assert Fuzzyurl.best_match_index([Fuzzyurl.mask()], Fuzzyurl.new()) == 0
    end
  end
end
