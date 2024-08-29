// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using_animtree("generic");

#namespace zm_tomb_teleporter;

#precache("client_fx", "dlc5/tomb/fx_portal_ice_brick_flash");
#precache("client_fx", "dlc5/tomb/fx_portal_ice_brick_glow");
#precache("client_fx", "dlc5/tomb/fx_portal_fire_brick_flash");
#precache("client_fx", "dlc5/tomb/fx_portal_fire_brick_glow");
#precache("client_fx", "dlc5/tomb/fx_portal_elec_brick_flash");
#precache("client_fx", "dlc5/tomb/fx_portal_elec_brick_glow");
#precache("client_fx", "dlc5/tomb/fx_portal_air_brick_flash");
#precache("client_fx", "dlc5/tomb/fx_portal_air_brick_glow");
#precache("client_fx", "dlc5/tomb/fx_portal_generic_brick_dust");
#precache("client_fx", "dlc5/tomb/fx_portal_air");
#precache("client_fx", "dlc5/tomb/fx_portal_air");
#precache("client_fx", "dlc5/tomb/fx_teleport_3p");
#precache("client_fx", "dlc5/tomb/fx_portal_air_koentje");
#precache("client_fx", "dlc5/tomb/fx_portal_elec_koentje");
#precache("client_fx", "dlc5/tomb/fx_portal_fire_koentje");
#precache("client_fx", "dlc5/tomb/fx_portal_ice_koentje");


/*
	Name: init
	Namespace: zm_tomb_teleporter
	Checksum: 0xACA97E60
	Offset: 0x260
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "teleporter_fx", 21000, 1, "int", &function_a8255fab, 0, 0);
	clientfield::register("allplayers", "teleport_arrival_departure_fx", 21000, 1, "counter", &function_dadd24b7, 0, 0);
	clientfield::register("vehicle", "teleport_arrival_departure_fx", 21000, 1, "counter", &function_dadd24b7, 0, 0);
	clientfield::register("toplayer", "player_rumble_and_shake", 21000, 5, "int", &player_rumble_and_shake, 0, 0);
	clientfield::register("scriptmover", "element_glow_fx", 21000, 4, "int", &crystal_fx, 0, 0);
	level._effect["air_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_air_glow";
	level._effect["elec_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_elec_glow";
	level._effect["fire_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_fire_glow";
	level._effect["ice_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_ice_glow";
	level._effect["teleport_3p"] = "dlc5/tomb/fx_teleport_3p";
	level._effect["teleport_air"] = "dlc5/tomb/fx_portal_air_koentje";
	level._effect["teleport_elec"] = "dlc5/tomb/fx_portal_elec_koentje";
	level._effect["teleport_fire"] = "dlc5/tomb/fx_portal_fire_koentje";
	level._effect["teleport_ice"] = "dlc5/tomb/fx_portal_ice_koentje";
}

/*
	Name: main
	Namespace: zm_tomb_teleporter
	Checksum: 0x7784DED7
	Offset: 0x300
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 21000, 1, "pstfx_zm_tomb_teleport");
}

/*
	Name: function_a8255fab
	Namespace: zm_tomb_teleporter
	Checksum: 0xD3E25CE2
	Offset: 0x338
	Size: 0x106
	Parameters: 7
	Flags: Linked
*/
function function_a8255fab(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon("disconnect");
	if(newval == 1)
	{
		if(!isdefined(self.var_1e8e073f))
		{
			self.var_1e8e073f = playfxontag(localclientnum, level._effect["teleport_1p"], self, "tag_origin");
			setfxignorepause(localclientnum, self.var_1e8e073f, 1);
		}
	}
	else if(isdefined(self.var_1e8e073f))
	{
		stopfx(localclientnum, self.var_1e8e073f);
		self.var_1e8e073f = undefined;
	}
}

