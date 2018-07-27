require 'rails_helper'

RSpec.describe 'people/show', vcr: true do
  constituency_graph_id     = 'MtbjxRrE'
  house_of_commons_graph_id = 'KL2k1BGP'
  house_of_lords_graph_id   = 'm1EgVTLj'
  government_graph_id       = 'NprsWxpz'
  opposition_graph_id       = ''
  context 'header' do
    before do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_title:     'Test Title',
          full_name:      'Test Full Name',
          given_name:     'Test',
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          image_id:       '12345678',
          current_mp?:    true,
          current_lord?:  false,
          mnis_id:        '1357',
          weblinks?:      false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))

      render
    end

    it 'will render the display name' do
      expect(rendered).to match(/Test Display Name/)
    end
  end

  context 'activity links' do
    before :each do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_title:     'Test Title',
          full_name:      'Test Full Name',
          given_name:     'Test',
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          image_id:       '12345678',
          current_mp?:    true,
          current_lord?:  false,
          mnis_id:        '1357',
          weblinks?:      false
        )
      )
      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))

      allow(Pugin::Feature::Bandiera).to receive(:show_activity_links?).and_return(true)
      render
    end

    it 'will render an activity link' do
      expect(rendered).to match('This is our beta website, pages are being tested and improved. You can view <a href="http://www.parliament.uk/biographies/Commons/member/1357">a version of this page</a> on the current website.')
    end
  end

  context '@most_recent_incumbency' do
    before do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_title:     'Test Title',
          full_name:      'Test Full Name',
          given_name:     'Test',
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          image_id:       '12345678',
          current_mp?:    true,
          current_lord?:  false,
          weblinks?:      false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
    end

    context 'nil' do
      before do
        assign(:most_recent_incumbency, nil)
        render
      end

      it 'will render full name and display name' do
        expect(rendered).to match(/Test Full Name/)
      end

      it 'will render display name' do
        expect(rendered).to match(/Test Display Name/)
      end
    end

    context 'is not nil' do
      context 'house is House of Commons' do
        before do
          assign(:most_recent_incumbency,
            double(:most_recent_incumbency,
              house: double(:house, name: 'House of Commons')))
          render
        end

        it 'will not render full name and title' do
          expect(rendered).not_to match(/Test Title/)
        end
      end

      context 'house is House of Lords' do
        before do
          assign(:most_recent_incumbency,
            double(:most_recent_incumbency,
              house: double(:house, name: 'House of Lords')))

          render
        end

        it 'will render full name' do
          expect(rendered).to match(/Test Full Name/)
        end

        it 'will render display name' do
          expect(rendered).to match(/Test Display Name/)
        end
      end
    end
  end

  context 'persons status' do
    before do
      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
      assign(:seat_incumbencies, [])
      assign(:most_recent_incumbency, nil)
    end

    context 'house membership status is empty' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: [] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:     true,
            weblinks?:       false))

        render
      end

      it 'will not render status info' do
        expect(rendered).not_to match(/MP for/)
      end

      it 'will render link to house_members_current_a_z_letter_path' do
        expect(rendered).not_to have_link('All current MPs', href: house_members_current_a_z_letter_path(house_of_commons_graph_id, 'a'))
      end
    end

    context 'person is an MP' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:    true,
            current_lord?:  false,
            weblinks?:      false))

        render
      end

      it 'will not render status info' do
        expect(rendered).to match(/MP for/)
      end

      it 'will render link to constituency' do
        expect(rendered).to have_link('Aberavon', href: constituency_path(constituency_graph_id))
      end

      context 'person is former Lord' do
        before do
          assign(:person,
            double(:person,
              display_name:   'Test Display Name',
              full_title:     'Test Title',
              full_name:      'Test Full Name',
              given_name:     'Test',
              gender_pronoun: 'She',
              image_id:       '12345678',
              statuses:       { house_membership_status: ['Current MP', 'Former Lord'] },
              current_mp?:    true,
              current_lord?:  false,
              weblinks?:      false))

          render
        end
      end

      context 'person is not a former Lord' do
        it 'will not render link to house_members_a_z_letter_path' do
          expect(rendered).not_to have_link('All Lords', href: house_members_a_z_letter_path(house_of_lords_graph_id, 'a'))
        end
      end
    end

    context 'person is a Lord' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            image_id:       '12345678',
            statuses:       { house_membership_status: ['Member of the House of Lords', 'test Membership'] },
            current_mp?:    false,
            current_lord?:  true,
            weblinks?:      false))

        render
      end

      it 'will render statuses' do
        expect(rendered).to match(/Member of the House of Lords and test Membership/)
      end

      context 'person is a former MP' do
        before do
          assign(:person,
            double(:person,
              display_name:   'Test Display Name',
              full_title:     'Test Title',
              full_name:      'Test Full Name',
              given_name:     'Test',
              gender_pronoun: 'She',
              statuses:       { house_membership_status: ['Former MP', 'member of the House of Lords'] },
              graph_id:       '7TX8ySd4',
              image_id:       '12345678',
              current_mp?:    false,
              current_lord?:  true,
              weblinks?:      false))

          render
        end

        it 'will render statuses' do
          expect(rendered).to match(/Former MP and member of the House of Lords/)
        end

        it 'will only keep the first house_membership_status capitalized' do
          expect(rendered).not_to match(/Former MP and Member of the House of Lords/)
        end
      end
    end

    context 'person is not a current MP or current Lord' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Test Membership'] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:    false,
            current_lord?:  false,
            weblinks?:      false))

        render
      end

      it 'will render statuses' do
        expect(rendered).to match(/Test Membership/)
      end

      context 'person is a former MP' do
        before do
          assign(:person,
            double(:person,
              display_name:   'Test Display Name',
              full_title:     'Test Title',
              full_name:      'Test Full Name',
              given_name:     'Test',
              gender_pronoun: 'She',
              statuses:       { house_membership_status: ['Former MP'] },
              graph_id:       '7TX8ySd4',
              image_id:       '12345678',
              current_mp?:    false,
              current_lord?:  false,
              weblinks?:      false))
          render
        end

        it 'will render statuses' do
          expect(rendered).to match(/Former MP/)
        end

        context 'person is a former Lord' do
          before do
            assign(:person,
              double(:person,
                display_name: 'Test Display Name',
                full_title:   'Test Title',
                full_name:    'Test Full Name',
                given_name:   'Test',
                gender:       double(:gender, pronoun: 'She'),
                statuses:     { house_membership_status: ['Former MP', 'former Lord'] },
                graph_id:     '7TX8ySd4',
                image_id:       '12345678',
                current_mp?:   false,
                current_lord?: false,
                weblinks?:     false))
            render
          end

          it 'will render statuses' do
            expect(rendered).to match(/Former MP and former Lord/)
          end
        end
      end
    end

    context 'current incumbency and current party membership' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:    true,
            current_lord?:  false,
            weblinks?:      false))

        assign(:current_incumbency,
          double(:current_incumbency,
            constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id), contact_points: [], date_range: 'from 2010'))

        assign(:current_party_membership,
          double(:current_party_membership, party: double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')))

        render
      end

      it 'will render link to party_path' do
        expect(rendered).to have_link('Conservative', href: party_path('jF43Jxoc'))
      end
    end
  end

  context '@current_incumbency and @current_party_membership are present' do
    before do
      assign(:seat_incumbencies, [
               double(:seat_incumbency,
                 house_of_commons?: true,
                 start_date:   Time.zone.now - 2.months,
                 end_date:     nil,
                 current?:     true,
                 date_range:   "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present",
                 constituency: double(:constituency,
                   name:       'Aberavon',
                   graph_id:   constituency_graph_id,
                   start_date: Time.zone.now - 2.months,
                   date_range: 'from 2010')),
               double(:seat_incumbency,
                 house_of_commons?: true,
                 start_date:   Time.zone.now - 2.months,
                 end_date:     Time.zone.now - 1.week,
                 current?:     false,
                 date_range:   "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to #{(Time.zone.now - 1.week).strftime('%-e %b %Y')}",
                 constituency: double(:constituency,
                   name:       'Aberconwy',
                   graph_id:   constituency_graph_id,
                   start_date: Time.zone.now - 2.months,
                   date_range: 'from 2010'))
             ])

      assign(:most_recent_incumbency, nil)
      assign(:current_party_membership, double(:current_party_membership, party: double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')))
    end

    context 'postcode' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:    true,
            current_lord?:  false,
            weblinks?:      false))

        assign(:current_incumbency,
          double(:current_incumbency,
            contact_points: [],
            constituency:   double(:constituency,
              name:     'Aberavon',
              graph_id: constituency_graph_id,
              date_range: 'from 2010')))
      end

      context 'postcode is assigned' do
        before do
          assign(:postcode, 'SW1A 0AA')
        end
      end
    end

    context 'person is a current MP' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:    true,
            current_lord?:  false,
            weblinks?:      false))
      end

      context '@current_incumbency.contact_points is empty' do
        before do
          assign(:current_incumbency,
            double(:current_incumbency,
              contact_points: [],
              constituency:   double(:constituency,
                name:     'Aberavon',
                graph_id: constituency_graph_id,
                date_range: 'from 2010'),
              house: double(:house, name: 'House of Commons', graph_id: house_of_commons_graph_id)))

             assign(:seat_incumbencies, [
               double(:seat_incumbency,
                 house_of_commons?: true,
                 start_date:   Time.zone.now - 2.months,
                 end_date:     nil,
                 current?:     true,
                 date_range:   "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present",
                 constituency: double(:constituency,
                   name:       'Aberavon',
                   graph_id:   constituency_graph_id,
                   start_date: Time.zone.now - 2.months,
                   date_range: 'from 2010'))
             ])
            assign(:committee_memberships, count: 2)
          render
        end

        it 'will not render contact points' do
          expect(rendered).to match(/Empty Contact Details/)
        end
      end

      context '@current_incumbency.contact_points is not empty' do
        before do
          assign(:current_incumbency,
            double(:current_incumbency,
              constituency:   double(:constituency,
                name:     'Aberavon',
                graph_id: constituency_graph_id,
                date_range: 'from 2010'),
              contact_points: [
                double(:contact_point,
                  email:            'testemail@test.com',
                  phone_number:     '07700000000',
                  postal_addresses: [
                    double(:postal_address, full_address: 'Full Test Address')
                                    ])],
              house: double(:house, name: 'House of Commons', graph_id: house_of_commons_graph_id)))

             assign(:seat_incumbencies, [
               double(:seat_incumbency,
                 house_of_commons?: true,
                 start_date:   Time.zone.now - 2.months,
                 end_date:     nil,
                 current?:     true,
                 date_range:   "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present",
                 constituency: double(:constituency,
                   name:       'Aberavon',
                   graph_id:   constituency_graph_id,
                   start_date: Time.zone.now - 2.months,
                   date_range: 'from 2010'))
                                        ])
          render
        end

        context 'contact details' do
          it 'will render email' do
            expect(rendered).to match(/testemail@test.com/)
          end

          context 'phone number' do
            it 'will render phone number' do
              expect(rendered).to match(/07700000000/)
            end
          end

          it 'will render postal address' do
            expect(rendered).to match(/Full Test Address/)
          end

          it 'will not render a line break' do
            expect(rendered).not_to match(/line-break-heavy/)
          end

          context 'contact information' do
            it 'will not display information' do
               expect(rendered).not_to match(/You may be able to discuss issues with your MP in person or online/)
            end
          end
        end

        context 'more than 1 contact point' do
          before do
            assign(:current_incumbency,
              double(:current_incumbency,
                constituency:   double(:constituency,
                  name:     'Aberavon',
                  graph_id: constituency_graph_id,
                  date_range: 'from 2010'),
                contact_points: [
                  double(:contact_point,
                    email:            'testemail@test.com',
                    phone_number:     '  07700000 001 ',
                    postal_addresses: [
                      double(:postal_address,
                        full_address: 'Full Test Address')
                    ]),
                  double(:contact_point,
                    email:            'testemail2@test.com',
                    phone_number:     '  0770000000',
                    postal_addresses: [
                      double(:postal_address,
                        full_address: 'Full Test Address 2')
                    ])
                ],house: double(:house, name: 'House of Commons', graph_id: house_of_commons_graph_id)))

            assign(:committee_memberships, count: 2)
            assign(:government_incumbencies, count: 2)
            render
          end

          it 'will render line break after last contact point' do
            expect(rendered).to match(/.line-break--sm/)
          end
        end
      end
    end

    context 'person is a Lord' do
      before do
        assign(:person,
          double(:person,
            display_name:   'Test Display Name',
            full_title:     'Test Title',
            full_name:      'Test Full Name',
            given_name:     'Test',
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Member of the House of Lords'] },
            graph_id:       '7TX8ySd4',
            image_id:       '12345678',
            current_mp?:    false,
            current_lord?:  true,
            weblinks?:      false))

        assign(:current_incumbency,
          double(:current_incumbency,
            contact_points: [],
            constituency:   double(:constituency,
              name:     'Aberavon',
              graph_id: constituency_graph_id,
              date_range: 'from 2010'),
                house: double(:house, name: 'House of Commons', graph_id: house_of_commons_graph_id)))

        render
      end

      context 'no contact details' do
        it 'will render fallback contact details' do
          expect(rendered).to match(/020 7219 5353/)
          expect(rendered).to match(/contactholmember@parliament.uk/)
          expect(rendered).to match(/House of Lords, London, SW1A 0PW/)
        end
      end

      context 'contact information' do
        it 'will not display information' do
          expect(rendered).not_to match(/You may be able to discuss issues with your MP in person or online/)
        end
      end
    end
  end

  context '@seat_incumbencies and @government_incumbencies are present' do
    before do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_title:     'Test Title',
          full_name:      'Test Full Name',
          given_name:     'Test',
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Member of the House of Lords'] },
          graph_id:       '9BSfSFxq',
          image_id:       '12345678',
          current_mp?:    false,
          current_lord?:  true,
          weblinks?:      false))

      assign(:most_recent_incumbency, nil)
      assign(:current_party_membership,
        double(:current_party_membership,
          party: double(:party,
            name: 'Conservative',
            graph_id: 'jF43Jxoc')
        )
      )
    end

    context 'with roles' do
      let(:history) do
        {
          start: Time.zone.now - 25.years,
          current: [
            double(:seat_incumbency,
              house_of_commons?: true,
              house_of_lords?: false,
              type: '/SeatIncumbency',
              date_range: "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Aberconwy',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:government_incumbency,
                   type: '/GovernmentIncumbency',
                   date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
                   government_position: double(:government_position,
                                       name: 'Test Government Position Name',
                                       graph_id:   government_graph_id,
              )
            ),
            double(:opposition_incumbency,
                   type: '/OppositionIncumbency',
                   date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
                   opposition_position: double(:opposition_position,
                                       name: 'Opposition Role 1',
                                       graph_id:   opposition_graph_id,
              )
            ),
            double(:seat_incumbency,
              type: '/SeatIncumbency',
              house_of_commons?: true,
              house_of_lords?: false,
              start_date: Time.zone.now - 2.months,
              end_date:   nil,
              date_range: "from #{(Time.zone.now - 4.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Fake Place 2',
                graph_id:   constituency_graph_id,
              )
            )
          ],
          years: {
            '10': [
              double(:government_incumbency,
                 type: '/GovernmentIncumbency',
                 date_range: "from #{(Time.zone.now - 5.years).strftime('%-e %b %Y')} to #{(Time.zone.now - 3.years).strftime('%-e %b %Y')}",
                 government_position: double(:government_position,
                   name: 'Second Government Positon Name',
                   graph_id:   government_graph_id,
                 )
              ),
              double(:opposition_incumbency,
                 type: '/OppositionIncumbency',
                 date_range: "from #{(Time.zone.now - 5.years).strftime('%-e %b %Y')} to #{(Time.zone.now - 3.years).strftime('%-e %b %Y')}",
                 opposition_position: double(:opposition_position,
                   name: 'Opposition Role 2',
                   graph_id:   opposition_graph_id,
                 )
              ),
              double(:seat_incumbency,
                type: '/SeatIncumbency',
                house_of_commons?: true,
                house_of_lords?: false,
                start_date: Time.zone.now - 6.months,
                date_range: "from #{(Time.zone.now - 6.months).strftime('%-e %b %Y')} to #{(Time.zone.now - 1.week).strftime('%-e %b %Y')}",
                constituency: double(:constituency,
                  name:       'Fake Place 1',
                  graph_id:   constituency_graph_id,
                )
              )
            ]
          }
        }
      end

      before :each do
        assign(:history, history)

        assign(:current_roles, {
          'OppositionIncumbency'.to_s => [
            double(:opposition_incumbency,
              type: '/OppositionIncumbency',
              date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
              opposition_position: double(:opposition_position,
                name: 'Opposition Role 1',
                graph_id:   opposition_graph_id,
              )
            ),
            double(:opposition_incumbency2,
              type: '/OppositionIncumbency',
              date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
              opposition_position: double(:opposition_position,
                name: 'Opposition Role 2',
                graph_id:   opposition_graph_id,
              )
            )
          ],
          "GovernmentIncumbency" => [
            double(:government_incumbency,
              type: '/GovernmentIncumbency',
              date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
              government_position: double(:government_position,
                name: 'Test Government Position Name',
                graph_id:   government_graph_id,
              )
            )
          ],
          'SeatIncumbency'.to_s => [
            double(:seat_incumbency,
              type: '/SeatIncumbency',
              house_of_commons?: true,
              house_of_lords?: false,
              start_date: Time.zone.now - 2.months,
              end_date:   nil,
              date_range: "from #{(Time.zone.now - 4.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Fake Place 2',
                graph_id:   constituency_graph_id,
              )
            )
          ]
        })
        assign(:sorted_incumbencies, [
          double(:first_incumbency,
            start_date: Time.zone.now - 5.years
          ),
          double(:last_incumbency,
            end_date: Time.zone.now - 1.years
          )
        ])

        render
      end

      context 'showing current' do
        it 'shows current person description' do
          expect(rendered).to match(/Test Display Name is currently Test Government Position Name, Opposition Role 1, and Opposition Role 2. She became an MP in 2013./)
        end
      end
    end
  end

  context 'with a former mp or lord' do
    before :each do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_title:     'Test Title',
          full_name:      'Test Full Name',
          given_name:     'Test',
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Former MP'] },
          graph_id:       '7TX8ySd4',
          image_id:       '12345678',
          current_mp?:    false,
          current_lord?:  false,
          mnis_id:        '1357',
          weblinks?:      false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010 to 2017')))
      assign(:most_recent_incumbency, nil)
      assign(:history, {
      start: double(:start, year: Time.zone.now - 5.years),
      current: [],
      years: {} })
      assign(:sorted_incumbencies, [
        double(:first_incumbency,
          start_date: Time.zone.now - 5.years
        ),
        double(:last_incumbency,
          end_date: Time.zone.now - 1.years
        )
      ])
      render
    end

    it 'shows the former person description' do
      expect(rendered).to match(/Test Display Name began work in Parliament in 2013 and finished in 2017./)
    end
  end

  context 'written questions' do

    before do
      assign(:person, double(:person,
        display_name:   'Test Display Name',
        full_title:     'Test Title',
        full_name:      'Test Full Name',
        given_name:     'Test',
        gender_pronoun: 'She',
        statuses:       { house_membership_status: ['Former MP'] },
        graph_id:       '7TX8ySd4',
        image_id:       '12345678',
        current_mp?:    false,
        current_lord?:  false,
        mnis_id:        '1357',
        weblinks?:      false
      ))
    end

    describe 'with a question' do
      before do
        assign(:question, double(:question,
          heading: 'Test question heading',
          graph_id: 'XXXXXXXX',
          answers: ['Test Answer'],
          answering_body_allocation: double(:answering_body_allocation,
            answering_body: double(:answering_body,
              name: 'Test answering body'
            )
          ),
          asked_at_date: DateTime.parse('2018-05-21T00:00:00+00:00')
        ))

        render
      end

      it 'displays the section title' do
        expect(rendered).to match("<h2>Written questions</h2>")
      end

      it 'displays question title as a link to the question' do
        expect(rendered).to have_link('Test question heading', href: question_path('XXXXXXXX'))
      end

      it 'displays the correct date format' do
        expect(rendered).to match("<time datetime='18-05-21'>21 May 2018</time>")
      end

      it 'displays a call to action to view all questions' do
        expect(rendered).to have_link("View all written questions", href: person_questions_written_path("7TX8ySd4"), class: "btn--primary")
      end
    end

    describe 'with an answer' do
      before do
        assign(:question, double(:question,
          heading: 'Test question heading',
          graph_id: 'XXXXXXXX',
          answers: ['Test Answer'],
          answering_body_allocation: double(:answering_body_allocation,
            answering_body: double(:answering_body,
              name: 'Test answering body'
            )
          ),
          asked_at_date: DateTime.parse('2018-05-21T00:00:00+00:00')
        ))

        render
      end

      it 'displays the answering body text' do
        expect(rendered).to match("<p>Answered by the Test answering body</p>")
      end

      it 'does not display the awaiting answer text' do
        expect(rendered).not_to match("<p>Awaiting answer from the Test answering body</p>")
      end
    end

    describe 'without an answer' do
      before do
        assign(:question, double(:question,
          heading: 'Test question heading',
          graph_id: 'XXXXXXXX',
          answers: [],
          answering_body_allocation: double(:answering_body_allocation,
            answering_body: double(:answering_body,
              name: 'Test answering body'
            )
          ),
          asked_at_date: DateTime.parse('2018-05-21T00:00:00+00:00')
        ))

        render
      end

      it 'does not display the answering body text' do
        expect(rendered).not_to match("<p>Answered by the Test answering body</p>")
      end

      it 'displays the awaiting answer text' do
        expect(rendered).to match("<p>Awaiting answer from the Test answering body</p>")
      end
    end
  end
end
