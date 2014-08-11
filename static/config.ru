# Sample app for Google OAuth2 Strategy
# Make sure to setup the ENV variables GOOGLE_KEY and GOOGLE_SECRET
# Run with "bundle exec rackup"

require 'rubygems'
require 'bundler'
require 'sinatra'

# Do not use for production code.
# This is only to make setup easier when running through the sample.
#
# If you do have issues with certs in production code, this could help:
# http://railsapps.github.io/openssl-certificate-verify-failed.html
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base

  set :protection, :except => :frame_options

  get '/iframe' do
    send_file 'iframe.html'
  end

  get '/' do
    send_file 'index.html'
  end
end

run App.new