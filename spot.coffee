events = require 'events'
io     = require 'socket.io'
uuid   = require 'uuid'
btle   = require 'btle'

###
 * This event emitter takes socket connections, and
 * relays location information sent over them.
###
class Spot extends events.EventEmitter
  constructor: ->
    @callbacks =
      wifi: {}
      gps: {}
      manual: {}
      btle: {}
      spot: {}

    @socket = io.listen 80 || TODO

    @socket
      .of '/spot'
      .on 'connection', (socket) =>
        socket.on 'init', ({obj}) =>
          socket.on 'gps', ({lat, lng}) =>
            @emit 'gps', {obj, lat, lng}

          socket.on 'btle', (args) ->
            {lat, lng} = btle.triangulate args.beacons
            @emit 'btle', {obj, lat, lng}

        socket.emit 'handshake'


  follow: (type, obj, callback) =>
    callbacks = @callbacks[type][obj] ?= {}
    uid = uuid.v4()
    callbacks[uid] = callback
    ->
      delete callbacks[uid]

spot = new Spot

params =
  obj:
    name: "Object"
    type: 'string'
    info: """
      The object to track the position of.
    """

spot.feed 'spot',
  name: "Spot"
  info: """
    Spot is the positioning system of Home.

    It provides layered granularities of location feeds.
    - wifi (~50m)
    - gps (~10m)
    - btle (~1m)
  """
  params:
    obj: params.obj
  , (args) ->
    spot.on 'spot', (args) ->

spot.feed 'gps', ->
  name: "Spot - GPS"
  info: """
    GPS location with an accuracy of ~10m
  """
  params:
    obj: params.obj
  , ({obj}) ->
    (callback) ->
      spot.gps 'gps', obj, callback

spot.feed 'wifi', ->
  name: "Spot - Wifi"
  info: """
    Tells if an object is connected to the wifi network.
  """
  params:
    obj: params.obj
  , ({obj}) ->
    (callback) ->
      spot.follow 'wifi', obj, callback

spot.feed 'btle', ->
  name: "Spot - BTLE"
  info: """
    Triangulate the accurate position of an object per Blue Tooth Low Energy.
  """
  params:
    obj: params.obj
  , ({obj}) ->
    (callback) ->
      spot.follow 'btle', obj, callback

spot.feed 'home', ->
  name: "Spot - Home"
  info: """
    A feed of objects entering or leaving homes.
  """
  params:
    obj: params.obj