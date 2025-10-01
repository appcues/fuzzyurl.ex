defmodule Fuzzyurl.ProtocolsTest do
  use ExUnit.Case, async: true
  import Fuzzyurl.Protocols
  doctest Fuzzyurl.Protocols

  describe "get_port" do
    test "gets port by protocol" do
      assert get_port("http") == "80"
      assert get_port("ssh") == "22"
      assert get_port("git+ssh") == "22"
      assert get_port(nil) == nil
    end
  end

  describe "get_protocol" do
    test "gets protocol by port" do
      assert get_protocol("80") == "http"
      assert get_protocol(80) == "http"
      assert get_protocol(nil) == nil
    end
  end
end
