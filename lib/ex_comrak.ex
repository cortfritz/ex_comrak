defmodule ExComrak do
  @moduledoc """
  Fast Markdown rendering via the [`comrak`](https://crates.io/crates/comrak) Rust crate.

  comrak is a CommonMark-compliant parser and renderer with full GitHub Flavored
  Markdown (GFM) extension support. It is used in production by GitHub and others.

  ## Modes

  | Mode | Description |
  |------|-------------|
  | `:commonmark` (default) | Strict CommonMark spec — no extensions |
  | `:gfm` | GitHub Flavored Markdown — adds tables, strikethrough, autolinks, task lists, tag filtering |
  | `:gfm_unsafe` | GFM + raw HTML passthrough (use only for trusted content) |

  ## Examples

      iex> ExComrak.to_html("# Hello")
      "<h1>Hello</h1>\\n"

      iex> ExComrak.to_html("~~strike~~", :gfm)
      "<p><del>strike</del></p>\\n"

      iex> ExComrak.to_html("| a | b |\\n|---|---|\\n| 1 | 2 |", :gfm)
      "<table>\\n<thead>\\n<tr>\\n<th>a</th>\\n<th>b</th>\\n</tr>\\n</thead>\\n<tbody>\\n<tr>\\n<td>1</td>\\n<td>2</td>\\n</tr>\\n</tbody>\\n</table>\\n"

      iex> ExComrak.to_html("<div>raw</div>", :gfm_unsafe)
      "<div>raw</div>\\n"
  """

  alias ExComrak.Native

  @type mode :: :commonmark | :gfm | :gfm_unsafe

  @doc """
  Renders a Markdown string to HTML.

  ## Arguments

  - `markdown` — the Markdown source as a binary string
  - `mode` — rendering mode (default `:commonmark`)

  ## Modes

  - `:commonmark` — CommonMark spec, no extensions, raw HTML stripped
  - `:gfm` — GitHub Flavored Markdown: tables, strikethrough, autolinks,
    task lists, footnotes, tag-filtered HTML
  - `:gfm_unsafe` — GFM with raw HTML allowed through unchanged.
    **Only use for trusted input** — user-supplied content must use `:gfm`.

  ## Examples

      iex> ExComrak.to_html("**bold**")
      "<p><strong>bold</strong></p>\\n"

      iex> ExComrak.to_html("- [x] done\\n- [ ] todo", :gfm)
      "<ul>\\n<li><input type=\\"checkbox\\" checked=\\"\\" disabled=\\"\\" /> done</li>\\n<li><input type=\\"checkbox\\" disabled=\\"\\" /> todo</li>\\n</ul>\\n"
  """
  @spec to_html(String.t(), mode()) :: String.t()
  def to_html(markdown, mode \\ :commonmark)

  def to_html(markdown, :commonmark) when is_binary(markdown) do
    Native.render_commonmark(markdown)
  end

  def to_html(markdown, :gfm) when is_binary(markdown) do
    Native.render_gfm(markdown)
  end

  def to_html(markdown, :gfm_unsafe) when is_binary(markdown) do
    Native.render_gfm_unsafe(markdown)
  end
end
