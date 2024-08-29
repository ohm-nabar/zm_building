#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_laststand;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_perks.gsh;

#precache( "material", "bo1_revive" );
#precache( "eventstring", "revive_info");
	
function main()
{
    callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self LUINotifyEvent(&"revive_info", 2, 0, false);
	self thread revive_icon_think();
	self thread progress_bar_think();
	//self thread testeroo();
}

function revive_icon_think()
{
	self endon( "disconnect" );
	
	while (true)
	{
		self waittill("player_downed");
		self thread revive_icon_display();
	}
}

function revive_icon_display()
{
	self endon("disconnect");
	self endon("player_revived");
	self endon("bled_out");

	/*
	start_color = (0.929, 0.780, 0);
	middle_color = (0.961, 0.541, 0);
	end_color = (1, 0, 0);

	x is time elapsed / bleedout time
	linear regression for red:  0.071x + 0.92783
	linear regression for green: -0.78X + 0.83033
	*/

	waypoint_pos = Spawn("script_model", self.origin);
	waypoint_pos SetModel("tag_origin");
	waypoint_pos LinkTo(self, "tag_origin", (0, 0, 45));

	revive_icons = [];

	foreach(player in level.players)
	{
		if(player != self)
		{
			revive_icon = NewClientHudElem(player);
			revive_icon SetTargetEnt(waypoint_pos);
			revive_icon SetShader("bo1_revive");
			revive_icon SetWayPoint(true, "bo1_revive", false, false);
			revive_icons[revive_icons.size] = revive_icon;
		}
	}
	
	self thread revive_icon_cleanup(waypoint_pos, revive_icons);

	bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
		
	if( isdefined( self.n_bleedout_time_multiplier ) )
	{
		bleedout_time *= self.n_bleedout_time_multiplier;
	}

	for(i = 0; i <= bleedout_time; i += 0.05)
	{
		x = i / bleedout_time;
		red = (0.071 * x) + 0.92783;
		green = (-0.78 * x) + 0.83033;
		blue = 0;
		if(self.revivetrigger.beingRevived == 0)
		{
			revive_icon.color = (red, green, blue);
		}
		else
		{
			revive_icon.color = (1, 1, 1);
		}
		wait(0.05);
	}
}

function revive_icon_cleanup(waypoint_pos, revive_icons)
{
	self util::waittill_any("disconnect", "player_revived", "bled_out");
	waypoint_pos Delete();
	foreach(icon in revive_icons)
	{
		icon Destroy();
	}
}

function progress_bar_think()
{
	self endon("disconnect");
	
	while(true)
	{
		if(self zm_laststand::is_reviving_any())
		{
			self LUINotifyEvent(&"revive_info", 2, 1, self HasPerk(PERK_QUICK_REVIVE));
			while(self zm_laststand::is_reviving_any())
			{
				wait(0.05);
			}
			self LUINotifyEvent(&"revive_info", 2, 0, self HasPerk(PERK_QUICK_REVIVE));
		}

		wait(0.05);
	}
}

function testeroo()
{
	while(true) 
	{
		self IPrintLn(self zm_laststand::is_reviving_any());
		wait(1);
	}
}