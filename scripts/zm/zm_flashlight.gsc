/*
				By Holofya and an unknown person
*/

#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_equipment;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\zm_flashlight.gsh;

#namespace zm_flashlight;

REGISTER_SYSTEM_EX("zm_flashlight", &__init__, &__main__, undefined)

function __init__()
{
	callback::on_connect(&on_player_connect);
	thread mid_game_flashlight_wait();
	thread mid_game_uv_light_wait();
	thread clientfield_init();
}

function __main__()
{
	if(FLASHLIGHT_USE_UV)
	{
		thread uv_entity_init();
	}
}

function on_player_connect()
{
	self thread player_flashlight_init();
}

function clientfield_init()
{
	clientfield::register("toplayer", "flashlight_fx_view", VERSION_SHIP, 2, "int");
	clientfield::register("allplayers", "flashlight_fx_world", VERSION_SHIP, 2, "int");
}

function mid_game_flashlight_wait()
{
	level.mid_game_flashlight = false;

	if(IsDefined(FLASHLIGHT_WAIT) && FLASHLIGHT_WAIT != "" && FLASHLIGHT_WAIT_TYPE == "all_players")
	{
		level waittill(FLASHLIGHT_WAIT);
		level.mid_game_flashlight = true;
	}
}

function mid_game_uv_light_wait()
{
	level.mid_game_uv_light = false;

	if(IsDefined(FLASHLIGHT_UV_WAIT) && FLASHLIGHT_UV_WAIT != "" && FLASHLIGHT_UV_WAIT_TYPE == "all_players")
	{
		level waittill(FLASHLIGHT_UV_WAIT);
		level.mid_game_uv_light = true;
	}
}

function player_flashlight_init()
{
	self endon("kill_flashlight");

	if(IsDefined(FLASHLIGHT_WAIT) && FLASHLIGHT_WAIT != "")
	{
		if(FLASHLIGHT_WAIT_TYPE == "all_players" && level.mid_game_flashlight)
		{
			wait(1);
		}
		else if(FLASHLIGHT_WAIT_TYPE == "all_players")
		{
			level waittill(FLASHLIGHT_WAIT);
		}
		else if(FLASHLIGHT_WAIT_TYPE == "per_player")
		{
			self waittill(FLASHLIGHT_WAIT);
		}
	}

	self.flashlight_state = 0;	// 0 is off, 1 is on, 2 is UV
	self clientfield::set_to_player("flashlight_fx_view", 0); // Flashlight is disabled on spawn
	self clientfield::set("flashlight_fx_world", 0); // Flashlight is disabled on spawn

	if(FLASHLIGHT_USE_UV)
	{
		level flag::init(FLASHLIGHT_UV_WAIT);
		self flag::init("uv_light_enabled");
		self thread uv_wait_for_notify();
	}

	if(FLASHLIGHT_TYPE == "normal")
	{
		self thread flashlight_watch_usebutton();
	}
	else if(FLASHLIGHT_TYPE == "automatic")
	{
		trigs = GetEntArray("flashlight_trig", "targetname");
		self thread flashlight_watch_trigs(trigs);
	}

	//level flag::init("flashlight_hinted");
	//self thread flashlight_hint();
	self thread flashlight_cleanup();
}


