# frozen_string_literal: true

class Rack::Attack
  # Use a dedicated in-memory store so throttling does not depend on solid_cache tables.
  cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("logins/ip", limit: 5, period: 20.minutes) do |req|
    req.ip if req.post? && req.path == "/session"
  end

  throttle("registrations/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.post? && req.path == "/registration"
  end

  self.throttled_responder = lambda do |_request|
    [ 429, { "Content-Type" => "text/plain; charset=utf-8" }, [ "リクエストが多すぎます。しばらく待ってから再度お試しください。" ] ]
  end
end
