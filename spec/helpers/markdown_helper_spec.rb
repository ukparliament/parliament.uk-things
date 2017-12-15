require_relative '../rails_helper'

RSpec.describe MarkdownHelper do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  describe '#markdown' do
    it 'converts markdown to HTML' do
      text = 'You can submit an oral question online using [e-tabling](https://etabling.parliament.uk/)'
      expect(subject.markdown(text)).to match('<p>You can submit an oral question online using <a href=\"https://etabling.parliament.uk/\">e-tabling</a></p>')
    end
  end
end
