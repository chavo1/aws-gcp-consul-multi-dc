#!/usr/bin/env ruby

public_dns_servers_virginia = attribute(
  "public_dns_servers_virginia",
  description: "server dns"
)

# puts(public_dns_servers_virginia.length)

1.upto(public_dns_servers_virginia.length) do |x|
  describe http("http://#{public_dns_servers_virginia[x -1]}:8500/ui/aws_virginia/services") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers_virginia[x -1]}:8500/ui/aws_virginia/nodes") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers_virginia[x -1]}:8500/ui/aws_virginia/services/web") do
    its('status') { should cmp 200 }
  end
end
