#!/usr/bin/env ruby

public_dns_servers_virginia = attribute(
  "public_dns_servers_virginia",
  description: "public dns"
)

puts(public_dns_servers_virginia.length)

require 'rubygems'
require 'selenium-webdriver'
require 'fileutils'

FileUtils.mkdir_p 'scr/'

1.upto(public_dns_servers_virginia.length) do |x|
  browser = Selenium::WebDriver.for :firefox
  browser.get "http://#{public_dns_servers_virginia[x -1]}:8500/ui/aws_virginia/services"
  sleep 2
  browser.save_screenshot("scr/consul_services_aws_virginia-#{00+x}.png")
  browser.get "http://#{public_dns_servers_virginia[x -1]}:8500/ui/aws_virginia/services/web"
  sleep 2
  browser.save_screenshot("scr/consul_services_aws_virginia_web-#{00+x}.png")
  browser.get "http://#{public_dns_servers_virginia[x -1]}:8500/ui/aws_virginia/nodes"
  sleep 2
  browser.save_screenshot("scr/consul_nodes_aws_virginia-#{00+x}.png")
  browser.quit
end

