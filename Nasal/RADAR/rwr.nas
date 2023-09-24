print("*** LOADING rwr.nas ... ***");

var lineWidth = 2;

RWRCanvas = {
    new: func (_ident, root, center, diameter) {
        var rwr = {parents: [RWRCanvas]};
        rwr.max_icons = 12;
        var radius = diameter/2;
        rwr.inner_radius = radius*0.30;
        rwr.outer_radius = radius*0.75;
        rwr.circle_radius_big = radius*0.5;
        rwr.circle_radius_small = radius*0.125;
        var tick_long = radius*0.25;
        var tick_short = tick_long*0.5;
        var font = int(0.08*diameter);
        var colorG = [0.3,1,0.3];
        var colorLG = [0,0.5,0];
        rwr.fadeTime = 7;#seconds
        rwr.rootCenter = root.createChild("group")
                .setTranslation(center[0],center[1]);
        rwr.rootCenter.setRotation(-45*D2R);
        var rootOffset = root.createChild("group")
                .setTranslation(center[0]-diameter/2,center[1]-diameter/2);
        rootOffset.setCenter(diameter/2,diameter/2);        
        rootOffset.setRotation(-45*D2R);
#        root.createChild("path")
#           .moveTo(0, diameter/2)
#           .arcSmallCW(diameter/2, diameter/2, 0, diameter, 0)
#           .arcSmallCW(diameter/2, diameter/2, 0, -diameter, 0)
#           .setStrokeLineWidth(lineWidth)
#           .setColor(1, 1, 1);
        rootOffset.createChild("path")
           .moveTo(diameter/2-rwr.circle_radius_small, diameter/2)
           .arcSmallCW(rwr.circle_radius_small, rwr.circle_radius_small, 0, rwr.circle_radius_small*2, 0)
           .arcSmallCW(rwr.circle_radius_small, rwr.circle_radius_small, 0, -rwr.circle_radius_small*2, 0)
           .setStrokeLineWidth(lineWidth)
           .setColor(colorLG);
        rootOffset.createChild("path")
           .moveTo(diameter/2-rwr.circle_radius_big, diameter/2)
           .arcSmallCW(rwr.circle_radius_big, rwr.circle_radius_big, 0, rwr.circle_radius_big*2, 0)
           .arcSmallCW(rwr.circle_radius_big, rwr.circle_radius_big, 0, -rwr.circle_radius_big*2, 0)
           .setStrokeLineWidth(lineWidth)
           .setColor(colorLG);
        rootOffset.createChild("path")
           .moveTo(diameter/2-rwr.circle_radius_small/2, diameter/2)
           .lineTo(diameter/2+rwr.circle_radius_small/2, diameter/2)
           .moveTo(diameter/2, diameter/2-rwr.circle_radius_small/2)
           .lineTo(diameter/2, diameter/2+rwr.circle_radius_small/2)
           .setStrokeLineWidth(lineWidth)
           .setColor(colorLG);
        rootOffset.createChild("path")
           .moveTo(0,diameter*0.5)
           .horiz(tick_long)
           .moveTo(diameter,diameter*0.5)
           .horiz(-tick_long)
           .moveTo(diameter*0.5,0)
           .vert(tick_long)
           .moveTo(diameter*0.5,diameter)
           .vert(-tick_long)
           .setStrokeLineWidth(lineWidth)
           .setColor(colorLG);
        rwr.rootCenter.createChild("path")
           .moveTo(radius*math.cos(30*D2R),radius*math.sin(-30*D2R))
           .lineTo((radius-tick_short)*math.cos(30*D2R),(radius-tick_short)*math.sin(-30*D2R))
           .moveTo(radius*math.cos(60*D2R),radius*math.sin(-60*D2R))
           .lineTo((radius-tick_short)*math.cos(60*D2R),(radius-tick_short)*math.sin(-60*D2R))
           .moveTo(radius*math.cos(30*D2R),radius*math.sin(30*D2R))
           .lineTo((radius-tick_short)*math.cos(30*D2R),(radius-tick_short)*math.sin(30*D2R))
           .moveTo(radius*math.cos(60*D2R),radius*math.sin(60*D2R))
           .lineTo((radius-tick_short)*math.cos(60*D2R),(radius-tick_short)*math.sin(60*D2R))

           .moveTo(-radius*math.cos(30*D2R),radius*math.sin(-30*D2R))
           .lineTo(-(radius-tick_short)*math.cos(30*D2R),(radius-tick_short)*math.sin(-30*D2R))
           .moveTo(-radius*math.cos(60*D2R),radius*math.sin(-60*D2R))
           .lineTo(-(radius-tick_short)*math.cos(60*D2R),(radius-tick_short)*math.sin(-60*D2R))
           .moveTo(-radius*math.cos(30*D2R),radius*math.sin(30*D2R))
           .lineTo(-(radius-tick_short)*math.cos(30*D2R),(radius-tick_short)*math.sin(30*D2R))
           .moveTo(-radius*math.cos(60*D2R),radius*math.sin(60*D2R))
           .lineTo(-(radius-tick_short)*math.cos(60*D2R),(radius-tick_short)*math.sin(60*D2R))
           .setStrokeLineWidth(lineWidth)
           .setColor(colorLG);
        rwr.texts = setsize([],rwr.max_icons);
        for (var i = 0;i<rwr.max_icons;i+=1) {
            rwr.texts[i] = rwr.rootCenter.createChild("text")
                .setText("00")
                .setAlignment("center-center")
                .setColor(colorG)
                .setFontSize(font, 1.0)
                .hide();

        }
        rwr.symbol_hat = setsize([],rwr.max_icons);
        for (var i = 0;i<rwr.max_icons;i+=1) {
            rwr.symbol_hat[i] = rwr.rootCenter.createChild("path")
                    .moveTo(0,-font)
                    .lineTo(font*0.7,-font*0.5)
                    .moveTo(0,-font)
                    .lineTo(-font*0.7,-font*0.5)
                    .setStrokeLineWidth(lineWidth)
                    .setColor(colorG)
                    .hide();
        }

 #       me.symbol_16_SAM = setsize([],max_icons);
#       for (var i = 0;i<max_icons;i+=1) {
 #          me.symbol_16_SAM[i] = me.rootCenter.createChild("path")
#                   .moveTo(-11, 7)
#                   .lineTo(-9, -7)
#                   .moveTo(-9, -7)
#                   .lineTo(-9, -4)
#                   .moveTo(-9, -8)
#                   .lineTo(-11, -4)
#                   .setStrokeLineWidth(lineWidth)
#                   .setColor(1,0,0)
#                   .hide();
#        }
        rwr.symbol_launch = setsize([],rwr.max_icons);
        for (var i = 0;i<rwr.max_icons;i+=1) {
            rwr.symbol_launch[i] = rwr.rootCenter.createChild("path")
                    .moveTo(font*1.2, 0)
                    .arcSmallCW(font*1.2, font*1.2, 0, -font*2.4, 0)
                    .arcSmallCW(font*1.2, font*1.2, 0, font*2.4, 0)
                    .setStrokeLineWidth(lineWidth)
                    .setColor(colorG)
                    .hide();
        }
        rwr.symbol_new = setsize([],rwr.max_icons);
        for (var i = 0;i<rwr.max_icons;i+=1) {
            rwr.symbol_new[i] = rwr.rootCenter.createChild("path")
                    .moveTo(font*1.2, 0)
                    .arcSmallCCW(font*1.2, font*1.2, 0, -font*2.4, 0)
                    .setStrokeLineWidth(lineWidth)
                    .setColor(colorG)
                    .hide();
        }
#        rwr.symbol_16_lethal = setsize([],max_icons);
#        for (var i = 0;i<max_icons;i+=1) {
#           rwr.symbol_16_lethal[i] = rwr.rootCenter.createChild("path")
#                   .moveTo(10, 10)
#                   .lineTo(10, -10)
#                   .lineTo(-10,-10)
#                   .lineTo(-10,10)
#                   .lineTo(10, 10)
#                   .setStrokeLineWidth(lineWidth)
#                   .setColor(1,0,0)
#                   .hide();
#        }
        rwr.symbol_priority = rwr.rootCenter.createChild("path")
                    .moveTo(0, font*1.2)
                    .lineTo(font*1.2, 0)
                    .lineTo(0,-font*1.2)
                    .lineTo(-font*1.2,0)
                    .lineTo(0, font*1.2)
                    .setStrokeLineWidth(lineWidth)
                    .setColor(colorG)
                    .hide();

	rwr.symbol_maw = rwr.rootCenter.createChild("path")
                    .moveTo(0,-font*1.2)
                    .lineTo(font*0.2, -font*1.0)
                    .vert(font*2)
                    .horiz(-font*0.4)
                    .vert(-font*2)
                    .lineTo(0,-font*1.2)
                    .setStrokeLineWidth(lineWidth*1.2)
                    .setColor(colorG)
                    .hide();
                    
#        rwr.symbol_16_air = setsize([],max_icons);
#        for (var i = 0;i<max_icons;i+=1) {
 #          rwr.symbol_16_air[i] = rwr.rootCenter.createChild("path")
#                   .moveTo(15, 0)
#                   .lineTo(0,-15)
#                   .lineTo(-15,0)
#                   .setStrokeLineWidth(lineWidth)
#                   .setColor(1,0,0)
#                   .hide();
#        }
# Threat list ID:

        rwr.AIRCRAFT_UNKNOWN  = "U";
        rwr.ASSET_AI          = "AI";
        rwr.AIRCRAFT_SEARCH   = "S";
        
        rwr.shownList = [];
        #
        # recipient that will be registered on the global transmitter and connect this
        # subsystem to allow subsystem notifications to be received
        rwr.recipient = emesary.Recipient.new(_ident);
        rwr.recipient.parent_obj = rwr;
        rwr.vector_aicontacts = [];

        rwr.recipient.Receive = func(notification)
        {
            if (notification.NotificationType == "FrameNotification")
            {
                #printf("RWR-canvas recv: %s", notification.NotificationType);
                me.parent_obj.update();
                return emesary.Transmitter.ReceiptStatus_OK;
            }
            
            return emesary.Transmitter.ReceiptStatus_NotProcessed;
        };
        emesary.GlobalTransmitter.Register(rwr.recipient);

        return rwr;
    },
    update: func {
        var list = radar_system.getRWRList();
	    var s = size(list);
        me.elapsed = getprop("sim/time/elapsed-sec");
        var sorter = func(a, b) {
            if(a[1] > b[1]){
                return -1; # A should before b in the returned vector
            }elsif(a[1] == b[1]){
                return 0; # A is equivalent to b 
            }else{
                return 1; # A should after b in the returned vector
            }
        }
        me.sortedlist = sort(list, sorter);#sort threat
        me.newList = [];
        me.i = 0;
        me.prio = 0;
        me.newsound = 0;
        me.unk = 0;
        foreach(me.contact; me.sortedlist) {
	       #print("rwr: " ~ me.contact[0].get_Callsign() ~ " " ~ me.contact[0].getModel() ~ " " ~ me.contact[1]);
            me.dbEntry = radar_system.getDBEntry(me.contact[0].getModel());
            me.typ = me.dbEntry.rwrCode;
	    # printf("type: %d, threat: %d", me.typ, me.contact[1]);
            if (me.i > me.max_icons-1) {
                break;
            }
            if (me.typ == nil) {
                if (me.contact[0].prop.getName() != "multiplayer") {
                    # AI planes are allowed to be unknowns
                    me.typ = me.AIRCRAFT_UNKNOWN;
                    me.unk = 1;
                } else {
                    continue;
                }
            }
            me.threat = me.contact[1];
            
            if (me.threat > 0.5 and me.typ != me.AIRCRAFT_UNKNOWN and me.typ != me.ASSET_AI) {
                me.threat = me.inner_radius;# inner circle
            } elsif (me.threat > 0) {
                me.threat = me.outer_radius;# outer circle
            } else {
                continue;
            }
            if (me.contact[0].get_range() > 130) {
                continue;
            }
            me.dev = -me.contact[2]+90;
            me.x = math.cos(me.dev*D2R)*me.threat;
            me.y = -math.sin(me.dev*D2R)*me.threat;
            me.texts[me.i].setTranslation(me.x,me.y);
            me.texts[me.i].setText(me.typ);
            me.texts[me.i].show();
            if (me.prio == 0 and me.typ != me.ASSET_AI and me.typ != me.AIRCRAFT_UNKNOWN) {# 
                me.symbol_priority.setTranslation(me.x,me.y);
                me.symbol_priority.show();
                me.prio = 1;
            }
            if (!(me.typ == me.ASSET_GARGOYLE or me.typ == me.ASSET_AAA or me.typ == me.ASSET_VOLGA or me.typ == me.ASSET_BUK or me.typ == me.ASSET_PAC2 or me.typ == me.ASSET_FRIGATE) and me.contact[0].get_Speed()>60) {
                #air-borne
                me.symbol_hat[me.i].setTranslation(me.x,me.y);
                me.symbol_hat[me.i].show();
            } else {
                me.symbol_hat[me.i].hide();
            }
            if (me.contact[0].get_Callsign()==getprop("sound/rwr-launch") and 10*(me.elapsed-int(me.elapsed))>5) {#blink 2Hz
                me.symbol_launch[me.i].setTranslation(me.x,me.y);
                me.symbol_launch[me.i].show();
            } else {
                me.symbol_launch[me.i].hide();
            }
            me.popupNew = me.elapsed;
            foreach(me.old; me.shownList) {
                if(me.old[0].equals(me.contact[0])) {
                    me.popupNew = me.old[1];
                    break;
                }
            }
            if (me.popupNew == me.elapsed) {
                me.newsound = 1;
            }
            if (me.popupNew > me.elapsed-me.fadeTime) {
                me.symbol_new[me.i].setTranslation(me.x,me.y);
                me.symbol_new[me.i].show();
                me.symbol_new[me.i].update();
            } else {
                me.symbol_new[me.i].hide();
            }
            #printf("display %s %d",contact[0].get_Callsign(), me.threat);
            append(me.newList, [me.contact[0],me.popupNew]);
            me.i += 1;
        }
        me.shownList = me.newList;
        if (me.newsound == 1) setprop("sound/rwr-new", !getprop("sound/rwr-new"));
        for (;me.i<me.max_icons;me.i+=1) {
            me.texts[me.i].hide();
            me.symbol_hat[me.i].hide();
            me.symbol_new[me.i].hide();
            me.symbol_launch[me.i].hide();
        }
        if (me.prio == 0) {
            me.symbol_priority.hide();
        }
        setprop("sound/rwr-pri", me.prio);
        setprop("sound/rwr-unk", me.unk);
      
        if (getprop("payload/armament/MAW-active")) {
          me.mawdegs = getprop("payload/armament/MAW-bearing");
          me.dev = -geo.normdeg180(me.mawdegs-getprop("orientation/heading-deg"))+90;
          me.x = math.cos(me.dev*D2R)*(me.inner_radius+me.outer_radius)*0.5;
          me.y = -math.sin(me.dev*D2R)*(me.inner_radius+me.outer_radius)*0.5;
          me.symbol_maw.setRotation(-(me.dev+90)*D2R);
          me.symbol_maw.setTranslation(me.x, me.y);
          me.symbol_maw.show();
        } else {
          me.symbol_maw.hide();
        }
    },
};
var rwr = nil;
var cv = nil;
var timer = nil;

