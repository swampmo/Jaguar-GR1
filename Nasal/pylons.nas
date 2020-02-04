var fcs = nil;
var pylonI = nil;
var pylon1 = nil;
var pylon2 = nil;
var pylon3 = nil;
var pylon4 = nil;
var pylon5 = nil;

var msgA = "If you need to repair now, then use Menu-Location-SelectAirport instead.";
var msgB = "Please land before changing payload.";
var msgC = "Please land before refueling.";

var cannon = stations.SubModelWeapon.new("20mm Cannon", 0.254, 150, [0,1], [], props.globals.getNode("controls/armament/trigger-gun",1), 0, nil,0);
cannon.typeShort = "GUN";
cannon.brevity = "Guns guns";
#var fuelTank267Left = stations.FuelTank.new("L External", "TK267", 8, 370, "sim/model/f-14b/wingtankL");
#var fuelTank267Right = stations.FuelTank.new("R External", "TK267", 9, 370, "sim/model/f-14b/wingtankR");

#var smokewinderWhite1 = stations.Smoker.new("Smokewinder White", "SmokeW", "sim/model/f-14b/fx/smoke-mnt-left");
#var smokewinderWhite10 = stations.Smoker.new("Smokewinder White", "SmokeW", "sim/model/f-14b/fx/smoke-mnt-right");

var pylonSets = {
	empty: {name: "Empty", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},
	mm20:  {name: "20mm Cannon", content: [cannon], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},

    m83:  {name: "MK-83", content: ["MK-83"], fireOrder: [0], launcherDragArea: 0.005, launcherMass: 300, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 2},
    
    # 340 = outer pylon
#	smokeWL: {name: "Smokewinder White", content: [smokewinderWhite1], fireOrder: [0], launcherDragArea: -0.05, launcherMass: 53+340, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},
#	smokeWR: {name: "Smokewinder White", content: [smokewinderWhite10], fireOrder: [0], launcherDragArea: -0.05, launcherMass: 53+340, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},

#	fuel26L: {name: "267 Gal Fuel tank", content: [fuelTank267Left], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
#	fuel26R: {name: "267 Gal Fuel tank", content: [fuelTank267Right], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},

    # A/A weapons on non-wing pylons:
	aim9:    {name: "AIM-9",   content: ["AIM-9"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: 53, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},
};

# sets. The first in the list is the default. Earlier in the list means higher up in dropdown menu.
# These are not strictly needed in F-14 beside from the Empty, since it uses a custom payload dialog, but there for good measure.
var pylon1set = [pylonSets.empty, pylonSets.aim9];
var pylon2set = [pylonSets.empty, pylonSets.m83, pylonSets.aim9];
var pylon3set = [pylonSets.empty, pylonSets.m83];
var pylon4set = [pylonSets.empty, pylonSets.m83];
var pylon5set = [pylonSets.empty, pylonSets.m83];
var pylon6set = [pylonSets.empty, pylonSets.m83, pylonSets.aim9];
var pylon7set = [pylonSets.empty, pylonSets.aim9];

# pylons
pylonI = stations.InternalStation.new("Internal gun mount", 7, [pylonSets.mm20], props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1));
pylon1 = stations.Pylon.new("Pylon Left Top",      0, [0.4795,-3.6717,-1.0600], pylon1set,  0, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[0]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[0]",1),func{return 1});
pylon2 = stations.Pylon.new("Pylon 2",      1, [0.4795,-3.7800,-1.5700], pylon2set,  1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return 1});
pylon3 = stations.Pylon.new("Pylon 3",      2, [-2,0,-1.4333],           pylon3set,  2, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[2]",1),func{return 1});
pylon4 = stations.Pylon.new("Pylon 4",      3, [-2,-1.0,-1.4333],        pylon4set,  3, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[3]",1),func{return 1});
pylon5 = stations.Pylon.new("Pylon 5",      4, [ 2,-1.0,-1.4333],        pylon5set,  4, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return 1});
pylon6 = stations.Pylon.new("Pylon 6",      5, [ 2,-1.0,-1.4333],        pylon6set,  5, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return 1});
pylon7 = stations.Pylon.new("Pylon Right Top",      6, [ 2,-1.0,-1.4333],        pylon7set,  6, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return 1});

#pylon1.forceRail = 1;# set the missiles mounted on this pylon on a rail.
#pylon9.forceRail = 1;

var pylons = [pylon1,pylon2,pylon3,pylon4,pylon5,pylon6,pylon7,pylonI];

# The order of first vector in this line is the default pylon order weapons is released in.
# The order of second vector in this line is the order cycle key would cycle through the weapons (but since the f-14 dont have that the order is not important):
fcs = fc.FireControl.new(pylons, [0,6,1,5,2,4,3,7], ["20mm Cannon","AIM-9","MK-83"]);

#print("** Pylon & fire control system started. **");
var getDLZ = func {
    if (fcs != nil and getprop("controls/armament/master-arm")) {
        var w = fcs.getSelectedWeapon();
        if (w!=nil and w.parents[0] == armament.AIM) {
            var result = w.getDLZ(1);
            if (result != nil and size(result) == 5 and result[4]<result[0]*1.5 and armament.contact != nil and armament.contact.get_display()) {
                #target is within 150% of max weapon fire range.
        	    return result;
            }
        }
    }
    return nil;
}

var reloadCannon = func {
    #setprop("ai/submodels/submodel[4]/count", 100);
    #setprop("ai/submodels/submodel[5]/count", 100);#flares
    cannon.reloadAmmo();
}

# reload cannon only
var cannon_load = func {
    if (fcs != nil and (!getprop("payload/armament/msg") or getprop("fdm/jsbsim/gear/unit[0]/WOW"))) {
        reloadCannon();
        return 1;
    } else {
      screen.log.write(msgB);
      return 0;
    }
}


var bore_loop = func {
    #enables firing of aim9 without radar. The aim-9 seeker will be fixed 3.5 degs below bore and any aircraft the gets near that will result in lock.
    bore = 0;
    if (fcs != nil) {
        var standby = 1;#getprop("sim/multiplay/generic/int[2]");
        var aim = fcs.getSelectedWeapon();
        if (aim != nil and aim.type == "AIM-9") {
            if (standby == 1) {
                #aim.setBore(1);
                aim.setContacts(radar.completeList);
                aim.commandDir(0,-3.5);# the real is bored to -6 deg below real bore
                bore = 1;
            } else {
                aim.commandRadar();
                aim.setContacts([]);
            }
        }
    }
    settimer(bore_loop, 0.5);
};
var bore = 0;
if (fcs!=nil) {
    bore_loop();
}




# swamp TODO list:
#
# find coords of each pylon and enter them into the abov pylon declarations
# add JSB pointmasses for those coords
# add more weapons, fuel tanks and smokewinders. Plus get correct loadout options for each pylon
# 