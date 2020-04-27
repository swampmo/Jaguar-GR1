setprop("/engines/throttle-stop[0]",1);
setprop("/engines/throttle-stop[1]",1);

setprop("/controls/electrical/battery-switch",1);
setprop("/controls/electrical/tru-1-switch",0);
setprop("/controls/electrical/tru-2-switch",0);
setprop("/controls/electrical/alternator-1-switch",0);
setprop("/controls/electrical/alternator-2-switch",0);
setprop("/controls/electrical/pitot-heat-switch",1);

setprop("/engines/eng-ign-switch", 1);
setprop("/engines/fuel-pumps-switch[0]", 1);
setprop("/engines/fuel-pumps-switch[1]", 1);
setprop("/engines/air-gen-switch", 1);
setprop("/controls/switches/anti-collision-lights", 1);
setprop("/controls/switches/nav-lights", 1);
setprop("/controls/switches/strobe-lights", 1);
setprop("/engines/air-gen-button", 1);
setprop("controls/flight/speedbrake",1);

var startEngine = 1;

var l1 = setlistener("engines/caution-bat", func(v) {
    if (!v.getValue()) {
        if (startEngine) {
            print("battery caution goes off");
            settimer(func { print("start eng L");setprop("/engines/eng-start-switch", -1); }, 0.5);
            settimer(func { print("start eng R");setprop("/engines/eng-start-switch", 1); }, 2.5);     
            startEngine = 0;
removelistener(l1);
        }
    }
});

var startEngineL = 1;
var startEngineR = 1;

var l2 = setlistener("/engines/engine[0]/n1", func(v){
    if (v.getValue() > 5.0 and startEngineL) {
        print("open throttle stop L");
        setprop("/engines/throttle-stop[0]",0);
        startEngineL=0;
        removelistener(l2);
    }
});

var l3 = setlistener("/engines/engine[1]/n1", func(v){
    if (v.getValue() > 5.0 and startEngineR) {
        print("open throttle stop R");
        setprop("/engines/throttle-stop[1]",0);
        startEngineR=0;
    }
    if (v.getValue() > 29){
        setprop("controls/flight/speedbrake",0);
        removelistener(l3);
        print("retract speedbrake");
    }

});


