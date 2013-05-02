require File.expand_path("../account", __FILE__)
require "sinatra"

set server: "thin"

connections = []

account_map = {} # account ID to socket

post '/accounts', provides: 'text/event-stream' do
  stamp = Time.now.strftime("%s%3N")
  url = "http://localhost:4567/push/#{stamp}"

  a = Account.new(params[:number], :callback => url)

  if a.transaction_state == "idle"
    a.to_json
  else
    stream :keep_open do |out|
      connections << out
      account_map[stamp] = out
      
      out.callback {
        connections.delete(out)
      }
    end
  end
end

post '/push/:stamp' do
  stamp = params[:stamp]
  out = account_map.delete(params[:stamp])
  out << params.select{ |k| k == "account" }.to_json
  out.close
end
