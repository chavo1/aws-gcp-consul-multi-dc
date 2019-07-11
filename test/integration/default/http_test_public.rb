###!/usr/bin/env ruby

public_dns_servers_virginia = attribute(
  "public_dns_servers_virginia",
  description: "server dns"
)

public_dns_servers_ohio = attribute(
  "public_dns_servers_ohio",
  description: "server dns"
)

# puts(public_dns_servers_virginia.length)
# puts(public_dns_servers_ohio.length)

1.upto(public_dns_servers_virginia.length) do |x|
  describe http("http://#{public_dns_servers_virginia[x -1]}:8500/ui/sofia/services") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers_virginia[x -1]}:8500/ui/sofia/nodes") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers_virginia[x -1]}:8500/ui/sofia/services/web") do
    its('status') { should cmp 200 }
  end
end
1.upto(public_dns_servers_ohio.length) do |y|
  describe http("http://#{public_dns_servers_ohio[y -1]}:8500/ui/varna/services") do
  its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers_ohio[y -1]}:8500/ui/varna/nodes") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers_ohio[y -1]}:8500/ui/varna/services/web") do
    its('status') { should cmp 200 }
  end
end