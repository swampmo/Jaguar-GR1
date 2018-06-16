##### Terrain Following System using submodels as radar beam
#abs()

setlistener("/sim/signals/fdm-initialized", func {
setprop("instrumentation/teravd/elevation_tf_in", 0);
setprop("instrumentation/teravd/distance_tf_in", 0);
setprop("instrumentation/teravd/elevation_tf", 0);
setprop("instrumentation/teravd/tfs_status", 0);
});

setlistener("controls/switches/terrain-follow", func {
settimer(alt_border, 4);
});
#main timer function outer radar beam border
settimer(func {

  # Add listener for radar pulse contact_tf for terrain follow
  setlistener("sim/radar/teravd/contact_tf", func(n) {
    var contact_tf = n.getValue();

      var long = getprop(contact_tf ~ "/impact/longitude-deg");
      var lat = getprop(contact_tf ~ "/impact/latitude-deg");
      var elev_m = getprop(contact_tf ~ "/impact/elevation-m");
      var spd = getprop(contact_tf ~ "/impact/speed-mps");
      var time = getprop(contact_tf ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);

#the code below calculates the same as dist_ft, using another method
var beam = geo.Coord.new().set_latlon(lat, long, elev_m);
var i_dist = beam.direct_distance_to(geo.aircraft_position());
var i_dist_ft = i_dist * 3.28;
setprop("instrumentation/teravd/i_dist", i_dist_ft);

#var beam = geo.Coord.new().set_latlon(a_lat, a_lon);
#var i_coord = beam.apply_course_distance(hdg, i_dist);
#var i_elev = geo.elevation(i_coord.lat(), i_coord.lon());

     setprop("instrumentation/teravd/elevation_tf", elev_ft);
     setprop("instrumentation/teravd/distance_tf", dist_ft);

     settimer(ter_flw, 0);

  });
}, 0);

#help function - inner radar beam border used to clear crests
settimer(func {

  # Add listener for radar pulse contact_tf for terrain follow
  setlistener("sim/radar/teravd/contact_in_tf", func(n) {
    var contact_in_tf = n.getValue();

      var long = getprop(contact_in_tf ~ "/impact/longitude-deg");
      var lat = getprop(contact_in_tf ~ "/impact/latitude-deg");
      var elev_m = getprop(contact_in_tf ~ "/impact/elevation-m");
      var spd = getprop(contact_in_tf ~ "/impact/speed-mps");
      var time = getprop(contact_in_tf ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);

#the code below calculates the same as dist_ft, using another method
#var beam = geo.Coord.new().set_latlon(lat, long, elev_m);
#var i_dist = beam.direct_distance_to(geo.aircraft_position());
#var i_dist_ft = i_dist * 3.28;
#setprop("instrumentation/teravd/i_dist_in", i_dist_ft);

     setprop("instrumentation/teravd/elevation_tf_in", elev_ft);
     setprop("instrumentation/teravd/distance_tf_in", dist_ft);

     settimer(ter_flw, 0);

  });
}, 0);

### calculations of target climb rate / altitude
var ter_flw = func {
var evfpm = getprop("instrumentation/teravd/target-vfpm-exec");
var etalt = getprop("instrumentation/teravd/target-alt-exec");
var calt = getprop("position/altitude-ft");
var cspd = getprop("velocities/groundspeed-kt");
#setprop("autopilot/settings/target-altitude-ft", 0);
#setprop("autopilot/settings/vertical-speed-fpm", -50);
var ele_tf = getprop("instrumentation/teravd/elevation_tf");
var dist_tf = getprop("instrumentation/teravd/distance_tf");
var ele_tf_in = getprop("instrumentation/teravd/elevation_tf_in");
var dist_tf_in = getprop("instrumentation/teravd/distance_tf_in");
var clr_tf = getprop("controls/switches/terrain-follow-clr");
var prty = getprop("controls/switches/terrain-follow-map-enabled");
var rdist2 = 20000;


### calculate vfpm rate/alt outer radar border
var dalt_tf = ((ele_tf + clr_tf) - calt);
var talt = calt + dalt_tf;
var itime = 0;
var itime = dist_tf / (cspd * 1.6878);
var tvfpm = (int((dalt_tf) / itime) * 60) * 1.2;

### calculate vfpm rate/alt inner radar border
var dalt_tf_in = ((ele_tf_in + clr_tf) - calt);
var talt_in = calt + dalt_tf_in;
var itime_in = dist_tf_in / (cspd * 1.6878);
var tvfpm_in = int((dalt_tf_in) / itime_in) * 60;

setprop("instrumentation/teravd/target_alt", talt);
setprop("instrumentation/teravd/target_itime", itime);
setprop("instrumentation/teravd/target_vfpm", tvfpm);
setprop("instrumentation/teravd/target_alt_in", talt_in);
setprop("instrumentation/teravd/target_vfpm_in", tvfpm_in);
setprop("instrumentation/teravd/target_itime_in", itime_in);
settimer(condition, 0);
}

