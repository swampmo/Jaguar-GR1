# Jaguar engine controls
#


var air_gen_rpm = 0;
var air_gen_on = 0;
var cutoff_0 = 1;
var cutoff_1 = 1;
var cwp_bat = 0;
var start_0 = 0;
var start_1 = 0;
var rdy_for_engine_start = 0;
var corr_rot_0 = 0;
var corr_rot_1 = 0;
var throttleStop_0 = 0;
var throttleStop_1 = 0;
var throttle_0 = 0;
var throttle_1 = 0;

var N2_IDLE = 60;#idlen2 in engine file (which should be 39)
var N2_IGNITE = 25.18;#ignitionn2 in engine file (which should be 15) [Wait to set it to 15 till FG 2019.2.1 due to bug in jsbsim]

props.globals.initNode("engines/air-gen-switch", 0, "BOOL");
props.globals.initNode("engines/air-gen-button", 0, "BOOL");
props.globals.initNode("engines/eng-ign-switch", 0, "BOOL");
props.globals.initNode("engines/throttle-stop[0]", 1, "BOOL");# latch on throttle
props.globals.initNode("engines/throttle-stop[1]", 1, "BOOL");# latch on throttle
props.globals.initNode("engines/eng-start-switch", 0, "INT");# -1 = engine 1   0 = none  1 = engine 2
props.globals.initNode("engines/air-gen-button-light", 0, "BOOL");# green
props.globals.initNode("engines/air-valve-open-light", 0, "BOOL");# orange
props.globals.initNode("engines/caution-bat", 0, "BOOL");# BAT on caution warning panel
props.globals.initNode("engines/corr-rotation[0]", 0, "BOOL");# CORRECT ROTATION light (LP-1)
props.globals.initNode("engines/corr-rotation[1]", 0, "BOOL");# CORRECT ROTATION light (LP-2)
props.globals.initNode("engines/air-gen-n1", 0, "INT");# rpm of starter engine
props.globals.initNode("engines/fuel-pumps-switch[0]", 0, "BOOL");
props.globals.initNode("engines/fuel-pumps-switch[1]", 0, "BOOL");
props.globals.initNode("engines/throttle-pos-norm[0]", 0, "DOUBLE");# use this to animate throttle
props.globals.initNode("engines/throttle-pos-norm[1]", 0, "DOUBLE");# use this to animate throttle

#startup sequence:
#-----------------
#both fuel-pumps-switch=1 (ON)
#air-gen-switch=1 (ON)
#air-gen-button=1 (PRESS) [green light in button comes on]
#eng-ign-switch=1 (ON)
#wait for BAT light on caution panel to go out
#eng-start-switch=-1 (1) [air valve light comes on]
#wait
#eng-start-switch=1 (2)
#wait
#both throttle-stop=0 (latches on throttle, is basically cutoff)
#wait for air valve and green button light to go out

