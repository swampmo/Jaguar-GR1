var livery_update = aircraft.livery_update.new("Aircraft/Jaguar-Gr1/Models/Liveries", 20);
var self = cmdarg();
var root = cmdarg();
var rootindex = root.getIndex();
var mpPath = "/ai/models/multiplayer["~ rootindex ~"]/";
var lightsPath = mpPath~"lightpack/"; #path to the property node, where all internal values are placed
props.globals.initNode(mpPath~"sim/is-MP-Aircraft", 1, "BOOL");
srand();
#wherever you want to add randomization of time, use something like:  + rand()*0.05-0.025 (included by default where appropriate)
#list of switches for lights - if you don't intend to use some light, assign it nil value instead, like whateverSwitch = nil; and you don't need to care about anything else
#IMPORTANT: don't put / on the start of the string, it's already included in the mpPath property
var navSwitch = mpPath~"controls/lighting/nav-lights-switch";
var beaconSwitch = mpPath~"controls/lighting/beacon-switch";
var strobeSwitch = mpPath~"controls/lighting/strobe-switch";
var landingSwitch = mpPath~"controls/lighting/landing-lights-switch";
var taxiSwitch = mpPath~"controls/lighting/taxi-light-switch";
var probeSwitch = mpPath~"controls/lighting/probe-light-switch";
var whiteSwitch = mpPath~"controls/lighting/white-light-switch";
#switch this from 1 to 0 if you want to use advanced cyclical fading animation of the the nav lights instead of being stable on when the switch is on
navStillOn = 0;
#I need to set listener on some MP transferred properties; this doesn't seem to work well sometimes, so I mirror them to the original location on any change
#This also simplifies work as I can use almost the same code for MP as is the local Nasal. Furthermore, I can use meaningful property names in the model XML files instead of referencing the MP properties.
var mpVar = {
	new: func(propIn, propOut) {
		var m = { parents: [mpVar] };
		m.propIn = propIn;
		m.propOut = propOut;
		if(propIn==nil or propOut==nil) return m;
		m.value = getprop(propIn);
		setprop(propOut, m.value);
		return m;
	},
	check: func {
		if(me.propIn==nil or me.propOut==nil) return;
		var newValue = getprop(me.propIn);
		if(newValue != me.value) {
			setprop(me.propOut, newValue);
			me.value = newValue;
			#print("value of "~me.propOut~" changed: "~newValue);
		}
	},
};
#init any property copy object needed in this array (anything you need to transfer over MP, but you are using the original paths in your xmls)
#also used for properties you are using a listener on, or properties which you maybe want to manipulate during the <unload>
#if you're just using the pack, change the values according to the MP bindings in the -set.xml file
#you don't need to delete the entries if the path is nil - it gets skipped automatically and the MP path is just ignored
var mirrorValues = [
	mpVar.new(mpPath~"sim/multiplay/generic/int[7]", mpPath~"sim/crashed"),
	mpVar.new(mpPath~"sim/multiplay/generic/int[0]", navSwitch),
	mpVar.new(mpPath~"sim/multiplay/generic/int[1]", beaconSwitch),
	mpVar.new(mpPath~"sim/multiplay/generic/int[1]", strobeSwitch),
	mpVar.new(mpPath~"sim/multiplay/generic/int[3]", landingSwitch),
	mpVar.new(mpPath~"sim/multiplay/generic/int[4]", taxiSwitch),
	mpVar.new(mpPath~"sim/multiplay/generic/int[4]", probeSwitch),
	mpVar.new(mpPath~"sim/multiplay/generic/int[0]", whiteSwitch),
];
#loop at the default MP transfer frequency (10Hz)
var mirrorTimer = maketimer(0.1, func {
	foreach(var mir; mirrorValues) {
		mir.check();
	}
});
mirrorTimer.start();
#### NAV LIGHTS ####
#class for a periodic fade in/out animation - for flashing, use rather standard aircraft.light.new(), as in Beacon and Strobe section
var lightCycle = {
	#constructor
	new: func(propSwitch, propOut) {
		m = { parents: [lightCycle] };
		props.globals.initNode(propOut, 0, "DOUBLE");
		props.globals.initNode(propSwitch, 1, "BOOL");
		m.fadeIn = 0.4 + rand()*0.05-0.025; #fade in time
		m.fadeOut = 0.4 + rand()*0.05-0.025; #fade out time
		m.stayOn = 1.5 + rand()*0.05-0.025; #stable on period
		m.stayOff = 1 + rand()*0.05-0.025; #stable off period
		m.turnOff = 0.12; #fade out time when turned off
		m.phase = 0; #phase to be run on next timer call: 0 -> fade in, 1 -> stay on, 2 -> fade out, 3 -> stay off
		m.cycleTimer = maketimer(0.1, func {
			if(getprop(propSwitch)) {
				if(m.phase == 0) {
					interpolate(propOut, 1, m.fadeIn);
					m.phase = 1;
					m.cycleTimer.restart(m.fadeIn);
				}
				else if(m.phase == 1){
					m.phase = 2;
					m.cycleTimer.restart(m.stayOn);
				}
				else if(m.phase == 2){
					interpolate(propOut, 0, m.fadeOut);
					m.phase = 3;
					m.cycleTimer.restart(m.fadeOut);
				}
				else if(m.phase == 3){
					m.phase = 0;
					m.cycleTimer.restart(m.stayOff);
				}
			}
			else {
				interpolate(propOut, 0, m.turnOff); #kills any currently ongoing interpolation
				m.phase = 0;
			}
		});
		m.cycleTimer.singleShot = 1;
		if(propSwitch==nil) {
			m.listen = nil;
			return m;
		}
		m.listen = setlistener(propSwitch, func{m.cycleTimer.restart(0);}); #handle switch changes
		m.cycleTimer.restart(0); #start the looping
		return m;
	},
	#destructor
	del: func {
		if(me.listen!=nil) removelistener(me.listen);
		me.cycleTimer.stop();
	},
};
#By default, the switch property is initialized to 1 (only if no value is already assigned). Don't change the class implementation! To override this, set the property manually. You don't need to care if any other code already does it for you.
var navLights = nil;
if(!navStillOn) {
	navLights = lightCycle.new(navSwitch, lightsPath~"nav-lights-intensity");
	### Uncomment and tune those to customize times ###
	#navLights.fadeIn = 0.4; #fade in time
	#navLights.fadeOut = 0.4; #fade out time
	#navLights.stayOn = 3 + rand()*0.05-0.025; #stable on period
	#navLights.stayOff = 0.6; #stable off period
	#navLights.turnOff = 0.12; #fade out time when turned off
}
### BEACON ###
var beacon = nil;
if(beaconSwitch!=nil) {
	props.globals.initNode(beaconSwitch, 1, "BOOL");
	beacon = aircraft.light.new(lightsPath~"beacon-state",
		[0.0, 1.0 + rand()*0.05-0.025], beaconSwitch);
}
### STROBE ###
var strobe = nil;
if(strobeSwitch!=nil) {
	props.globals.initNode(strobeSwitch, 1, "BOOL");
	strobe = aircraft.light.new(lightsPath~"strobe-state",
		[0.0, 0.87 + rand()*0.05-0.025], strobeSwitch);
}
### LIGHT FADING ###
#class for controlling fade in/out behavior - propIn is a control property (handled as a boolean) and propOut is interpolated
#all light brightness animations in xmls depend on propOut (Rembrandt brightness, material emission, flares transparency, ...)
var lightFadeInOut = {
	#constructor
	new: func(propSwitch, propOut) {
		m = { parents: [lightFadeInOut] };
		m.fadeIn = 0.3; #some sane defaults
		m.fadeOut = 0.4;
		if(propSwitch==nil) {
			m.listen = nil;
			return m;
		}
		props.globals.initNode(propSwitch, 1, "BOOL");
		m.isOn = getprop(propSwitch);
		props.globals.initNode(propOut, m.isOn, "DOUBLE");
		m.listen = setlistener(propSwitch,
			func {
				if(m.isOn and !getprop(propSwitch)) {
					interpolate(propOut, 0, m.fadeOut);
					m.isOn = 0;
				}
				if(!m.isOn and getprop(propSwitch)) {
					interpolate(propOut, 1, m.fadeIn);
					m.isOn = 1;
				}
			}
		);
		return m;
	},
	#destructor
	del: func {
		if(me.listen!=nil) removelistener(me.listen);
	},
};
fadeLanding = lightFadeInOut.new(landingSwitch, lightsPath~"landing-lights-intensity");
fadeTaxi = lightFadeInOut.new(taxiSwitch, lightsPath~"taxi-light-intensity");
fadeProbe = lightFadeInOut.new(probeSwitch, lightsPath~"probe-light-intensity");
fadeWhite = lightFadeInOut.new(whiteSwitch, lightsPath~"white-light-intensity");
if(navStillOn) {
	navLights = lightFadeInOut.new(navSwitch, lightsPath~"nav-lights-intensity");
	navLights.fadeIn = 0.1;
	navLights.fadeOut = 0.12;
}
#manipulate times if defaults don't fit your needs:
#fadeLanding.fadeIn = 0.5;
#fadeLanding.fadeOut = 0.8;
### the rest of your model load embedded Nasal code ###
]]>
    </load>

    <unload>
      <![CDATA[
	 #prevent multiple timers and listeners from running and fighting on next connect
      #cleanly destroy MP property mirroring
      mirrorTimer.stop();
      mirrorTimer = nil;
      mirrorValues = nil;
      #cleanly destroy nav lights
      if(navStillOn) {
      	navLights.del();
      }
      else {
      	if(navSwitch!=nil) setprop(navSwitch, 0);
      	navLights.del();
      	if(navSwitch!=nil) navLights.cycleTimer = nil;
      	navLights = nil;
      }
      #cleanly destroy beacon
      if(beaconSwitch!=nil) setprop(beaconSwitch, 0);
      beacon.del();
      beacon = nil;
      #cleanly destroy strobe
      if(strobeSwitch!=nil) setprop(strobeSwitch, 0);
      strobe.del();
      strobe = nil;
      #cleanly destroy light fade in/out animation objects
      fadeLanding.del();
      fadeTaxi.del();
      fadeProbe.del();
      fadeWhite.del();
      ### the rest of your model unload embedded Nasal code ###
      livery_update.stop();
 ]]>
