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
#using scripts\zm\_zm_perk_electric_cherry;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

#precache( "fx", "zombie/fx_trap_green_light_doa" );
	
function main()
{
    callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	//self EnableInvulnerability();

	self thread monitor_klauser_fired();
	//self thread display_trident_power_level();
	//self thread testeroo();
}

//from Harry Bo21's staff code
function monitor_klauser_fired()
{
	self endon( "disconnect" );
	
	while ( 1 )
	{
		self waittill( "missile_fire", e_projectile, str_weapon );
		if ( str_weapon != GetWeapon("s4_klauser_up") )
		{
			continue;
		}
		PlayFXOnTag("zombie/fx_trap_green_light_doa", e_projectile, "tag_origin");		
	
	}
}



function testeroo()
{
	//self thread testerootoo();
	while(true) 
	{
		IPrintLn(self IsMeleeing());
		wait(0.5);
	}
}

function testerootoo()
{
	level waittill("start_of_round");
	wait(30);
	self SetMoveSpeedScale(0);
}