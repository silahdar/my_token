class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  throttle("limit", limit: 5, period: 20) do |request|
    request.ip if request.path == "/api/v1/tokenize" || "/api/v1/detokenize"
  end
end
