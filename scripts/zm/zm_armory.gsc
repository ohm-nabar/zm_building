#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_ai_shadowpeople;

#insert scripts\shared\shared.gsh;

#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_USE" );
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

#define PANZERWURFMINE_COST_BASE 500
#define PANZERWURFMINE_COST_MAX 512000
#define PANZERWURFMINE_COOLDOWN 120
#define PANZERWURFMINE_UPGRADE_KILLS 25

#define CROSSBOW_RECHARGE_KILLS_BASE 1
#define CROSSBOW_RECHARGE_KILLS_UPGRADE 1

#define NUM_ARMORY_STATIONS 5

#define NUM_TARGETS 3
#define TARGET_WAIT 4
#define PUZZLE_FAIL_WAIT 1.5

#define TARGET_SEQUENCE_INACTIVE 0
#define TARGET_SEQUENCE_OTHER 1
#define TARGET_SEQUENCE_SAME 2

#namespace zm_armory;

REGISTER_SYSTEM( "zm_armory", &__init__, undefined )

function __init__()
{
	panzerwurfmine_trigs = GetEntArray("panzerwurfmine_use", "targetname");
	
	level.panzerwurfmine = GetWeapon("zm_panzerwurfmine");
	level.panzerwurfmine_up = GetWeapon("zm_panzerwurfmine_up");
	level.panzerwurfmine_cost = PANZERWURFMINE_COST_BASE;
	level.panzerwurfmine_start_of_round = [];
	
	crossbow_trigs = GetEntArray("crossbow_use", "targetname");
	level.crossbow_upgraded = false;
	level.crossbow_active = false;
	level.crossbow_recharge_kills = CROSSBOW_RECHARGE_KILLS_BASE;
	level.crossbow_recharge_progress = CROSSBOW_RECHARGE_KILLS_BASE;

	level.target_sequence_count = [];
	level.armory_symbols_all = array("gumball_blue", "gumball_green", "gumball_orange", "gumball_purple", "gumball_white", "gumball_aqua", "gumball_black", "gumball_red", "gumball_yellow");
	level.armory_symbols = [];
	level.cur_board_symbol = [];
	level.symbol_board_opened = [];
	level.armory_puzzles_solved = 0;
	for(i = 0; i < NUM_ARMORY_STATIONS; i++)
	{
		level.panzerwurfmine_start_of_round[i] = false;
		level.target_sequence_count[i] = 0;
		level.armory_symbols[i] = [];
		level.cur_board_symbol[i] = undefined;
		level.symbol_board_opened[i] = false;
		level thread symbol_think(i);
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
	self thread panzerwurfmine_award_grenade_skip();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if (! self zm_ai_shadowpeople::is_shadow_person() && (willBeKilled && ! IS_TRUE(self.marked_for_recycle)) || (IsPlayer(attacker) && level.zombie_vars[attacker.team]["zombie_insta_kill"]))
	{
		if(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
		{
			level.crossbow_recharge_progress += 1;
		}
		if(IsPlayer(attacker) && weapon == level.panzerwurfmine && attacker.panzerwurfmine_upgrade_kills < PANZERWURFMINE_UPGRADE_KILLS)
		{
			attacker.panzerwurfmine_upgrade_kills += 1;
			if(attacker.panzerwurfmine_upgrade_kills >= PANZERWURFMINE_UPGRADE_KILLS)
			{
				IPrintLn("Panzerwurfmine upgrade ready!");
			}
		}
	}
}

function panzerwurfmine_award_grenade_skip()
{
	self endon("disconnect");

	while(true)
	{
		level waittill("end_of_round");
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
		for(i = 0; i < 10; i++)
		{
			level waittill("start_of_round");
			for(i = 0; i < NUM_ARMORY_STATIONS; i++)
			{
				level.panzerwurfmine_start_of_round[i] = true;
			}
		}
		level.panzerwurfmine_cost *= 2;
	}
}

function panzerwurfmine_hintstring_think()
{
	while(! IS_EQUAL(level.round_number, 1))
	{
		wait(0.05);
	}

	hintstring_state = -1;
	prev_cost = level.panzerwurfmine_cost;
	prev_recharge_time = self.recharge_time;
	cost_weapons = array(GetWeapon("s4_1911"), GetWeapon("s2_mas38"), GetWeapon("zm_healing_grenade"), GetWeapon("s4_gorenko_rifle"), GetWeapon("s4_mg42"), GetWeapon("s4_machinepistol"), GetWeapon("s4_mk11"), GetWeapon("s4_owen_gun"), GetWeapon("s4_nz41"), GetWeapon("s4_ratt"), GetWeapon("zm_panzerwurfmine"));
	while(true)
	{
		if(self.recharge_time == 0 && (hintstring_state != 0 || level.panzerwurfmine_cost != prev_cost))
		{
			hintstring_state = 0;
			prev_cost = level.panzerwurfmine_cost;
			cost_index = Int(level.round_number / 10);
			cost_weapon = cost_weapons[cost_index];
			self SetCursorHint("HINT_WEAPON", cost_weapon);
			self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_USE");
		}
		else if(self.recharge_time > 1 && (hintstring_state != 1 || self.recharge_time != prev_recharge_time))
		{
			hintstring_state = 1;
			prev_recharge_time = self.recharge_time;
			self SetCursorHint("HINT_NOICON");
			self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_RECHARGE", self.recharge_time);
		}
		else if(self.recharge_time == 1 && hintstring_state != 2)
		{
			hintstring_state = 2;
			self SetCursorHint("HINT_NOICON");
			self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_RECHARGE_SINGULAR");
		}
		wait(0.05);
	}
}

function panzerwurfmine_think()
{
	self.recharge_time = 0;
	self SetCursorHint("HINT_NOICON");
	self SetHintString(&"ZOMBIE_NEED_POWER");

	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	self thread panzerwurfmine_hintstring_think();

	while(true)
	{
		self.recharge_time = 0;
		level.panzerwurfmine_start_of_round[self.script_int] = false;
		self waittill("trigger", player);

		if(! (zm_utility::is_player_valid(player) && player zm_magicbox::can_buy_weapon()) || (player zm_weapons::has_weapon_or_upgrade(level.panzerwurfmine) && player GetFractionMaxAmmo(player zm_utility::get_player_lethal_grenade()) == 1))
		{
			continue;
		}

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

function crossbow_hintstring_think()
{
	zombie_vars_defined = false;
	while(! zombie_vars_defined)
	{
		if(isdefined(level.players))
		{
			foreach(player in level.players)
			{
				if(isdefined(player.zombie_vars))
				{
					zombie_vars_defined = true;
					break;
				}
			}
		}
		wait(0.05);
	}

	hintstring_state = -1;
	while(true)
	{
		if(level.crossbow_active && hintstring_state != 0)
		{
			hintstring_state = 0;
			self SetHintString(&"ZM_ABBEY_CROSSBOW_IN_USE");
		}
		else if(level.crossbow_recharge_progress < level.crossbow_recharge_kills && hintstring_state != 1)
		{
			hintstring_state = 1;
			self SetHintString(&"ZM_ABBEY_CROSSBOW_RECHARGE");
		}
		else if(! level.crossbow_active && level.crossbow_recharge_progress >= level.crossbow_recharge_kills && hintstring_state != 2)
		{
			hintstring_state = 2;
			self SetHintString(&"ZM_ABBEY_CROSSBOW_USE");
		}
		wait(0.05);
	}
}

function crossbow_souls_think()
{
	canister = GetEnt("crossbow_soulbox" + self.script_int, "targetname");
	target_canister = GetEnt("crossbow_soulbox_target" + self.script_int, "targetname");
	target_canister SetInvisibleToAll();

	original_pos = canister.origin;
	z_diff = target_canister.origin[2] - canister.origin[2];
	prev_prog = 0;
	
	level waittill("power_on" + self.script_int);

	while(true)
	{
		new_prog = level.crossbow_recharge_progress - prev_prog;
		prev_prog = level.crossbow_recharge_progress;
		if(new_prog > 0)
		{
			z_inc = (z_diff / level.crossbow_recharge_kills) * new_prog;
			canister MoveZ(z_inc, 0.05);
		}
		else if(new_prog < 0)
		{
			canister MoveZ(-z_diff, 0.05);
		}
		wait(0.05);
	}
}

function crossbow_think()
{
	self SetCursorHint("HINT_NOICON");
	self SetHintString(&"ZOMBIE_NEED_POWER");

	if(self.script_int == 1)
	{
		self thread crossbow_souls_think();
	}

	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	self thread crossbow_hintstring_think();

	while(true)
	{
		self waittill("trigger", player);

		if(! (zm_utility::is_player_valid(player) && player zm_magicbox::can_buy_weapon()))
		{
			continue;
		}
		
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
		while(isdefined(player) && (player.zombie_vars[ "zombie_powerup_crossbow_on" ] || player.zombie_vars[ "zombie_powerup_crossbow_up_on" ]))
		{
			wait(0.05);
		}
		level.crossbow_active = false;
		level.crossbow_recharge_progress = 0;
		while(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
		{
			wait(0.05);
		}
	}
}

function crossbow_watch_upgrade()
{
	while(level.armory_puzzles_solved < NUM_ARMORY_STATIONS)
	{
		wait(0.05);
	}

	level.crossbow_upgraded = true;
	IPrintLn("All puzzles complete!");
}

function symbol_think(gen_num)
{
	board_symbols = GetEntArray("symbol_board" + gen_num, "targetname");
	board_symbols = level array::sort_by_script_int(board_symbols, true);
	board_symbol_display = GetEntArray("symbol_display_board" + gen_num, "targetname");
	board_symbol_display = level array::sort_by_script_int(board_symbol_display, true);
	board_symbol_solution = GetEntArray("symbol_solution_board" + gen_num, "targetname");
	board_symbol_solution = level array::sort_by_script_int(board_symbol_solution, true);
	board_symbol_enter = GetEnt("symbol_enter_board" + gen_num, "targetname");
	board_symbol_touching = GetEnt("symbol_touching_board" + gen_num, "targetname");
	symbol_board_container = GetEnt("symbol_board_container" + gen_num, "targetname");
	symbol_board_container_clip = GetEntArray("symbol_board_container_clip" + gen_num, "targetname");

	foreach(symbol_display in board_symbol_display)
	{
		symbol_display SetScale(2);
	}

	foreach(symbol_solution in board_symbol_solution)
	{
		symbol_solution SetScale(2);
	}

	level thread board_symbol_look_handler_wrapper(gen_num, board_symbol_display, board_symbol_touching);
	board_symbol_enter thread board_symbol_enter_think_wrapper(gen_num, board_symbol_solution);

	board_symbol_enter SetCursorHint("HINT_NOICON");
	board_symbol_enter SetHintString("");

	for(i = 0; i < board_symbols.size; i++)
	{
		board_symbols[i] thread board_symbol_think_wrapper(gen_num, i, board_symbol_touching);
	}

	symbol_board_container thread symbol_board_container_think(gen_num, symbol_board_container_clip);
}

function board_symbol_think(gen_num, symbol_num, board_symbol_touching)
{
	level endon("target_sequence_started" + gen_num);
	level endon("armory_puzzle_solved" + gen_num);
	level endon("armory_puzzle_failed" + gen_num);

	while(true)
	{
		self waittill("trigger", player);
		if(player zm_magicbox::can_buy_weapon() && zm_utility::is_player_valid(player) && player IsTouching(board_symbol_touching))
		{
			level notify("board_symbol_lookat" + gen_num, symbol_num);
		}
	}
}

function board_symbol_think_wrapper(gen_num, symbol_num, board_symbol_touching)
{
	level endon("armory_puzzle_solved" + gen_num);

	while(true)
	{
		level waittill("target_sequence_success" + gen_num);
		self thread board_symbol_think(gen_num, symbol_num, board_symbol_touching);
	}
}

function fx_model_cleanup(gen_num)
{
	level util::waittill_any("target_sequence_started" + gen_num, "armory_puzzle_solved" + gen_num, "armory_puzzle_failed" + gen_num);
	self Delete();
}

function board_symbol_look_handler(gen_num, &board_symbol_display, board_symbol_touching)
{
	level endon("target_sequence_started" + gen_num);
	level endon("armory_puzzle_solved" + gen_num);
	level endon("armory_puzzle_failed" + gen_num);

	fx_model = Spawn("script_model", board_symbol_display[0].origin);
	fx_model thread fx_model_cleanup(gen_num);
	fx_model SetModel("tag_origin");
	PlayFXOnTag("custom/fx_trail_blood_soul_zmb", fx_model, "tag_origin");
	fx_model Hide();

	while(true)
	{
		level waittill("board_symbol_lookat" + gen_num, symbol_num);

		if(! IS_EQUAL(level.cur_board_symbol[gen_num], symbol_num))
		{
			level.cur_board_symbol[gen_num] = symbol_num;
			fx_model.origin = board_symbol_display[symbol_num].origin;
			fx_model Show();
		}
	}
}

function board_symbol_look_handler_wrapper(gen_num, &board_symbol_display, board_symbol_touching)
{
	level endon("armory_puzzle_solved" + gen_num);

	while(true)
	{
		level waittill("target_sequence_success" + gen_num);
		level thread board_symbol_look_handler(gen_num, board_symbol_display, board_symbol_touching);
	}
}

function board_symbol_enter_think(gen_num, &board_symbol_solution)
{
	level endon("target_sequence_started" + gen_num);

	while(! level.symbol_board_opened[gen_num])
	{
		wait(0.05);
	}

	selected_symbols = [];
	while(selected_symbols.size < 3)
	{
		self waittill("trigger", player);
		if(isdefined(level.cur_board_symbol[gen_num]) && player zm_magicbox::can_buy_weapon() && zm_utility::is_player_valid(player))
		{
			selected_model = level.armory_symbols_all[level.cur_board_symbol[gen_num]];
			display_model = board_symbol_solution[selected_symbols.size];
			display_model SetModel(selected_model);
			display_model Show();
			level array::add(selected_symbols, selected_model);
		}
	}

	solved = true;
	foreach(symbol in selected_symbols)
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
}

function board_symbol_enter_think_wrapper(gen_num, &board_symbol_solution)
{
	level endon("armory_puzzle_solved" + gen_num);

	solved = false;
	while(true)
	{
		wait(PUZZLE_FAIL_WAIT);
		foreach(symbol_solution in board_symbol_solution)
		{
			symbol_solution Hide();
		}
		level waittill("target_sequence_success" + gen_num);
		self board_symbol_enter_think(gen_num, board_symbol_solution);
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

function target_delete_on_solve(gen_num, symbol)
{
	level waittill("armory_puzzle_solved" + gen_num);

	self Delete();
	symbol Delete();
}

function target_think()
{
	self SetCanDamage(true);
	gen_num = self.script_int;
	symbol = GetEnt(self.target, "targetname");
	symbol SetScale(2);
	self thread target_delete_on_solve(gen_num, symbol);
	level endon("armory_puzzle_solved" + gen_num);

	while(true)
	{
		symbol Hide();
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
	symbol_model = level.armory_symbols[gen_num][symbol_index];

	level.target_sequence_count[gen_num] += 1;
	self RotateYaw(180, 0.1);
	symbol SetModel(symbol_model);
	symbol Show();	
	result = level util::waittill_any_return("target_sequence_success" + gen_num, "target_sequence_fail" + gen_num);
	if(result == "target_sequence_success" + gen_num)
	{
		wait(TARGET_WAIT);
	}
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
	while(w_weapon != level.zombie_powerup_weapon[ "crossbow_up" ] && str_type != "MOD_PROJECTILE_SPLASH")
	{
		well_cover waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type, STR_MODEL, str_tag, str_part, w_weapon);
	}

	well_cover Delete();
	foreach(clip in well_cover_clips)
	{
		clip Delete();
	}
}