var engineStartLoop = func {
	#inputs
	var air_gen_start = getprop("engines/air-gen-switch");
	var gen_start = getprop("engines/air-gen-button");
	var eng_ign = getprop("engines/eng-ign-switch");
	throttleStop_0 = getprop("engines/throttle-stop[0]");
	throttleStop_1 = getprop("engines/throttle-stop[1]");
	var eng_start = getprop("engines/eng-start-switch");
	var fuel_0 = getprop("engines/fuel-pumps-switch[0]");
	var fuel_1 = getprop("engines/fuel-pumps-switch[1]");
	var n2_0 = getprop("engines/engine[0]/n2");
	var n2_1 = getprop("engines/engine[1]/n2");
	
	
	cwp_bat = 0;
	
	#air gen logic (battery powered starter engine)
	if (!air_gen_start or (n2_0 >= N2_IDLE and n2_1 >= N2_IDLE)) {
		corr_rot_0 = 0; 
		corr_rot_1 = 0; 
		air_gen_on = 0;
		rdy_for_engine_start = 0;
	} elsif (air_gen_start and gen_start) {
		air_gen_on = 1;
	}
	if (air_gen_on and air_gen_rpm < 0.2) {
		air_gen_rpm += 0.01;
		if (air_gen_rpm > 0.2) {
			air_gen_rpm = 0.2;
		}
		cwp_bat = 1;
	} elsif (air_gen_on and (eng_start != 0 or rdy_for_engine_start) and air_gen_rpm >= 0.2) {
		air_gen_rpm += 0.04;
		if (air_gen_rpm > 1) {
			air_gen_rpm = 1;
		}
		rdy_for_engine_start = 1;
	} elsif (!air_gen_on and air_gen_rpm > 0) {
		air_gen_rpm -= 0.04;
		if (air_gen_rpm < 0) {
			air_gen_rpm = 0;
		}
	}
	
	# Starting to ignition
	if (rdy_for_engine_start) {
		if (eng_start == -1) {
			start_0 = throttleStop_0 and eng_ign;
		}
		if (eng_start == 1) {
			start_1 = throttleStop_1 and eng_ign;
		}
	} else {
		if (!eng_ign and n2_0 < N2_IDLE) {
			cutoff_0 = 1;
			start_0 = 0;
		}
		if (!eng_ign and n2_1 < N2_IDLE) {
			cutoff_1 = 1;
			start_1 = 0;
		}
	}
	
	#ignition to idle
	if (start_0) {
		if (n2_0 >= N2_IGNITE and air_gen_rpm == 1 and n2_0 < N2_IDLE) {
			corr_rot_0 = 1;
		}
		cutoff_0 = !(!throttleStop_0 and fuel_0);
	}
	if (start_1) {
		if (n2_1 >= N2_IGNITE and air_gen_rpm == 1 and n2_1 < N2_IDLE) {
			corr_rot_1 = 1;
		}
		cutoff_1 = !(!throttleStop_1 and fuel_1);
	}
	
	# running
	if (n2_0 >= N2_IDLE) {
		start_0 = 0;
		corr_rot_0 = 0;
		cutoff_0 = !(!throttleStop_0 and fuel_0);
	}
	if (n2_1 >= N2_IDLE) {
		start_1 = 0;
		corr_rot_1 = 0;
		cutoff_1 = !(!throttleStop_1 and fuel_1);
	}
	
	#outputs
	setprop("engines/air-gen-button-light", air_gen_on);
	setprop("engines/air-valve-open-light", rdy_for_engine_start and (start_0 or start_1));
	setprop("engines/caution-bat", cwp_bat);
	setprop("engines/corr-rotation[0]", corr_rot_0);
	setprop("engines/corr-rotation[1]", corr_rot_1);
	setprop("controls/engines/engine[0]/cutoff", cutoff_0);
	setprop("controls/engines/engine[1]/cutoff", cutoff_1);
	setprop("controls/engines/engine[0]/starter", start_0);
	setprop("controls/engines/engine[1]/starter", start_1);
	setprop("engines/air-gen-n1", air_gen_rpm*100);
	setprop("engines/air-gen-button", 0);
	setprop("engines/eng-start-switch", 0);
	settimer(engineStartLoop,0.25);
}

var engineStartLoop2 = func {
	#inputs
	throttleStop_0 = getprop("engines/throttle-stop[0]");
	throttleStop_1 = getprop("engines/throttle-stop[1]");
	throttle_0 = getprop("controls/engines/engine[0]/throttle");
	throttle_1 = getprop("controls/engines/engine[1]/throttle");
	
	#outputs
	setprop("engines/throttle-pos-norm[0]", throttleStop_0?0:throttle_0*0.9+0.1);
	setprop("engines/throttle-pos-norm[1]", throttleStop_1?0:throttle_1*0.9+0.1);
	settimer(engineStartLoop2,0.05);
}

var main_init_listener = setlistener("sim/signals/fdm-initialized", func {
  	if (getprop("sim/signals/fdm-initialized") == 1) {
	    removelistener(main_init_listener);
		engineStartLoop();
		engineStartLoop2();
	}
}, nil, 0);

# internal sequence
# AIR GEN START on/off switch
# GENERATION START button with light
# ENGINE IGN on/off switch
# Throttle stop
# CWP BAT light comes on until air gen idle
# ENGINE START 1/2 switch to open air valve and acc to full power of air gen
# CORRECT ROTATION light comes on when at full starter speed
# rpm N2 15
# Throttle idle (cutoff open)
# N2 39 rpm in both engines: valve closes and air gen power down
# CORRECT ROTATION goes out