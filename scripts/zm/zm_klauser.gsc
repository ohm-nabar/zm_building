#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

#precache( "fx", "zombie/fx_trap_green_light_doa" );
	
function main()
{
    callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );
	zm::register_player_damage_callback ( &player_damage_adjustment );
}

function on_player_connect()
{
	self.just_revived_no_splash = false;
	self thread monitor_klauser_fired();
}

function player_damage_adjustment(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(self.just_revived_no_splash)
	{
		switch(sMeansOfDeath)
		{
			case "MOD_BURNED":
			case "MOD_ELECTOCUTED":
			case "MOD_EXPLOSIVE":
			case "MOD_EXPLOSIVE_SPLASH":
			case "MOD_FALLING":
			case "MOD_GRENADE":
			case "MOD_GRENADE_SPLASH":
			case "MOD_IMPACT":
			case "MOD_SUICIDE":
				return 0;
			default:
				break;
		}

		if(isdefined(weapon))
		{
			switch(weapon.name)
			{
				case "s4_klauser_up":
				case "s4_1911_rdw_up":
				case "s4_1911_ldw_up":
				case "zm_diedrich":
				case "zm_diedrich_upgraded":
					return 0;
				default:
					break;
			}
		}
	}

	return -1;
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

function on_laststand()
{
	self endon("disconnect");

	self.just_revived_no_splash = true;
	result = self util::waittill_any_return("player_revived", "bled_out");
	
	if(result == "player_revived")
	{
		wait(2);
	}
	
	self.just_revived_no_splash = false;
}