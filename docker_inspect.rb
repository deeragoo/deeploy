#!/usr/bin/env ruby

require 'json'

container_id = "dbceac3f4e0c8678a8c5c5fd9fb364873b375066201da03a3f68b454bd1a32e9"
puts "container_id: #{container_id}"

output = `docker inspect #{container_id}`
# puts "output: #{output}"
data = JSON.parse(output)
# puts "data: #{data}"

ip_address = data[0]['NetworkSettings']['IPAddress']
state_error = data[0]['State']['Error']
state_status = data[0]['State']['Status']
puts "ip address: #{ip_address}"
puts "State Error: #{state_error}"
puts "State Status: #{state_status}"
