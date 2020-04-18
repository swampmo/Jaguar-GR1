props.globals.initNode("instrumentation/radar/mode/tws-auto", 1, "BOOL");
props.globals.initNode("instrumentation/radar/mode/rws", 0, "BOOL");
props.globals.initNode("instrumentation/radar2/sweep-width-m", 1, "INT");
props.globals.initNode("instrumentation/radar2/radius-ppi-display-m", 1, "INT");
props.globals.initNode("systems/electrical/outputs/radar", 25, "INT");
props.globals.initNode("instrumentation/radar/az-fieldCenter", 0, "INT");

var myRadar3 = radar.Radar.new(NewRangeTab:[10, 20, 40, 60, 160], NewRangeIndex:4, forcePath:"instrumentation/radar2/targets", NewAutoUpdate:1);
myRadar3.init();