#terrain following system - max speed 540knots tas
#print("terrain following system active");

#define local global vars
var beam_ele = -9999;
var sec_per_km = nil;
var fixpos = nil;

#start main loops if terrain-follow activated
setlistener("controls/switches/terrain-follow", func {
  cont_loop();
  time_loop();
});


var cont_loop = func {
  if(enabled){
    beam();
    dist_cycle();
    follow();
    cont_loop();
  }
}

var time_loop = func {
  if(enabled){
    time_per_km();
    settimer(time_loop,0.5);
  }
}

var beam = func {
  var beam_dist = 3000;#in m
  var my_pos = geo.aircraft_position();
  var beam = my_pos.apply_course_distance(hdg, beam_dist);
  var beam_alt = geo.elevation(beam.lat(), beam.lon());
  if(beam_alt > beam_ele){
    beam_ele = beam_alt;
  }
}

var time_per_km = func {
  var tas = getprop("velocities/groundspeed-kt");
  var tas_mps = tas * 1.852 / 3.6;
  sec_per_km = 1000 / tas_mps;
}

var vfps_up = func {
  var calt = getprop("position/altitude-ft");
  var talt = nil;
  target-vfpm = ((talt - calt) / sec_per_km + ((talt - calt) * 1) / (2 * sec_per_km)) * 3600;
  interpolate(instrumentation/teravd/current-vfpm,target-vfpm,(sec_per_km / 3));
}

var vfps_up_level = func {
  var talt = nil;
  if ((talt - calt) < ((talt - fixalt) / 4)){
    #engage alt hold to level out
  }
  
}

var dist_cycle = func {
  if(fixdist == nil or fixdist > 1000){#in m
  beam_ele = -9999;
  fixpos = geo.aircraft_position();
  }
  var fixdist = fixpos.direct_distance_to(geo.aircraft_position());#in m
}

var follow = func {
  if(talt >= calt){
    #go up
  }
  if(talt < calt){
    #go down
  }

}