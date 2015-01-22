# Spot

# Identifies location
# Distance between locations
# Set a GPS location for homehub/router

+ Wifi Network
    - At home?
+ Geofencing
    - At home?
    - Distance to home?
+ BLE
  Goes on when person is at home
    - At room?
    - Distance to object?
+ Manual
  Through interface
    - All


## ISSUES
Altitude (same building different floor)
Quadangulate? ((x, y, z) or (x, y, floor)

    /area
        [Area]
        /<area>
            {
                "uid": "lounge",
                "name": "Lounge",
                "blefence": []
            }

    /spots
        [Spot]

        /<uuid>
            {
                "uuid": <uuid>
                "home": <home> or None,
                "area": <area> or None,
                "global": {
                    "lat": <lat>,
                    "long": <long>
                },
                "local": {
                    "x": <x>,
                    "y": <y>
                }
            }

        /distance/<uuid>
            {
                "meters": <meters>
            }

## Triggers

    enter.home <uuid> -> <home>
    enter.area <uuid> -> <area>

    enter.home <home> -> <uuid>
    enter.area <area> -> <uuid>
    enter.spot <uuid> <meters> -> <uuid>

    enter.home <home> <uuid>
    enter.area <area> <uuid>
    enter.spot <uuid> <meters> <uuid>

    leave.home <uuid> -> <home>
    leave.area <uuid> -> <area>

    leave.home <home> -> <uuid>
    leave.area <area> -> <uuid>
    leave.spot <uuid> <meters> -> <uuid>

    leave.home <home> <uuid>
    leave.area <area> <uuid>
    leave.spot <uuid> <meters> <uuid>

## Feeds

    home <uuid> -> <home>
    area <uuid> -> <area>
    distance <uuid> <uuid> -> <meters>