/*	void <player> flashlight_watch_usebutton(<boolean>)
*
*	Parameters:
*		boolean - whether or not this is being called for the automatic flashlight, the default is false (you do not need to call it with a parameter)
*
*	Return:
*		
*	Description:
*		Enables or disables the flashlight of the player it is called on
*/
function flashlight_watch_usebutton(automatic = false)
{
	self endon("kill_flashlight");
	self endon("stop_automatic");
	   
	for(;;)
	{
		if(USE_LIGHT_DISABLE && self IsThrowingGrenade() && self.flashlight_state > 0)
		{
			self deactivate_for_grenade();
		}
		else if(self UseButtonPressed())
		{
			catch_next = false;
			
			for(i = 0; i <= 0.5; i += 0.05)
			{
				if(catch_next && self UseButtonPressed())
				{
					if(automatic && (self flag::exists("uv_light_enabled") && self flag::get("uv_light_enabled")) && self.flashlight_state == 1)
					{
						self flashlight_state(2);
						wait 1;
						break;
					}
					else if(automatic && (self flag::exists("uv_light_enabled") && self flag::get("uv_light_enabled")) && self.flashlight_state == 2)
					{
						self flashlight_state(1);
						wait 1;
						break;
					}
					else if(!automatic && self.flashlight_state == 0)
					{
						self flashlight_state(1);
						wait 1;
						break;
					}
					else if(!automatic && (self flag::exists("uv_light_enabled") && self flag::get("uv_light_enabled")) && self.flashlight_state == 1)
					{
						self flashlight_state(2);
						wait 1;
						break;
					}
					else if(!automatic && ((!(self flag::exists("uv_light_enabled") && self flag::get("uv_light_enabled")) && self.flashlight_state == 1) || self.flashlight_state == 2))
					{
						self flashlight_state(0);
						wait 1;
						break;
					}
				}
				else if(!(self UseButtonPressed()))
				{
					catch_next = true;
				}

				wait 0.05;
			}
		}

		wait 0.05;
	}
}

/*	void <player> flashlight_watch_trigs(<array>)
*
*	Parameters:
*		array - an array of entities that trigger the automatic flashlight
*
*	Return:
*		
*	Description:
*		Automatically enables the player's flashlight when touching specific entities
*/
function flashlight_watch_trigs(trigs)
{
	self endon("kill_flashlight");

	if(FLASHLIGHT_ACTIVATE == "normal")
	{
		self thread flashlight_watch_usebutton();
	}
	
	for(;;)
	{
		foreach (trig in trigs)
		{
			while(self IsTouching(trig))
			{
				if(USE_LIGHT_DISABLE && self IsThrowingGrenade() && self.flashlight_state > 0)
				{
					self deactivate_for_grenade();
				}
				else if(self.flashlight_state == 0)
				{
					self flashlight_state(1);

					if(FLASHLIGHT_ACTIVATE == "in_area")
					{
						self thread flashlight_watch_usebutton(true);
					}
				}
		
				wait 0.05;
			}

			if(FLASHLIGHT_ACTIVATE == "in_area" && self.flashlight_state > 0)
			{
				self flashlight_state(0);
				self notify("stop_automatic");
			}
		}
		
		wait 0.05;
	}
}

/*	void <player> deactivate_for_grenade()
*
*	Parameters:
*
*	Return:
*		
*	Description:
*		Changes the flashlight and fx state of the player to maintain fx integrity
*/
function deactivate_for_grenade()
{
	self endon("kill_flashlight");

	self.old_flashlight_state = self.flashlight_state;
	self flashlight_state(0);

	self waittill("weapon_change");
	
	if(self IsThrowingGrenade())
	{
		self util::waittill_any_return("weapon_change", "grenade_fire");
	}
	
	wait(0.1);
	self flashlight_state(self.old_flashlight_state);
	wait(1);
}

/*	void <player> flashlight_state(<int>)
*
*	Parameters:
*		state - int, the state to set the player's flashlight to
*
*	Return:
*		
*	Description:
*		Changes the flashlight and fx state of the player it is called on
*/
function flashlight_state(state)
{
	if(!IsDefined(state))
		break;

	if(state == 0)
	{
		self clientfield::set_to_player("flashlight_fx_view", 0);
		self clientfield::set("flashlight_fx_world", 0);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 0;
	}
	else if(state == 1)
	{
		self clientfield::set_to_player("flashlight_fx_view", 1);
		self clientfield::set("flashlight_fx_world", 1);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 1;
	}
	else if(state == 2)
	{
		self clientfield::set_to_player("flashlight_fx_view", 2);
		self clientfield::set("flashlight_fx_world", 2);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 2;
	}
}

