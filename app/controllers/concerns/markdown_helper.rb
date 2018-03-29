module MarkdownHelper
  # Uses redcarpet gem to convert markdown into HTML, with chosen HTML extensions
  #
  # @return template [String] Template as HTML
  def self.markdown(template)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    html = markdown.render(ActionController::Base.helpers.sanitize(template))
    ActionController::Base.helpers.sanitize(html).html_safe
  end
end
