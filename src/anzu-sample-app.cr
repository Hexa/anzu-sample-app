require "kemal"
require "http/client"
require "openssl/hmac"
require "time"

CHANNEL_ID = ""
UPSTREAM_TOKEN = ""
ANZU_API_KEY = ""
ANZU_SECRET_KEY = ""
ANZU_API_URI = "https://anzu.shiguredo.jp/api/"

def generate_request_headers(target, secret_key, api_key)
  date = Time.utc_now.to_s("%Y-%m-%dT%H:%M:%SZ")
  signature = generate_signature(date, secret_key, api_key)
  HTTP::Headers{"x-anzu-target" => target,
                "x-anzu-apikey" => api_key,
                "x-anzu-date" => date,
                "x-anzu-signature" => signature,
                "Content-Type" => "application/json"}
end

def generate_signature(date, secret_key, api_key)
  OpenSSL::HMAC.hexdigest(:sha256, secret_key, api_key + date)
end

get "/channel_id/" do
  {channelId: CHANNEL_ID}.to_json
end

get "/upstream_token/" do
  {upstreamToken: UPSTREAM_TOKEN}.to_json
end

get "/downstream_token/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.GenerateDownstreamToken", ANZU_SECRET_KEY, ANZU_API_KEY)
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

post "/disconnect/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.Disconnect", ANZU_SECRET_KEY, ANZU_API_KEY)
  client_id = env.params.json["clientId"]
  body = {channelId: CHANNEL_ID, clientId: client_id}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

post "/disconnect_channel/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.DisconnectChannel", ANZU_SECRET_KEY, ANZU_API_KEY)
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

get "/list_connections/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.ListConnections", ANZU_SECRET_KEY, ANZU_API_KEY)
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

get "/list_channels/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.ListChannels", ANZU_SECRET_KEY, ANZU_API_KEY)
  response = HTTP::Client.post(ANZU_API_URI, headers: headers)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

post "/regenerate_upstream_token/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.RegenerateUpstreamToken", ANZU_SECRET_KEY, ANZU_API_KEY)
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

Kemal.run
