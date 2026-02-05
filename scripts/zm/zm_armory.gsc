#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_ai_shadowpeople;
#using scripts\zm\zm_trident;

#insert scripts\zm\zm_armory.gsh;

#using scripts\Sphynx\_zm_sphynx_util;

#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_USE" );
#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_AMMO_FULL" );
#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_RECHARGE", "2" );
#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_RECHARGE_SINGULAR" );

#precache( "triggerstring", "ZM_ABBEY_CROSSBOW_USE" );
#precache( "triggerstring", "ZM_ABBEY_CROSSBOW_RECHARGE" );

#precache( "model", "gumball_blue" );
#precache( "model", "gumball_green" );
#precache( "model", "gumball_orange" );
#precache( "model", "gumball_purple" );
#precache( "model", "gumball_white" );
#precache( "model", "gumball_aqua" );
#precache( "model", "gumball_black" );
#precache( "model", "gumball_red" );
#precache( "model", "gumball_yellow" );

#namespace zm_armory;

REGISTER_SYSTEM( "zm_armory", &__init__, undefined )

function __init__()
{
	panzerwurfmine_trigs = level struct::get_array("panzerwurfmine_use", "targetname");
	level.panzerwurfmine = GetWeapon("zm_panzerwurfmine");
	level.panzerwurfmine_up = GetWeapon("zm_panzerwurfmine_up");
	level.panzerwurfmine_cost = PANZERWURFMINE_COST_BASE;
	level.panzerwurfmine_cost_weapons = array(GetWeapon("s4_1911"), GetWeapon("s2_mas38"), GetWeapon("zm_healing_grenade"), GetWeapon("s4_gorenko_rifle"), GetWeapon("s4_mg42"), GetWeapon("s4_machinepistol"), GetWeapon("s4_mk11"), GetWeapon("s4_owen_gun"), GetWeapon("s4_nz41"));
	level.panzerwurfmine_cost_index = 0;
	level.panzerwurfmine_start_of_round = [];
	
	crossbow_trigs = level struct::get_array("crossbow_use", "targetname");
	level.crossbow_upgraded = false;
	level.crossbow_active = false;
	level.crossbow_recharge_kills = CROSSBOW_RECHARGE_KILLS_BASE;
	level.crossbow_recharge_progress = CROSSBOW_RECHARGE_KILLS_BASE;

	level.target_sequence_count = [];
	level.armory_symbols_all = array("gumball_blue", "gumball_green", "gumball_orange", "gumball_purple", "gumball_white", "gumball_aqua", "gumball_black", "gumball_red", "gumball_yellow");
	level.armory_symbols = [];
	level.armory_symbols_selected = [];
	level.cur_board_symbol = [];
	level.symbol_board_opened = [];
	level.armory_puzzles_solved = 0;
	for(i = 0; i < NUM_ARMORY_STATIONS; i++)
	{
		level.panzerwurfmine_start_of_round[i] = false;
		level.target_sequence_count[i] = 0;
		level.armory_symbols[i] = [];
		level.armory_symbols_selected[i] = [];
		level.cur_board_symbol[i] = undefined;
		level.symbol_board_opened[i] = false;
		level thread symbol_board_think(i);
	}	

	level callback::on_connect(&on_player_connect);
	level zm::register_zombie_damage_override_callback( &zombie_damage_override );
	level zm_utility::register_lethal_grenade_for_level("zm_panzerwurfmine");
	level zm_utility::register_lethal_grenade_for_level("zm_panzerwurfmine_up");
	level zm_weapons::register_zombie_weapon_callback( level.panzerwurfmine, &player_give_panzerwurfmine );
	level zm_weapons::register_zombie_weapon_callback( level.panzerwurfmine_up, &player_give_panzerwurfmine );
	level array::thread_all(panzerwurfmine_trigs, &panzerwurfmine_think);
	level array::thread_all(crossbow_trigs, &crossbow_think);
	level thread panzerwurfmine_cost_scale();

	armory_targets = GetEntArray("armory_target", "targetname");
	level array::thread_all(armory_targets, &target_think);
	level thread crossbow_watch_upgrade();
	level thread golden_well_think();
}

