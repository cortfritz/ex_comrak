# ExComrak

[![Hex.pm](https://img.shields.io/hexpm/v/ex_comrak.svg)](https://hex.pm/packages/ex_comrak)
[![Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/ex_comrak)
[![CI](https://github.com/cortfritz/ex_comrak/actions/workflows/release.yml/badge.svg)](https://github.com/cortfritz/ex_comrak/actions/workflows/release.yml)
[![License](https://img.shields.io/hexpm/l/ex_comrak.svg)](https://github.com/cortfritz/ex_comrak/blob/main/LICENSE)

Fast, spec-complete Markdown rendering for Elixir via the
[`comrak`](https://crates.io/crates/comrak) Rust crate.

**Precompiled NIF — no Rust toolchain needed in production.**

comrak passes 100% of the CommonMark spec tests and the GFM spec. It is used
in production by GitHub and is actively maintained. This library wraps it with
a minimal, idiomatic Elixir API.

## Why ExComrak?

Pure Elixir Markdown parsers (`earmark`, `md`) work well for small documents.
For large documents — documentation sites, CMS content, API responses serving
many users — a native parser is significantly faster and fully spec-compliant.

| | ExComrak | Earmark |
|---|---|---|
| CommonMark compliant | ✅ 100% | ~90% |
| GitHub Flavored Markdown | ✅ Full | Partial |
| Large doc performance | ✅ Native | Pure Elixir |
| No Rust in production | ✅ Precompiled | N/A |
| BEAM scheduler safe | ✅ Dirty CPU | N/A |

## Installation

```elixir
def deps do
  [
    {:ex_comrak, "~> 0.1"}
  ]
end
```

No Rust toolchain required — precompiled binaries are provided for all common
platforms (macOS Apple Silicon, macOS Intel, Linux x86_64, Linux ARM64, Windows).

## Usage

```elixir
# CommonMark (default) — strict spec, no extensions
ExComrak.to_html("# Hello, world!")
#=> "<h1>Hello, world!</h1>\n"

# GitHub Flavored Markdown
ExComrak.to_html("~~strikethrough~~", :gfm)
#=> "<p><del>strikethrough</del></p>\n"

ExComrak.to_html("| Name | Value |\n|------|-------|\n| foo  | 42    |", :gfm)
#=> "<table>\n<thead>..."

ExComrak.to_html("- [x] Done\n- [ ] Todo", :gfm)
#=> "<ul>\n<li><input type=\"checkbox\" checked=\"\" disabled=\"\" /> Done</li>..."

ExComrak.to_html("Visit https://elixir-lang.org for more.", :gfm)
#=> "<p>Visit <a href=\"https://elixir-lang.org\">https://elixir-lang.org</a> for more.</p>\n"

# GFM with raw HTML passthrough (trusted content only)
ExComrak.to_html("<div class=\"callout\">Note</div>", :gfm_unsafe)
#=> "<div class=\"callout\">Note</div>\n"
```

## Modes

| Mode | Description |
|------|-------------|
| `:commonmark` (default) | Strict [CommonMark](https://commonmark.org) spec. Raw HTML stripped. |
| `:gfm` | [GitHub Flavored Markdown](https://github.github.com/gfm/): tables, strikethrough, autolinks, task lists, footnotes, tag-filtered HTML. Raw HTML stripped — safe for user-supplied content. |
| `:gfm_unsafe` | GFM + raw HTML passthrough unchanged. **Only use for content you fully trust.** |

### GFM extensions enabled in `:gfm` / `:gfm_unsafe`

| Extension | Example |
|-----------|---------|
| Tables | `\| col \| col \|` |
| Strikethrough | `~~text~~` |
| Task lists | `- [x] done` |
| Autolinks | bare URLs auto-linked |
| Footnotes | `text[^1]` / `[^1]: note` |
| Tag filter | `<script>` and dangerous tags stripped |

## BEAM safety

All three NIF functions run on **dirty CPU schedulers** (`schedule = "DirtyCpu"`).
Large documents do not block the BEAM scheduler or affect latency for other
processes.

## Building from source

Precompiled binaries are provided for:

- `aarch64-apple-darwin` (macOS Apple Silicon)
- `x86_64-apple-darwin` (macOS Intel)
- `x86_64-unknown-linux-gnu` (Linux x86_64)
- `aarch64-unknown-linux-gnu` (Linux ARM64)
- `x86_64-pc-windows-msvc` (Windows)
- `x86_64-pc-windows-gnu` (Windows MinGW)

To build from source instead:

```bash
EXCOMRAK_BUILD=1 mix deps.get
```

Requires a Rust toolchain: https://rustup.rs

## Related projects

Part of a family of Elixir NIFs wrapping focused Rust libraries:

- [`ex_mgrs`](https://hex.pm/packages/ex_mgrs) — MGRS ↔ lat/lon coordinate conversion
- [`ex_rstar`](https://hex.pm/packages/ex_rstar) — R\*-tree spatial indexing (nearest neighbour, envelope, radius queries)

## License

MIT — see [LICENSE](LICENSE).

## Sponsorship

If this library saves you time, consider [sponsoring](https://github.com/sponsors/cortfritz). ☕
