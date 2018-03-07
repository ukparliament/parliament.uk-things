module MarkdownHelper
  # Uses redcarpet gem to convert markdown into HTML, with chosen HTML extensions
  #
  # @return template [String] Template as HTML
  def self.markdown(template)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    markdown.render(template)
  end
end
