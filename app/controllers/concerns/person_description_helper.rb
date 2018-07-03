module PersonDescriptionHelper
  # Builds description of person using current roles
  ROLES = {'GovernmentIncumbency' => :government_position, 'OppositionIncumbency' => :opposition_position, 'FormalBodyMembership' => :formal_body}.freeze

  class << self
    # Returns former description string
    #
    # @param person_name [String] String of person display name
    # @param first_incumbency_start_date [String] String of year of first incumbency start date
    # @param last_incumbency_end_date [String] String of year of last incumbency end date
    # @return [String] Person's current roles description
    def former_description(person_name, first_incumbency_start_date, last_incumbency_end_date)
      t('former_description', name: person_name, start_date: first_incumbency_start_date, end_date: last_incumbency_end_date)
    end

    # Returns current description string
    #
    # @param person [Grom::Node] Person object
    # @param first_incumbency_start_date [String] String of year of first incumbency
    # @param current_roles [Hash] Hash of current roles grouped by role type
    # @return [String] Person's current roles description
    def current_description(person, first_incumbency_start_date, current_roles)
      seat_incumbency_text = seat_incumbency_text(current_roles.fetch('SeatIncumbency', []).first, first_incumbency_start_date)
      current_roles_text = fetch_current_role_names(current_roles).to_sentence
      person_display_name = person.display_name.dup
      return current_roles_description(person_display_name, current_roles_text, person.gender_pronoun, seat_incumbency_text) unless current_roles_text.empty?
      return name_with_seat_incumbency_text(person_display_name, seat_incumbency_text) if current_roles_text.empty?
    end

    private

    # Creates a scoped translation. Automatically translates within the helpers.person_description_helper scope
    #
    # @param key [String] Key within translation file
    # @param [Hash] **options Any number of translation options
    # @return [String]
    def t(key, **options)
      options.merge!({ scope: [:helpers, :person_description_helper] })

      I18n.t(key, options)
    end

    # Returns seat incumbency text string
    #
    # @param seat_incumbency [Grom::Node] Seat incumbency object
    # @param first_incumbency_start_date [String] String of year of first incumbency
    # @return [String] String of seat incumbency text
    def seat_incumbency_text(seat_incumbency, first_incumbency_start_date)
      translation_key = 'lords'
      translation_key = 'commons' if seat_incumbency_is_grouped_object?(seat_incumbency) || seat_incumbency&.house_of_commons?

      t("#{translation_key}.seat_incumbency_text", start_date: first_incumbency_start_date)
    end

    # Returns true or false to check if seat incumbency is a grouped object
    #
    # @param seat_incumbency [Grom::Node] Seat incumbency object
    # @return [Boolean] True if seat_incumbency is a RoleGroupedObject
    def seat_incumbency_is_grouped_object?(seat_incumbency)
      seat_incumbency.is_a?(RoleGroupingHelper::RoleGroupedObject)
    end

    # Returns person name with seat incumbency text
    #
    # @param person_display_name [String] Person display name
    # @param seat_incumbency_text [String] Seat incumbency text string
    # @return [String] String of person name with seat incumbency text
    def name_with_seat_incumbency_text(person_display_name, seat_incumbency_text)
      "#{person_display_name} #{seat_incumbency_text}."
    end

    # Returns current roles text with pronoun and seat incumbency text
    #
    # @param person_display_name [String] Person display name
    # @param current_roles_text [String] Current roles text string
    # @param person_pronoun [String] Person pronoun
    # @param seat_incumbency_text [String] Seat incumbency text string
    # @return [String] String of current roles text with pronoun and seat incumbency text
    def current_roles_description(person_display_name, current_roles_text, person_pronoun, seat_incumbency_text)
      t('current_roles_description', name: person_display_name, roles: current_roles_text, pronoun: person_pronoun, incumbency: seat_incumbency_text)
    end

    # Fetches formal body memberships from current_roles
    #
    # @param current_roles [Hash] Hash of current roles grouped by role type
    # @return [Array] Array of current roles with the type 'FormalBodyMembership'
    def fetch_formal_body_memberships(current_roles)
      current_roles.fetch('FormalBodyMembership', [])
    end

    # Fetches names for current roles based on role type
    #
    # @param current_roles [Hash] Hash of current roles grouped by role type
    # @return [Array] Array of strings of current role names
    def fetch_current_role_names(current_roles)
      formal_body_memberships = fetch_formal_body_memberships(current_roles)
      current_role_names = []
      ROLES.keys.each do |role_type|
        current_roles.fetch(role_type, []).each do |current_role|
          role_name = get_role_name(role_type, current_role)

          break if role_name.nil?

          current_role_names << role_name unless role_type == 'FormalBodyMembership'
          current_role_names << formal_body_membership_role_name(current_role, formal_body_memberships[0], role_name) if role_type == 'FormalBodyMembership'
        end
      end
      current_role_names
    end

    # Returns formal body membership role name
    #
    # @param current_role [Grom::Node] Role object
    # @param first_formal_body_membership [Grom::Node] First formal body membership object
    # @param role_name [String] Role name for formal body membership
    # @return [String] String of formal body membership role name
    def formal_body_membership_role_name(current_role, first_formal_body_membership, role_name)
      translation_key = current_role == first_formal_body_membership ? 'first' : 'other'
      t("formal_body_membership_role_name.#{translation_key}", role: role_name)
    end

    # Returns role name using role type and role
    #
    # @param role_type [String] String of role type
    # @param role [Grom::Node] Role object
    # @return [String] String of role name
    def get_role_name(role_type, role)
      method_symbol = ROLES[role_type]

      return nil if method_symbol.nil?

      role_object = role.send(method_symbol)

      return nil if role_object.name.empty?

      role_object.name
    end
  end
end
