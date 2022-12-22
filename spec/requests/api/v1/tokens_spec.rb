require 'rails_helper'

RSpec.describe "Api::V1::Tokens", type: :request do
  describe "test tokens controller endpoints" do
    it "takes the valid secret as an input and saves it to the tokens table" do
      secret = SecureRandom.hex(16)
      input = { secret: secret }.to_json

      post "/api/v1/tokenize", params: input, headers: { 'Content-Type': 'application/json' }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json).to have_key("token")
      expect(json["token"]).to be_present

      token = Token.find_by(secret: secret)

      expect(token).to be_present
      expect(token.secret).to eq(secret)
    end

    it "takes the already existing secret as an input and returns an error message" do
      secret = SecureRandom.hex(16)
      token = Token.create(secret: secret)
      input = { secret: token.secret }.to_json

      post "/api/v1/tokenize", params: input, headers: { 'Content-Type': 'application/json' }

      expect(response).to have_http_status(:bad_request)

      json = JSON.parse(response.body)

      expect(json).to have_key("error")
      expect(json["error"]).to be_present
      expect(json["error"]).to eq("Secret already taken or it is empty!")
    end

    it "detokenizes the input and returns it in JSON" do
      secret = SecureRandom.hex(16)
      token = Token.create(secret: secret)
      input = { secret: secret }.to_json

      post "/api/v1/detokenize", params: input, headers: { 'Content-Type': 'application/json' }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to have_key("token")
      expect(json["token"]).to be_present

      token = Token.find_by(secret: secret)

      expect(token.secret).to eq(secret)
    end

    it "tries to detokenize empty secret and returns an error message" do
      input = { secret: "" }.to_json

      post "/api/v1/detokenize", params: input, headers: { 'Content-Type': 'application/json' }

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)

      expect(json).to have_key("error")
      expect(json["error"]).to be_present
      expect(json["error"]).to eq("Could not find token!")
    end
  end
end