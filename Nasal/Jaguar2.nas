#### Typhonn systems	
#### crazy dj nasal from many sources...
#### and also, almursi work

#slat flaps system
setprop("/controls/flight/flap-lever", 0);
setprop("/controls/flight/flaps", 0);
setprop("/controls/flight/slats", 0);

controls.flapsDown = func(step) {
  if (step == 1) {
    var flapLever = getprop("/controls/flight/flap-lever");
    if (flapLever == 0) {
      setprop("/controls/flight/flaps", 0.000);
      setprop("/controls/flight/slats", 0.391);
      setprop("/controls/flight/flap-lever", 1);
      return;
    } else if (flapLever == 1) {
      setprop("/controls/flight/flaps", 0.000);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 2);
      return;
    } else if (flapLever == 2) {
      setprop("/controls/flight/flaps", 0.150);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 3);
      return;
    } else if (flapLever == 3) {
      setprop("/controls/flight/flaps", 0.250);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 4);
      return;
    } else if (flapLever == 4) {
      setprop("/controls/flight/flaps", 0.500);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 5);
      return;
    } else if (flapLever == 5) {
      setprop("/controls/flight/flaps", 1.000);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 6);
      return;
    } 
  } else if (step == -1) {
    var flapLever = getprop("/controls/flight/flap-lever");
    if (flapLever == 6) {
      setprop("/controls/flight/flaps", 0.500);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 5);
      return;
    } else if (flapLever == 5) {
      setprop("/controls/flight/flaps", 0.250);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 4);
      return;
    } else if (flapLever == 4) {
      setprop("/controls/flight/flaps", 0.150);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 3);
      return;
    } else if (flapLever == 3) {
      setprop("/controls/flight/flaps", 0.000);
      setprop("/controls/flight/slats", 1.000);
      setprop("/controls/flight/flap-lever", 2);
      return;
    } else if (flapLever == 2) {
      setprop("/controls/flight/flaps", 0.000);
      setprop("/controls/flight/slats", 0.391);
      setprop("/controls/flight/flap-lever", 1);
      return;
    } else if (flapLever == 1) {
      setprop("/controls/flight/flaps", 0.000);
      setprop("/controls/flight/slats", 0.000);
      setprop("/controls/flight/flap-lever", 0);
      return;
    }
  } else {
    return 0;
  }
}




setlistener("/controls/engines/engine[0]/throttle", func(n) {
    setprop("/controls/engines/engine[0]/reheat", n.getValue() >= 0.95);
},1);


setlistener("/controls/engines/engine[1]/throttle", func(n) {
    setprop("/controls/engines/engine[1]/reheat", n.getValue() >= 0.95);
},1);


# turn off hud in external views
# setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);

var canopy = aircraft.door.new ("/controls/canopy/", 3);

aircraft.livery.init("Aircraft/Jaguar/Models/Liveries");



### Stall warning
### 
#var s_warning_state = getprop("/sim/alarms/stall-warning");
#
#var stall_warning = func {
#    # WOW =getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
#    var Estado = 0;
#    if ( and !WOW) {
#    } else { 
#    };
#   setprop("/sim/alarms/stall-warning", Estado);
#};


var controls = {
     gearLights: func(a) {
	     var switch = props.globals.getNode("/controls/switches/gear-lights");
		 var land = props.globals.getNode("/controls/switches/landing-light");
#		 var land1 = props.globals.getNode("/controls/switches/landlight1");
		 var taxi = props.globals.getNode("/controls/switches/taxi-light");
#		 var taxi1 = props.globals.getNode("/controls/switches/taxilight1");
		 switch.setValue(a);
		 if ( a == 1 ) {
			 land.setBoolValue(1);
#			 land1.setBoolValue(1);
#				setprop("/sim/rendering/als-secondary-lights/landing-light1-offset-deg", 5.5);
			 taxi.setBoolValue(0);
#			 taxi1.setBoolValue(1);
			 }
		 if ( a == 2 ) {
			 land.setBoolValue(0);
#			 land1.setBoolValue(0);
#				setprop("/sim/rendering/als-secondary-lights/landing-light1-offset-deg", 0);
			 taxi.setBoolValue(0);
#			 taxi1.setBoolValue(0);
			 }
		 if ( a == 3 ) {
			 land.setBoolValue(0);
#			 land1.setBoolValue(0);
			 taxi.setBoolValue(1);
#			 taxi1.setBoolValue(1);
#				setprop("/sim/rendering/als-secondary-lights/landing-light1-offset-deg", 6.5);
			 }
		}		     
};


# ================================== Chute ==================================================

controls.deployChute = func(v){

	# Deploy
	if (v > 0){
		setprop("sim/model/lightning/controls/flight/chute_deployed",1);
		setprop("sim/model/lightning/controls/flight/chute_open",1);
		chuteAngle();
	}
	# Jettison
	if (v < 0){ 
		var voltage = getprop("systems/electrical/outputs/chute_jett");
		if (voltage > 20) {
			setprop("sim/model/lightning/controls/flight/chute_jettisoned",1);
			setprop("sim/model/lightning/controls/flight/chute_open",0);
		}
	}
}


var chuteAngle = func {

	var chute_open = getprop('sim/model/lightning/controls/flight/chute_open');
	
	if (chute_open != '1') {return();}

	var speed = getprop('velocities/airspeed-kt');
	var aircraftpitch = getprop('orientation/pitch-deg[0]');
	var aircraftyaw = getprop('orientation/side-slip-deg');
	var chuteyaw = getprop("sim/model/lightning/orientation/chute_yaw");
	var aircraftroll = getprop('orientation/roll-deg');

	if (speed > 210) {
		setprop("sim/model/lightning/controls/flight/chute_jettisoned", 1); # Model Shear Pin
		return();
	}

	# Chute Pitch
	var chutepitch = aircraftpitch * -1;
	setprop("sim/model/lightning/orientation/chute_pitch", chutepitch);

	# Damped yaw from Vivian's A4 work
	var n = 0.01;
	if (aircraftyaw == nil) {aircraftyaw = 0;}
	if (chuteyaw == nil) {chuteyaw = 0;}
	var chuteyaw = ( aircraftyaw * n) + ( chuteyaw * (1 - n));	
	setprop("sim/model/lightning/orientation/chute_yaw", chuteyaw);

	# Chute Roll - no twisting for now
	var chuteroll = aircraftroll;
	setprop("sim/model/lightning/orientation/chute_roll", chuteroll*rand()*-1 );

	return registerTimerControlsNil(chuteAngle);	# Keep watching

} # end function

var chuteRepack = func{

	setprop('sim/model/lightning/controls/flight/chute_open', 0);
	setprop('sim/model/lightning/controls/flight/chute_deployed', 0);
	setprop('sim/model/lightning/controls/flight/chute_jettisoned', 0);

} # end func	

