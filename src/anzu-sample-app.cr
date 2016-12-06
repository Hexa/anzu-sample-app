require "kemal"
require "http/client"
require "openssl/hmac"
require "time"

CHANNEL_ID = ""
UPSTREAM_TOKEN = ""
ANZU_API_KEY = ""
ANZU_SECRET_KEY = ""
ANZU_API_URI = "https://anzu.shiguredo.jp/api/"

def generate_request_headers(target)
  date = Time.utc_now.to_s("%Y-%m-%dT%H:%M:%SZ")
  signature = generate_signature(date, ANZU_SECRET_KEY, ANZU_API_KEY)
  HTTP::Headers{"x-anzu-target" => target,
                "x-anzu-apikey" => ANZU_API_KEY,
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
  headers = generate_request_headers("AnzuAPI_20151216.GenerateDownstreamToken")
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

post "/disconnect/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.Disconnect")
  client_id = env.params.json["clientId"]
  body = {channelId: CHANNEL_ID, clientId: client_id}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

post "/disconnect_channel/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.DisconnectChannel")
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

get "/list_connections/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.ListConnections")
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

get "/list_channels/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.ListChannels")
  response = HTTP::Client.post(ANZU_API_URI, headers: headers)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

post "/regenerate_upstream_token/" do |env|
  headers = generate_request_headers("AnzuAPI_20151216.RegenerateUpstreamToken")
  body = {channelId: CHANNEL_ID}.to_json
  response = HTTP::Client.post(ANZU_API_URI, headers: headers, body: body)
  env.response.status_code = response.status_code
  env.response.content_type = "application/json"
  response.body
end

Kemal.run
