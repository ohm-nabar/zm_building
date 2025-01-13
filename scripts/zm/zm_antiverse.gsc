#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\lui_shared;

#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\scene_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm;
#using scripts\zm\_zm_spawner;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_audio;

#using scripts\zm\zm_ai_shadowpeople;
#using scripts\Sphynx\_zm_sphynx_util;
#using scripts\zm\zm_flashlight;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

#precache("fx", "custom/fx_trail_blood_soul_zmb");

function main()
{
	level.maze_step_count = 0;
	level.broken_walls = [];

	level.antiverse_loadout = SpawnStruct();
	level.antiverse_loadout.w_current_weapon = GetWeapon("s4_1911");
	level.antiverse_loadout.w_stowed_weapon = undefined;
	level.antiverse_loadout.a_all_weapons = array(zm_weapons::get_default_weapondata(GetWeapon("s4_1911")), zm_weapons::get_default_weapondata(GetWeapon("knife")));
	level.antiverse_loadout.n_score = 0;
	level.antiverse_loadout.a_perks = [];
	level.antiverse_loadout.a_disabled_perks = [];
	level.antiverse_loadout.a_additional_primary_weapons_lost = false;
	level.antiverse_spawn_points = struct::get_array("shadow_maze_spawn", "targetname");
	level.antiverse_end_points = array::sort_by_script_int(struct::get_array("shadow_maze_end", "targetname"), true);
	create_walls();
	create_nodes();
	create_edges();
}

function create_walls()
{
	level.shadow_maze_walls = [];
	walls = GetEntArray("shadow_maze_wall", "targetname");
	for(i = 0; i < walls.size; i++)
	{
		level.shadow_maze_walls[walls[i].script_string] = walls[i];
	}
}

function create_nodes()
{
	// i hate to do it like this but working with gsc classes
	// has been the worst experience of my life and i will never do it again
	// wtf treyarch??
	level.maze_node_neighbors = [];
	level.maze_node_assigned = [];
	for(i = 0; i < 25; i++)
	{
		array::add(level.maze_node_neighbors, []);
		array::add(level.maze_node_assigned, false);
	}
}

function create_edges()
{
	for(i = 0; i < 25; i++)
	{
		if((i + 1) % 5 != 0)
		{
			create_edge(i, i + 1);
		}
		if((i + 5) < 25) // could just be i < 20, but this is more symmetrical and shows logic better
		{	
			create_edge(i, i + 5);
		}
	}
}

function create_edge(index1, index2)
{
	array::add(level.maze_node_neighbors[index1], index2);
	array::add(level.maze_node_neighbors[index2], index1);
}

function send_to_antiverse()
{
	self thread player_maze_setup(level.antiverse_spawn_points[0].origin, level.antiverse_spawn_points[0].angles);

	queue = [];
	cur_node = 0;
	array::add(queue, cur_node);
	level.maze_node_assigned[cur_node] = true;
	neighbor = random_unassigned_neighbor(0);
	furthest_dist = 0;
	end_node = 0;

	while(isdefined(neighbor))
	{
		break_wall(cur_node, neighbor);
		if(queue.size > furthest_dist)
		{
			furthest_dist = queue.size;
			end_node = neighbor;
		}
		cur_node = neighbor;
		array::add(queue, cur_node);
		level.maze_node_assigned[cur_node] = true;
		neighbor = random_unassigned_neighbor(cur_node);
		while(! isdefined(neighbor) && queue.size > 0)
		{
			cur_node = array::pop(queue, queue.size - 1);
			neighbor = random_unassigned_neighbor(cur_node);
		}

		wait(0.05);
	}

	level.antiverse_end = Spawn("script_model", level.antiverse_end_points[end_node].origin);
	level.antiverse_end SetModel("tag_origin");
	PlayFXOnTag("custom/fx_trail_blood_soul_zmb", level.antiverse_end, "tag_origin");

	self thread player_finish_monitor();
}

