require 'rails_helper'

RSpec.describe Token, type: :model do
  describe Token do
    it "successfully creates a token" do
      secret = SecureRandom.hex(32)
      token = Token.create(secret: secret)

      expect(token).to be_valid    
    end
  end
end
