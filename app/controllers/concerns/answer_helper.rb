# Namespace for answer helper methods
module AnswerHelper
  # Return html string with new url class added to anchor tags
  # @param [String] String of html
  # @example "<p>Here is example html with an example link <a href>www.example.com</a></p>" returns "<p>Here is example html with an example link <a href class=\"url\">www.example.com</a></p>"
  def self.add_url_class_to_anchors(html)
    parsed_html = parse_html(html)
    href_attributes = extract_href_attributes(parsed_html)
    anchor_tags = anchor_tags_hash(href_attributes)
    anchor_tags.each { |original_anchor_tag, new_anchor_tag| html.gsub!(original_anchor_tag, new_anchor_tag) }
    html
  end

  # Return parsed html as Nokogiri::HTML::Document
  # @param [String] String of html
  # @example "<p>Here is example html with an example link <a href>www.example.com</a></p>" returns Nokogiri::HTML::Document object
  def self.parse_html(html)
    Nokogiri::HTML.parse(html)
  end

  # Extract href attributes from Nokogiri::HTML::Document
  # @param [Nokogiri::HTML::Document] Nokogiri::HTML::Document object
  # @example Nokogiri::HTML::Document returns Nokogiri::XML::NodeSet object
  def self.extract_href_attributes(parsed_html)
    parsed_html.xpath('//a[@href]')
  end

  # Return a hash with keys of original anchor tag strings and values of new anchor tag strings
  # @param [Nokogiri::XML::NodeSet] Nokogiri::XML::NodeSet object
  # @example Nokogiri::XML::NodeSet object returns { "<a href>www.example.com</a>" => "<a href class=\"url\">www.example.com</a>" }
  def self.anchor_tags_hash(href_attributes)
    anchor_tags = {}
    href_attributes.each do |original_tag|
      key = original_tag.to_s
      anchor_tags[key] = new_tag_class(original_tag)
    end
    anchor_tags
  end

  # Return a string of anchor tag with new url class added
  # @param [Nokogiri::XML::NodeSet] Nokogiri::XML::NodeSet object
  # @example Nokogiri::XML::NodeSet object returns "<a href class=\"url\">www.example.com</a>"
  def self.new_tag_class(tag)
    tag['class'] = 'url'
    tag.to_s
  end
end
