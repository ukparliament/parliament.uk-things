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
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          current_mp?:    true,
          current_lord?:  false,
          mnis_id:        '1357',
          weblinks?:      false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
      assign(:most_recent_incumbency, nil)
      assign(:history, {
      start: double(:start, year: Time.zone.now - 5.years),
      current: [],
      years: {} })
      assign(:seat_incumbencies, count: 2)
      assign(:committee_memberships, count: 2)
      assign(:government_incumbencies, count: 2)
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
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          current_mp?:    true,
          current_lord?:  false,
          mnis_id:        '1357',
          weblinks?:      false
        )
      )
      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
      assign(:most_recent_incumbency, nil)
      assign(:history, {
      start: double(:start, year: Time.zone.now - 2.years),
      current: [],
      years: {} })
      assign(:seat_incumbencies, count: 2)
      assign(:committee_memberships, count: 2)
      assign(:government_incumbencies, count: 2)
      assign(:sorted_incumbencies, [
        double(:first_incumbency,
          start_date: Time.zone.now - 5.years
        ),
        double(:last_incumbency,
          end_date: Time.zone.now - 1.years
        )
      ])
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
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          current_mp?:    true,
          current_lord?:  false,
          weblinks?:      false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
      assign(:seat_incumbencies, [])
    end

    context 'nil' do
      before do
        assign(:most_recent_incumbency, nil)
        assign(:government_incumbencies, count: 2)
        assign(:committee_memberships, count: 2)
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
          assign(:seat_incumbencies, count: 2)
          assign(:committee_memberships, count: 2)
          assign(:government_incumbencies, count: 2)

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

          assign(:committee_memberships, count: 2)
          assign(:government_incumbencies, count: 2)
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: [] },
            graph_id:       '7TX8ySd4',
            current_mp?:     true,
            weblinks?:       false))

        assign(:committee_memberships, count: 2)
        assign(:government_incumbencies, count: 2)
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
            current_mp?:    true,
            current_lord?:  false,
            weblinks?:      false))

        assign(:committee_memberships, count: 2)
        assign(:government_incumbencies, count: 2)
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
              gender_pronoun: 'She',
              statuses:       { house_membership_status: ['Current MP', 'Former Lord'] },
              current_mp?:    true,
              current_lord?:  false,
              weblinks?:      false))

          assign(:committee_memberships, count: 2)
          assign(:government_incumbencies, count: 2)
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Member of the House of Lords', 'test Membership'] },
            current_mp?:    false,
            current_lord?:  true,
            weblinks?:      false))

        assign(:seat_incumbencies, count: 2)
        assign(:committee_memberships, count: 2)
        assign(:government_incumbencies, count: 2)
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
              gender_pronoun: 'She',
              statuses:       { house_membership_status: ['Former MP', 'member of the House of Lords'] },
              graph_id:       '7TX8ySd4',
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Test Membership'] },
            graph_id:       '7TX8ySd4',
            current_mp?:    false,
            current_lord?:  false,
            weblinks?:      false))

        assign(:committee_memberships, count: 2)
        assign(:government_incumbencies, count: 2)
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
              gender_pronoun: 'She',
              statuses:       { house_membership_status: ['Former MP'] },
              graph_id:       '7TX8ySd4',
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
                gender:       double(:gender, pronoun: 'She'),
                statuses:     { house_membership_status: ['Former MP', 'former Lord'] },
                graph_id:     '7TX8ySd4',
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
            current_mp?:    true,
            current_lord?:  false,
            weblinks?:      false))

        assign(:current_incumbency,
          double(:current_incumbency,
            constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id), contact_points: [], date_range: 'from 2010'))

        assign(:current_party_membership,
          double(:current_party_membership, party: double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')))

        assign(:committee_memberships, count: 2)
        assign(:government_incumbencies, count: 2)

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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Current MP'] },
            graph_id:       '7TX8ySd4',
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

          assign(:committee_memberships, count: 2)
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
            gender_pronoun: 'She',
            statuses:       { house_membership_status: ['Member of the House of Lords'] },
            graph_id:       '7TX8ySd4',
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

  context '@seat_incumbencies, @government_incumbencies or @committee_memberships are present' do
    before do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_title:     'Test Title',
          full_name:      'Test Full Name',
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Member of the House of Lords'] },
          graph_id:       '9BSfSFxq',
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
            double(:committee_membership,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 3.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name',
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
              double(:committee_membership,
                type: '/FormalBodyMembership',
                date_range: "from #{(Time.zone.now - 8.years).strftime('%-e %b %Y')} to #{(Time.zone.now - 7.years).strftime('%-e %b %Y')}",
                formal_body: double(:formal_body,
                  name: 'Second Committee Name',
                  graph_id:   constituency_graph_id,
                )
              ),
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
          'FormalBodyMembership'.to_s => [
            double(:committee_membership1,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 12.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name 1',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:committee_membership2,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 8.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name 2',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:committee_membership3,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 9.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name 3',
                graph_id:   constituency_graph_id,
              )
            )
          ],
          'OppositionIncumbency'.to_s => [
            double(:opposition_incumbency,
              type: '/OppositionIncumbency',
              date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
              opposition_position: double(:opposition_position,
                name: 'Opposition Role 1',
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
        it 'shows header' do
          expect(rendered).to match(/Held currently/)
        end

        context 'With Bandiera flag "show-person-description-string" enabled' do
          before :each do
            allow(BANDIERA_CLIENT).to receive(:enabled?).with('parliament', 'show-person-description-string').and_return(true)

            render
          end

          it 'shows current person description' do
            expect(rendered).to match(/Test Display Name is currently Test Government Position Name, Opposition Role 1, a member of the Test Committee Name 1, the Test Committee Name 2, and the Test Committee Name 3. She became an MP in 2013./)
          end

          it 'checks if person description is inside a lead paragraph' do
            expect(rendered).to match(/<p class='lead'>\nTest Display Name is currently Test Government Position Name, Opposition Role 1, a member of the Test Committee Name 1, the Test Committee Name 2, and the Test Committee Name 3. She became an MP in 2013.\n<\/p>/)
          end
        end

        context 'With Bandiera flag "show-person-description-string" disabled' do
          it 'does not show current person description' do
            expect(rendered).not_to match(/Test Display Name is currently Test Government Position Name, Opposition Role 1, a member of the Test Committee Name 1, the Test Committee Name 2, and the Test Committee Name 3. She became an MP in 2013./)
          end
        end

        context 'Parliamentary roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Parliamentary role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Aberconwy/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present")
          end
        end

        context 'Committee roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Committee role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Test Committee Name/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 3.months).strftime('%-e %b %Y')} to present")
          end
        end

        context 'Government roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Government role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Test Government Position Name/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present")
          end
        end

        context 'Opposition roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Opposition role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Opposition Role 1/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present")
          end
        end

        context 'House roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Parliamentary role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Member of the House of Lords/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 4.months).strftime('%-e %b %Y')} to present" )
          end
        end
      end

      context 'showing historic' do
        it 'shows header' do
          expect(rendered).to match(/Held in the last 10 years/)
        end

        context 'Committee roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Committee role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Second Committee Name/)
          end

          it 'will render start date to present' do
            expect(rendered).to match((Time.zone.now - 8.years).strftime('%-e %b %Y'))
          end

          it 'will render present status' do
            expect(rendered).to match((Time.zone.now - 7.years).strftime('%-e %b %Y'))
          end
        end

        context 'Government roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Test Government Position Name/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Second Government Positon Name/)
          end

          it 'will render start date to present' do
            expect(rendered).to match((Time.zone.now - 5.years).strftime('%-e %b %Y'))
          end

          it 'will render present status' do
            expect(rendered).to match((Time.zone.now - 3.years).strftime('%-e %b %Y'))
          end
        end

        context 'Opposition roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Opposition Role 2/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Opposition Role 2/)
          end

          it 'will render start date to present' do
            expect(rendered).to match((Time.zone.now - 5.years).strftime('%-e %b %Y'))
          end

          it 'will render present status' do
            expect(rendered).to match((Time.zone.now - 3.years).strftime('%-e %b %Y'))
          end
        end

        context 'House roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Parliamentary role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Member of the House of Lords/)
          end

          it 'will render start date to present' do
            expect(rendered).to match((Time.zone.now - 6.months).strftime('%-e %b %Y'))
          end

          it 'will render present status' do
            expect(rendered).to match((Time.zone.now - 1.week).strftime('%-e %b %Y'))
          end
        end
      end

      context 'showing start date' do
        it 'shows start date' do
          expect(rendered).to match((Time.zone.now - 25.years).strftime('%Y'))
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
          gender_pronoun: 'She',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          current_mp?:    true,
          current_lord?:  false,
          mnis_id:        '1357',
          weblinks?:      false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
      assign(:most_recent_incumbency, nil)
      assign(:history, {
      start: double(:start, year: Time.zone.now - 5.years),
      current: [],
      years: {} })
      assign(:seat_incumbencies, count: 2)
      assign(:committee_memberships, count: 2)
      assign(:government_incumbencies, count: 2)
      assign(:sorted_incumbencies, [
        double(:first_incumbency,
          start_date: Time.zone.now - 5.years
        ),
        double(:last_incumbency,
          end_date: Time.zone.now - 1.years
        )
      ])

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

    context 'With Bandiera flag "show-person-description-string" enabled' do
      before :each do
        allow(BANDIERA_CLIENT).to receive(:enabled?).with('parliament', 'show-person-description-string').and_return(true)

        render
      end

      it 'shows the former person description' do
        expect(rendered).to match(/Test Display Name began work in Parliament in 2013 and finished in 2017./)
      end
    end

    context 'With Bandiera flag "show-person-description-string" disabled' do
      before :each do
        allow(BANDIERA_CLIENT).to receive(:enabled?).with('parliament', 'show-person-description-string').and_return(false)

        render
      end
      it 'does not show the former person description' do
        expect(rendered).not_to match(/Test Display Name began work in Parliament in 2013 and finished in 2017./)
      end
    end
  end
end
