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

#insert scripts\shared\shared.gsh;

#precache( "fx", "custom/fx_zmb_shadow_explode" );

function main() 
{
	level.abbey_diedrich = GetWeapon( "zm_diedrich" );
    level.abbey_diedrich_upgraded = GetWeapon( "zm_diedrich_upgraded" );

    level.diedrich_radius = 150;
    level.diedrich_radius_upgraded = 200;

    level.diedrich_min_damage = 500;
    level.diedrich_max_damage = 2000;

    level.diedrich_min_damage_upgraded = 500;
    level.diedrich_max_damage_upgraded = 3000;

	level.audio_get_mod_type = &get_mod_type;

    zm::register_zombie_damage_override_callback( &zombie_damage_override );
	callback::on_connect( &on_player_connect );
    //zm::register_actor_damage_callback( &damage_adjustment );
	
}

function on_player_connect()
{
	self thread monitor_diedrich_used();
}


function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( weapon == level.abbey_diedrich && meansofdeath == "MOD_PROJECTILE" )
	{
		self thread diedrich_think(false, attacker);
	}
	else if ( weapon == level.abbey_diedrich_upgraded && meansofdeath == "MOD_PROJECTILE" )
	{
		self thread diedrich_think(true, attacker);
	}
}

function get_mod_type( impact, mod, weapon, zombie, instakill, dist, player )
{
	close_dist = 64 * 64;
	med_dist = 124 * 124;
	far_dist = 400 * 400;
	
	if( weapon.name == "hero_annihilator" )
	{
		return "annihilator";
	}
	
	if( zm_utility::is_placeable_mine( weapon ) )
	{
	    if( !instakill )
	        return "betty";
	    else
	        return "weapon_instakill";
	}
	
	if ( zombie.damageweapon.name ==  "cymbal_monkey" )
	{
		if(instakill)
			return "weapon_instakill";
		else
			return "monkey";
	}
	
	//RAYGUN & RAYGUN_INSTAKILL
	if( weapon.name == "zm_diedrich" || weapon.name == "zm_diedrich_upgraded" && dist > far_dist )
	{
		if( !instakill )
			return "raygun";
		else
			return "weapon_instakill";
	}
	
	//HEADSHOT
	if( zm_utility::is_headshot(weapon,impact,mod) && dist >= far_dist )
	{
		return "headshot";
	}	
	
	//MELEE & MELEE_INSTAKILL
	if ( (mod == "MOD_MELEE" || mod == "MOD_UNKNOWN") && dist < close_dist )
	{
		if( !instakill )
			return "melee";
		else
			return "melee_instakill";
	}
	
	//EXPLOSIVE & EXPLOSIVE_INSTAKILL
	if( zm_utility::is_explosive_damage( mod ) && weapon.name != "ray_gun" && !IS_TRUE(zombie.is_on_fire) )
	{
		if( !instakill )
			return "explosive";
		else
			return "weapon_instakill";
	}
	
	//FLAME & FLAME_INSTAKILL
	if( weapon.doesFireDamage && ( mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" ) )
	{
		if( !instakill )
			return "flame";
		else
			return "weapon_instakill";
	}
		
	if (!isdefined(impact))
		impact = "";
	
	//BULLET & BULLET_INSTAKILL
	if( mod == "MOD_RIFLE_BULLET" ||   mod == "MOD_PISTOL_BULLET" )
	{
		if( !instakill )
			return "bullet";
		else
			return "weapon_instakill";
	}
	
	if(instakill)
	{
		return "default";
	}
	
	//CRAWLER
	if( mod != "MOD_MELEE" && zombie.missingLegs )
	{
		return "crawler";
	}
	
	//CLOSEKILL
	if( mod != "MOD_BURNED" && dist < close_dist  )
	{
		return "close";
	}
	
	return "default";
}

function monitor_diedrich_used()
{
	self endon( "disconnect" );
	
	while (true)
	{
		weapon = self GetCurrentWeapon();
		if ( self IsFiring() && ! self IsMeleeing() && (weapon == level.abbey_diedrich || weapon == level.abbey_diedrich_upgraded) )
		{
			alias_name = "diedrich_shot" + RandomIntRange(1, 4);
			self PlaySoundOnTag(alias_name, "tag_weapon_right");
			while (self IsFiring())
			{
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

function diedrich_think(isUpgraded, player)
{
	//IPrintLn("diedrich_shot");

	alias_name = "diedrich_explos" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	PlayFX("custom/fx_zmb_shadow_explode", self.origin);

	weapon = (isUpgraded ? level.abbey_diedrich_upgraded : level.abbey_diedrich);
	radius = (isUpgraded ? level.diedrich_radius_upgraded : level.diedrich_radius); 
	max_damage = (isUpgraded ? level.diedrich_max_damage_upgraded : level.diedrich_max_damage);
	min_damage = (isUpgraded ? level.diedrich_min_damage_upgraded : level.diedrich_min_damage);

	player_min_damage = 10;
	player_max_damage = 200;
	player_splash_radius = 150;

	//GrenadeExplosionEffect(self.origin);

	zombies = GetAITeamArray( "axis" );

	playerdist = Distance(self.origin, player.origin);

	//IPrintLn(playerdist);

	if( playerdist <= player_splash_radius )
	{
		playerslope = (player_min_damage - player_max_damage) / (player_splash_radius - 30);
		playerdamage = playerslope * (playerdist - 30) + player_max_damage;
		player DoDamage( playerdamage, player.origin + (0,0,20), player, player, "none", "MOD_EXPLOSIVE", 0, weapon ) ;
	}

	a_zombies = zombie_utility::get_round_enemy_array();
	a_zombies = util::get_array_of_closest( self.origin, a_zombies, undefined, undefined, radius );

	slope = (min_damage - max_damage) / radius;

	foreach( zombie in a_zombies ) 
	{
		distance = Distance(self.origin, zombie.origin);

		damage = slope * distance + max_damage;

		//IPrintLn(damage);

		zombie DoDamage(damage, player.origin, player, player, "none", "MOD_EXPLOSIVE", 0, weapon );

	}

}

/*
function diedrich_death(player)
{
	if( IS_TRUE(self.in_diedrich_death) ) 
	{
		return;
	}

	self.in_diedrich_death = true;

	//IPrintLn("died from diedrich");
	//play death fx
	self.zombie_tesla_hit = true;		
	self.ignoreall = true;

	wait(1);

	self.zombie_tesla_hit = false;
	self.ignoreall = false;
	self DoDamage(self.health + 666, player.origin, player);
}
*/