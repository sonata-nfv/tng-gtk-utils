## Copyright (c) 2015 SONATA-NFV, 2017 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## ALL RIGHTS RESERVED.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Neither the name of the SONATA-NFV, 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## nor the names of its contributors may be used to endorse or promote
## products derived from this software without specific prior written
## permission.
##
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the SONATA
## partner consortium (www.sonata-nfv.eu).
##
## This work has been performed in the framework of the 5GTANGO project,
## funded by the European Commission under Grant number 761493 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the 5GTANGO
## partner consortium (www.5gtango.eu).
# encoding: utf-8
# frozen_string_literal: true
require 'redis'

module Tng
  module Gtk
    module Utils
      class Cache
  
        class RedisCache 
          class << self
            attr_accessor :store
          end
    
          def store=(value) self.class.store = value end
          def store() self.class.store end

          begin
            self.store = Redis.new
          rescue StandardError => e
            e.inspect
            e.message
          end
          def self.set(key, val) self.store.set(key, val) end
          def self.get(key)      self.store.get(key) end
          def self.del(key)      self.store.set(key, nil) end
        end
  
        class MemoryCache
          class << self
            attr_accessor :store
          end
          def store=(value) self.class.store = value end
          def store() self.class.store end
          self.store = {}
          def self.set(key, val) self.store[key] = val end
          def self.get(key)      self.store[key] end
          def self.del(key)      self.store[key] = nil end
        end

        STRATEGIES = {
          redis: RedisCache, 
          memory: MemoryCache
        }
        class << self
          attr_accessor :strategy
        end

        def strategy=(value) self.class.strategy = value end
        def strategy() self.class.strategy end
  
        self.strategy = ENV['REDIS_URL'] ? STRATEGIES[:redis] : STRATEGIES[:memory]
        STDERR.puts "Strategy used: #{self.strategy}"
  
        def self.set(records)
          if records.is_a?(Hash)
            STDERR.puts "Setting key '#{records[:uuid]}' with value '#{records}' (strategy #{self.strategy})"
            self.strategy.set(records[:uuid], records) if records.key?(:uuid)
            return
          end
          records.each do |record|
            STDERR.puts "Setting key '#{record[:uuid]}' with value '#{record}' (strategy #{self.strategy})"
            self.strategy.set(record[:uuid], record) if record.key?(:uuid)
          end
        end
        def self.get(key)
          STDERR.puts "Getting key '#{key}' (strategy #{self.strategy})"
          self.strategy.get(key)
        end
        def self.del(key)      self.strategy.del(key) end
      end
    end
  end
end
