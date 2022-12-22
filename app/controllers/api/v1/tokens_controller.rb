class Api::V1::TokensController < ApplicationController
  def tokenize
    token = Token.new(token_params)

    if token.save
      render json: { token: token }, status: :created
    else
      render json: { error: "Secret already taken or it is empty!" }, status: :bad_request
    end
  end

  def detokenize
    token = Token.find_by(secret: params[:secret])

    if token
      render json: { token: token }, status: :ok
    else
      render json: { error: "Could not find token!" }, status: :not_found
    end
  end

  private

  def token_params
    params.require(:token).permit(:secret)
  end
end
