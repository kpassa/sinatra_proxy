require File.expand_path("../account", __FILE__)

a = Account.new("12345115")

while a.transaction_state == "busy" do
  print "*"
  a.get
  sleep(1)
end
print "\n"

puts a.to_s
