public_ip_gcp = attribute(
  "public_ip_gcp",
  description: "server public ip gcp"
)

1.upto(public_ip_gcp.length) do |x|
  describe command('terraform state list') do
    its('stdout') { should include "google_compute_instance.server[#{x -1}]" }
    its('stderr') { should include '' }
    its('exit_status') { should eq 0 }
  end
end