function on_player_connect()
{
	self.panzerwurfmine_upgrade_kills = 0;
	self.b_has_upgraded_panzerwurfmine = false;

	self.cymbal_monkey_upgrade_kills = 0;
	self.b_has_upgraded_cymbal_monkey = false;

	self.healing_grenade_upgrade_kills = 0;
	self.b_has_upgraded_healing_grenade = false;

	self thread panzerwurfmine_award_grenade_skip();
	self thread panzerwurfmine_watch_upgrade();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if (! self zm_ai_shadowpeople::is_shadow_person() && isdefined(attacker) && weapon != level.zombie_powerup_weapon["crossbow"] && weapon != level.zombie_powerup_weapon["crossbow_up"])
	{
		if(IsPlayer(attacker) && (willBeKilled || level.zombie_vars[attacker.team]["zombie_insta_kill"]))
		{
			if(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
			{
				level.crossbow_recharge_progress += 1;
			}
			if(weapon == level.panzerwurfmine && attacker.panzerwurfmine_upgrade_kills < PANZERWURFMINE_UPGRADE_KILLS)
			{
				attacker.panzerwurfmine_upgrade_kills += 1;
				if(attacker.panzerwurfmine_upgrade_kills >= PANZERWURFMINE_UPGRADE_KILLS)
				{
					IPrintLn("Panzerwurfmine upgrade ready!");
				}
			}
			if(weapon == level.weaponZMCymbalMonkey && attacker.cymbal_monkey_upgrade_kills < MONKEY_UPGRADE_KILLS)
			{
				attacker.cymbal_monkey_upgrade_kills += 1;
				if(attacker.cymbal_monkey_upgrade_kills >= MONKEY_UPGRADE_KILLS)
				{
					IPrintLn("Monkey Bomb upgrade ready!");
				}
			}
		}
		else if(isdefined(attacker.activated_by_player) && willBeKilled)
		{
			if(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
			{
				level.crossbow_recharge_progress += 1;
			}
		}
	}
}

function grenade_upgrade_check(grenade, weapon, well_bottom)
{
	self endon("disconnect");

	while(isdefined(grenade) && ! grenade IsTouching(well_bottom))
	{
		wait(0.05);
	}

	if(isdefined(grenade))
	{
		grenade Delete();
		if(weapon == level.panzerwurfmine && self.panzerwurfmine_upgrade_kills >= PANZERWURFMINE_UPGRADE_KILLS)
		{
			IPrintLn("Upgraded Panzerwurfmine!");
			self.b_has_upgraded_panzerwurfmine = true;
			self zm_weapons::weapon_give(level.panzerwurfmine_up);
		}
		else if(weapon == level.weaponZMCymbalMonkey && self.cymbal_monkey_upgrade_kills >= MONKEY_UPGRADE_KILLS)
		{
			IPrintLn("Upgraded Monkey Bomb!");
			self.b_has_upgraded_cymbal_monkey = true;
			self zm_weapons::weapon_give(level.w_cymbal_monkey_upgraded);
		}
		else if(weapon == level.healingGrenade && self.healing_grenade_upgrade_kills >= HEALING_UPGRADE_KILLS)
		{
			IPrintLn("Upgraded Healing Grenade!");
			self.b_has_upgraded_healing_grenade = true;
			self zm_weapons::weapon_give(level.healingGrenadeUpgraded);
		}
		else
		{
			IPrintLn("Not yet!");
		}
	}
}

function panzerwurfmine_watch_upgrade()
{
	self endon("disconnect");

	well_bottom = GetEnt("golden_well_bottom", "targetname");
	grenade = undefined;
	while(true)
	{
		self waittill( "grenade_fire", grenade, weapon );
		if(weapon == level.panzerwurfmine || weapon == level.weaponZMCymbalMonkey || weapon == level.healingGrenade)
		{
			self thread grenade_upgrade_check(grenade, weapon, well_bottom);
		}
		else if(weapon == level.panzerwurfmine_up)
		{
			self thread panzerwurfmine_upgrade_damage(grenade);
		}
	}
}

function filter_invalid_zombies(zombie)
{
	return (isdefined(zombie) && IsAlive(zombie) && ! zombie zm_ai_shadowpeople::is_shadow_person());
}

function panzerwurfmine_upgrade_damage(grenade)
{
	origin = undefined;

	while(isdefined(grenade))
	{
		origin = grenade.origin;
		wait(0.05);
	}

	if(! isdefined(origin))
	{
		return;
	}

	zombies = GetAISpeciesArray("axis", "all");
	exclude_zombies = level array::filter(zombies, false, &filter_invalid_zombies);
	closest_zombies = level array::get_all_closest(origin, exclude_zombies, undefined, PANZERWURFMINE_UPGRADE_MAX_ZOMBIES, PANZERWURFMINE_UPGRADE_RADIUS);
	foreach(zombie in closest_zombies)
	{
		zombie DoDamage(zombie.health + 666, origin, self, self);
	}
}

function panzerwurfmine_award_grenade_skip()
{
	self endon("disconnect");

	while(true)
	{
		level waittill("end_of_round");
		self notify("zombify");
		if(self zm_weapons::has_weapon_or_upgrade(level.panzerwurfmine))
		{
			self.altbody = true;
		}
		level waittill("start_of_round");
		self.altbody = false;
	}
}

function player_give_panzerwurfmine()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_lethal_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_lethal_grenade() );
	}
	
	if(self.b_has_upgraded_panzerwurfmine)
	{
		self GiveWeapon( level.panzerwurfmine_up );
		self zm_utility::set_player_lethal_grenade( level.panzerwurfmine_up );
	}
	else
	{
		self GiveWeapon( level.panzerwurfmine );
		self zm_utility::set_player_lethal_grenade( level.panzerwurfmine );
	}
}

