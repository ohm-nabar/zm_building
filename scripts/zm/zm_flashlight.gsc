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

REGISTER_SYSTEM_EX("zm_flashlight", &__init__, undefined, undefined)

function __init__()
{
	callback::on_connect(&on_player_connect);
	thread clientfield_init();
}

function on_player_connect()
{
	self thread disconnect_watch();
}

function clientfield_init()
{
	clientfield::register("toplayer", "flashlight_fx_view", VERSION_SHIP, 2, "int");
	clientfield::register("allplayers", "flashlight_fx_world", VERSION_SHIP, 2, "int");
}

function disconnect_watch()
{
	self waittill("disconnect");

	self flashlight_state(0);
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
		//self clientfield::set("flashlight_fx_world", 0);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 0;
	}
	else if(state == 1)
	{
		self clientfield::set_to_player("flashlight_fx_view", 1);
		//self clientfield::set("flashlight_fx_world", 1);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 1;
	}
	else if(state == 2)
	{
		self clientfield::set_to_player("flashlight_fx_view", 2);
		//self clientfield::set("flashlight_fx_world", 2);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 2;
	}
	else if(state == 3)
	{
		self clientfield::set_to_player("flashlight_fx_view", 3);
		//self clientfield::set("flashlight_fx_world", 1);
		self PlaySound("1_flashlight_click");
		self.flashlight_state = 3;
	}
}