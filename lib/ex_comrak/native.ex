defmodule ExComrak.Native do
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :ex_comrak,
    crate: "comrak_nif",
    base_url: "https://github.com/cortfritz/ex_comrak/releases/download/v#{version}",
    # Always build from source during development (before precompiled binaries are published).
    # After publishing v0.1.0 release with NIF binaries, flip this to:
    #   force_build: System.get_env("EXCOMRAK_BUILD") in ["1", "true"]
    force_build: true,
    version: version

  # When the NIF is loaded these are overridden.
  def render_commonmark(_markdown), do: :erlang.nif_error(:nif_not_loaded)
  def render_gfm(_markdown), do: :erlang.nif_error(:nif_not_loaded)
  def render_gfm_unsafe(_markdown), do: :erlang.nif_error(:nif_not_loaded)
end
