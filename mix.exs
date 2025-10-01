defmodule Fuzzyurl.Mixfile do
  use Mix.Project

  @version "1.0.1"

  def project do
    [
      app: :fuzzyurl,
      version: @version,
      elixir: "~> 1.12",
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix]
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      description: """
      Fuzzyurl is a library for non-strict parsing, construction, and
      fuzzy-matching of URLs.
      """,
      package: [
        maintainers: ["pete gamache"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/gamache/fuzzyurl.ex"}
      ]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.38", only: :dev},
      {:excoveralls, "~> 0.18", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
