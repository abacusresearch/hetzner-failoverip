#!/usr/bin/env ruby
require "rubygems"
require "hetzner-api"

# Retrieve your API login credentials from the Hetzner admin interface
# at https://robot.your-server.de and assign the appropriate environment
# variables:
#
#     $~ export HBC_ROBOT_USER="hetzner_user"
#     $~ export HBC_ROBOT_PASSWORD="verysecret"
#
# Next launch the failover script:
#
#     $~ ./failover.rb failover_ip destination_ip

failover_ip = ARGV[0]
destination_ip = ARGV[1]

print "running ./failover.rb " + failover_ip + " " + destination_ip + "\n"
@api = Hetzner::API.new(ENV['HBC_ROBOT_USER'], ENV['HBC_ROBOT_PASSWORD'])

result = @api.failover? failover_ip

print "Current status: " + result['failover']['active_server_ip'] + "\n"

if result['failover']['active_server_ip'] != destination_ip
  print "Failover " + failover_ip + " ==> " + destination_ip + "\n"
  result = @api.failover! failover_ip, destination_ip
  print "New status: " + result['failover']['active_server_ip'] + "\n"
end
