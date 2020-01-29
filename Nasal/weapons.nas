############ Cannon impact messages #####################
var TRUE = 1;
var FALSE = 0;
var hits_count = 0;
var hit_timer  = FALSE;
var hit_callsign = "";

var impact_listener = func {
    var list = radar.completeList;
    var ballistic_name = props.globals.getNode("/ai/models/model-impact").getValue();
    var ballistic = props.globals.getNode(ballistic_name, 0);
    if (ballistic != nil and ballistic.getName() != "munition") {
      var typeNode = ballistic.getNode("impact/type");
      if (typeNode != nil and typeNode.getValue() != "terrain") {
        var lat = ballistic.getNode("impact/latitude-deg").getValue();
        var lon = ballistic.getNode("impact/longitude-deg").getValue();
        var alt = ballistic.getNode("impact/elevation-m").getValue();
        var impactPos = geo.Coord.new().set_latlon(lat, lon, alt);
        var typeOrd = ballistic.getNode("name").getValue();
        foreach(var active_u;list) {
          var selectionPos = active_u.get_Coord();
          var distance = impactPos.direct_distance_to(selectionPos);
          if (distance < 75) {
            hits_count += 1;
            if ( hit_timer == FALSE ) {
              hit_timer = TRUE;
              hit_callsign = active_u.get_Callsign();
              settimer(func{hitmessage(typeOrd);},1);
            }
          }
        }
      }
    }
}

var hitmessage = func(typeOrd) {
  #print("inside hitmessage");
  var phrase = typeOrd ~ " hit: " ~ hit_callsign ~ ": " ~ hits_count ~ " hits";
  if (getprop("payload/armament/msg") == TRUE) {
    armament.defeatSpamFilter(phrase);
  } else {
    setprop("/sim/messages/atc", phrase);
  }
  hit_callsign = "";
  hit_timer = 0;
  hits_count = 0;
}

# setup impact listener
setlistener("/ai/models/model-impact", impact_listener, 0, 0);