/*
	Name: function_ffedfe48
	Namespace: zm_tomb_teleporter
	Checksum: 0xB8CCA17
	Offset: 0x448
	Size: 0xE4
	Parameters: 7
	Flags: None
*/
function function_ffedfe48(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_b162502d = !(isdefined(self.var_76534568) && self.var_76534568);
	if(!(isdefined(self.var_76534568) && self.var_76534568))
	{
		self useanimtree(#animtree);
		self.var_76534568 = 1;
	}
	if(newval)
	{
		self thread scene::play("p7_fxanim_zm_ori_portal_open_bundle", self);
	}
	else
	{
		self thread scene::play("p7_fxanim_zm_ori_portal_collapse_bundle", self);
	}
}

/*
	Name: function_dadd24b7
	Namespace: zm_tomb_teleporter
	Checksum: 0xE7FFB710
	Offset: 0x538
	Size: 0x172
	Parameters: 7
	Flags: Linked
*/
function function_dadd24b7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	str_tag_name = "";
	if(self isplayer())
	{
		str_tag_name = "j_spinelower";
	}
	else
	{
		str_tag_name = "tag_brain";
	}
	a_e_players = getlocalplayers();
	foreach(e_player in a_e_players)
	{
		self.var_16ab725 = playfxontag(e_player.localclientnum, level._effect["teleport_arrive_player"], self, str_tag_name);
		setfxignorepause(e_player.localclientnum, self.var_16ab725, 1);
	}
}

function crystal_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval >= 5)
	{
		var_1f503d41 = newval - 4;
		teleporter_fx(localclientnum, var_1f503d41);
		return;
	}
	if(newval == 1)
	{
		self.var_c304583e = playfxontag(localclientnum, level._effect["fire_glow"], self, "tag_origin");
		setfxignorepause(localclientnum, self.var_c304583e, 1);
	}
	else
	{
		if(newval == 2)
		{
			self.var_c304583e = playfxontag(localclientnum, level._effect["air_glow"], self, "tag_origin");
			setfxignorepause(localclientnum, self.var_c304583e, 1);
		}
		else
		{
			if(newval == 3)
			{
				self.var_c304583e = playfxontag(localclientnum, level._effect["elec_glow"], self, "tag_origin");
				setfxignorepause(localclientnum, self.var_c304583e, 1);
			}
			else
			{
				if(newval == 4)
				{
					self.var_c304583e = playfxontag(localclientnum, level._effect["ice_glow"], self, "tag_origin");
					setfxignorepause(localclientnum, self.var_c304583e, 1);
				}
				else if(newval == 0)
				{
					stopfx(localclientnum, self.var_c304583e);
				}
			}
		}
	}
}

function teleporter_fx(localclientnum, enum)
{
	str_fx = "teleport_air";
	switch(enum)
	{
		case 1:
		{
			str_fx = "teleport_fire";
			break;
		}
		case 4:
		{
			str_fx = "teleport_ice";
			break;
		}
		case 3:
		{
			str_fx = "teleport_elec";
			break;
		}
		case 2:
		default:
		{
			str_fx = "teleport_air";
			break;
		}
	}
	self.var_c304583e = playfxontag(localclientnum, level._effect[str_fx], self, "tag_origin");
	setfxignorepause(localclientnum, self.var_c304583e, 1);
}

function player_rumble_and_shake(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon("disconnect");
	if(newval == 4)
	{
		self thread player_continuous_rumble(localclientnum, 1);
	}
	else
	{
		if(newval == 5)
		{
			self thread player_continuous_rumble(localclientnum, 2);
		}
		else
		{
			if(newval == 3)
			{
				self earthquake(0.6, 1.5, self.origin, 100);
				self playrumbleonentity(localclientnum, "artillery_rumble");
			}
			else
			{
				if(newval == 2)
				{
					self earthquake(0.3, 1.5, self.origin, 100);
					self playrumbleonentity(localclientnum, "shotgun_fire");
				}
				else
				{
					if(newval == 1)
					{
						self earthquake(0.1, 1, self.origin, 100);
						self playrumbleonentity(localclientnum, "damage_heavy");
					}
					else
					{
						if(newval == 6)
						{
							self thread player_continuous_rumble(localclientnum, 1, 0);
						}
						else
						{
							self notify("stop_rumble_and_shake");
						}
					}
				}
			}
		}
	}
}

function player_continuous_rumble(localclientnum, rumble_level, shake_camera = 1)
{
	self notify("stop_rumble_and_shake");
	self endon("disconnect");
	self endon("stop_rumble_and_shake");
	while(true)
	{
		if(isdefined(self) && self islocalplayer() && isdefined(self))
		{
			if(rumble_level == 1)
			{
				if(shake_camera)
				{
					self earthquake(0.2, 1, self.origin, 100);
				}
				self playrumbleonentity(localclientnum, "reload_small");
				wait(0.05);
			}
			else
			{
				if(shake_camera)
				{
					self earthquake(0.3, 1, self.origin, 100);
				}
				self playrumbleonentity(localclientnum, "damage_light");
			}
		}
		wait(0.1);
	}
}