function panzerwurfmine_cost_scale()
{
	while(level.panzerwurfmine_cost < PANZERWURFMINE_COST_MAX)
	{
		for(i = 0; i < PANZERWURFMINE_COST_SCALE_ROUNDS; i++)
		{
			level waittill("start_of_round");
			for(i = 0; i < NUM_ARMORY_STATIONS; i++)
			{
				level.panzerwurfmine_start_of_round[i] = true;
			}
		}
		level.panzerwurfmine_cost *= PANZERWURFMINE_COST_MULT;
		level.panzerwurfmine_cost_index += 1;
	}
}

function panzerwurfmine_prompt_and_visibility(player)
{
	struct = self.stub.related_parent;
	if(struct.script_int > 0 && ! level flag::get("power_on" + struct.script_int))
	{
		self SetHintString(&"ZOMBIE_NEED_POWER");
		return false;
	}
	if(! player zm_magicbox::can_buy_weapon())
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}
	if(struct.recharge_time > 1)
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_RECHARGE", struct.recharge_time);
		return false;
	}
	if(struct.recharge_time == 1)
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_RECHARGE_SINGULAR");
		return false;
	}
	if(player zm_weapons::has_weapon_or_upgrade(level.panzerwurfmine) && player GetFractionMaxAmmo(player zm_utility::get_player_lethal_grenade()) == 1)
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_AMMO_FULL");
		return false;
	}

	cost_weapon = level.panzerwurfmine_cost_weapons[level.panzerwurfmine_cost_index];
	self SetCursorHint("HINT_WEAPON", cost_weapon);
	self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_USE");
	return true;
}

function panzerwurfmine_think()
{
	level waittill("start_of_round");
	self.recharge_time = 0;
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZOMBIE_NEED_POWER", undefined, &panzerwurfmine_prompt_and_visibility);

	if(self.script_int > 0)
	{
		level flag::wait_till("power_on" + self.script_int);
	}

	while(true)
	{
		self.recharge_time = 0;
		self waittill("trigger_activated", player);

		if(player.score < level.panzerwurfmine_cost)
		{
			player PlaySound("zmb_no_cha_ching");
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
			continue;
		}

		player PlaySound("zmb_cha_ching");
		player zm_score::minus_to_player_score(level.panzerwurfmine_cost);
		player zm_weapons::weapon_give(level.panzerwurfmine);

		self.recharge_time = Ceil(PANZERWURFMINE_COOLDOWN / 60);
		level.panzerwurfmine_start_of_round[self.script_int] = false;
		for(i = PANZERWURFMINE_COOLDOWN; i > 0 && ! level.panzerwurfmine_start_of_round[self.script_int]; i--)
		{
			while(level.is_coop_paused)
			{
				wait(0.05);
			}
			wait(1);
			if(i % 60 == 0)
			{
				self.recharge_time = Ceil(i / 60);
			}
		}
	}
}

