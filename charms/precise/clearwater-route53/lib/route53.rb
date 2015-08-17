#!/usr/bin/env ruby

require 'aws-sdk-v1'
require 'optparse'
require 'resolv'

class Route53
  def initialize(access_key, secret_key, zone)
    route53 = AWS::Route53.new(access_key_id: access_key,
                               secret_access_key: secret_key)
    
    zones = route53.hosted_zones

    @zone = zones.find { |z| z.name == "#{zone}." }
    if @zone.nil?
      zones.create(zone)
      @zone = zones.find { |z| z.name == "#{zone}." }
    end

    fail "Couldn't find or create zone #{zone}" if zone.nil?
  end

  def hostname(role)
    if role == "bono"
      @zone.name
    else
      "#{role}.#{@zone.name}"
    end
  end

  def add(role, address)
    record_sets = @zone.resource_record_sets
    record_set = record_sets[hostname(role), "A"]
    if record_set.exists?
      unless record_set.resource_records.find { |rr| rr[:value] == address }
        # Update the existing record
        record_set.resource_records = record_set.resource_records + [{ value: address }]
        record_set.update
      end
    else
      # Create a single record
      record_sets.create(hostname(role), "A", ttl: 60, resource_records: [{ value: address }])
    end
  end

  def remove(role, address)
    record_sets = @zone.resource_record_sets
    record_set = record_sets[hostname(role), "A"]
    if record_set.exists? and record_set.resource_records.find { |rr| rr[:value] == address }
      # Remove the record or the whole set
      if record_set.resource_records.size == 1
        record_set.delete
      else
        record_set.resource_records = record_set.resource_records - [{ value: address }]
        record_set.update
      end
    end
  end

  def clean
    record_sets = @zone.resource_record_sets
    record_sets.each do |rs|
      if rs.type == "A"
        rs.delete
      end
    end
  end

private

  def self.parse_options
    options = {}
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: route53 [options]"

      opts.on("--access-key KEY", String, "EC2 Access Key") do |key|
        options[:access_key] = key
      end

      opts.on("--secret-key KEY", String, "EC2 Secret Access Key") do |key|
        options[:secret_key] = key
      end

      opts.on("--zone ZONE", String, "DNS root zone to configure domain in") do |zone|
        options[:zone] = zone
      end

      opts.on("--role ROLE", String, "Node role to modify") do |role|
        options[:role] = role
      end

      opts.on("--address ADDRESS", String, "IP address of the node") do |address|
        options[:address] = Resolv.getaddress(address)
      end
    end

    opts.parse!

    [:access_key, :secret_key, :zone].each do |s|
      if options[s].nil?
        puts opts
        exit
      end
    end

    options
  end
end
