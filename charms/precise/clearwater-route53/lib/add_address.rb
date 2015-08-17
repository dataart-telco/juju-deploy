#!/usr/bin/env ruby

require_relative './route53'

opts = Route53.parse_options
route53 = Route53.new(opts[:access_key], opts[:secret_key], opts[:zone])
route53.add(opts[:role], opts[:address])
