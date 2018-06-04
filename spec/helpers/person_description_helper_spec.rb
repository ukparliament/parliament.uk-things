require_relative '../rails_helper'

RSpec.describe PersonDescriptionHelper do
  let(:formal_body_membership) {double(:formal_body_membership,
    formal_body: double(:formal_body,
    name: 'Example formal body name')
    )
  }
  let(:formal_body_membership2) {double(:formal_body_membership2,
    formal_body: double(:formal_body,
    name: 'Example formal body name 2')
    )
  }
  let(:formal_body_membership3) {double(:formal_body_membership3,
    formal_body: double(:formal_body,
    name: 'Example formal body name 3')
    )
  }
  let(:opposition_role) {double(:opposition_role,
    opposition_position: double(:opposition_position,
    name: 'Example opposition position name')
    )
  }
  let(:government_role) {double(:government_role,
    government_position: double(:government_position,
    name: 'Example government position name')
    )
  }
  let(:seat_incumbency) {double(:seat_incumbency,
    house_of_commons?: true
  )}

  let(:current_roles) {{'FormalBodyMembership' => [formal_body_membership, formal_body_membership2, formal_body_membership3], 'OppositionIncumbency' => [opposition_role], 'GovernmentIncumbency' => [government_role], 'SeatIncumbency' => [seat_incumbency]}}

  context '#current_description' do
    let(:first_incumbency_start_date){'2007'}
    let(:person) {double(:person,
      display_name: 'Example person name',
      gender_pronoun: 'He'
      )
    }

    it 'returns the appropriate current description for a person' do
      expect(PersonDescriptionHelper.current_description(person, first_incumbency_start_date, current_roles)).to eq('Example person name is currently Example government position name, Example opposition position name, a member of the Example formal body name, the Example formal body name 2, and the Example formal body name 3. He became an MP in 2007.')
    end
  end

  context '#former_description' do
    let(:first_incumbency_start_date){'2007'}
    let(:last_incumbency_end_date){'2001'}
    let(:person_name){'Example person name'}

    it 'returns the appropriate former description for a person' do
      expect(PersonDescriptionHelper.former_description(person_name, first_incumbency_start_date, last_incumbency_end_date)).to eq('Example person name began work in Parliament in 2007 and finished in 2001.')
    end
  end

  context '#seat_incumbency_text' do
    let(:seat_incumbency) {double('seat_incumbency', :house_of_commons? => true, :class => RoleGroupingHelper::RoleGroupedObject)}
    let(:first_incumbency_start_date) {'1996'}

    it 'can return seat incumbency text' do
      expect(PersonDescriptionHelper.send(:seat_incumbency_text, seat_incumbency, first_incumbency_start_date)).to eq('became an MP in 1996')
    end
  end

  context '#seat_incumbency_is_grouped_object?' do

    context 'with a grouped object' do
      let(:grouped_object) { RoleGroupingHelper::RoleGroupedObject.new }

      it 'returns true' do
        expect(PersonDescriptionHelper.send(:seat_incumbency_is_grouped_object?, grouped_object)).to eq(true)
      end
    end

    context 'with an object that is not grouped' do
      let(:seat_incumbency) {double('seat_incumbency', :house_of_commons? => true, :class => 'SeatIncumbency')}
      let(:first_incumbency_start_date) {'1996'}

      it 'returns false' do
        expect(PersonDescriptionHelper.send(:seat_incumbency_is_grouped_object?, seat_incumbency)).to eq(false)
      end
    end
  end

  context '#name_with_seat_incumbency_text' do
    let(:seat_incumbency_text) {' became an MP in 1996'}
    let(:person_display_name) {'Example Name'}

    it 'returns the name of the person with their seat incumbency' do
      expect(PersonDescriptionHelper.send(:name_with_seat_incumbency_text, person_display_name, seat_incumbency_text)).to eq('Example Name  became an MP in 1996.')
    end
  end

  context '#current_roles_description' do
    let(:seat_incumbency_text) {' became an MP in 1996'}
    let(:current_roles_text) {'shadow home secretary, a Member of the Example Committee and Committee on Examples'}
    let(:person_display_name) {'Example Name'}
    let(:person_pronoun) {'She'}

    it 'returns the current roles description' do
      expect(PersonDescriptionHelper.send(:current_roles_description, person_display_name, current_roles_text, person_pronoun, seat_incumbency_text)).to eq('Example Name is currently shadow home secretary, a Member of the Example Committee and Committee on Examples. She  became an MP in 1996.')
    end
  end

  context '#fetch_formal_body_memberships' do
    let(:current_roles) {{'FormalBodyMembership' => ['formal_body_membership'], 'OppositionIncumbency' => ['opposition_incumbency']}}

    it 'fetches the formal body memberships from current roles' do
      expect(PersonDescriptionHelper.send(:fetch_formal_body_memberships, current_roles)).to eq(['formal_body_membership'])
    end
  end

  context '#fetch_current_role_names' do
    context 'with all the required data' do
      it 'makes an array of all the current role names' do
        expect(PersonDescriptionHelper.send(:fetch_current_role_names, current_roles)).to eq(['Example government position name', 'Example opposition position name', 'a member of the Example formal body name', 'the Example formal body name 2', 'the Example formal body name 3'])
      end
    end

    context 'with incorrect data' do
      let(:current_roles) {{'FormalBodyMembership' => [formal_body_membership, formal_body_membership2, formal_body_membership3], 'NonsenseName' => [opposition_role], 'GovernmentIncumbency' => [government_role], 'SeatIncumbency' => [seat_incumbency]}}

      it 'makes an array of all the current role names available' do
        expect(PersonDescriptionHelper.send(:fetch_current_role_names, current_roles)).to eq(['Example government position name', 'a member of the Example formal body name', 'the Example formal body name 2', 'the Example formal body name 3'])
      end
    end
  end

  context '#formal_body_membership_role_name' do
    let(:role_name){'Example formal body name'}
    let(:current_role) {double(:current_role,
      formal_body: double(:formal_body,
      name: 'Example formal body name')
      )
    }
    let(:first_formal_body_membership) {double(:first_formal_body_membership,
      formal_body: double(:formal_body,
      name: 'Example formal body name 2')
      )
    }

    it 'returns the appropriate formal body description for the first formal body name' do
      expect(PersonDescriptionHelper.send(:formal_body_membership_role_name, current_role, current_role, role_name)).to eq('a member of the Example formal body name')
    end

    it 'returns the appropriate formal body description for formal body name that are not first' do
      expect(PersonDescriptionHelper.send(:formal_body_membership_role_name, current_role, first_formal_body_membership, role_name)).to eq('the Example formal body name')
    end
  end

  context '#get_role_name' do
    context 'with all the required data' do
      let(:role_type){'GovernmentIncumbency'}
      let(:role) {double(:role,
        government_position: double(:government_position,
        name: 'Example position name')
        )
      }
      it 'gets the role name' do
        expect(PersonDescriptionHelper.send(:get_role_name, role_type, role)).to eq('Example position name')
      end
    end

    context 'with an unexpected type' do
      let(:role_type){'NonsenseName'}
      it 'returns nil' do
        expect(PersonDescriptionHelper.send(:get_role_name, role_type, nil)).to be(nil)
      end
    end

    context 'with no role name' do
      let(:role_type){'GovernmentIncumbency'}
      let(:role) { double(:role, government_position: double(:government_position, name: '')) }

      it 'returns nil' do
        expect(PersonDescriptionHelper.send(:get_role_name, role_type, role)).to be(nil)
      end
    end
  end
end
