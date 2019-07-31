#!/usr/bin/env ruby

public_ip_gcp = attribute(
  "public_ip_gcp",
  description: "public dns"
)

puts(public_ip_gcp.length)

require 'rubygems'
require 'selenium-webdriver'
require 'fileutils'

FileUtils.mkdir_p 'scr/'

1.upto(public_ip_gcp.length) do |x|
  browser = Selenium::WebDriver.for :firefox
  browser.get "http://#{public_ip_gcp[x -1]}:8500/ui/gcp_virginia/services"
  sleep 2
  browser.save_screenshot("scr/consul_services_gcp_virginia-#{00+x}.png")
  browser.get "http://#{public_ip_gcp[x -1]}:8500/ui/gcp_virginia/services/web"
  sleep 2
  browser.save_screenshot("scr/consul_services_gcp_virginia_web-#{00+x}.png")
  browser.get "http://#{public_ip_gcp[x -1]}:8500/ui/gcp_virginia/nodes"
  sleep 2
  browser.save_screenshot("scr/consul_nodes_gcp_virginia-#{00+x}.png")
  browser.quit
end

