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
require_relative '../../../spec_helper'
require 'tng/gtk/utils/fetch'
require 'securerandom'

RSpec.describe Tng::Gtk::Utils::Fetch do
  let(:data) {{uuid: SecureRandom.uuid, whatever: 'else'}}
  context 'with NO_CACHE' do
    it 'should fetch requested data' do
      allow(ENV).to receive(:[]).with("NO_CACHE").and_return("true")
      Tng::Gtk::Utils::Fetch.site='http://example.com'
      WebMock.stub_request(:get, Tng::Gtk::Utils::Fetch.site+'/'+data[:uuid]).to_return(body: data.to_json, status: 200)
      expect(Tng::Gtk::Utils::Fetch.call({uuid: data[:uuid]})).to eq(data)
    end
  end
  context 'without NO_CACHE' do
    before(:each){allow(ENV).to receive(:[]).with("NO_CACHE").and_return("")}
    it 'should cache passed data the first time' do
      allow(Tng::Gtk::Utils::Cache).to receive(:cached?).with(data[:uuid]).and_return('')
      allow(Tng::Gtk::Utils::Cache).to receive(:cache).with(data).and_return(data)
      Tng::Gtk::Utils::Fetch.site='http://example.com'
      WebMock.stub_request(:get, Tng::Gtk::Utils::Fetch.site+'/'+data[:uuid]).to_return(body: data.to_json, status: 200)
      Tng::Gtk::Utils::Fetch.call({uuid: data[:uuid]})
      expect(Tng::Gtk::Utils::Cache).to have_received(:cache).with(data)
    end
    it 'should fetch from cache passed data the next time' do
      allow(Tng::Gtk::Utils::Cache).to receive(:cached?).with(data[:uuid]).and_return(data)
      allow(Tng::Gtk::Utils::Cache).to receive(:cache).with(data).and_return(data)
      Tng::Gtk::Utils::Fetch.call({uuid: data[:uuid]})
      expect(Tng::Gtk::Utils::Cache).not_to have_received(:cache).with(data)
    end
  end
end