require 'rails_helper'

RSpec.describe 'groups/show' do
  let!(:group) {
    assign(:group,
      double(:group,
        name: 'Test Group Name',
        graph_id: 'df5n8bxs',
        joint?: false,
        select_committee?: true,
        houses: [double(:house, name: 'House of Commons')],
        committee_type: 'select',
        remit: 'Some test remit, illustrating what the group is all about',
        member_count: 13,
        formal_body?: true
      )
    )
  }

  let!(:chair_people) {
    assign(:chair_people,
      [
        double(:person,
          graph_id: 'zxcvbnmk',
          image_id: 'e3e3e3e3',
          display_name: 'Test chair person display name',
          current_mp?: true,
          current_party: double(:party, name: 'Labour'),
          current_seat_incumbency: double(:current_seat_incumbency,
            constituency: double(:constituency,
              name: 'Westminster'
            )
          )
        )
      ]
    )
  }

  let!(:contact_points) {
    assign(:contact_points,
      [
        double(:contact_point,
          email: 'test@group.com',
          phone_number: '01234567890'
        )
      ]
    )
  }

  let!(:postal_address) {
    assign(:postal_address,
      double(:postal_address,
        full_address: 'House of Commons, London, SW1A 0AA'
      )
    )
  }

  before(:each) do
    render
  end

  context 'title' do
    it 'displays the correct title' do
      expect(rendered).to match(/Test Group Name/)
    end
  end

  context 'committee type' do
    context 'select and formal body' do
      context 'joint committee' do
        let!(:group) {
          assign(:group,
            double(:group,
              name: 'Test Group Name',
              graph_id: 'df5n8bxs',
              joint?: true,
              select_committee?: true,
              houses: [double(:house, name: 'House of Commmons')],
              committee_type: 'select',
              remit: 'Some test remit, illustrating what the group is all about',
              member_count: 13,
              formal_body?: true
            )
          )
        }

        it 'renders the correct committee type' do
          expect(rendered).to match(/Joint \(Commons and Lords\) select committee/)
        end
      end

      context 'House of Commons committee' do
        it 'renders the correct committee type' do
          expect(rendered).to match(/Commons select committee/)
        end
      end

      context 'House of Lords committee' do
        let!(:group) {
          assign(:group,
            double(:group,
              name: 'Test Group Name',
              graph_id: 'df5n8bxs',
              joint?: false,
              select_committee?: true,
              houses: [double(:house, name: 'House of Lords')],
              committee_type: 'select',
              remit: 'Some test remit, illustrating what the group is all about',
              member_count: 13,
              formal_body?: true
            )
          )
        }

        it 'renders the correct committee type' do
          expect(rendered).to match(/Lords select committee/)
        end
      end
    end

    context 'non-select or formal body' do
      let!(:group) {
        assign(:group,
          double(:group,
            name: 'Test Group Name',
            graph_id: 'df5n8bxs',
            joint?: false,
            select_committee?: false,
            houses: [double(:house, name: 'House of Commmons')],
            committee_type: 'select',
            remit: 'Some test remit, illustrating what the group is all about',
            member_count: 13,
            formal_body?: false
          )
        )
      }

      it 'displays group name' do
        expect(rendered).to match(/Test Group Name/)
      end
    end
  end

  context 'remit' do
    context 'for a formal body' do
      context 'when it exists' do
        it 'displays the correct remit' do
          expect(rendered).to match(/Some test remit, illustrating what the group is all about/)
        end
      end

      context 'when it does not exist' do
        let!(:group) {
          assign(:group,
            double(:group,
              name: 'Test Group Name',
              graph_id: 'df5n8bxs',
              joint?: false,
              select_committee?: true,
              houses: [double(:house, name: 'House of Commmons')],
              committee_type: 'select',
              remit: '',
              member_count: 13,
              formal_body?: true
            )
          )
        }

        it 'does not display anything about the committee' do
          expect(rendered).not_to match(/About the committee/)
        end
      end
    end
  end

  context 'chairs' do
    context 'when they exist' do
      it 'displays the correct chair display name' do
        expect(rendered).to match(/Test chair person display name/)
      end

      it 'displays the correct chair party name' do
        expect(rendered).to match(/Labour/)
      end

      context 'when they are an MP' do
        it 'displays the correct chair constituency name' do
          expect(rendered).to match(/MP for Westminster/)
        end
      end

      context 'when they are a Lord' do
        let!(:chair_people) {
          assign(:chair_people,
            [
              double(:person,
                graph_id: 'zxcvbnmk',
                image_id: 'e3e3e3e3',
                display_name: 'Test chair person display name',
                current_mp?: false,
                current_party: double(:party, name: 'Labour'),
                statuses: { house_membership_status: ['Member of the House of Lords']}
              )
            ]
          )
        }

        it 'displays the correct title' do
          expect(rendered).to match(/member of the House of Lords/)
        end
      end
    end
  end

  context 'all members' do
    context 'when there are members' do
      it 'displays a heading for all members' do
        expect(rendered).to match(/Committee members/)
      end

      it 'displays a link to view all members' do
        expect(rendered).to match(/<a href="\/groups\/df5n8bxs\/memberships\/current">/)
      end

      it 'displays a count of all members' do
        expect(rendered).to match(/13 committee members/)
      end
    end

    context 'when there are no members' do
      let!(:group) {
        assign(:group,
          double(:group,
            name: 'Test Group Name',
            graph_id: 'df5n8bxs',
            joint?: false,
            select_committee?: true,
            houses: [double(:house, name: 'House of Commmons')],
            committee_type: 'select',
            remit: 'Some test remit, illustrating what the group is all about',
            member_count: nil,
            formal_body?: true
          )
        )
      }

      it 'displays a heading for all members' do
        expect(rendered).not_to match(/Committee members/)
      end
    end
  end

  context 'contact us' do
    context 'when both contact points and addresses exist' do
      it 'displays a heading for contact us' do
        expect(rendered).to match(/Contact us/)
      end
    end

    context 'when contact points exist but addresses do not' do
      let!(:postal_address) {
        assign(:postal_address, nil)
      }

      it 'displays a heading for contact us' do
        expect(rendered).to match(/Contact us/)
      end
    end

    context 'when contact points do not exist but addresses do' do
      let!(:contact_points) {
        assign(:contact_points, [])
      }

      it 'displays a heading for contact us' do
        expect(rendered).to match(/Contact us/)
      end
    end

    context 'when neither contact points nor addresses exist' do

      let!(:postal_address) {
        assign(:postal_address, nil)
      }

      let!(:contact_points) {
        assign(:contact_points, [])
      }

      it 'displays a heading for contact us' do
        expect(rendered).not_to match(/Contact us/)
      end
    end
  end

  context 'contact points' do
    context 'when they exist' do
      context 'email' do
        it 'heading displays correctly' do
          expect(rendered).to match(/Email/)
        end

        it 'link displays correctly' do
          expect(rendered).to match(/<a href="mailto:test@group.com">test@group.com<\/a>/)
        end
      end

      context 'phone number' do
        it 'heading displays correctly' do
          expect(rendered).to match(/Phone/)
        end

        it 'link displays correctly' do
          expect(rendered).to match(/<a href="tel:01234567890">01234567890<\/a>/)
        end
      end
    end

    context 'when they do not exist' do
      let!(:contact_points) {
        assign(:contact_points, [])
      }

      context 'email' do
        it 'heading does not display' do
          expect(rendered).not_to match(/Email/)
        end
      end

      context 'phone number' do
        it 'heading does not display' do
          expect(rendered).not_to match(/Phone/)
        end
      end
    end
  end

  context 'address' do
    context 'when it exists' do
      it 'heading displays correctly' do
        expect(rendered).to match(/Address/)
      end

      it 'displays correctly' do
        expect(rendered).to match(/Test Group Name, House of Commons, London, SW1A 0AA/)
      end
    end
  end
end
