require "sinatra/base"
require 'chartkick'

class Visualiser < Sinatra::Base
 
  set :bind, '0.0.0.0'

  get '/' do
    @rooms = settings.rooms
    @state = settings.state
    erb :rooms
  end

  get '/rooms/:name' do
    @roomName = params['name']
    @room = settings.rooms[@roomName.to_sym]
    erb :room
  end

  get '/history/:name' do
    @stateName = params['name']
    @state = settings.state
    erb :history
  end

  get '/rooms/:name/:device/:action' do
    @roomName = params['name']
    @deviceName = params['device']
    @action = params['action']

    settings.rooms[@roomName.to_sym][@deviceName.to_sym].send(@action.to_sym)
    redirect "/rooms/#{@roomName}"
  end
end