function player_maze_setup(origin, angles)
{
	self DisableWeaponCycling();
	self.antiverse_loadout = self zm_sphynx_util::get_player_loadout();
	self visionset_mgr::activate("visionset", "abbey_shadow", self);
	
	self PlaySoundToPlayer("1_flashlight_click", self);
	self zm_flashlight::flashlight_state(1);
	if(self.startingpistol != level.start_weapon)
	{
		level.antiverse_loadout.a_all_weapons[0] = zm_weapons::get_default_weapondata(self.startingpistol);
	}
	else
	{
		level.antiverse_loadout.a_all_weapons[0] = zm_weapons::get_default_weapondata(GetWeapon("s4_1911"));
	}
	antiverse_loadout = level.antiverse_loadout;
	antiverse_loadout.a_location_info = []; antiverse_loadout.a_location_info["origin"] = origin; antiverse_loadout.a_location_info["angles"] = angles; 
	self zm_sphynx_util::give_player_loadout(level.antiverse_loadout, 1, 1, 1, 1);

	wait(1.2);
	self thread lui::screen_fade_in( 1.5, "black" );
	level zm_audio::sndMusicSystem_PlayState("antiverse_amb_" + RandomIntRange(0, 6));
}

function player_finish_monitor()
{
	timer = 0;
	flashlight_50 = false;
	flashlight_25 = false;
	while (DistanceSquared(self.origin, level.antiverse_end.origin) > 40000 && timer <= 1200)
	{
		if(timer > 900 && ! flashlight_25)
		{
			flashlight_25 = true;
			self zm_flashlight::flashlight_state(3);
		}
		else if(timer > 600 && ! flashlight_50)
		{
			flashlight_50 = true;
			self zm_flashlight::flashlight_state(2);
		}

		timer += 1;
		wait(0.05);
	}
	
	if(timer > 1200)
	{
		self.antiverse_skip = true;
		self FreezeControls(true);
		self zm_flashlight::flashlight_state(0);
		wait(0.75);
		self lui::screen_fade_out( 0.75, "black" );
		self visionset_mgr::deactivate("visionset", "abbey_shadow", self);
		self Kill();
		wait(8);
		self lui::screen_fade_in( 0.1, "black" );
		return;
	}

	level thread antiverse_reset();
	level zm_audio::sndMusicSystem_StopAndFlush();
	music::setmusicstate("none");
	self lui::screen_fade_out( 0.75, "black" );
	if(! level.shadow_vision_active)
	{
		self visionset_mgr::deactivate("visionset", "abbey_shadow", self);
	}
	wait(0.75);
	self zm_sphynx_util::give_player_loadout(self.antiverse_loadout, 1, 0, 0, 1);
	self zm_flashlight::flashlight_state(0);
	self lui::screen_fade_in( 0.75, "black" );
	wait(0.75);
	self.abbey_no_waypoints = self.prev_abbey_no_waypoints;
	if(! self.abbey_no_hud)
	{
		self util::show_hud(true);
	}
	self EnableWeaponCycling();
	level.sndVoxOverride = false;
}

function antiverse_reset()
{
	for(i = 0; i < level.maze_node_assigned.size; i++)
	{
		level.maze_node_assigned[i] = false;
	}

	level.antiverse_end Delete();
	level.antiverse_end = undefined;
	
	wait(1.5);

	foreach(wall in level.broken_walls)
	{
		wall MoveZ(1000, 1);
	}
	level.broken_walls = [];

	if(level flag::get("dog_round"))
	{
		level thread zm_ai_shadowpeople::unpause(true);
		level thread zm_audio::sndMusicSystem_PlayState("shadow_breach");
	}
	else
	{
		level zm_sphynx_util::start_zombie_spawning();
	}
}

function random_unassigned_neighbor(node)
{
	unassigned_neighbors = filter_unassigned(level.maze_node_neighbors[node]);
	
	level.maze_step_count++;
	player1 = level.players[0];
	return array::random(unassigned_neighbors);
}

function filter_unassigned(neighbors)
{
	arr = [];
	foreach(node in neighbors)
	{
		if(! level.maze_node_assigned[node])
		{
			array::add(arr, node);
		}
	}

	return arr;
}

function break_wall(node1, node2)
{
	key = Min(node1, node2) + "" + Max(node1, node2);
	wall = level.shadow_maze_walls[key];
	wall MoveZ(-1000, 1);
	array::add(level.broken_walls, wall);
}