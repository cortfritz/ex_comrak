use comrak::{markdown_to_html, Options};

/// CommonMark — strict spec, no extensions, raw HTML stripped.
#[rustler::nif(schedule = "DirtyCpu")]
fn render_commonmark(markdown: String) -> String {
    markdown_to_html(&markdown, &Options::default())
}

/// GitHub Flavored Markdown — tables, strikethrough, autolinks, task lists,
/// footnotes, tag-filtered HTML. Raw HTML is stripped (safe for user input).
#[rustler::nif(schedule = "DirtyCpu")]
fn render_gfm(markdown: String) -> String {
    markdown_to_html(&markdown, &gfm_options(false))
}

/// GFM + raw HTML passthrough. Only use for trusted content.
#[rustler::nif(schedule = "DirtyCpu")]
fn render_gfm_unsafe(markdown: String) -> String {
    markdown_to_html(&markdown, &gfm_options(true))
}

fn gfm_options(allow_raw_html: bool) -> Options<'static> {
    let mut opts = Options::default();
    opts.extension.strikethrough = true;
    opts.extension.tagfilter = true;
    opts.extension.table = true;
    opts.extension.autolink = true;
    opts.extension.tasklist = true;
    opts.extension.footnotes = true;
    opts.render.r#unsafe = allow_raw_html;
    opts
}

rustler::init!("Elixir.ExComrak.Native");