function crossbow_souls_think()
{
	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	canister = GetEnt("crossbow_soulbox" + self.script_int, "targetname");
	target_canister = level struct::get("crossbow_soulbox_target" + self.script_int, "targetname");

	original_pos = canister.origin;
	z_diff = target_canister.origin[2] - canister.origin[2];
	prev_recharge_kills = level.crossbow_recharge_kills;
	prev_prog = 0;
	prev_upgraded = false;

	while(true)
	{
		if(level.crossbow_upgraded && ! prev_upgraded)
		{
			if(level.crossbow_active)
			{
				while(level.crossbow_active)
				{
					wait(0.05);
				}
			}
			else
			{
				prev_upgraded = true;
				z_diff_upg = target_canister.origin[2] - canister.origin[2];
				canister MoveZ(z_diff_upg, 0.05);
			}
			prev_prog = level.crossbow_recharge_progress;
		}
		else
		{
			new_prog = level.crossbow_recharge_progress - prev_prog;
			prev_prog = level.crossbow_recharge_progress;
			if(level.crossbow_recharge_kills > prev_recharge_kills)
			{
				prev_recharge_kills = level.crossbow_recharge_kills;
				new_prog -= CROSSBOW_RECHARGE_KILLS_INCREMENT;
			}
			z_inc = (z_diff / level.crossbow_recharge_kills) * new_prog;
			canister MoveZ(z_inc, 0.05);
		}
		wait(0.05);
	}
}

function crossbow_prompt_and_update(player)
{
	struct = self.stub.related_parent;
	if(struct.script_int > 0 && ! level flag::get("power_on" + struct.script_int))
	{
		self SetHintString(&"ZOMBIE_NEED_POWER");
		return false;
	}
	if(! player zm_magicbox::can_buy_weapon())
	{
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}
	if(level.crossbow_active)
	{
		self SetHintString(&"ZM_ABBEY_CROSSBOW_IN_USE");
		return false;
	}
	if(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_CROSSBOW_RECHARGE");
		return false;
	}
	
	self SetHintString(&"ZM_ABBEY_CROSSBOW_USE");
	return true;
}

