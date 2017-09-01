require 'sinatra'
require 'yaml'
require 'haml'

use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == 'admin' && password == 'admin'
end

get '/' do
  users = YAML.load_file('user_list.yml')
  @names =  users["names"]
  haml :peoples
end

get '/peoples' do
  users = YAML.load_file('user_list.yml')
  @names =  users["names"]
  haml :peoples
end

get '/manage' do
  all_users = YAML.load_file('user_list.yml')
  @all_names =  all_users["names"]
  haml :manage
end

post '/user' do
  new_user = {}
  all_users = YAML.load_file('user_list.yml')
  name = params[:name]
  dob = params[:dob]
  new_key = all_users["names"].keys.max ? all_users["names"].keys.max + 1 : 1
  new_user = {"name" => name, "dob" => dob, "completed" => "false", "status" => "false" }
  all_users["names"]["#{new_key}".to_i] = new_user
  File.open("user_list.yml", "w") {|f| f.write(all_users.to_yaml) }
  redirect '/manage'
end

get '/users' do
  all_users = YAML.load_file('user_list.yml')
  @users = all_users["names"]
  haml :users
end

delete '/users/:id' do
  p params[:id]
  redirect '/users'
end

get '/completed/:id' do
  key = params[:id].to_i
  all_users = YAML.load_file('user_list.yml')
  all_users["names"][key]["completed"] = 'true'
  File.open("user_list.yml", "w") {|f| f.write(all_users.to_yaml) }
  redirect '/peoples'
end

get '/revoke/:id' do
  key = params[:id].to_i
  all_users = YAML.load_file('user_list.yml')
  all_users["names"][key]["completed"] = 'false'
  File.open("user_list.yml", "w") {|f| f.write(all_users.to_yaml) }
  redirect '/peoples'
end

get '/reset' do
  all_users = YAML.load_file('user_list.yml')
  all_users["names"].each do |key, value|
    all_users["names"][key]["completed"] = 'false'
  end
  File.open("user_list.yml", "w") {|f| f.write(all_users.to_yaml) }
  redirect '/peoples'
end

get '/add/:id' do
  key = params[:id].to_i
  all_users = YAML.load_file('user_list.yml')
  all_users["names"][key]["status"] = 'true'
  File.open("user_list.yml", "w") {|f| f.write(all_users.to_yaml) }
  redirect '/manage'
end

get '/delete/:id' do
  key = params[:id].to_i
  all_users = YAML.load_file('user_list.yml')
  all_users["names"].delete(key)
  File.open("user_list.yml", "w") {|f| f.write(all_users.to_yaml) }
  redirect '/users'
end