### conditions and decisions
var condition = func {
var calt = getprop("position/altitude-ft");
var talt = getprop("instrumentation/teravd/target_alt");
var etalt = getprop("instrumentation/teravd/target-alt-exec");
var tvfpm = getprop("instrumentation/teravd/target_vfpm");
var evfpm = getprop("instrumentation/teravd/target-vfpm-exec");
var itime = getprop("instrumentation/teravd/target_itime");
var clr_tf = getprop("controls/switches/terrain-follow-clr");
var talt_in = getprop("instrumentation/teravd/target_alt_in");
var tvpm_in = getprop("instrumentation/teravd/target_vfpm_in");
var itime_in = getprop("instrumentation/teravd/target_itime_in");
var dist_tf = getprop("instrumentation/teravd/distance_tf");
var rdist2 = 20000;

if (dist_tf < rdist2) {
### this is the easy part, estimation of begin of climb/end of descent
### if the new climb rate value is bigger than the last
  if (tvfpm > evfpm) {
  # first stop the timer and set parameters
  setprop("instrumentation/teravd/target-clear-time", 0);
  #setprop("instrumentation/teravd/ridge-clear", 0);
  #setprop("instrumentation/teravd/obst-clear", 1);
  setprop("instrumentation/teravd/tfs_status", 1);
  # then set new vertical speed to prevent crash
  setprop("instrumentation/teravd/target-vfpm-exec", tvfpm);
  settimer(setpath, 0);
  #print("simple_climb");
  }

### this is about clearing crests, when the climb rate sinks, alt and time to next safe flight point
### is calculated and executed, then lower climb rates are allowed again
    var r_clear = getprop("instrumentation/teravd/ridge-clear");
    var tfs_status = getprop("instrumentation/teravd/tfs_status");
    if ((tvfpm <= evfpm) and (tfs_status != 2)) {
      #setprop("instrumentation/teravd/ridge-clear", 1);
      #setprop("instrumentation/teravd/obst-clear", 0);
      setprop("instrumentation/teravd/tfs_status", 2);
      ### the uphill part
      if (tvfpm > 0) {
        if (talt > calt) {
          # now check if inner radar border detects some terrain
          if (talt_in > talt) {
          tvfpm = tvpm_in;
          itime = itime_in;
          }
      setprop("instrumentation/teravd/target-vfpm-exec", tvfpm);
      var r_clear_time = int(itime) + 1;
      setprop("instrumentation/teravd/target-clear-time", r_clear_time);
      settimer(clear_time, 0);
      settimer(setpath, 0);
      #print("clear uphill");
        } else {
        setprop("instrumentation/teravd/target-vfpm-exec", -500);
        #setprop("instrumentation/teravd/ridge-clear", 0);
        settimer(setpath, 0);
        print("clear up_stop");
        }

      ### the downhill part
      } elsif (tvfpm <= 0) {
      ### now check if inner radar border detects some terrain
          if (talt_in > talt) {
          tvfpm = tvpm_in;
          itime = itime_in;
          }
            ###filter a bit
            tvfpm = (tvfpm * 4) / 5;
            if (tvfpm <= -5000) {
            tvfpm = -5000;
            }
      setprop("instrumentation/teravd/target-vfpm-exec", tvfpm);
      var r_clear_time = int(itime) + 1;
      setprop("instrumentation/teravd/target-clear-time", r_clear_time);
      settimer(clear_time, 0);
      settimer(setpath, 0);
      #print("clear downhill");
      }
    }
}
}

## timer for clearing crests (how long to fly with current vfps)
var clear_time = func {
var r_clear_time = getprop("instrumentation/teravd/target-clear-time");
#var obst_clear = getprop("instrumentation/teravd/obst-clear");
var tfs_status = getprop("instrumentation/teravd/tfs_status");
  if ((r_clear_time > 0) and (tfs_status != 1)) {
  r_clear_time_new = r_clear_time - 0.5;
  setprop("instrumentation/teravd/target-clear-time", r_clear_time_new);
  settimer(clear_time, 0.5);
    } elsif (r_clear_time <= 0) {
    setprop("instrumentation/teravd/ridge-clear", 0);
    setprop("instrumentation/teravd/tfs_status", 1);
    #print("timer_clear");
    } elsif (tfs_status == 1) {
      setprop("instrumentation/teravd/ridge-clear", 0);
      setprop("instrumentation/teravd/tfs_status", 1);
      #print("timer_clear_abort");
      }
}


## prevents the plane from going into space, if submodels do not hit any terrain while going up
var alt_border = func {
var terflw = getprop("controls/switches/terrain-follow");
if (terflw == 1) {
  var calt = getprop("position/altitude-ft");
  var talt = getprop("instrumentation/teravd/target_alt");
  var clr_tf = getprop("controls/switches/terrain-follow-clr");
  var tvfpm = getprop("instrumentation/teravd/target_vfpm");
  if (((calt - talt) > (2 * clr_tf)) and (tvfpm > 0)) {
    if (tvfpm < -500) {
      var negvfpm = tvfpm;
    } else {
      var negvfpm = -500;
    }
  setprop("instrumentation/teravd/target-vfpm-exec", negvfpm);
  setprop("instrumentation/teravd/ridge-clear", 0);
  settimer(alt_border, 1);
  settimer(setpath, 0);
  } else {
  settimer(alt_border, 1);
  }
}
}


### executors
var setpath = func {
var terflw = getprop("controls/switches/terrain-follow");
if (terflw == 1) {

var tvfpm = getprop("instrumentation/teravd/target-vfpm-exec");

setprop("autopilot/settings/vertical-speed-fpm", tvfpm);
setprop("autopilot/locks/altitude", "vertical-speed-hold");
#setprop("instrumentation/teravd/obst-clear", 0);
#setprop("instrumentation/teravd/tfs_status", 4);
#print("set_properties");
}
}