function crossbow_think()
{
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZOMBIE_NEED_POWER", undefined, &crossbow_prompt_and_update);

	self thread crossbow_souls_think();

	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	while(true)
	{
		self waittill("trigger_activated", player);
		
		prev_upgraded = level.crossbow_upgraded;
		powerup_struct = Spawn("script_origin", player.origin);
		if(level.crossbow_upgraded)
		{
			powerup_struct.powerup_name = "crossbow_up";
		}
		else
		{
			powerup_struct.powerup_name = "crossbow";
		}
		powerup_struct.zombie_grabbable = false;
		powerup_struct.only_affects_grabber = true;
		powerup_struct.can_pick_up_in_last_stand = false;
		powerup_struct.powerup_team = player.team;
		powerup_struct.powerup_location = player.origin;
		powerup_struct.powerup_player = player;

		powerup_struct zm_powerups::powerup_grab(player.team);
		level.crossbow_active = true;
		time = 0;
		while(isdefined(player) && (player.zombie_vars[ "zombie_powerup_crossbow_on" ] || player.zombie_vars[ "zombie_powerup_crossbow_up_on" ]))
		{
			time += 0.05;
			wait(0.05);
		}
		level.crossbow_active = false;
		if(! level.crossbow_upgraded || prev_upgraded)
		{	
			level set_crossbow_recharge_progress(time);
		}
		while(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
		{
			wait(0.05);
		}
	}
}

function set_crossbow_recharge_progress(time)
{
	time_remaining = CROSSBOW_MAX_TIME - Min(time, CROSSBOW_MAX_TIME);
	level.crossbow_recharge_kills += CROSSBOW_RECHARGE_KILLS_INCREMENT;
	progress = (time_remaining / CROSSBOW_MAX_TIME) * level.crossbow_recharge_kills;
	level.crossbow_recharge_progress = Int(Min(progress, level.crossbow_recharge_kills * CROSSBOW_RECHARGE_KILLS_MULT_MIN));
}

function crossbow_watch_upgrade()
{
	while(level.armory_puzzles_solved < NUM_ARMORY_STATIONS)
	{
		wait(0.05);
	}

	level.crossbow_recharge_progress = level.crossbow_recharge_kills;
	level.crossbow_upgraded = true;
	IPrintLn("All puzzles complete!");
}

function symbol_board_think(gen_num)
{
	board_symbols = level struct::get_array("symbol_board" + gen_num, "targetname");
	board_symbols = level array::sort_by_script_int(board_symbols, true);
	board_symbol_solution = level struct::get_array("symbol_solution_board" + gen_num, "targetname");
	board_symbol_solution = level array::sort_by_script_int(board_symbol_solution, true);
	board_symbol_enter = level struct::get("symbol_enter_board" + gen_num, "targetname");
	symbol_board_container = GetEnt("symbol_board_container" + gen_num, "targetname");
	symbol_board_container_clip = GetEntArray("symbol_board_container_clip" + gen_num, "targetname");

	level thread board_symbol_look_handler_wrapper(gen_num, board_symbols);
	board_symbol_enter thread board_symbol_enter_think_wrapper(gen_num, board_symbols, board_symbol_solution);

	symbol_board_container thread symbol_board_container_think(gen_num, symbol_board_container_clip);
}

function fx_model_cleanup(gen_num)
{
	level util::waittill_any("target_sequence_started" + gen_num, "armory_puzzle_solved" + gen_num, "armory_puzzle_failed" + gen_num);
	self Delete();
}

function fx_model_hide_on_select(gen_num)
{
	level endon("target_sequence_started" + gen_num);
	level endon("armory_puzzle_solved" + gen_num);
	level endon("armory_puzzle_failed" + gen_num);

	while(true)
	{
		level waittill("armory_puzzle_select" + gen_num);
		self clientfield::set("fx_floating_orb_glow", 0);
	}
}

function board_symbol_look_handler(gen_num, &board_symbols)
{
	level endon("target_sequence_started" + gen_num);
	level endon("armory_puzzle_solved" + gen_num);
	level endon("armory_puzzle_failed" + gen_num);

	while(! level.symbol_board_opened[gen_num])
	{
		wait(0.05);
	}

	fx_model = Spawn("script_model", board_symbols[0].origin);
	fx_model thread fx_model_cleanup(gen_num);
	fx_model thread fx_model_hide_on_select(gen_num);
	fx_model SetModel("tag_origin");

	while(true)
	{
		level waittill("board_symbol_lookat" + gen_num, symbol_num);
		if(! (IS_EQUAL(level.cur_board_symbol[gen_num], symbol_num) || level array::contains(level.armory_symbols_selected[gen_num], level.armory_symbols_all[symbol_num])))
		{
			level.cur_board_symbol[gen_num] = symbol_num;
			fx_model.origin = board_symbols[symbol_num].origin;
			fx_model clientfield::set("fx_floating_orb_glow", 1);
		}
	}
}

function board_symbol_look_handler_wrapper(gen_num, &board_symbols)
{
	level endon("armory_puzzle_solved" + gen_num);

	while(true)
	{
		level waittill("target_sequence_success" + gen_num);
		level thread board_symbol_look_handler(gen_num, board_symbols);
	}
}

function board_symbol_vector_dot(origin)
{
	eye = self util::get_eye();
	delta_vec = AnglesToForward(VectorToAngles(origin - eye));
	view_vec = AnglesToForward(self GetPlayerAngles());
	new_dot = VectorDot( delta_vec, view_vec );

	return new_dot;
}

function board_symbol_look_check(gen_num, board_symbol_enter_trig, &board_symbols)
{
	self endon("disconnect");
	level endon("target_sequence_started" + gen_num);
	level endon("armory_puzzle_solved" + gen_num);
	level endon("armory_puzzle_failed" + gen_num);

	while(! level.symbol_board_opened[gen_num])
	{
		wait(0.05);
	}

	while(true)
	{
		if(! (level zm_utility::is_player_valid(self) && self zm_magicbox::can_buy_weapon() && self IsTouching(board_symbol_enter_trig)))
		{
			wait(0.05);
			continue;
		}
		for(i = 0; i < board_symbols.size; i++)
		{
			dot = self board_symbol_vector_dot(board_symbols[i].origin);
			if(dot >= SYMBOL_LOOKAT_DOT)
			{
				level notify("board_symbol_lookat" + gen_num, i);
				break;
			}
		}
		wait(0.05);
	}
}

function display_model_cleanup(gen_num)
{
	level endon("armory_puzzle_solved" + gen_num);

	event = level util::waittill_any_return("target_sequence_started" + gen_num, "armory_puzzle_failed" + gen_num);
	if(event == "armory_puzzle_failed" + gen_num)
	{
		wait(PUZZLE_FAIL_WAIT);
	}
	self Delete();
}

function board_symbol_enter_think(gen_num, &board_symbol_solution)
{
	level endon("target_sequence_started" + gen_num);

	while(! level.symbol_board_opened[gen_num])
	{
		wait(0.05);
	}

	level.armory_symbols_selected[gen_num] = [];
	while(level.armory_symbols_selected[gen_num].size < NUM_TARGETS)
	{
		self waittill("trigger", player);
		if(isdefined(level.cur_board_symbol[gen_num]) && player zm_magicbox::can_buy_weapon() && zm_utility::is_player_valid(player))
		{
			selected_index = level.cur_board_symbol[gen_num];
			selected_model = level.armory_symbols_all[selected_index];
			display_struct = board_symbol_solution[level.armory_symbols_selected[gen_num].size];

			display_model = Spawn("script_model", display_struct.origin);
			display_model.angles = display_struct.angles;
			display_model SetModel(selected_model);
			display_model thread display_model_cleanup(gen_num);

			level array::add(level.armory_symbols_selected[gen_num], selected_model);
			level.cur_board_symbol[gen_num] = undefined;
			level notify("armory_puzzle_select" + gen_num);
		}
	}

	solved = true;
	foreach(symbol in level.armory_symbols_selected[gen_num])
	{
		if(! level array::contains(level.armory_symbols[gen_num], symbol))
		{
			solved = false;
		}
	}

	if(solved)
	{
		IPrintLn("Solved puzzle!");
		level.armory_puzzles_solved += 1;
		level notify("armory_puzzle_solved" + gen_num);
	}
	else
	{
		IPrintLn("Failed puzzle :(");
		level notify("armory_puzzle_failed" + gen_num);
	}

	return solved;
}

function board_symbol_enter_trig_spawn(origin, angles, width, length, height)
{
	trig = Spawn("trigger_box_use", origin, 0, width, length, height);
	trig.angles = angles;
	trig TriggerIgnoreTeam();
	trig SetCursorHint("HINT_NOICON");
	return trig;
}

function board_symbol_enter_think_wrapper(gen_num, &board_symbols, &board_symbol_solution)
{
	origin = self.origin;
	angles = self.angles;
	dimensions = StrTok(self.script_string, " ");
	width = Float(dimensions[0]);
	length = Float(dimensions[1]);
	height = Float(dimensions[2]);

	solved = false;
	while(! IS_TRUE(solved))
	{
		level waittill("target_sequence_success" + gen_num);
		board_symbol_enter_trig = level board_symbol_enter_trig_spawn(origin, angles, width, length, height);

		foreach(player in level.players)
		{
			player thread board_symbol_look_check(gen_num, board_symbol_enter_trig, board_symbols);
		}

		solved = board_symbol_enter_trig board_symbol_enter_think(gen_num, board_symbol_solution);

		board_symbol_enter_trig Delete();
	}
}

function symbol_board_container_think(gen_num, &symbol_board_container_clip)
{
	level waittill("initial_blackscreen_passed");
	
	self SetCanDamage(true);

	w_weapon = level.weaponNone;
	while(w_weapon != level.panzerwurfmine)
	{
		self waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type, STR_MODEL, str_tag, str_part, w_weapon);
		if(w_weapon == level.abbey_trident && str_type == "MOD_MELEE")
		{
			e_attacker thread zm_trident::preserve_ammo_on_melee();
		}
	}

	self Delete();
	foreach(clip in symbol_board_container_clip)
	{
		clip Delete();
	}
	level.symbol_board_opened[gen_num] = true;
}

