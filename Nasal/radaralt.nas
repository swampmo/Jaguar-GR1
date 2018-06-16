##### radar altimeter loop

setlistener("/sim/signals/fdm-initialized", func {

settimer(ralt, 1);
});

var ralt = func {

var radaralt = getprop("position/altitude-agl-ft");

if (radaralt > 2000) {
	setprop("instrumentation/radar-altimeter/flag-display", 1);
	} else {
	setprop("instrumentation/radar-altimeter/flag-display", 0);
	}

settimer(ralt, 1);
}

