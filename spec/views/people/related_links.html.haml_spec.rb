require 'rails_helper'

RSpec.describe 'people/_related_links' do

  context 'weblinks' do
    context 'is present and person is an MP' do
      before do
        assign(:person,
          double(:person,
            current_mp?: true,
            weblinks?: true,
            personal_weblinks: ['http://www.example.com'],
            twitter_weblinks: ['https://www.twitter.com/doesnotexists'],
            facebook_weblinks: ['https://www.facebook.com/doesnotexists']
          )
        )

        render
      end

      it 'will render section' do
        expect(rendered).to match(/Related links/)
      end

      context 'has personal weblinks' do
        it 'will render link to personal website' do
          expect(rendered).to have_link('http://www.example.com', href: 'http://www.example.com')
        end
      end

      context 'has twitter weblinks' do
        it 'will render link to twitter website' do
          expect(rendered).to have_link('https://www.twitter.com/doesnotexists', href: 'https://www.twitter.com/doesnotexists')
        end
      end

      context 'has facebook weblinks' do
        it 'will render link to facebook website' do
          expect(rendered).to have_link('https://www.facebook.com/doesnotexists', href: 'https://www.facebook.com/doesnotexists')
        end
      end
    end

    context 'is present and person is an Lord' do
      before do
        assign(:person,
          double(:person,
            current_mp?: false,
            current_lord?: true,
            weblinks?: true,
            personal_weblinks: ['http://www.example.com'],
            twitter_weblinks: ['https://www.twitter.com/doesnotexists'],
            facebook_weblinks: ['https://www.facebook.com/doesnotexists']
          )
        )

        render
      end

      it 'will not render section' do
        expect(rendered).not_to match(/Related links/)
      end

      context 'has personal weblinks' do
        it 'will not render link to personal website' do
          expect(rendered).not_to have_link('http://www.example.com', href: 'http://www.example.com')
        end
      end

      context 'has twitter weblinks' do
        it 'will not render link to twitter website' do
          expect(rendered).not_to have_link('https://www.twitter.com/doesnotexists', href: 'https://www.twitter.com/doesnotexists')
        end
      end

      context 'has facebook weblinks' do
        it 'will not render link to facebook website' do
          expect(rendered).not_to have_link('https://www.facebook.com/doesnotexists', href: 'https://www.facebook.com/doesnotexists')
        end
      end
    end

    context 'is not present' do
      before do
        assign(:person,
          double(:person,
            current_mp?: true,
            weblinks?: false
          )
        )

        render
      end

      it 'will not render section' do
        expect(rendered).not_to match(/Related links/)
      end
    end
  end

  context 'image id' do
    context 'is present' do
      before do
        assign(:person,
          double(:person,
            current_mp?: true,
            weblinks?: false,
            image_id: 'XXXXXXXX',
            full_name: 'Test Name',
            personal_weblinks: [],
            twitter_weblinks: [],
            facebook_weblinks: []
          )
        )
        assign(:most_recent_incumbency,
          double(:most_recent_incumbency,
            house: double(:house, name: 'House of Commons')
          )
        )

        allow(Pugin::Feature::Bandiera).to receive(:show_list_images?).and_return(true)

        render
      end

      it 'will render link to media_path' do
        expect(rendered).to have_link('available to download', href: media_show_path('XXXXXXXX'))
      end
    end

    context 'is not present' do
      before do
        assign(:person,
          double(:person,
            current_mp?: true,
            weblinks?: true,
            image_id: false,
            full_name: 'Test Name',
            personal_weblinks: [],
            twitter_weblinks: [],
            facebook_weblinks: []
          )
        )

        allow(Pugin::Feature::Bandiera).to receive(:show_list_images?).and_return(true)

        render
      end

      it 'will not render link to media_path' do
        expect(rendered).not_to have_link('available to download', href: media_show_path('XXXXXXXX'))
      end
    end
  end

end
