require 'uv'

class Typo
  class Textfilter
    class Ultraviolet < TextFilterPlugin::MacroPre
      plugin_display_name "Ultraviolet"
      plugin_description "Apply syntax highlighting to a code block using Ultraviolet"

      def self.help_text
        syntaxes, themes = [Uv.syntaxes, Uv.themes].map do |ary|
          ary.sort.map {|i| "* #{i.gsub('_', '\_')}" }.join("\n")
        end

        %{
This uses the [Ultraviolet](http://ultraviolet.rubyforge.org/) syntax highlighting engine. Options:

* **lang**. Sets the programming language. The default language is Ruby.
* **linenumber**. Turns on line numbering. Use `linenumber="true"` to enable.
* **theme**. Sets the theme. The default theme is Idle.

### Supported themes:
#{themes}

### Supported languages:
#{syntaxes}
}
      end

      def self.macrofilter(blog,content,attrib,params,text="")
        lang       = attrib['lang'] || 'ruby'
        theme      = attrib['theme'] || 'idle'
        linenumber = attrib['linenumber']

        text = text.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

        result = Uv.parse(text, 'xhtml', lang, linenumber, theme)

        set_whiteboard(blog, content, theme)

        "<notextile>#{result}</notextile>"
      end

      def self.set_whiteboard(blog, content, theme)
        content.whiteboard["page_header_ultraviolet_#{theme}"] = <<-HTML
          <link href="#{blog.base_url}/stylesheets/ultraviolet/#{theme}.css" media="all" rel="Stylesheet" type="text/css" />
        HTML
      end 
    end
  end
end
