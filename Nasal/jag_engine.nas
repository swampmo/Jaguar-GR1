# Jaguar engine controls
#
# AIR GEN START on/off switch
# GENERATOR START button with light
# ENGINE IGN on/off switch
# Throttle stop
# CWP BAT light comes on until air gen idle
# ENGINE START 1/2 switch to open air valve and acc to full power of air gen
# CORRECT ROTATION light comes on when at full starter speed
# rpm N2 15
# Throttle idle (cutoff open)
# N2 39 rpm valve closes and air gen power down
# CORRECT ROTATION goes out

var air_gen_rpm = 0;
var air_gen_on = 0;
var cutoff_0 = 1;
var cutoff_1 = 1;
var cwp_bat = 0;
var start_0 = 0;
var start_1 = 0;
var rdy_for_full_air = 0;
var rdy_for_engine_start = 0;
var corr_rot = 0;

var N2_IDLE = 60;#idlen2 in engine file
var N2_IGNITE = 26;#higher than ignitionn2 in engine file

props.globals.initNode("engines/air-gen-switch", 0, "BOOL");
props.globals.initNode("engines/air-gen-button", 0, "BOOL");
props.globals.initNode("engines/eng-ign-switch", 0, "BOOL");
props.globals.initNode("engines/throttle-stop", 1, "BOOL");# latch on throttle
props.globals.initNode("engines/eng-start-switch", 0, "INT");# -1 = engine 1   0 = none  1 = engine 2
props.globals.initNode("engines/air-gen-button-light", 0, "BOOL");# green
props.globals.initNode("engines/caution-bat", 0, "BOOL");# BAT on caution warning panel
props.globals.initNode("engines/corr-rotation", 0, "BOOL");# CORRECT ROTATION light
props.globals.initNode("engines/air-gen-n1", 0, "INT");# rpm of starter engine

var engineStartLoop = func {
	#inputs
	var air_gen_start = getprop("engines/air-gen-switch");
	var gen_start = getprop("engines/air-gen-button");
	var eng_ign = getprop("engines/eng-ign-switch");
	var throttleStop = getprop("engines/throttle-stop");
	var eng_start = getprop("engines/eng-start-switch");
	var n2_0 = getprop("engines/engine[0]/n2");
	var n2_1 = getprop("engines/engine[1]/n2");
	
	rdy_for_full_air = throttleStop and eng_ign;
	
	#air gen logic (battery powered starter engine)
	cwp_bat = 0;
	
	
	if (!air_gen_start or (n2_0 > 39 and n2_1 > 39)) {
		corr_rot = 0; 
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
	} elsif (air_gen_on and (rdy_for_full_air or (eng_ign and (n2_0 < N2_IGNITE or n2_1 < N2_IGNITE) and n2_0 > N2_IGNITE-2 and n2_1 > N2_IGNITE-2)) and air_gen_rpm >= 0.2) {
		air_gen_rpm += 0.04;
		if (air_gen_rpm > 1) {
			air_gen_rpm = 1;
			corr_rot = 1;
		}
		rdy_for_engine_start = 1;
	} elsif (air_gen_on and !eng_ign) {
		air_gen_rpm -= 0.03;
		if (air_gen_rpm < 0.2) {
			air_gen_rpm = 0.2;
		}
	} elsif (!air_gen_on and air_gen_rpm > 0) {
		air_gen_rpm -= 0.04;
		if (air_gen_rpm < 0) {
			air_gen_rpm = 0;
		}
	}
	
	# Starting
	if (rdy_for_engine_start) {
		if (eng_start == -1) {
			start_0 = 1;
		}
		if (eng_start == 1) {
			start_1 = 1;
		}
	} else {
		if (!eng_ign and n2_0 < N2_IDLE) {
			cutoff_0 = 1;
		} elsif (!eng_ign and n2_1 < N2_IDLE) {
			cutoff_1 = 1;
		} elsif (throttleStop) {
			cutoff_0 = 1;
			cutoff_1 = 1;
		}		
	}
	if (start_0) {
		cutoff_0 = throttleStop;
	}
	if (start_1) {
		cutoff_1 = throttleStop;
	}
	
	# running
	if (n2_0 >= N2_IDLE) {
		start_0 = 0;
	}
	if (n2_1 >= N2_IDLE) {
		start_1 = 0;
	}
	
	#outputs
	setprop("engines/air-gen-button-light", air_gen_on);#bool
	setprop("engines/caution-bat", cwp_bat);#bool
	setprop("engines/corr-rotation", corr_rot);#bool
	setprop("controls/engines/engine[0]/cutoff", cutoff_0);
	setprop("controls/engines/engine[1]/cutoff", cutoff_1);
	setprop("controls/engines/engine[0]/starter", start_0);
	setprop("controls/engines/engine[1]/starter", start_1);
	setprop("engines/air-gen-n1", air_gen_rpm*100);#int
	setprop("engines/air-gen-button", 0);
	settimer(engineStartLoop,0.25);
}

var main_init_listener = setlistener("sim/signals/fdm-initialized", func {
  	if (getprop("sim/signals/fdm-initialized") == 1) {
	    removelistener(main_init_listener);
		engineStartLoop();
	}
}, nil, 0);
