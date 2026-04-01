defmodule ExComrakTest do
  use ExUnit.Case, async: true
  doctest ExComrak

  describe "to_html/1 (CommonMark)" do
    test "heading" do
      assert ExComrak.to_html("# Hello") == "<h1>Hello</h1>\n"
    end

    test "paragraph with bold and italic" do
      assert ExComrak.to_html("**bold** and _italic_") ==
               "<p><strong>bold</strong> and <em>italic</em></p>\n"
    end

    test "code block" do
      assert ExComrak.to_html("```\nfoo\n```") == "<pre><code>foo\n</code></pre>\n"
    end

    test "inline code" do
      assert ExComrak.to_html("`code`") == "<p><code>code</code></p>\n"
    end

    test "link" do
      assert ExComrak.to_html("[text](https://example.com)") ==
               "<p><a href=\"https://example.com\">text</a></p>\n"
    end

    test "unordered list" do
      assert ExComrak.to_html("- a\n- b\n- c") ==
               "<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n</ul>\n"
    end

    test "raw HTML is stripped in commonmark mode" do
      result = ExComrak.to_html("<script>alert(1)</script>")
      refute String.contains?(result, "<script>")
    end

    test "empty string" do
      assert ExComrak.to_html("") == ""
    end

    test "large document does not crash" do
      big = String.duplicate("# Heading\n\nParagraph text here.\n\n", 1000)
      result = ExComrak.to_html(big)
      assert String.contains?(result, "<h1>")
    end
  end

  describe "to_html/2 :gfm" do
    test "strikethrough" do
      assert ExComrak.to_html("~~strike~~", :gfm) == "<p><del>strike</del></p>\n"
    end

    test "table" do
      md = "| a | b |\n|---|---|\n| 1 | 2 |"
      result = ExComrak.to_html(md, :gfm)
      assert String.contains?(result, "<table>")
      assert String.contains?(result, "<th>a</th>")
      assert String.contains?(result, "<td>1</td>")
    end

    test "task list" do
      md = "- [x] done\n- [ ] todo"
      result = ExComrak.to_html(md, :gfm)
      assert String.contains?(result, ~s(checked=""))
      assert String.contains?(result, "done")
      assert String.contains?(result, "todo")
    end

    test "autolink" do
      result = ExComrak.to_html("Visit https://elixir-lang.org for more.", :gfm)
      assert String.contains?(result, ~s(href="https://elixir-lang.org"))
    end

    test "raw HTML is still stripped in :gfm mode" do
      result = ExComrak.to_html("<script>xss</script>", :gfm)
      refute String.contains?(result, "<script>")
    end

    test "footnote" do
      md = "Text[^1]\n\n[^1]: A footnote."
      result = ExComrak.to_html(md, :gfm)
      assert String.contains?(result, "footnote")
    end
  end

  describe "to_html/2 :gfm_unsafe" do
    test "raw HTML passes through" do
      result = ExComrak.to_html("<div class=\"foo\">content</div>", :gfm_unsafe)
      assert String.contains?(result, "<div")
      assert String.contains?(result, "content")
    end

    test "still renders markdown alongside raw HTML" do
      md = "**bold** and <em>raw em</em>"
      result = ExComrak.to_html(md, :gfm_unsafe)
      assert String.contains?(result, "<strong>bold</strong>")
      assert String.contains?(result, "<em>raw em</em>")
    end
  end

  describe "default mode is :commonmark" do
    test "to_html/1 and to_html/2 :commonmark produce the same output" do
      md = "# Title\n\nParagraph."
      assert ExComrak.to_html(md) == ExComrak.to_html(md, :commonmark)
    end
  end
end
