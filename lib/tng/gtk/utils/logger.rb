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
require 'json'
require 'logger'

module Tng
  module Gtk
    module Utils
      class Logger
        LOGFILE = ENV.fetch('LOGFILE', STDOUT)
        LOGLEVEL = ENV.fetch('LOGLEVEL', 'info')
        #LOGGER_LEVELS = ['debug', 'info', 'warn', 'error', 'fatal', 'unknown'].freeze
        LOGGER_LEVELS = ['D', 'I', 'W', 'E', 'F', 'U'].freeze
        
        class << self
          def error(start_stop: '', component:, operation:, message:, status: , time_elapsed:)
            generic(type: 'E', start_stop: start_stop, component:component, operation: operation, message:message, status: status, time_elapsed:time_elapsed)
          end
          def warning(start_stop: '', component:, operation: , message:, status: , time_elapsed:)
            generic(type: 'W', start_stop: start_stop, component:component, operation:operation, message:message, status:status, time_elapsed:time_elapsed)
          end
          def info(start_stop: '', component:, operation: , message:, status: , time_elapsed:)
            generic(type: 'I', start_stop: start_stop, component:component, operation:operation, message:message, status:status, time_elapsed:time_elapsed)
          end
          def fatal(start_stop: '', component:, operation: , message:, status: , time_elapsed:)
            generic(type: 'F', start_stop: start_stop, component:component, operation:operation, message:message, status:status, time_elapsed:time_elapsed)
          end
          def debug(start_stop: '', component:, operation:, message:, status:'', time_elapsed:'')
            generic(type: 'D', start_stop: start_stop, component:component, operation:operation, message:message, status:status, time_elapsed:time_elapsed)
          end
          def unknown(start_stop: '', component:, operation: , message:, status: , time_elapsed:)
            generic(type: 'U', start_stop: start_stop, component: component, operation:operation, message: message, status:status, time_elapsed: time_elapsed)
          end
            
          private
          def generic(type:, start_stop:, component:, operation:, message:, status:, time_elapsed:) 
            LOGFILE.puts "#{{
              type: type,                 # mandatory, can be I(nfo), W(arning), D(ebug), E(rror), F(atal) or U(nknown)
              timestamp: Time.now.utc, # mandatory
              start_stop: start_stop,                    # optional, can be empty, 'START' or 'STOP'
              component: component,             # mandatory
              operation: operation,          # mandatory
              message: message,      # mandatory
              status: status,                        # optional, makes sense for start_stop='END'
              time_elapsed: time_elapsed              # optional, makes sense for start_stop='END'
            }.to_json}" if logger_level(type) < LOGLEVEL
          end
          
          def logger_level(level)
            LOGGER_LEVELS.find_index(LOGGER_LEVELS[level])
          end
        end
      end
    end
  end
end
=begin
LOGLEVEL
Unknown: a message that should always be logged, whatever the logging level set;
Fatal: an unhandleable error ocurred;
Error: a handleable error occurred. The service the component delivers should not be interrupted (i.e., it should be able to recover from the error);
Warning: a warning message;
Info: a generic (but useful) information about system operation;
Debug: a low-level information for developers;

{
  "type": "I",                 # mandatory, can be I(nfo), W(arning), D(ebug), E(rror), F(atal) or U(nknown)
  "timestamp": "2018-10-18 15:49:08 UTC", # mandatory
  "start_stop": "END",                    # optional, can be empty, 'START' or 'STOP'
  "component": "tng-api-gtw",             # mandatory
  "operation": "package upload",          # mandatory
  "message": "package uploaded 201",      # mandatory
  "status": "201",                        # optional, makes sense for start_stop='END'
  "time_elapsed": "00:01:20"              # optional, makes sense for start_stop='END'
}

  LOGGER_LEVELS = ['debug', 'info', 'warn', 'error', 'fatal', 'unknown'].freeze
  FORMAT = %{%s - %s [%s] "%s %s%s %s" %d %s %0.4f\n}
  
  def initialize(app, options = {})
    @app = app
    @error_io = options[:logger_io]
    @logger = Logger.new(@error_io)
    @error_io.sync = true
    @logger_level = LOGGER_LEVELS.find_index(options[:logger_level].downcase ||= 'debug')
  end
  

  def call(env)
    msg = self.class.name+'#'+__method__.to_s
    env['5gtango.error']=@error_io
    env['5gtango.logger']=@logger
    @logger.info(msg) {"Called"}

    status, headers, body = @app.call(env)
    @logger.info(msg) {"Finishing with status #{status}"}
    [status, headers, body]
  end

=end