function generate_target_symbols(gen_num)
{
	random_symbols = level array::randomize(level.armory_symbols_all);
	level.armory_symbols[gen_num] = level array::clamp_size(random_symbols, NUM_TARGETS);
}

function target_delete_on_solve(gen_num)
{
	level waittill("armory_puzzle_solved" + gen_num);

	self Delete();
}

function target_think()
{
	self SetCanDamage(true);
	gen_num = self.script_int;
	symbol = level struct::get(self.target, "targetname");
	self thread target_delete_on_solve(gen_num);
	level endon("armory_puzzle_solved" + gen_num);

	while(true)
	{
		self waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type, STR_MODEL, str_tag, str_part, w_weapon);
		if(w_weapon != level.zombie_powerup_weapon[ "crossbow" ])
		{
			continue;
		}
		sequence_state = level target_sequence_state(gen_num);
		switch(sequence_state)
		{
			case TARGET_SEQUENCE_OTHER:
				break;
			case TARGET_SEQUENCE_INACTIVE:
				level thread target_sequence_start(gen_num);
			case TARGET_SEQUENCE_SAME:
				self target_shot_think(gen_num, symbol);
				break;
		}
	}
}

function target_shot_think(gen_num, symbol)
{
	symbol_index = level.target_sequence_count[gen_num];
	symbol_model_name = level.armory_symbols[gen_num][symbol_index];

	level.target_sequence_count[gen_num] += 1;
	self RotateYaw(180, 0.1);
	symbol_model = Spawn("script_model", symbol.origin);
	symbol_model.angles = symbol.angles;
	symbol_model SetModel(symbol_model_name);
	symbol_model SetScale(2);
	result = level util::waittill_any_return("target_sequence_success" + gen_num, "target_sequence_fail" + gen_num);
	if(result == "target_sequence_success" + gen_num)
	{
		wait(TARGET_WAIT);
	}
	symbol_model Delete();
	self RotateYaw(180, 0.1);
}

