module Crowdring
  class AssignedPhoneNumber
    include DataMapper::Resource
    include PhoneNumberFields

    property :phone_number, String, key: true

    belongs_to :campaign


    validates_with_method :phone_number, :valid_phone_number?
  end
end