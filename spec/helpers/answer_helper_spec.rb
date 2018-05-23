require_relative '../rails_helper'

RSpec.describe AnswerHelper do
  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  context 'with one or more anchor tags in the html' do
    let(:html) { '<p>Here is example html with an example link <a href>www.example.com</a></p>. Here is another link <a href>www.example2.com</a></p>' }
    let(:parsed_html) { subject.parse_html(html) }
    let(:href_attributes) { subject.extract_href_attributes(parsed_html) }

    describe '#parse_html' do
      it 'returns a Nokogiri HTML Document' do
        expect(parsed_html.class).to eq(Nokogiri::HTML::Document)
      end
    end

    describe '#extract_href_attributes' do
      it 'returns a Nokogiri XML NodeSet' do
        expect(href_attributes.class).to eq(Nokogiri::XML::NodeSet)
      end

      it 'stores the href tags' do
        expect(href_attributes[0].to_s).to eq('<a href>www.example.com</a>')
        expect(href_attributes[1].to_s).to eq('<a href>www.example2.com</a>')
      end
    end

    describe '#new_tag_class' do
      let(:tag) { href_attributes.first }

      it 'adds a new class to the tag' do
        expect(subject.new_tag_class(tag)).to eq("<a href class=\"url\">www.example.com</a>")
      end
    end

    describe '#href_tags_hash' do
      let(:anchor_tags) { subject.anchor_tags_hash(href_attributes) }

      it 'returns a hash with key of original tag' do
        expect(anchor_tags.keys[0]).to eq('<a href>www.example.com</a>')
        expect(anchor_tags.keys[1]).to eq('<a href>www.example2.com</a>')
      end

      it 'returns a hash with value of new tag with url class added' do
        expect(anchor_tags.values[0]).to eq("<a href class=\"url\">www.example.com</a>")
        expect(anchor_tags.values[1]).to eq("<a href class=\"url\">www.example2.com</a>")
      end
    end

    describe '#add_url_class_to_anchors' do
      it 'returns a version of html with new class added to anchors' do
        expect(subject.add_url_class_to_anchors(html)).to eq("<p>Here is example html with an example link <a href class=\"url\">www.example.com</a></p>. Here is another link <a href class=\"url\">www.example2.com</a></p>")
      end
    end
  end

  context 'with no anchors in the html' do
    describe '#add_url_class_to_anchors' do
      let(:html) { '<p>Here is example html with no links</p>' }

      it 'returns a version of html with no class added to anchors' do
        expect(subject.add_url_class_to_anchors(html)).to eq('<p>Here is example html with no links</p>')
      end
    end
  end
end
