require 'rubygems'
require 'debugger'
require 'logger'
require 'oauth2'
require 'sinatra'

CLIENT_ID               = '<REPLACE>'
CLIENT_SECRET           = '<REPLACE>'
OAUTH2_PROVIDER         = '<REPLACE WITH PORTAL URL>'
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

def token
  OAuth2::AccessToken.from_hash(client, session[:access_token_hash] || {})
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

enable :sessions

before do
  # Check for valid Portal session by calling its API
  # Logout if invalid

  # Check for valid access token by looking at its expiration
  if token.expired?
    redirect to('/logout')
  end
end

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
  session[:access_token] = access_token.token
  session[:access_token_hash] = access_token.to_hash
  redirect to('/success')
end

get '/refresh' do
  if token.expires?
    new_token = token.refresh!
    session[:access_token_hash] = new_token.to_hash
  end
  redirect to('/')
end

get '/logout' do
  session.clear
  redirect logout_uri
  return
end

get '/success' do
  erb :success, locals: { target: logout_uri }
end
