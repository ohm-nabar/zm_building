#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_utility;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\scene_shared;
#using scripts\zm\_zm_spawner;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

function main()
{
    //callback::on_connect( &on_player_connect );
	level.maze_step_count = 0;
	maze_think();
}

//function on_player_connect(){}

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
	for(i = 0; i < 9; i++)
	{
		array::add(level.maze_node_neighbors, []);
		array::add(level.maze_node_assigned, false);
	}

	create_edge(0, 1);
	create_edge(0, 3);
	create_edge(1, 2);
	create_edge(1, 4);
	create_edge(2, 5);
	create_edge(3, 4);
	create_edge(3, 6);
	create_edge(4, 5);
	create_edge(4, 7);
	create_edge(5, 8);
	create_edge(6, 7);
	create_edge(7, 8);
}

function create_edge(index1, index2)
{
	array::add(level.maze_node_neighbors[index1], index2);
	array::add(level.maze_node_neighbors[index2], index1);
}

function maze_think()
{
	player1 = level.players[0];
	while( ! ( isdefined(level.players) && isdefined(level.players[0]) && level.players[0] MeleeButtonPressed() ) )
	{
		player1 = level.players[0];
		wait(0.05);
	}
	
	create_walls();
	create_nodes();

	level.maze_debug_text = "starting maze generation!\n";
	player1 = level.players[0];
	player1.maze_debug = NewClientHudElem(player1);
	player1.maze_debug.alignX = "center";
	player1.maze_debug.alignY = "top";
	player1.maze_debug.horzAlign = "center";
	player1.maze_debug.vertAlign = "top";
	player1.maze_debug.fontscale = 2;
	player1.maze_debug.alpha = 1;
	player1.maze_debug.color = (1,1,1);
	player1.maze_debug.hidewheninmenu = true;
	player1.maze_debug SetText(level.maze_debug_text);

	cur_node = 0;
	level.maze_node_assigned[0] = true;

	neighbor = random_unassigned_neighbor(0);

	while(! player1 MeleeButtonPressed())
	{
		wait(0.05);
	}

	while(isdefined(neighbor))
	{
		break_wall(cur_node, neighbor);
		level.maze_node_assigned[neighbor] = true;
		cur_node = neighbor;
		neighbor = random_unassigned_neighbor(cur_node);
		wait(3);
		while(! player1 MeleeButtonPressed())
		{
			wait(0.05);
		}
	}

	level.maze_debug_text = "maze generated!";
	player1.maze_debug SetText(level.maze_debug_text);
}

function random_unassigned_neighbor(node)
{
	unassigned_neighbors = filter_unassigned(level.maze_node_neighbors[node]);
	
	level.maze_debug_text = "step " + level.maze_step_count + " (" + node + ")\n";
	level.maze_debug_text += "UAs - ";
	level.maze_step_count++;
	foreach(node in unassigned_neighbors)
	{
		unassigned_str = (level.maze_node_assigned[node] ? "A " : "UA ");
		level.maze_debug_text += "node " + node + ": " + unassigned_str;
	}
	level.maze_debug_text += "\n";
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
	level.maze_debug_text += "breaking wall [node " + node1 + ", " + node2 + "]\n";
	player1 = level.players[0];
	player1.maze_debug SetText(level.maze_debug_text);

	key = Min(node1, node2) + "" + Max(node1, node2);
	wall = level.shadow_maze_walls[key];
	level.maze_debug_text += "breaking wall " + wall.targetname + ", " + wall.script_string + "\n";
	wall MoveZ(-1000, 1);
}

function wall_index_lookup(sum_of_nodes)
{
	// this is gonna seem like random math but it's based off patterns
	// and is applicable to any n*n fully connected graph structured like ours
	if(sum_of_nodes % 2 == 0)
	{
		return (sum_of_nodes / 2) + 10;
	}

	coefficient = Int(sum_of_nodes / 8) + 1;
	return ((sum_of_nodes + 1) / 2) - coefficient;
}