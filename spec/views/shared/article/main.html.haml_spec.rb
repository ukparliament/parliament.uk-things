require 'rails_helper'

RSpec.describe 'shared/article/_main' do
  let!(:content) { '__This__ is some content' }

  before(:each) do
    render partial: 'shared/article/main', locals: { content: content }
  end

  context 'converted to HTML' do
    it 'will render the content correctly' do
      expect(rendered).to match(/<p><strong>This<\/strong> is some content<\/p>/)
    end
  end

  context 'sanitize' do
    let!(:content)  { '<script>__This__ is some body text</script>' }

    it 'will render the sanitized article body correctly' do
      expect(rendered).to match(/<p><strong>This<\/strong> is some body text<\/p>/)
    end
  end
end