var main_init_listener = setlistener("sim/signals/fdm-initialized", func {
   if (getprop("sim/signals/fdm-initialized") == 1) {
      var diam = 256;
      cv = canvas.new({
         "name": "Rwr",
         "size": [diam,diam], 
         "view": [diam,diam],
         "mipmapping": 1
     });  

     cv.addPlacement({"node": "RWRScreen", "texture":"A-10-rwr.png"});
     cv.setColorBackground(0, 0.20, 0);
     var root = cv.createGroup();
     rwr = RWRCanvas.new("RWRCanvas", root, [diam/2,diam/2],diam*0.9);
     removelistener(main_init_listener);
     timer = maketimer(0.5, func rwr.update());
     timer.start();
   }
}, 0, 0);

var openDialog = func(){
    return;
   var diam = 256;
     cv = canvas.new({
        "name": "Rwr",
        "size": [diam,diam], 
        "view": [diam,diam],
        "mipmapping": 1
      });  
        
    cv.setColorBackground(0, 0.20, 0);
    var root = cv.createGroup();
    
    rwr = RWRCanvas.new(root, [diam/2,diam/2],diam);
  
  
  var window = canvas.Window.new([256,256],"Rwr");
  window.setCanvas(cv);
}

var setGroup = func (root) {
    root.createChild("path").horiz(768).vert(576).horiz(-768).vert(-576).setColorFill(0,0,0).setColor(0,0,0);
    rwr = RWRCanvas.new("RWRCanvas",root, [768/2,576/2],576);
};

