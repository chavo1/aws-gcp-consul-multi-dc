#!/usr/bin/env ruby

public_dns_servers_virginia = attribute(
  "public_dns_servers_virginia",
  description: "public dns"
)

public_dns_servers_ohio = attribute(
  "public_dns_servers_ohio",
  description: "public dns"
)

puts(public_dns_servers_virginia.length)
puts(public_dns_servers_ohio.length)

require 'rubygems'
require 'selenium-webdriver'

1.upto(public_dns_servers_virginia.length) do |x|
  browser = Selenium::WebDriver.for :firefox
  browser.get "http://#{public_dns_servers_virginia[x -1]}:8500/ui/virginia/services"
  sleep 2
  browser.save_screenshot("scr/consul_services_virginia-#{00+x}.png")
  browser.get "http://#{public_dns_servers_virginia[x -1]}:8500/ui/virginia/services/web"
  sleep 2
  browser.save_screenshot("scr/consul_services_virginia_web-#{00+x}.png")
  browser.get "http://#{public_dns_servers_virginia[x -1]}:8500/ui/virginia/nodes"
  sleep 2
  browser.save_screenshot("scr/consul_nodes_virginia-#{00+x}.png")
  browser.quit
end

1.upto(public_dns_servers_ohio.length) do |y|
  browser = Selenium::WebDriver.for :firefox
  browser.get "http://#{public_dns_servers_ohio[y -1]}:8500/ui/ohio/services"
  sleep 2
  browser.save_screenshot("scr/consul_services_ohio-#{00+y}.png")
  browser.get "http://#{public_dns_servers_ohio[y -1]}:8500/ui/ohio/services/web"
  sleep 2
  browser.save_screenshot("scr/consul_services_ohio_web-#{00+y}.png")
  browser.get "http://#{public_dns_servers_ohio[y -1]}:8500/ui/ohio/nodes"
  sleep 2
  browser.save_screenshot("scr/consul_nodes_ohio-#{00+y}.png")
  browser.quit
end

