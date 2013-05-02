require 'httparty'
require 'json'

class Account
  include HTTParty

  URL = "http://localhost:3000/api/v1/gt/services/post-pago-guatemala/accounts.json"
  TOKEN = "0e59149cd488993fe0babaab676a5ec6"

  attr_accessor :account_data
  
  def initialize(number, opts = {})
    @account_data = {}
    response = self.class.post(URL, 
                               body: 
                               { account: 
                                 { number: number, 
                                   query: { 
                                     callback_url: opts[:callback]}}, 
                                 token: TOKEN})
    raise "unprocessable entity" if response.code == 422
    parse(response.body.to_s)
  end

  def get
    parse(self.class.get(url, body: {token: TOKEN}))
  end

  def to_json
    @account_data.to_json
  end

  def method_missing(m,*args,&block)
    @account_data[m.to_s] or super
  end

  def to_s
    @account_data
  end

  private

  def parse(body)
    json_body = JSON.parse(body)
    @account_data = json_body["account"]
  end

end
