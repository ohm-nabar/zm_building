#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_utility;
#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_ai_shadowpeople;
#using scripts\zm\zm_room_manager;

#define CLOSE_INDEX 0
#define FAR_INDEX 1
#define CLOSE_DIR_INDEX 2
#define FAR_DIR_INDEX 3

#define PATH_DIR_LEFT 0
#define PATH_DIR_RIGHT 1
#define PATH_DIR_BACKWARD 2
#define PATH_DIR_FORWARD 3

#define CHASE_MIN_SIZE 1

#define INTERCEPTION_MIN_SIZE 2
#define INTERCEPTION_MAX_SIZE 3

#define INTERCEPTION_SPAWN_ROOMS 2
#define CONTINGENCY_SPAWN_ROOMS 3

#define MAIN_PATH_ODDS 75

REGISTER_SYSTEM( "zm_cloak_logic", &__init__, undefined )

class CloakRoom
{
    var name;
    var forward;
    var backward;
    var left;
    var right;
    var connected_flags;

    constructor(){}
    destructor(){}
}

function CloakRoom_init(name)
{
    cloak_room = new CloakRoom();
    cloak_room.name = name;
    cloak_room.connected_flags = [];
    cloak_room.connected_flags[name] = "initial_blackscreen_passed"; // hacky way to have an always active flag
    level.cloak_rooms[name] = cloak_room;
    return cloak_room;
}

function add_adj_room(adj_room, front_back, connect_flag)
{
    if(front_back)
    {
        self.forward = adj_room;
        adj_room.backward = self;
    }
    else
    {
        self.right = adj_room;
        adj_room.left = self;
    }

    self.connected_flags[adj_room.name] = connect_flag;
    adj_room.connected_flags[self.name] = connect_flag;
}

function cloak_room_equal(cloak_room)
{
    return (isdefined(self) && isdefined(cloak_room) && (self.name == cloak_room.name));
}

class CloakPathInfo
{
    var name;
    var player;
    var spawn_point;
    var path;

    constructor(){}
    destructor(){}
}

function CloakPathInfo_init(name, player, spawn_point, &path)
{
    path_info = new CloakPathInfo();
    path_info.name = name;
    path_info.player = player;
    path_info.spawn_point = spawn_point;
    path_info.path = path;

    return path_info;
}

function __init__()
{
    level.cloak_rooms = [];
    staminarch = level CloakRoom_init("Staminarch");
    spawn = level CloakRoom_init("Spawn Room");
    wtower = level CloakRoom_init("Water Tower");
    lion = level CloakRoom_init("Lion Room");
    clean = level CloakRoom_init("Clean Room");
    downstairs = level CloakRoom_init("Downstairs Room");

    staminarch add_adj_room(spawn, true, "enter_staminarch");
    spawn add_adj_room(wtower, true, "enter_wtower");
    wtower add_adj_room(lion, false, "enter_dirty");
    downstairs add_adj_room(clean, false, "enter_downstairs");
    clean add_adj_room(wtower, false, "enter_clean");

    level cloak_spawns_initialize();
    level cloak_nodes_initialize();
}

function cloak_spawns_initialize()
{
    level waittill("initial_blackscreen_passed");

    level.cloak_spawns = [];
    level.cloak_quick_attack_spawns = [];
    level.cloak_quick_attack_check = [];

    cloak_spawn_structs = level struct::get_array("cloak_spawn", "targetname");
    if(! isdefined(cloak_spawn_structs))
    {
        debug_str = "Undefined";
        /# PrintLn(debug_str); #/
    }
    
    foreach(spawn_struct in cloak_spawn_structs)
    {
        spawn_model = Spawn("script_model", spawn_struct.origin);
        spawn_model SetModel("tag_origin");
        cloak_room = spawn_model get_ent_cloak_room(true);
        spawn_model Delete();
        spawn_struct.room_name = cloak_room.name;
        if(! isdefined(level.cloak_spawns[cloak_room.name]))
        {
            level.cloak_spawns[cloak_room.name] = [];
        }
        level array::add(level.cloak_spawns[cloak_room.name], spawn_struct);

        gen_num = spawn_struct.script_int;
        if(gen_num > 0)
        {
            quick_attack_room_names = StrTok(spawn_struct.script_noteworthy, ",");
            if(! isdefined(quick_attack_room_names))
            {
                debug_str = "Quick Attack room names undefined for spawn point in " + cloak_room.name;
                /# PrintLn(debug_str); #/
            }
            else
            {
                foreach(name in quick_attack_room_names)
                {
                    if(! isdefined(level.cloak_quick_attack_spawns[name]))
                    {
                        level.cloak_quick_attack_spawns[name] = [];
                    }
                    level array::add(level.cloak_quick_attack_spawns[name], spawn_struct);
                    level.cloak_quick_attack_check[name] = gen_num;
                }
            }
        }
    }
}

