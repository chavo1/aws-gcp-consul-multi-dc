public_dns_servers_virginia = attribute(
  "public_dns_servers_virginia",
  description: "server dns"
)

1.upto(public_dns_servers_virginia.length) do |x|
  describe command('terraform state list') do
    its('stdout') { should include "module.consul_virginia.aws_instance.server[#{x -1}]" }
    its('stderr') { should include '' }
    its('exit_status') { should eq 0 }
  end
end