/*	void uv_wait_for_notify()
*
*	Parameters:
*
*	Return:
*		
*	Description:
*		Waits for the specific notify before enabling the UV light
*/
function uv_wait_for_notify()
{
	self endon("kill_flashlight");

	if(IsDefined(FLASHLIGHT_UV_WAIT) && FLASHLIGHT_UV_WAIT != "")
	{
		if(FLASHLIGHT_UV_WAIT_TYPE == "all_players" && level.mid_game_uv_light)
		{
			wait(1);
		}
		else if(FLASHLIGHT_UV_WAIT_TYPE == "all_players")
		{
			level waittill(FLASHLIGHT_UV_WAIT);
		}
		else if(FLASHLIGHT_UV_WAIT_TYPE == "per_player")
		{
			self waittill(FLASHLIGHT_UV_WAIT);
		}
	}

	self flag::set("uv_light_enabled");
	self thread uv_light_hint();
}

/*	void update_reveal_ents()
*
*	Parameters:
*
*	Return:
*		
*	Description:
*		Creates the initial reveal entities array and hides them
*/
function uv_entity_init()
{
	level.reveal_ents = GetEntArray("uv_reveal_ent", "targetname");

	foreach (ent in level.reveal_ents)
	{
		ent Hide();
	}

	level waittill("initial_blackscreen_passed");
	
	thread check_player_seeing_ent();
	thread update_reveal_ents();
	thread uv_entity_cleanup();
}

/*	void update_reveal_ents()
*
*	Parameters:
*
*	Return:
*		
*	Description:
*		Checks to see if an entity needs hidden or shown
*/
function update_reveal_ents()
{
	level endon("kill_flashlight");

	level.visible_reveal_ents = [];
	level.not_visible_reveal_ents = [];

	for(;;)
	{
		level waittill("uv_ents_visible_update");

		foreach (ent in level.visible_reveal_ents)
		{
			if(ent IsHidden())
			{
				ent Show();
			}
		}

		foreach (ent in level.not_visible_reveal_ents)
		{
			if(!ent IsHidden())
			{
				ent Hide();
			}
		}

		level.visible_reveal_ents = [];
		level.not_visible_reveal_ents = [];
	}
}

/*	void check_player_seeing_ent()
*
*	Parameters:
*
*	Return:
*		
*	Description:
*		Checks to see if any player is looking at a reveal entity with their UV light on
*/
function check_player_seeing_ent()
{
	level endon("kill_flashlight");

	for(;;)
	{
		if(any_player_uv_active())
		{
			foreach (player in level.active_uv_players)
			{
				uv_dist_sq = UV_VISIBILITY_DIST * UV_VISIBILITY_DIST;
				view_pos = player GetWeaponMuzzlePoint();
				forward_view_angles = player GetWeaponForwardDir();
				end_pos = view_pos + VectorScale(forward_view_angles, UV_VISIBILITY_DIST);

				foreach (ent in level.reveal_ents)
				{
					test_origin = ent GetCentroid();
					test_range_squared = DistanceSquared(view_pos, test_origin);

					if(test_range_squared > uv_dist_sq)
					{
						if(!IsInArray(level.not_visible_reveal_ents, ent))
						{
							level.not_visible_reveal_ents[level.not_visible_reveal_ents.size] = ent;
						}
						
						continue; // ent is not close enough
					}

					normal = VectorNormalize(test_origin - view_pos);
					dot = VectorDot(forward_view_angles, normal);

					if (0 > dot)
					{
						if(!IsInArray(level.not_visible_reveal_ents, ent))
						{
							level.not_visible_reveal_ents[level.not_visible_reveal_ents.size] = ent;
						}

						continue; // ent is behind player
					}
	
					radial_origin = PointOnSegmentNearestToPoint(view_pos, end_pos, test_origin);

					if(DistanceSquared(test_origin, radial_origin) > 900)
					{
						if(!IsInArray(level.not_visible_reveal_ents, ent))
						{
							level.not_visible_reveal_ents[level.not_visible_reveal_ents.size] = ent;
						}

						continue; // ent is not within cone
					}

					if(0.75 >= ent DamageConeTrace(view_pos, player, VectorNormalize(forward_view_angles), 25))
					{
						if(!IsInArray(level.not_visible_reveal_ents, ent))
						{
							level.not_visible_reveal_ents[level.not_visible_reveal_ents.size] = ent;
						}

						continue; // less than 75% of the entity is visible
					}

					if(!IsInArray(level.visible_reveal_ents, ent))
					{
						level.visible_reveal_ents[level.visible_reveal_ents.size] = ent;
					}
				}

				is_updating = false;

				foreach (entity in level.not_visible_reveal_ents)
				{
					if(!entity IsHidden())
					{
						level notify("uv_ents_visible_update");
						is_updating = true;
					}
				}

				if(!is_updating)
				{
					foreach (entity in level.visible_reveal_ents)
					{
						if(entity IsHidden())
						{
							level notify("uv_ents_visible_update");
						}
					}
				}
			}
		}
		else
		{
			foreach (ent in level.reveal_ents)
			{
				if(!ent IsHidden())
				{
					level.not_visible_reveal_ents[level.not_visible_reveal_ents.size] = ent;
				}
			}

			if(IsDefined(level.not_visible_reveal_ents))
			{
				level notify("uv_ents_visible_update");
			}
		}

		wait(0.05);
	}
}