function cloak_nodes_initialize()
{
    level.cloak_nodes = [];
    cloak_node_structs = level struct::get_array("cloak_node", "targetname");

    foreach(node_struct in cloak_node_structs)
    {
        node_model = Spawn("script_model", node_struct.origin);
        node_model SetModel("tag_origin");
        cloak_room = node_model get_ent_cloak_room(true);
        node_model Delete();

        level.cloak_nodes[cloak_room.name] = node_struct;
    }
}

function cloak_shadow_death_watch(gen_saved_notify)
{
    self endon(#"shadowing_complete");

    foreach(player in level.players)
    {
        player.prev_gen_notify_count = player.gen_notify_count;
    }

    self waittill("death");
    level notify(gen_saved_notify);
    foreach(player in level.players)
    {
        if(player.gen_notify_count == player.prev_gen_notify_count)
        {
            player notify(#"generator_override");
        }
    }
}

function cloak_path_logic(gen_struct, gen_num, path)
{
    self endon("death");

    foreach(cloak_room in path)
    {
        debug_str = "Moving to " + cloak_room.name;
        /# PrintLn(debug_str); #/
        cloak_node = level.cloak_nodes[cloak_room.name];
        self.v_zombie_custom_goal_pos = cloak_node.origin;
		self SetGoal(cloak_node.origin, false, 64, 64);

        do 
        {
            wait(0.05);
        } 
        while(! self IsInGoal(self.origin));

        if(IS_EQUAL(level.cloak_quick_attack_check[cloak_room.name], gen_num))
        {
            break;
        }
    }

    debug_str = "Moving to Generator " + gen_num;
    /# PrintLn(debug_str); #/
    self.v_zombie_custom_goal_pos = gen_struct.origin;
    self SetGoal(gen_struct.origin, false, 64, 64);

    do
    {
        wait(0.05);
    }
    while(! self IsInGoal(self.origin));

    self notify("goal_reached");
    self.ignoreall = false; 
    self.v_zombie_custom_goal_pos = undefined;

    self PlayLoopSound("shadow_ritual");
    self clientfield::set("cloak_shadowing", 1);
    self AnimScripted("cloak_conjuring", self.origin, self.angles, "cloak_conjuring");
    
    foreach(player in level.players)
    {
        player thread zm_abbey_inventory::notifyGenerator();
        player LUINotifyEvent(&"generator_attacked", 1, gen_num - 1);
    }

    level.generator_touched = true;

    gen_saved_notify = "generator" + gen_num + "_saved";
    self thread cloak_shadow_death_watch(gen_saved_notify);
    for(i = 0; i < 10; i++)
    {
        wait(1);
    }

    self notify(#"shadowing_complete");
    self StopLoopSound();

    level.generators_shadowed[level.generators_shadowed.size] = gen_num;
    level notify("generator" + gen_num + "_shadowed");
    foreach(player in level.players)
    {
        player thread zm_abbey_inventory::notifyGenerator(true);
        player LUINotifyEvent(&"generator_shadowed", 1, gen_num - 1);
        player clientfield::set_player_uimodel("shadowPerks", gen_num);
    }

    self DoDamage(self.health + 666, self.origin);
}

function cloak_spawn_logic(gen_struct, gen_num)
{
    main_paths = [];
    low_odds_paths = [];
    fallback_paths = [];

    gen_model = Spawn("script_model", gen_struct.origin);
    gen_model SetModel("tag_origin");
    gen_cloak_room = gen_model get_ent_cloak_room();
    gen_model Delete();

    cloaks = level zm_ai_shadowpeople::get_cloaks();
    foreach(player in level.players)
    {
        should_skip = false;
        foreach(cloak in cloaks)
        {
            if(IS_EQUAL(cloak.player, player))
            {
                should_skip = true;
            }
        }
        if(should_skip || ! level zm_utility::is_player_valid(player))
        {
            debug_str = "Skipped Player " + player.characterIndex;
            /# PrintLn(debug_str); #/
            continue;
        }
        player cloak_spawn_logic_player(gen_cloak_room, gen_num, main_paths, low_odds_paths, fallback_paths);
    }

    debug_str = "Main Paths Size: " + main_paths.size;
    debug_str2 = "Low Odds Paths Size: " + low_odds_paths.size;
    debug_str3 = "Fallback Paths Size: " + fallback_paths.size;
    /#
    PrintLn(debug_str);
    PrintLn(debug_str2);
    PrintLn(debug_str3);
    #/

    path_info = undefined;
    if(main_paths.size > 0 && low_odds_paths.size > 0)
    {
        rand = RandomInt(100);
        if(rand < MAIN_PATH_ODDS)
        {
            debug_str = "Choosing from Main Paths";
            /# PrintLn(debug_str); #/
            path_info = level array::random(main_paths);
        }
        else
        {
            debug_str = "Choosing from Low Odds Paths";
            /# PrintLn(debug_str); #/
            path_info = level array::random(low_odds_paths);
        }
    }
    else if(main_paths.size > 0)
    {
        debug_str = "Choosing from Main Paths, Low Odds Paths empty";
        /# PrintLn(debug_str); #/
        path_info = level array::random(main_paths);
    }
    else if(low_odds_paths.size > 0)
    {
        debug_str = "Choosing from Low Odds Paths, Main Paths empty";
        /# PrintLn(debug_str); #/
        path_info = level array::random(low_odds_paths);
    }
    else if(fallback_paths.size > 0)
    {
        debug_str = "Choosing from Fallback Paths";
        /# PrintLn(debug_str); #/
        path_info = level array::random(fallback_paths);
    }
    else
    {
        debug_str = "No Paths found, generating Contingency Paths";
        /# PrintLn(debug_str); #/
        path_info = level contingency_create_path(gen_cloak_room);
    }

    debug_str = "Choosing " + path_info.name + " Path";
    debug_str2 = "Spawning in " + path_info.spawn_point.room_name;
    /#
    PrintLn(debug_str);
    PrintLn(debug_str2);
    #/
    cloak = level zm_ai_shadowpeople::cloak_spawn(gen_struct, path_info.spawn_point);
    cloak.gen_num = gen_num;
    cloak.player = path_info.player;
    cloak cloak_path_logic(gen_struct, gen_num, path_info.path);
}

// self = player
function cloak_spawn_logic_player(gen_cloak_room, gen_num, &main_paths, &low_odds_paths, &fallback_paths)
{
    self endon("disconnect");

    player_cloak_room = self get_ent_cloak_room();

    if(! isdefined(player_cloak_room))
    {
        debug_str = "Player room undefined";
        /# PrintLn(debug_str); #/
        return;
    }
    else
    {
        debug_str = "Player in: " + player_cloak_room.name;
        /# PrintLn(debug_str); #/
    }
    if(! isdefined(gen_cloak_room))
    {
        debug_str = "Generator room undefined";
        /# PrintLn(debug_str); #/
        return;
    }
    else
    {
        debug_str = "Generator in: " + gen_cloak_room.name;
        /# PrintLn(debug_str); #/
    }

    paths = player_cloak_room find_paths(gen_cloak_room);
    close_path = paths[CLOSE_INDEX];
    far_path = paths[FAR_INDEX];
    close_dir = paths[CLOSE_DIR_INDEX];
    far_dir = paths[FAR_DIR_INDEX];

    self quick_attack_check(player_cloak_room.name, gen_num, gen_cloak_room.connected_flags, main_paths, fallback_paths);
    self chase_check(close_path, far_path, main_paths, low_odds_paths, fallback_paths);
    self interception_check(close_path, close_dir, gen_cloak_room, low_odds_paths, fallback_paths);
}

function quick_attack_check(room_name, gen_num, &connected_flags, &main_paths, &fallback_paths)
{
    if(IS_EQUAL(level.cloak_quick_attack_check[room_name], gen_num) && level flag::get(connected_flags[room_name]))
    {
        spawn_points = level.cloak_quick_attack_spawns[room_name];
        spawn_points = level array::randomize(spawn_points);
        chosen_spawn_point = undefined;
        foreach(spawn_point in spawn_points)
        {
            if(level flag::get(connected_flags[spawn_point.room_name]))
            {
                chosen_spawn_point = spawn_point;
                break;
            }
        }
        if(isdefined(chosen_spawn_point))
        {
            debug_str = "Added a Quick Attack Path (Spawn -- " + chosen_spawn_point.room_name + ")";
            /# PrintLn(debug_str); #/
            self add_cloak_path("Quick Attack", chosen_spawn_point, [], main_paths, fallback_paths, false);
        }
        else
        {
            debug_str = "Failed to add a Quick Attack path, no Quick Attack spawners available for " + room_name;
            /# PrintLn(debug_str); #/
        }
    }
    else
    {
        debug_str = "Failed to add a Quick Attack path, player not in Quick Attack zone";
        /# PrintLn(debug_str); #/
    }
}

function chase_check(close_path, far_path, &main_paths, &low_odds_paths, &fallback_paths)
{
    if(self chase_create_and_add_path(close_path, main_paths, fallback_paths))
    {
        debug_str = "Added a Chase Path using the Close Path";
        /# PrintLn(debug_str); #/
    }
    else
    {
        debug_str = "Failed to add a Chase Path using the Close Path";
        /# PrintLn(debug_str); #/
    }
    if(! level path_equal(close_path, far_path))
    {
        if(self chase_create_and_add_path(far_path, low_odds_paths, fallback_paths))
        {
            debug_str = "Added a Chase Path using the Far Path";
            /# PrintLn(debug_str); #/
        }
        else
        {
            debug_str = "Failed to add a Chase Path using the Far Path";
            /# PrintLn(debug_str); #/
        }
    }
}

function chase_create_and_add_path(path, &paths, &fallback_paths)
{
    if(isdefined(path) && path.size > CHASE_MIN_SIZE)
    {
        spawn_room = path[0];
        spawn_point = level array::random(level.cloak_spawns[spawn_room.name]);
        debug_str = "Creating Chase Path (Spawn -- " + path[0].name + "):";
        /# PrintLn(debug_str); #/

        chase_path = [];
        for(i = 1; i < path.size; i++)
        {
            debug_str = path[i].name;
            /# PrintLn(debug_str); #/
            chase_path[i-1] = path[i];
        }

        self add_cloak_path("Chase", spawn_point, chase_path, paths, fallback_paths);
        return true;
    }
    return false;
}

function interception_check(close_path, close_dir, gen_cloak_room, &low_odds_paths, &fallback_paths)
{
    if(! isdefined(close_path))
    {
        debug_str = "Failed to add an Interception Path, no Close Path defined";
        /# PrintLn(debug_str); #/
        return;
    }
    if(close_path.size < INTERCEPTION_MIN_SIZE || close_path.size > INTERCEPTION_MAX_SIZE)
    {
        debug_str = "Failed to add an Interception Path, Close Path size out of acceptable bounds";
        /# PrintLn(debug_str); #/
        return;
    }

    forward_path = undefined;
    backward_path = undefined;

    // Special cases if we are in the strictly linear part of the map
    override_dir = level interception_override_dir(close_path);
    if(IS_EQUAL(override_dir, PATH_DIR_FORWARD))
    {
        forward_path = gen_cloak_room interception_create_path(PATH_DIR_LEFT);
        backward_path = gen_cloak_room interception_create_path(PATH_DIR_RIGHT);
    }
    else if(IS_EQUAL(override_dir, PATH_DIR_BACKWARD))
    {
        backward_path = gen_cloak_room interception_create_path(close_dir, PATH_DIR_BACKWARD);
    }
    else
    {
        forward_path = gen_cloak_room interception_create_path(close_dir);
        backward_path = gen_cloak_room interception_create_path(close_dir, PATH_DIR_BACKWARD);
    }

    if(isdefined(forward_path) && isdefined(backward_path) && ! level path_equal(forward_path, backward_path))
    {
        debug_str = "Added Interception Paths (Forward and Backward)";
        /# PrintLn(debug_str); #/
        self add_cloak_path("Interception", forward_path[0], forward_path[1], low_odds_paths, fallback_paths);
        self add_cloak_path("Interception", backward_path[0], backward_path[1], low_odds_paths, fallback_paths);
    }
    else if(level path_equal(forward_path, backward_path))
    {
        debug_str = "Added an Interception Path (Forward = Backward)";
        /# PrintLn(debug_str); #/
        self add_cloak_path("Interception", forward_path[0], forward_path[1], low_odds_paths, fallback_paths);
    }
    else
    {
        if(isdefined(forward_path))
        {
            debug_str = "Added an Interception Path (Forward)";
            /# PrintLn(debug_str); #/
            self add_cloak_path("Interception", forward_path[0], forward_path[1], low_odds_paths, fallback_paths);
        }
        if(isdefined(backward_path))
        {
            debug_str = "Added an Interception Path (Backward)";
            /# PrintLn(debug_str); #/
            self add_cloak_path("Interception", backward_path[0], backward_path[1], low_odds_paths, fallback_paths);
        }
        if(! isdefined(forward_path) && ! isdefined(backward_path))
        {
            debug_str = "Failed to add any Interception Paths";
            /# PrintLn(debug_str); #/
        }
    }
}

function interception_create_path(path_dir, override_dir=PATH_DIR_FORWARD, num_rooms=INTERCEPTION_SPAWN_ROOMS, allow_incomplete=false)
{
    path = array(self);
    cur_cloak_room = self;

    for(i = 0; i < num_rooms; i++)
    {
        cur_cloak_room = cur_cloak_room path_step(path_dir, override_dir);
        if(! isdefined(cur_cloak_room))
        {
            if(! allow_incomplete)
            {
                return undefined;
            }
            break;
        }
        path[path.size] = cur_cloak_room;
        if(! level is_path_open(path))
        {
            if(! allow_incomplete)
            {
                return undefined;
            }
            path = level array::clamp_size(path, path.size - 1);
            break;
        }
    }

    spawn_room = path[path.size - 1];
    spawn_point = level array::random(level.cloak_spawns[spawn_room.name]);
    path = level array::clamp_size(path, path.size - 1);
    path = level array::reverse(path);

    if(! allow_incomplete)
    {
        debug_str = "Creating Interception Path (Spawn -- " + spawn_room.name + "): ";
        /# PrintLn(debug_str); #/
    }
    else
    {
        debug_str = "Creating Contingency Path (Spawn -- " + spawn_room.name + "): ";
        /# PrintLn(debug_str); #/
    }

    foreach(room in path)
    {
        debug_str = room.name;
        /# PrintLn(debug_str); #/
    }

    return array(spawn_point, path);
}

function interception_override_dir(&path)
{
    foreach(room in path)
    {
        if(! (isdefined(room.backward) || isdefined(room.forward)))
        {
            return undefined;
        }
    }

    if(isdefined(path[0].forward) && path[0].forward cloak_room_equal(path[1]))
    {
        return PATH_DIR_FORWARD;
    }

    return PATH_DIR_BACKWARD;
}

function contingency_create_path(gen_cloak_room)
{
    lf_path = gen_cloak_room interception_create_path(PATH_DIR_LEFT, PATH_DIR_FORWARD, CONTINGENCY_SPAWN_ROOMS, true);
    lb_path = gen_cloak_room interception_create_path(PATH_DIR_LEFT, PATH_DIR_BACKWARD, CONTINGENCY_SPAWN_ROOMS, true);
    rf_path = gen_cloak_room interception_create_path(PATH_DIR_RIGHT, PATH_DIR_FORWARD, CONTINGENCY_SPAWN_ROOMS, true);
    rb_path = gen_cloak_room interception_create_path(PATH_DIR_RIGHT, PATH_DIR_BACKWARD, CONTINGENCY_SPAWN_ROOMS, true);
    
    paths = array(lf_path, lb_path, rf_path, rb_path);
    paths = level array::randomize(paths);
    path_ret = paths[0];
    foreach(path in paths)
    {
        if(path[1].size > path_ret[1].size)
        {
            path_ret = path;
        }
    }

    return CloakPathInfo_init("Contingency", undefined, path_ret[0], path_ret[1]);
}

function escargot_spawn_logic()
{
    escargot_spawn_points = [];

    foreach(player in level.players)
    {
        if(! level zm_utility::is_player_valid(player))
        {
            continue;
        }
        player escargot_spawn_logic_player(escargot_spawn_points);
    }

    spawn_point = level array::random(escargot_spawn_points);
    
    level zm_ai_shadowpeople::escargot_spawn(spawn_point);
}

function escargot_spawn_logic_player(&escargot_spawn_points)
{
    player_cloak_room = self get_ent_cloak_room();
    if(! isdefined(player_cloak_room))
    {
        return;
    }

    player_cloak_room escargot_add_spawns(player_cloak_room.forward, escargot_spawn_points);
    player_cloak_room escargot_add_spawns(player_cloak_room.backward, escargot_spawn_points);
    player_cloak_room escargot_add_spawns(player_cloak_room.left, escargot_spawn_points);
    player_cloak_room escargot_add_spawns(player_cloak_room.right, escargot_spawn_points);
}

function escargot_add_spawns(cloak_room, &escargot_spawn_points)
{
    path = array(self, cloak_room);
    if(! (isdefined(cloak_room) && level is_path_open(path)))
    {
        return;
    }

    spawn_points = level.cloak_spawns[cloak_room.name];

    foreach(spawn_point in spawn_points)
    {
        level array::add(escargot_spawn_points, spawn_point);
    }
}

function is_path_open(&path)
{
    prev_room = undefined;
    foreach(room in path)
    {
        if(isdefined(prev_room) && ! level flag::get(room.connected_flags[prev_room.name]))
        {
            return false;
        }
        prev_room = room;
    }
    return true;
}

function path_step(path_dir, override_dir=PATH_DIR_FORWARD)
{
    if(override_dir == PATH_DIR_BACKWARD && isdefined(self.backward))
    {
        return self.backward;
    }
    else if(override_dir == PATH_DIR_FORWARD && isdefined(self.forward))
    {
        return self.forward;
    }
    else if((path_dir == PATH_DIR_LEFT) && isdefined(self.left))
    {
        return self.left;
    }
    else if((path_dir == PATH_DIR_RIGHT) && isdefined(self.right))
    {
        return self.right;
    }
    else
    {
        return undefined;
    }
}

function find_path(dest_cloak_room, path_dir)
{
    path = [];
    cur_cloak_room = self;
    
    while(! cur_cloak_room cloak_room_equal(dest_cloak_room))
    {
        if(dest_cloak_room.name == "Staminarch") // Special Case
        {
            cur_cloak_room = cur_cloak_room path_step(path_dir, PATH_DIR_BACKWARD);
        }
        else
        {
            cur_cloak_room = cur_cloak_room path_step(path_dir);
        }
        if(! isdefined(cur_cloak_room))
        {
            debug_str = "Cannot find path [path_dir = " + path_dir + ", dest_cloak_room = " + dest_cloak_room.name + "]";
            /# PrintLn(debug_str); #/
            return undefined;
        }
        path[path.size] = cur_cloak_room;
    }

    if(! level is_path_open(path))
    {
        return undefined;
    }

    return path;
}

function path_equal(path1, path2)
{
    if(! (isdefined(path1) && isdefined(path2)))
    {
        return false;
    }
    if(path1.size != path2.size)
    {
        return false;
    }

    for(i = 0; i < path1.size; i++)
    {
        if(! path1[i] cloak_room_equal(path2[i]))
        {
            return false;
        }
    }

    return true;
}

function find_paths(dest_cloak_room)
{
    left_path = self find_path(dest_cloak_room, PATH_DIR_LEFT);
    right_path = self find_path(dest_cloak_room, PATH_DIR_RIGHT);

    close_path = undefined;
    far_path = undefined;
    close_dir = undefined;
    far_dir = undefined;

    if(isdefined(left_path) && isdefined(right_path))
    {
        debug_str = "Left and right paths found";
        /# PrintLn(debug_str); #/
        close_path = left_path;
        far_path = right_path;
        close_dir = PATH_DIR_RIGHT;
        far_dir = PATH_DIR_LEFT;
        
        if(left_path.size > right_path.size)
        {
            close_path = right_path;
            far_path = left_path;
            close_dir = PATH_DIR_LEFT;
            far_dir = PATH_DIR_RIGHT;
        }
    }
    else if(! isdefined(left_path))
    {
        close_path = right_path;
        close_dir = PATH_DIR_RIGHT;
    }
    else if(! isdefined(right_path))
    {
        close_path = left_path;
        close_dir = PATH_DIR_LEFT;
    }

    return array(close_path, far_path, close_dir, far_dir);
}

function players_on_path(&path)
{
    foreach(player in level.players)
    {
        if(player == self)
        {
            continue;
        }
        foreach(cloak_room in path)
        {
            player_cloak_room = player get_ent_cloak_room();
            if(player_cloak_room cloak_room_equal(cloak_room))
            {
                return true;
            }
        }
    }

    return false;
}

function add_cloak_path(name, spawn_point, &path, &paths, &fallback_paths, use_fallback=true)
{
    path_info = CloakPathInfo_init(name, self, spawn_point, path);
    if(use_fallback && self players_on_path(path))
    {
        fallback_paths[fallback_paths.size] = path_info;
    }
    else
    {
        paths[paths.size] = path_info;
    }
}

function get_ent_cloak_room(ignore_enabled_check=false)
{
    foreach(room_name in GetArrayKeys(level.cloak_rooms))
    {
        if(self zm_room_manager::is_player_in_room(level.abbey_rooms[room_name], ignore_enabled_check))
        {
            return level.cloak_rooms[room_name];
        }
    }

    return undefined;
}