function target_sequence_start(gen_num)
{
	IPrintLn("Sequence start!");
	level notify("target_sequence_started" + gen_num);

	level generate_target_symbols(gen_num);

	while(level.crossbow_active && level.target_sequence_count[gen_num] < NUM_TARGETS)
	{
		wait(0.05);
	}
	
	if(level.target_sequence_count[gen_num] == NUM_TARGETS)
	{
		IPrintLn("Sequence success!");
		level notify("target_sequence_success" + gen_num);
	}
	else
	{
		IPrintLn("Sequence fail :(");
		level notify("target_sequence_fail" + gen_num);
	}

	level.target_sequence_count[gen_num] = 0;
}

function target_sequence_state(gen_num)
{
	for(i = 0; i < level.target_sequence_count.size; i++)
	{
		if(level.target_sequence_count[i] > 0)
		{
			if(i == gen_num)
			{
				return TARGET_SEQUENCE_SAME;
			}
			else
			{
				return TARGET_SEQUENCE_OTHER;
			}
		}
	}

	return TARGET_SEQUENCE_INACTIVE;
}

function golden_well_think()
{
	level waittill("initial_blackscreen_passed");

	well_cover = GetEnt("golden_well_cover", "targetname");
	well_cover_clips = GetEntArray("golden_well_cover_clip", "targetname");

	well_cover SetCanDamage(true);

	w_weapon = level.weaponNone;
	str_type = "";
	while(! (w_weapon == level.zombie_powerup_weapon[ "crossbow_up" ] && str_type == "MOD_PROJECTILE_SPLASH"))
	{
		well_cover waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type, STR_MODEL, str_tag, str_part, w_weapon);
		if(w_weapon == level.abbey_trident && str_type == "MOD_MELEE")
		{
			e_attacker thread zm_trident::preserve_ammo_on_melee();
		}
	}

	well_cover Delete();
	foreach(clip in well_cover_clips)
	{
		clip Delete();
	}
}