/*	void any_player_uv_active()
*
*	Parameters:
*
*	Return:
*		returns true if any players have their UV light active
*		
*	Description:
*		Checks which players have their UV light active, then adds them to the array
*/
function any_player_uv_active()
{
	if(!IsDefined(level.active_uv_players))
	{
		level.active_uv_players = [];
	}
	
	foreach (player in GetPlayers())
	{
		if(player.flashlight_state == 2)
		{
			level.active_uv_players[level.active_uv_players.size] = player;
		}
		else
		{
			if(IsInArray(level.active_uv_players, player))
			{
				ArrayRemoveValue(level.active_uv_players, player);
			}
		}
	}

	if(level.active_uv_players.size > 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*	void add_ent_to_reveal_ents(<entity>)
*
*	Parameters:
*		entity - entity, the entity to make a UV revealed entity
*
*	Return:
*		
*	Description:
*		Adds an entity to the array of reveal entities
*/
function add_ent_to_reveal_ents(ent)
{
	ent.targetname = "uv_reveal_ent";
	update_reveal_ent_array();
}

function update_reveal_ent_array()
{
	level.reveal_ents = GetEntArray("uv_reveal_ent", "targetname");
}

function flashlight_cleanup()
{
	self util::waittill_either("disconnect", "kill_flashlight");

	self flashlight_state(0);
}

function uv_entity_cleanup()
{
	level waittill("kill_flashlight");

	foreach (ent in level.reveal_ents)
	{
		ent Hide();
	}

	level.reveal_ents = GetEntArray("uv_reveal_ent", "targetname");

	foreach (ent in level.reveal_ents)
	{
		ent Hide();
	}
}

/*	void <player> flashlight_hint()
*
*	Parameters:
*		
*	Return:
*		
*	Description:
*		Plays the flashlight toggle hint to the player it is called on
*/
function flashlight_hint()
{
	if(!level flag::get("initial_blackscreen_passed"))
	{
		level flag::wait_till("initial_blackscreen_passed");
	}

	if(FLASHLIGHT_TYPE == "automatic")
	{
		self thread zm_equipment::show_hint_text("Your flashlight will activate when in dark areas.");
	}

	wait(4);

	if(FLASHLIGHT_ACTIVATE == "normal")
	{
		self thread zm_equipment::show_hint_text("Double press ^3[{+activate}]^7 to activate your flashlight.");
	}

	if(!level flag::get("flashlight_hinted"))
	{
		level flag::set("flashlight_hinted");
	}
}

/*	void <player> uv_light_hint()
*
*	Parameters:
*		
*	Return:
*		
*	Description:
*		Plays the uv light toggle hint to the player it is called on
*/
function uv_light_hint()
{
	if(!level flag::get("initial_blackscreen_passed"))
	{
		level flag::wait_till("initial_blackscreen_passed");
	}

	if(!level flag::get("flashlight_hinted"))
	{
		level flag::wait_till("flashlight_hinted");
	}
	
	wait(4);
	self thread zm_equipment::show_hint_text("Double press ^3[{+activate}]^7 to activate your uv light when the flashlight is active.");
}
