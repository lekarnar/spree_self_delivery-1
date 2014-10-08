module Spree
  class SelfDeliveryPoint < ActiveRecord::Base

    belongs_to :country
    belongs_to :state

    #acts_as_list
    scope :ordered, -> { order("#{SelfDeliveryPoint.table_name}.position ASC") }

    validates :phone, :company, :country, :city, :address1, :presence => true
    validate :state_or_state_name

    #attr_accessible :country_id, :show_country, :state_id, :state_name, :show_state, :city, :address1, :hours, :description, :cost

    def full_address
      addr = []
      addr << country.try(:name) if show_country
      addr << (state.try(:name).presence || state_name) if show_state
      addr << address1
      addr.compact.join(', ')
    end

    def cost=(cost)
      self[:cost] = parse_cost(cost)
    end

    private

    def state_or_state_name
      return unless country.present?
      if country.states.exists?
        self.state_name = nil
        errors.add(:state, :invalid) if state.blank? || state.country_id != country.id
      else
        self.state_id = nil
      end
    end

    def parse_cost(cost)
      return cost unless cost.is_a?(String)

      separator = I18n.t(:'number.currency.format.separator')
      non_price_characters = /[^0-9\-#{separator}]/
      cost.gsub!(non_price_characters, '') # strip everything else first
      cost.gsub!(separator, '.') unless separator == '.' # then replace the locale-specific decimal separator with the standard separator if necessary

      cost.to_d
    end

  end
end
