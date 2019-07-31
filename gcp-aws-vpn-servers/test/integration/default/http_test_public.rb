#!/usr/bin/env ruby

public_ip_gcp = attribute(
  "public_ip_gcp",
  description: "server dns"
)

# puts(public_ip_gcp.length)

1.upto(public_ip_gcp.length) do |x|
  describe http("http://#{public_ip_gcp[x -1]}:8500/ui/gcp_virginia/services") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_ip_gcp[x -1]}:8500/ui/gcp_virginia/nodes") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_ip_gcp[x -1]}:8500/ui/gcp_virginia/services/web") do
    its('status') { should cmp 200 }
  end
end
