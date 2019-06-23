defmodule FourLucha.MixProject do
  use Mix.Project

  def project do
    [
      app: :four_lucha,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "FourLucha",
      source_url: "https://github.com/Thomas-Jean/four_lucha",
      docs: [
        # The main page in the docs
        main: "readme",
        api_reference: false,
        extras: ["README.md"]
      ],
      package: package()
    ]
  end

  defp package() do
    [
      description: "Giant Bomb API Client With Automatic Client-Side Caching",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/Thomas-Jean/four_lucha"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FourLucha.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:cachex, "~> 3.3"},
      {:exvcr, "~> 0.11", only: :test},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
