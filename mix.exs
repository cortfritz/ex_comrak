defmodule ExComrak.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/cortfritz/ex_comrak"

  def project do
    [
      app: :ex_comrak,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "ExComrak",
      source_url: @source_url,
      docs: [
        main: "ExComrak",
        source_url: @source_url
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:rustler, "~> 0.36", runtime: false},
      {:rustler_precompiled, "~> 0.8"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Fast CommonMark and GitHub Flavored Markdown rendering via the comrak Rust crate. " <>
      "Precompiled NIF — no Rust toolchain needed."
  end

  defp package do
    [
      name: "ex_comrak",
      files: [
        "lib",
        "native/comrak_nif/src",
        "native/comrak_nif/Cargo.toml",
        "priv/native",
        "checksum-*.exs",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      maintainers: ["Cort Fritz"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Sponsor" => "https://github.com/sponsors/cortfritz"
      }
    ]
  end
end
