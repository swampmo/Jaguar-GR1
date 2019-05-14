# Jaguar Electrical System
# Jonathan Redpath (legoboyvdlp)
var electricalSys = {
	cachedElec: 0,
	init: func() {
		me.cachedElec = getprop("/fdm/jsbsim/systems/electrical/bus/dc") or 0;
		me.reset();
	},
	update: func() {
		if (getprop("/fdm/jsbsim/systems/electrical/bus/dc") != me.cachedElec) {
			if (getprop("/fdm/jsbsim/systems/electrical/bus/dc") >= 25) {
				me.turnOn();
			} else {
				me.reset();
			}
			me.cachedElec = getprop("/fdm/jsbsim/systems/electrical/bus/dc");
		}
	},
	reset: func() {
		# Below are standard FG Electrical stuff to keep things working when the plane is powered
		setprop("/systems/electrical/outputs/adf", 0);
		setprop("/systems/electrical/outputs/audio-panel", 0);
		setprop("/systems/electrical/outputs/audio-panel[1]", 0);
		setprop("/systems/electrical/outputs/autopilot", 0);
		setprop("/systems/electrical/outputs/avionics-fan", 0);
		setprop("/systems/electrical/outputs/beacon", 0);
		setprop("/systems/electrical/outputs/bus", 0);
		setprop("/systems/electrical/outputs/cabin-lights", 0);
		setprop("/systems/electrical/outputs/dme", 0);
		setprop("/systems/electrical/outputs/efis", 0);
		setprop("/systems/electrical/outputs/flaps", 0);
		setprop("/systems/electrical/outputs/fuel-pump", 0);
		setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
		setprop("/systems/electrical/outputs/gps", 0);
		setprop("/systems/electrical/outputs/gps-mfd", 0);
		setprop("/systems/electrical/outputs/hsi", 0);
		setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
		setprop("/systems/electrical/outputs/instrument-lights", 0);
		setprop("/systems/electrical/outputs/landing-lights", 0);
		setprop("/systems/electrical/outputs/map-lights", 0);
		setprop("/systems/electrical/outputs/mk-viii", 0);
		setprop("/systems/electrical/outputs/nav", 0);
		setprop("/systems/electrical/outputs/nav[1]", 0);
		setprop("/systems/electrical/outputs/nav[2]", 0);
		setprop("/systems/electrical/outputs/nav[3]", 0);
		setprop("/systems/electrical/outputs/pitot-head", 0);
		setprop("/systems/electrical/outputs/stobe-lights", 0);
		setprop("/systems/electrical/outputs/tacan", 0);
		setprop("/systems/electrical/outputs/taxi-lights", 0);
		setprop("/systems/electrical/outputs/transponder", 0);
		setprop("/systems/electrical/outputs/turn-coordinator", 0);
	},
	turnOn: func() {
		setprop("/systems/electrical/outputs/adf", 1);
		setprop("/systems/electrical/outputs/audio-panel", 1);
		setprop("/systems/electrical/outputs/audio-panel[1]", 1);
		setprop("/systems/electrical/outputs/autopilot", 1);
		setprop("/systems/electrical/outputs/avionics-fan", 1);
		setprop("/systems/electrical/outputs/beacon", 1);
		setprop("/systems/electrical/outputs/bus", 1);
		setprop("/systems/electrical/outputs/cabin-lights", 1);
		setprop("/systems/electrical/outputs/dme", 1);
		setprop("/systems/electrical/outputs/efis", 1);
		setprop("/systems/electrical/outputs/flaps", 1);
		setprop("/systems/electrical/outputs/fuel-pump", 1);
		setprop("/systems/electrical/outputs/fuel-pump[1]", 1);
		setprop("/systems/electrical/outputs/gps", 1);
		setprop("/systems/electrical/outputs/gps-mfd", 1);
		setprop("/systems/electrical/outputs/hsi", 1);
		setprop("/systems/electrical/outputs/instr-ignition-switch", 1);
		setprop("/systems/electrical/outputs/instrument-lights", 1);
		setprop("/systems/electrical/outputs/landing-lights", 1);
		setprop("/systems/electrical/outputs/map-lights", 1);
		setprop("/systems/electrical/outputs/mk-viii", 1);
		setprop("/systems/electrical/outputs/nav", 1);
		setprop("/systems/electrical/outputs/nav[1]", 1);
		setprop("/systems/electrical/outputs/nav[2]", 1);
		setprop("/systems/electrical/outputs/nav[3]", 1);
		setprop("/systems/electrical/outputs/pitot-head", 1);
		setprop("/systems/electrical/outputs/stobe-lights", 1);
		setprop("/systems/electrical/outputs/tacan", 1);
		setprop("/systems/electrical/outputs/taxi-lights", 1);
		setprop("/systems/electrical/outputs/transponder", 1);
		setprop("/systems/electrical/outputs/turn-coordinator", 1);
	}
};

setlistener("/sim/signals/fdm-initialized", func {
	electricalSys.init();
});