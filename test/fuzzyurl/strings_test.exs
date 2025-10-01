defmodule Fuzzyurl.StringsTest do
  use ExUnit.Case, async: true
  doctest Fuzzyurl.Strings

  describe "from_string" do
    import Fuzzyurl.Strings, only: [from_string: 1]

    test "handles simple URLs" do
      assert {:ok, _} = from_string("http://example.com")
      assert {:ok, _} = from_string("ssh://user:pass@host")
      assert {:ok, _} = from_string("https://example.com:443/omg/lol")
      assert {:ok, _} = from_string("")
    end

    test "rejects bullshit" do
      assert {:error, _} = from_string(nil)
      assert {:error, _} = from_string(22)
    end

    test "handles rich URLs" do
      assert {:ok, fu} =
               from_string(
                 "http://user_1:pass%20word@foo.example.com:8000/some/path?awesome=true&encoding=ebcdic#/hi/mom"
               )

      assert fu.protocol == "http"
      assert fu.username == "user_1"
      assert fu.password == "pass%20word"
      assert fu.hostname == "foo.example.com"
      assert fu.port == "8000"
      assert fu.path == "/some/path"
      assert fu.query == "awesome=true&encoding=ebcdic"
      assert fu.fragment == "/hi/mom"
    end
  end

  describe "to_string" do
    test "handles simple URLs" do
      assert Fuzzyurl.Strings.to_string(%Fuzzyurl{hostname: "example.com"}) == "example.com"

      assert Fuzzyurl.Strings.to_string(%Fuzzyurl{protocol: "http", hostname: "example.com"}) ==
               "http://example.com"

      assert Fuzzyurl.Strings.to_string(%Fuzzyurl{
               protocol: "http",
               hostname: "example.com",
               path: "/oh/yeah"
             }) == "http://example.com/oh/yeah"
    end

    test "handles rich URLs" do
      fu = %Fuzzyurl{
        protocol: "https",
        username: "usah",
        password: "pash",
        hostname: "api.example.com",
        port: "443",
        path: "/secret/endpoint",
        query: "admin=true",
        fragment: "index"
      }

      assert Fuzzyurl.Strings.to_string(fu) ==
               "https://usah:pash@api.example.com:443/secret/endpoint?admin=true#index"
    end
  end
end
