# use:
var crashCode = nil;
var crash_start = func {
    removelistener(lsnr);
    crashCode = CrashAndStress.new([0,1,2], {"weightLbs":34600, "maxG": 12}, ["controls/flight/aileron", "controls/flight/elevator", "controls/flight/flaps"]);
    crashCode.start();
}

var lsnr = setlistener("sim/signals/fdm-initialized", crash_start);

# test:
var repair = func {
    crashCode.repair();
};