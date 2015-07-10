require 'rubygems'
require 'logger'
require 'oauth2'
require 'sinatra'
require 'pry'

CLIENT_ID               = '<REPLACE>'
CLIENT_SECRET           = '<REPLACE>'
OAUTH2_PROVIDER         = '<REPLACE>'
OAUTH2_ACCESS_TOKEN_URL = '/oauth/phase_two_token'
OAUTH2_AUTHORIZE_URL    = '/oauth/phase_one_authorize'
OAUTH2_CALLBACK         = '/oauth2callback'
OAUTH2_PARAMS           = {
  site:          OAUTH2_PROVIDER,
  authorize_url: OAUTH2_AUTHORIZE_URL,
  token_url:     OAUTH2_ACCESS_TOKEN_URL }


def client
  OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, OAUTH2_PARAMS)
end

def form_uri(url, path)
  uri       = URI.parse url
  uri.path  = path
  uri.query = nil
  uri.to_s
end

def logger
  @logger ||= begin
    log_file      = File.open('oauth2_client.log', 'a+')
    log_file.sync = true
    Logger.new(log_file).tap { |log| log.level  = Logger::DEBUG }
  end
end

def logout_uri
  form_uri OAUTH2_PROVIDER, '/logout'
end

def redirect_uri
  form_uri request.url, OAUTH2_CALLBACK
end

# always start on :4567 for testing
set :port, 4567

enable :sessions
set :session_secret, 'oauth2client'

get '/' do
  erb :home
end

#
# OAuth2 Authorize Phase (aka Step 1):
#   Clicking on the 'Login' link in this app brings the browser here.
#   Redirect to the OAuth server authorize link.
get '/oauth2authorize' do
  redirect client.auth_code.authorize_url( redirect_uri: redirect_uri )
end

#
# OAuth2 Request Phase (aka Step 2):
#   The Provider calls this app here with a request token in params[:code]
#   Exchange the request token for an access token.
get OAUTH2_CALLBACK do
  access_token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
  session[:oauth2] = access_token.to_hash
  redirect to('/')
end

get '/logout' do
  session.clear
  redirect logout_uri
  return
end

get '/refresh' do
  access_token = OAuth2::AccessToken.from_hash(client, session[:oauth2].dup).refresh!
  session[:oauth2] = access_token.to_hash
  redirect to('/')
end
