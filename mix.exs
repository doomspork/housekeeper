defmodule Housekeeper.Mixfile do
  use Mix.Project

  def project do
    [
      app: :housekeeper,
      version: "1.0.0",
      elixir: "> 1.3.2",
      description: description(),
      package: package(),
      deps: deps(),
      dialyzer: [plt_apps: [:dialyzer, :elixir, :kernel, :mix, :stdlib]],
      name: "Housekeeper",
      source_url: "https://github.com/doomspork/housekeeper",
      homepage_url: "https://github.com/doomspork/housekeeper"
    ]
  end

  def application do
    [applications: [:dialyzer, :crypto, :mix]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    """
    Mix task to automagically clean your warnings
    """
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md"],
     maintainers: ["Sean Callan"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/doomspork/housekeeper"}]
  end
end
