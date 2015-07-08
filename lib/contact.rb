require 'sinatra' 
require 'sinatra/activerecord'

db = URI.parse('postgres://user:pass@localhost/dbname')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => 'postgres',
  :password => 'pass',
  :database => 'contacts',
  :encoding => 'utf8'
)

class Client < ActiveRecord::Base
	validates :client_name, presence: true, length: {minimum: 5}
  validates :budget, presence: true, length: {minimum: 3}
end

get '/' do 
	@clients = Client.all
  @clients_sum_budget = Client.all.pluck(:budget).sum
  haml :index
end

post '/' do
  Client.create(params[:client])
  redirect to('/')
end

get "/clients/:id" do
  @client = Client.find(params[:id])
  haml :client
end

delete '/delete/clients/:id' do
  Client.find(params[:id]).destroy
  redirect to('/')
end
