spot = require 'home.spot'

spot.model 'Spot',
  info: """
    The location of an object. This should be used for objects
    that can not track themselves.

    Those that can should stream their location over feeds.
    They could perhaps use this as a 'last seen at'
  """
  schema:
    obj:
      type: String
      required: yes
    lat:
      type: Number
      required: yes
    lng:
      type: Number
      required: yes
