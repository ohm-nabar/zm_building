#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\aat_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_behavior_utility;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_puppet;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_zonemgr;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_weap_riotshield;

#insert scripts\zm\craftables\_zm_craftables.gsh;
#using scripts\zm\craftables\_zm_craftables;

#insert scripts\zm\_zm_utility.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\shared\ai\zombie.gsh;
#insert scripts\shared\ai\systems\gib.gsh;
#insert scripts\zm\_zm.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_traps.gsh;

#namespace zm_sphynx_util;

#precache( "material", "robit_hitmarker" );
#precache( "material", "robit_hitmarker_death" );

REGISTER_SYSTEM( "zm_sphynx_util", &__init__, undefined )

function __init__()
{

}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::change_delay_between_rounds( <time_in_seconds> )"
"Summary: Change the delay between rounds"
"Module: Util"
"Example: zm_sphynx_util::change_delay_between_rounds( 0.1 );"
@/
function change_delay_between_rounds( wait_for_seconds ){
    level.zombie_vars["zombie_between_round_time"] = wait_for_seconds;
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::add_weapon_to_random_box_rotation( <weapon_name> )"
"Summary: Adds the weapon into the box midgame"
"Module: Util"
"Example: zm_sphynx_util::add_weapon_to_random_box_rotation( "smg_fastfire" );"
@/
function add_weapon_to_random_box_rotation( weapon_name ){
    level.zombie_weapons[ getWeapon( weapon_name ) ].is_in_box = 1;
}

/@
"Author: HarryBo21"
"Name: zm_sphynx_util::enable_player_voice_lines()"
"Summary: Enables player voice lines [Der Eisendrache]"
"Module: Util"
"Example: zm_sphynx_util::enable_player_voice_lines();"
@/
function enable_player_voice_lines()
{
    zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_castle_vox.csv");
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::play_sound_randomized_wait( <sound_alias>, <timer_minimal>, <timer_maximal>, <stop_notify> )"
"Summary: Plays a sound/alias and randomly waits between two given times, can be stopped by a notify"
"Module: Util"
"Example: zm_sphynx_util::play_sound_randomized_wait( "quest_complete", 12, 14, "stop_randomized_sound" );"
@/
function play_sound_randomized_wait( soundAlias, timeMin, timeMax, stopNotify ){
    self endon(stopNotify);

    while(isdefined(self)){
        PlaySoundAtPosition( soundAlias, self.origin);
        wait RandomIntRange(timeMin, timeMax);
    }   
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::zombie_health_cap( <round_cap> )"
"Summary: Stops health increase for zombies after specified round"
"Module: Util"
"Example: zm_sphynx_util::zombie_health_cap( 65 );"
@/
function zombie_health_cap( round_cap )
{
    level endon( "end_game" );
    while ( 1 )
    {
        level waittill( "start_of_round" );
        if ( level.round_number >= round_cap )
            break;
        
    }
    zombie_utility::set_zombie_var( "zombie_health_increase_multiplier", 0, 1, 2 );
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::zombie_limit_increase( <base_limit>, <increase_by> )"
"Summary: Increases zombie limit foreach player added"
"Module: Util"
"Example: zm_sphynx_util::zombie_limit_increase( 24, 8 );"
@/
function zombie_limit_increase( base_limit, increase_by )
{
    level endon( "end_game" );
    while ( isdefined( self ) )
    {
        level waittill( "start_of_round" );
        
        level.zombie_actor_limit = base_limit + (increase_by * GetPlayers().size);
        level.zombie_ai_limit = base_limit + (increase_by * GetPlayers().size);
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::black_ops_4_carpenter()"
"Summary: Enables Black Ops 4 Carpenter [Refills shield]"
"Module: Util"
"Example: zm_sphynx_util::black_ops_4_carpenter();"
@/
function black_ops_4_carpenter(){
    callback::on_spawned( &watch_carpenter_repair );
}

//BO4 Carpenter
function watch_carpenter_repair()
{
    self endon("bled_out");
    self endon("spawned_player");
    self endon("disconnect");
    for(;;){
        level waittill( "carpenter_finished" );
        foreach(weapon in self GetWeaponsList(1))
        {
            if(isdefined(weapon.isriotshield) && weapon.isriotshield)
            {
                self GiveMaxAmmo( weapon );
                self riotshield::player_damage_shield( -weapon.weaponstarthitpoints );
            }
        }
    }
}

/@
"Author: Serious"
"Name: zm_sphynx_util::black_ops_4_ammo()"
"Summary: Enables Black Ops 4 ammo [Refills clip]"
"Module: Util"
"Example: zm_sphynx_util::black_ops_4_ammo();"
@/
function black_ops_4_ammo(){
    callback::on_spawned( &watch_max_ammo );
}

function watch_max_ammo(){
    self endon("bled_out");
    self endon("spawned_player");
    self endon("disconnect");
    for(;;){
        self waittill("zmb_max_ammo");
        foreach(weapon in self GetWeaponsList(1))
        {
            if(isdefined(weapon.clipsize) && weapon.clipsize > 0)
            {
                self SetWeaponAmmoClip(weapon, weapon.clipsize);
            }
        }
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::enable_bo4_zombie_hitmarkers()"
"Summary: Enables Black Ops 4 Hitmarkers [Do NOT enable both hitmarkers]"
"Module: Util"
"Example: zm_sphynx_util::enable_bo4_zombie_hitmarkers();"
@/
function enable_bo4_zombie_hitmarkers(){
    callback::on_spawned( &enable_player_hitmarkers );

    zm_spawner::register_zombie_damage_callback( &hitmarker_bo4_damage ); 
    zm_spawner::register_zombie_death_event_callback( &hitmarker_bo4_death ); 
}

function hitmarker_bo4_damage(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
    w_damage = zm_weapons::get_nonalternate_weapon( weapon );
    weaponClass = util::getWeaponClass( w_damage );

    if( hit_location == "helmet" && weaponClass == "weapon_sniper")
    {
        player PlayLocalSound( "mp_hit_indication_3d" );  
    }

    if(IS_TRUE(player.uses_hitmarkers)){
        player PlayLocalSound( "zmb_death_gibs" );

        if(level.zombie_vars[player.team]["zombie_insta_kill"] == 1)
        {
            player PlayLocalSound( "mp_hit_indication_3d" );
            player.waithitdeath = true;
            player.hud_damagefeedback.alpha = 0;
            player.hud_damagefeedback.x = 0;
            player.hud_damagefeedback.y = 0;
            player.hud_damagefeedback.alignX = "center";
            player.hud_damagefeedback.alignY = "middle";
            player.hud_damagefeedback.horzAlign = "center";
            player.hud_damagefeedback.vertAlign = "middle";
            player.hud_damagefeedback setShader( "robit_hitmarker_death", 56, 56 );
            player.hud_damagefeedback.color = ( 1, 1, 1 );
            player.hud_damagefeedback.alpha = 1; 
            player.hud_damagefeedback ScaleOverTime(0.2,32,32);
            wait 0.8;
            player.hud_damagefeedback fadeOverTime(0.2);
            player.hud_damagefeedback.alpha = 0;
            player.waithitdeath = false;
        }
        else if(player.waithitdeath != true)
        { 
            player.hud_damagefeedback.alpha = 0;
            player.hud_damagefeedback.x = 0;
            player.hud_damagefeedback.y = 0;
            player.hud_damagefeedback.alignX = "center";
            player.hud_damagefeedback.alignY = "middle";
            player.hud_damagefeedback.horzAlign = "center";
            player.hud_damagefeedback.vertAlign = "middle";
            player.hud_damagefeedback setShader( "robit_hitmarker", 32, 32 );
            player.hud_damagefeedback.color = ( 1, 1, 1 );
            player.hud_damagefeedback.alpha = 1; 
            wait 0.8;
            player.hud_damagefeedback fadeOverTime(0.4);
            player.hud_damagefeedback.alpha = 0; 
            player.waithitdeath = false;
        }
    }

    return false;
}

function hitmarker_bo4_death(player)
{
    str_damagemod = self.damagemod;
    w_damage = self.damageweapon;
    w_damage = zm_weapons::get_nonalternate_weapon( w_damage );
    weaponClass = util::getWeaponClass( w_damage );

    if( zm_utility::is_headshot( w_damage, self.damagelocation, str_damagemod) && weaponClass == "weapon_sniper")
    {
        self PlayLocalSound( "mp_hit_indication_3d" );  
    }

    if(IS_TRUE(player.uses_hitmarkers)){
        player PlayLocalSound( "mp_hit_indication_3d" );
        player.waithitdeath = true;
        player.hud_damagefeedback.alpha = 0;
        player.hud_damagefeedback.x = 0;
        player.hud_damagefeedback.y = 0;
        player.hud_damagefeedback.alignX = "center";
        player.hud_damagefeedback.alignY = "middle";
        player.hud_damagefeedback.horzAlign = "center";
        player.hud_damagefeedback.vertAlign = "middle";
        player.hud_damagefeedback setShader( "robit_hitmarker_death", 56, 56 );
        player.hud_damagefeedback.color = ( 1, 1, 1 );
        player.hud_damagefeedback.alpha = 1; 
        player.hud_damagefeedback ScaleOverTime(0.2,32,32);
        wait 0.8;
        player.hud_damagefeedback fadeOverTime(0.2);
        player.hud_damagefeedback.alpha = 0;
        player.waithitdeath = false;
    }

    return false;
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::disable_zombie_hitmarkers()"
"Summary: Enables hitmarkers"
"Module: Util"
"Example: zm_sphynx_util::disable_zombie_hitmarkers();"
@/
function disable_zombie_hitmarkers(){
    foreach(player in GetPlayers())
        player.uses_hitmarkers = false;
}

/@
"Author: Kingslayer Kyle"
"Name: zm_sphynx_util::enable_original_zombie_hitmarkers()"
"Summary: Enables hitmarkers"
"Module: Util"
"Example: zm_sphynx_util::enable_original_zombie_hitmarkers();"
@/
function enable_original_zombie_hitmarkers( alias ){
    callback::on_spawned( &enable_player_hitmarkers );

    if(isdefined(alias) && alias != undefined)
        level.hitmarker_sound = alias;

    zm::register_zombie_damage_override_callback( &hit_markers );
}

function enable_player_hitmarkers(){
    self endon("bled_out");
    self endon("spawned_player");
    self endon("disconnect");

    self.uses_hitmarkers = true;
}

function show_hit_marker( death )  // self = player
{
    if ( IsDefined( self ) && IsDefined( self.hud_damagefeedback ) )
    {
        if( IS_TRUE( death ) )
        {
            self.hud_damagefeedback SetShader( "damage_feedback_glow_orange", 24, 48 );
        }
        else
        {
            self.hud_damagefeedback SetShader( "damage_feedback", 24, 48 );
        }

        if(isdefined(level.hitmarker_sound) && level.hitmarker_sound != undefined)
            self PlaySoundToPlayer(level.hitmarker_sound, self);

        self.hud_damagefeedback.alpha = 1;
        self.hud_damagefeedback FadeOverTime(1);
        self.hud_damagefeedback.alpha = 0;
    }    
}

function hit_markers( death, inflictor, attacker, damage, flags, mod, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
    if( isdefined( attacker ) && IsPlayer( attacker ) )
    {
        if(IS_TRUE(attacker.uses_hitmarkers))
            attacker show_hit_marker( death );
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::register_new_equipment( <equipment>, <hint_text>, <howto_text>, <equipment_name> )"
"Summary: Register new equipment"
"Module: Util"
"Example: zm_sphynx_util::register_new_equipment( "brazen_bull_shield", "", "" );"
@/
function register_new_equipment( equipment, hint_text, howto_text, equipment_name ){
    zm_equipment::register( equipment, hint_text, howto_text, undefined, equipment_name );

    zm_equipment::register_for_level( equipment );
    zm_equipment::include( equipment );
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::easy_easter_egg_song( <targetname>, <confirmAudio>, <musicAudio>, <loopSound> )"
"Summary: Easy enable a music easter egg using models"
"Module: Util"
"Example: zm_sphynx_util::easy_easter_egg_song( "targetname_model", undefined, "music_ee", undefined );"
"Example: zm_sphynx_util::easy_easter_egg_song( "targetname_model", "meteor_affirm", "music_ee", "115_loop" );"
@/
function easy_easter_egg_song( targetname, confirmAudio, musicAudio, loopSound ){
    while(true){
        array::thread_all( GetEntArray(targetname, "targetname"), &ee_song_func, confirmAudio, loopSound);
        level.ee_song_activated = 0;

        while(level.ee_song_activated < GetEntArray(targetname, "targetname").size)
            wait 1;

        foreach(player in GetPlayers())
            player PlaySoundToPlayer(musicAudio, player);

        wait 200;
    }
}

function ee_song_func(confirmAudio, loopSound){
    self.a_trigger = spawn_regular_trigger("", "trigger_radius_use", self.origin, 40, 80);

    if(isdefined(loopSound))
        self PlayLoopSound(loopSound);

    while(isdefined(self)){
        self.a_trigger waittill("trigger", player);

        if(isdefined(confirmAudio))
            PlaySoundAtPosition(confirmAudio, self.a_trigger.origin);

        self StopLoopSound(2);

        level.ee_song_activated++;

        self.a_trigger Delete();
    }
}

/@
"Author: Sphynx"
"Name: entity zm_sphynx_util::check_all_players_in_radius( <distance> )"
"Summary: Check a specified trigger_multiple if all players in match are inside"
"Module: Util"
"Example: if( entity zm_sphynx_util::check_all_players_in_radius( 1500 ) )"
@/
function check_all_players_in_radius( distance ){
    j = 0;
    foreach(player in GetPlayers()){
        if(Distance(self.origin, player.origin) < distance && zm_utility::is_player_valid( player ) || !player laststand::player_is_in_laststand())
            j++;
    }

    if(j == GetPlayers().size)
        return true;
    else
    {
        return false;
    }
}

/@
"Author: Sphynx"
"Name: trig_multiple zm_sphynx_util::check_all_players_in_trigger()"
"Summary: Check a specified trigger_multiple if all players in match are inside"
"Module: Util"
"Example: if( trig_multiple zm_sphynx_util::check_all_players_in_trigger() )"
@/
function check_all_players_in_trigger(){
    j = 0;
    foreach(player in GetPlayers()){
        if(player IsTouching(self) && zm_utility::is_player_valid( player ) || !player laststand::player_is_in_laststand())
            j++;
    }

    if(j == GetPlayers().size)
        return true;
    else
    {
        return false;
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::give_player_specific_starting_weapon( <weapon_array_player_1>, <weapon_array_player_2>, <weapon_array_player_3>, <weapon_array_player_4> )"
"Summary: Change starting weapon to a random weapon"
"Module: Util"
"Example: zm_sphynx_util::give_player_specific_starting_weapon( array("smg_standard", "smg_fastfire"), array("ar_damage", "ar_accurate"), array("sniper_fastbolt", "sniper_fastsemi"), array("lmg_cqb", "lmg_heavy") );"
@/
function give_player_specific_starting_weapon( player_1_weapons_list, player_2_weapons_list, player_3_weapons_list, player_4_weapons_list ){
    level.player_specific_starting_weapon_list[0] = player_1_weapons_list;
    level.player_specific_starting_weapon_list[1] = player_2_weapons_list;
    level.player_specific_starting_weapon_list[2] = player_3_weapons_list;
    level.player_specific_starting_weapon_list[3] = player_4_weapons_list;
    level.giveCustomLoadout = &give_player_specific_start_weapon;
}

function give_player_specific_start_weapon( b_switch_weapon )
{
    DEFAULT( self.hasCompletedSuperEE, self zm_stats::get_global_stat( "DARKOPS_GENESIS_SUPER_EE" ) > 0 );
    
    if( self.hasCompletedSuperEE )
    {
        self zm_weapons::weapon_give( GetWeapon( array::random( level.player_specific_starting_weapon_list[self.characterIndex]) ), false, false, true, false );
        self GiveMaxAmmo( level.start_weapon );
        self zm_weapons::weapon_give( level.super_ee_weapon, false, false, true, b_switch_weapon );
    }
    else 
    {
        self zm_weapons::weapon_give( GetWeapon( array::random( level.player_specific_starting_weapon_list[self.characterIndex]) ), false, false, true, b_switch_weapon );
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::give_random_starting_weapon( <weapon_array> )"
"Summary: Change starting weapon to a random weapon"
"Module: Util"
"Example: zm_sphynx_util::give_random_starting_weapon( array("smg_standard", "smg_fastfire") );"
@/
function give_random_starting_weapon( weapons_list ){
    level.random_starting_weapon_list = weapons_list;
    level.giveCustomLoadout = &give_start_weapon;
}

function give_start_weapon( b_switch_weapon )
{
    DEFAULT( self.hasCompletedSuperEE, self zm_stats::get_global_stat( "DARKOPS_GENESIS_SUPER_EE" ) > 0 );
    
    if( self.hasCompletedSuperEE )
    {
        self zm_weapons::weapon_give( GetWeapon( array::random( level.random_starting_weapon_list) ), false, false, true, false );
        self GiveMaxAmmo( level.start_weapon );
        self zm_weapons::weapon_give( level.super_ee_weapon, false, false, true, b_switch_weapon );
    }
    else 
    {
        self zm_weapons::weapon_give( GetWeapon( array::random( level.random_starting_weapon_list) ) , false, false, true, b_switch_weapon );
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::change_start_weapon( <weapon_name> )"
"Summary: Change starting weapon and last stand weapon"
"Module: Util"
"Example: zm_sphynx_util::change_start_weapon( "smg_standard" );"
@/
function change_start_weapon( weapon ){
    level.start_weapon = GetWeapon(weapon);
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::change_last_stand_weapon( <weapon_name> )"
"Summary: Change starting weapon and last stand weapon"
"Module: Util"
"Example: zm_sphynx_util::change_last_stand_weapon( "smg_standard" );"
@/
function change_last_stand_weapon( weapon ){
    level.default_laststandpistol             = getWeapon( weapon ); // The one you get if you go down in co-op and didnt have another pistol
    level.default_solo_laststandpistol        = getWeapon( weapon ); // The one you get with quickrevive in solo
    level.laststandpistol                     = level.default_laststandpistol;
    level thread zm::last_stand_pistol_rank_init();
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::change_starting_and_last_stand_weapon( <weapon_name> )"
"Summary: Change starting weapon and last stand weapon"
"Module: Util"
"Example: zm_sphynx_util::change_starting_and_last_stand_weapon( "smg_standard" );"
@/
function change_starting_and_last_stand_weapon( weapon ){
    level.default_laststandpistol             = getWeapon( weapon ); // The one you get if you go down in co-op and didnt have another pistol
    level.default_solo_laststandpistol        = getWeapon( weapon ); // The one you get with quickrevive in solo
    level.laststandpistol                     = level.default_laststandpistol;
    level.start_weapon                        = level.default_laststandpistol;
    level thread zm::last_stand_pistol_rank_init();
}

/@
"Author: Mikeyray"
"Name: zm_sphynx_util::enable_non_stop_dog_spawning( <startRound>, <minimumZombies>, <minDelayBetweenSpawns>, <maxDelayBetweenSpawns>)"
"Summary: Enable non-stop dog spawning from a specified round"
"Module: Util"
"Example: level flag::clear("non_stop_dog_spawning");"
"Example: zm_sphynx_util::enable_non_stop_dog_spawning(8, 5, 18, 24);"
@/
function enable_non_stop_dog_spawning( startRound = 8, minimumZombies = 5, minDelayBetweenSpawns = 18, maxDelayBetweenSpawns = 24 )
{
    level endon( "intermission" );

    level flag::init("non_stop_dog_spawning");
    level flag::set("non_stop_dog_spawning");
    WAIT_SERVER_FRAME
    
    n_start_spawning_from_round             = startRound;        // Round number for continuous spawn dog
    n_minimum_zombie_total_for_spawn        = minimumZombies;        // Minimum zombies remaining either "now" or "left to spawn" - if less the do spawning will pause till the next round
    n_minimum_delay_between_spawns          = minDelayBetweenSpawns;       // Minimum wait in seconds between spawning dogs
    n_maximum_delay_between_spawns          = maxDelayBetweenSpawns;       // Maximum wait in seconds between spawning dogs
    
    while ( 1 )
    {
        level waittill( "start_of_round" ); // Wait till the start round
        
        if ( !isDefined( level.round_number ) || level.round_number < n_start_spawning_from_round || ( level flag::exists( "dog_round" ) && level flag::get( "dog_round" ) ) || !isDefined( level.zombie_total )) // If round number is less that decided above, loop back to start
            continue;
        
        n_count_total_zombie = level.zombie_total;  // level.zombie_total by default, this number is updated while (n_count_total_zombie >= n_minimum_zombie_total_for_spawn) using "n_count_total_zombie = n_count_zombies_spawn + level.zombie_total;"
        while ( n_count_total_zombie >= n_minimum_zombie_total_for_spawn ) // Loop this block of code "only" while there is a high enough zombie total either spawned or spawning
        {
            wait randomIntRange( n_minimum_delay_between_spawns, n_maximum_delay_between_spawns ); // Use the random delay
            n_count_zombies_spawn = zombie_utility::get_current_zombie_count(); //Get enemies spawned
            n_count_total_zombie = n_count_zombies_spawn + level.zombie_total; //Update n_count_total_zombie = enemies spawned + zombies spawning
            
            if( n_count_zombies_spawn < level.zombie_ai_limit && IS_TRUE( level flag::get("non_stop_dog_spawning") ) ){ zm_ai_dogs::special_dog_spawn(); } // Force spawn a dog if it does not reach the zombie_ai_limit and level flag::get("non_stop_dog_spawning") is set/true
        }
    }
}

/@
"Author: MikeyRay"
"Name: zm_sphynx_util::spawn_regular_trigger( <hintstring>, <trigger_type>, <origin>, <radius>, <height> )"
"Summary: Spawn a regular trigger with hintstring"
"Module: Util"
"Example: trigger = zm_sphynx_util::spawn_regular_trigger( "Hold ^3&&1^7 to Claim Reward", "trigger_radius_use", loc.origin, 64, 64 );"
@/
function spawn_regular_trigger(hintstring = "No hintstring set", trigger_type = "trigger_radius_use", origin, radius = 40, height = 80)
{
    trigger = Spawn(trigger_type, origin, 0, radius, height);
    trigger SetHintString(hintstring);
    trigger TriggerIgnoreTeam();
    trigger SetVisibleToAll();
    //trigger UseTriggerRequireLookAt();
    trigger SetCursorHint("HINT_NOICON");

    return trigger;
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::wait_for_rounds( <rounds> )"
"Summary: Wait for specified amount of rounds"
"Module: Util"
"Example: zm_sphynx_util::wait_for_rounds( 5 );"
@/
function wait_for_rounds( rounds ){
    for(i=0; i <= rounds; i++){
        level waittill("start_of_round");
    }
}

/@
"Author: gcp345"
"Name: zm_sphynx_util::create_perk_loc( <origin>, <angle>, <perk>, <model>, <parameters>, <string> )"
"Summary: Create a new perk location - Handy for mods"
"Module: Util"
"MandatoryArg: origin : Origin of the specified location where you want the perk"
"MandatoryArg: angle : Angles to set the perk machine"
"MandatoryArg: perk : Perk to add ["specialty_...."]"
"MandatoryArg: model : Model that shows up in game"
"OptionalArg: parameters : Parameters used like in shang perk models [Mostly unused]"
"OptionalArg: string : Specify gamemodes here [Mostly unused]"
"Example: zm_sphynx_util::create_perk_loc( ( 3064.79 , -5195.26 , 0 ), ( 0, 225, 0 ), "specialty_staminup", "p7_zm_vending_marathon", undefined, "zgrief_perks_start_room" );"
@/
// NEED TO DO IT BEFORE INIT
function create_perk_loc( origin, angle, perk, model, parameters, string )
{
    struct = struct::spawn( origin, angle );
    struct.angles = angle;
    
    struct.targetname = "zm_perk_machine";
    
    if( isdefined( perk ) )
    {
        struct.script_noteworthy = perk;
    }

    if( isdefined( parameters ) )
    {
        struct.script_parameters = parameters;
    }

    if( isdefined( model ) )
    {
        struct.model = model;
    }

    if( isdefined( string ) )
    {
        struct.script_string = string;
    }

    if( !isdefined( level.struct_class_names[ "targetname" ][ "zm_perk_machine" ] ) )
    {
        level.struct_class_names[ "targetname" ][ "zm_perk_machine" ] = [];
    }
    level.struct_class_names[ "targetname" ][ "zm_perk_machine" ][ level.struct_class_names[ "targetname" ][ "zm_perk_machine" ].size ] = struct;

    return struct;
}

/@
"Author: gcp345"
"Name: zm_sphynx_util::move_perk_machine( <perk>, <origin>, <angles> )"
"Summary: Move specified perk to location"
"Module: Util"
"Example: zm_sphynx_util::move_perk_machine( "specialty_staminup", origin.origin, origin.angles );"
@/
function move_perk_machine(perk, origin, angles)
{
    triggers = GetEntArray( perk, "script_noteworthy" );

    // Only move one of the triggers
    if(triggers.size > 0)
    {
        t_use = triggers[0];
        t_use.origin = origin + (0, 0, 60);

        if(isdefined(t_use.machine))
        {
            t_use.machine.origin = origin;
            t_use.machine.angles = angles;
        }
        if(isdefined(t_use.bump))
        {
            t_use.bump.origin = origin + (0, 0, 20);
            t_use.bump.angles = angles;
        }
        if(isdefined(t_use.s_fxloc))
        {
            t_use.s_fxloc.origin = origin;
            t_use.s_fxloc.angles = angles;
        }
        if(isdefined(t_use.clip))
        {
            t_use.clip ConnectPaths();
            t_use.clip.origin = origin;
            t_use.clip.angles = angles;
            t_use.clip DisconnectPaths();
        }
    }

    WAIT_SERVER_FRAME;
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::do_player_fire_damage()"
"Summary: Sets the specified player on fire"
"Module: Player"
"Example: player zm_sphynx_util::do_player_fire_damage();"
@/
function do_player_fire_damage( damage )
{    
    self endon("death");
    self endon("disconnect");
    
    if( !IS_TRUE(self.is_burning) && !self laststand::player_is_in_laststand() )
    {
        self.is_burning = 1;        
        if (IS_TRUE(level.trap_fire_visionset_registered))
            visionset_mgr::activate( "overlay", "zm_trap_burn", self, ZM_TRAP_BURN_MAX, ZM_TRAP_BURN_MAX );
        else
            self setburn(1.25);
            
        self notify("burned");

        if(!self hasperk( PERK_JUGGERNOG ) || self.health - 100 < 1)
        {
            RadiusDamage(self.origin, 10, self.health + 100, self.health + 100);
            self.is_burning = undefined;
        }
        else
        {
            self dodamage( damage , self.origin);
            wait(.1);
            //self playsound("wpn_zmb_electrap_zap");
            self.is_burning = undefined;
        }
    }
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::player_max_ammo()"
"Summary: Gives the player a max ammo [No hud indication]"
"Module: Player"
"Example: player zm_sphynx_util::player_max_ammo();"
@/
function player_max_ammo(){
    weapons_list = self GetWeaponsList(true);
    foreach(weapon in weapons_list){
        if ( weapon != level.weaponNone )
        {
            self SetWeaponOverheating( 0,0 );
            max = weapon.maxAmmo;
            if (isdefined(max))
            {
                self SetWeaponAmmoStock( weapon, max );
            }
            
            if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
            {
                self GiveMaxAmmo( self zm_utility::get_player_tactical_grenade() );
            }
            if ( isdefined( self zm_utility::get_player_lethal_grenade() )){
                self GiveMaxAmmo( self zm_utility::get_player_lethal_grenade() );
            }
        }
    }
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::upgrade_current_weapon_aat()"
"Summary: Upgrade the current player weapon"
"Module: Player"
"Example: player zm_sphynx_util::upgrade_current_weapon_aat();"
@/
function upgrade_current_weapon_aat(){
    weap = self GetCurrentWeapon();
    weapon = zm_weapons::get_upgrade_weapon( weap, false );

    if ( ( isdefined( level.aat_in_use ) && level.aat_in_use ) )
    {
        self thread aat::acquire( weapon );
    }

    weapon.camo_index = self zm_weapons::get_pack_a_punch_weapon_options( weapon );
    self TakeWeapon( weap );
    self GiveWeapon( weapon, weapon.camo_index );
    self GiveMaxAmmo( weapon );
        
    self SwitchToWeapon( weapon );

    zm_utility::play_sound_at_pos( "zmb_perks_packa_ready", self );
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::upgrade_current_weapon()"
"Summary: Upgrade the current player weapon"
"Module: Player"
"Example: player zm_sphynx_util::upgrade_current_weapon();"
@/
function upgrade_current_weapon(){
    weap = self GetCurrentWeapon();
    weapon = zm_weapons::get_upgrade_weapon( weap, false );

    weapon.camo_index = self zm_weapons::get_pack_a_punch_weapon_options( weapon );
    self TakeWeapon( weap );
    self GiveWeapon( weapon, weapon.camo_index );
    self GiveMaxAmmo( weapon );
        
    self SwitchToWeapon( weapon );

    zm_utility::play_sound_at_pos( "zmb_perks_packa_ready", self );
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::downgrade_current_weapon()"
"Summary: Downgrade the current player weapon"
"Module: Player"
"Example: player zm_sphynx_util::downgrade_current_weapon();"
@/
function downgrade_current_weapon(){
    weap = self GetCurrentWeapon();
    weapon = zm_weapons::get_base_weapon( weap );

    self TakeWeapon( weap );
    self GiveWeapon( weapon, self zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
    self GiveStartAmmo( weapon );
    self SwitchToWeapon( weapon );

    zm_utility::play_sound_at_pos( "zmb_perks_packa_ready", self );
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::get_eye_origin( <distance> )"
"Summary: Trace where the player is looking with specified distance"
"Module: Player"
"Example: player zm_sphynx_util::get_eye_origin( 5000 );"
@/
function get_eye_origin( distance = 8000){
    // Trace to where the player is looking
    direction = self GetPlayerAngles();
    direction_vec = AnglesToForward( direction );
    eye = self GetEye();

    scale = distance;
    direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);

    // offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
    trace = bullettrace( eye, eye + direction_vec, 0, undefined );

    final_pos = trace["position"];

    return final_pos;
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::take_all_perks()"
"Summary: Takes all perks from the player"
"Module: Player"
"Example: player zm_sphynx_util::take_all_perks();"
@/
function take_all_perks(){
    vending_triggers = GetEntArray( "zombie_vending", "targetname" );

    if ( vending_triggers.size < 1 )
    {
        debug_print(0, "No perk machines found in map");
        return;
    }

    foreach( perk_a in GetArrayKeys( level._custom_perks ) ){
        self zm_perks::lose_random_perk();
        wait .5;
    }
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::take_perk( <perk_name> )"
"Summary: Takes a specified or random perk from the player"
"Module: Player"
"Example: player zm_sphynx_util::take_perk( "specialty_staminup" );"
"Example: player zm_sphynx_util::take_perk( undefined );"
@/
function take_perk( perk ){
    vending_triggers = GetEntArray( "zombie_vending", "targetname" );

    if ( vending_triggers.size < 1 )
    {
        debug_print(0, "No perk machines found in map");
        return;
    }

    if(!isdefined(perk)){
        self zm_perks::lose_random_perk();
    }else{
        perk_str = perk + "_stop";
        self notify( perk_str );

        if ( use_solo_revive() && perk == PERK_QUICK_REVIVE )
        {
            self.lives--;
        }
    }
}

function private use_solo_revive()
{
    if( isdefined(level.override_use_solo_revive) )
    {
        return [[level.override_use_solo_revive]]();
    }

    players = GetPlayers();
    solo_mode = 0;
    if ( players.size == 1 || IS_TRUE( level.force_solo_quick_revive ) )
    {
        solo_mode = 1;
    }
    level.using_solo_revive = solo_mode;
    return solo_mode;
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::give_all_perks()"
"Summary: Gives all perks to the player"
"Module: Player"
"Example: player zm_sphynx_util::give_all_perks();"
@/
function give_all_perks(){
    vending_triggers = GetEntArray( "zombie_vending", "targetname" );

    if ( vending_triggers.size < 1 )
    {
        debug_print(0, "No perk machines found in map");
        return;
    }

    foreach( perk_a in GetArrayKeys( level._custom_perks ) ){
        self zm_perks::give_perk( perk_a, false );
        wait .5;
    }
}

/@
"Author: Sphynx"
"Name: player zm_sphynx_util::give_specific_perk( <perk_name> )"
"Summary: Gives a specific or random perk to the player"
"Module: Player"
"Example: player zm_sphynx_util::give_specific_perk( "specialty_staminup" );"
"Example: player zm_sphynx_util::give_specific_perk( undefined );"
@/
function give_specific_perk( perk ){
    vending_triggers = GetEntArray( "zombie_vending", "targetname" );

    if ( vending_triggers.size < 1 )
    {
        debug_print(0, "No perk machines found in map");
        return;
    }

    if(!isdefined(perk)){
        self zm_perks::give_random_perk();
    }else{
        self zm_perks::give_perk( perk, false );
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::turn_on_power()"
"Summary: Turns on all power on the map [Opens doors]"
"Module: Util"
"Example: zm_sphynx_util::turn_on_power();"
@/
function turn_on_power(){
    level waittill("initial_blackscreen_passed");

    level flag::clear( "power_off" );
    level flag::set("power_on");
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::turn_off_power()"
"Summary: Turns off all power on the map [Does not close doors]"
"Module: Util"
"Example: zm_sphynx_util::turn_off_power();"
@/
function turn_off_power(){
    level waittill("initial_blackscreen_passed");

    level flag::clear( "power_on" );
    level flag::set("power_off");
    level clientfield::set("zombie_power_off", 0);
    level notify("power_off" );
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::change_player_weapon_camo( <camo_index> )"
"Summary: Changes the players' current gun camo"
"MandatoryArg: camo_index : The camo index number you want the gun to get"
"Module: Util"
"Example: player zm_sphynx_util::change_player_weapon_camo( 15 );"
@/
function change_player_weapon_camo( camo_index ){
    self UpdateWeaponOptions( self GetCurrentWeapon(), self CalcWeaponOptions(camo_index, 0, 0) );
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::teleport_zombies_to_origin( <origin> )"
"Summary: Teleports all zombies to a specific origin"
"MandatoryArg: origin : The origin origin where you want the zombies to teleport to"
"Module: Util"
"Example: zm_sphynx_util::teleport_zombies_to_origin( origin.origin );"
@/
function teleport_zombies_to_origin( origin, angles ){
    foreach(zombie in GetAITeamArray( "axis" )){
        if(!isdefined(angles))
            zombie ForceTeleport( origin, zombie.angles, 1 );
        else
            zombie ForceTeleport( origin, angles, 1 );

    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::stop_zombie_spawning()"
"Summary: Stops zombies from spawning and kills of any remaining zombies [Does not advance round]"
"Module: Util"
"Example: zm_sphynx_util::stop_zombie_spawning();"
@/
function stop_zombie_spawning(){
    level flag::clear("spawn_zombies");
    a_ai_enemies = GetAITeamArray( "axis" );
    foreach( ai_enemy in a_ai_enemies )
    {
        level.zombie_total++;
        level.zombie_respawns++;    // Increment total of zombies needing to be respawned
        
        ai_enemy Kill();
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::start_zombie_spawning()"
"Summary: Starts regular zombie spawning again"
"Module: Util"
"Example: zm_sphynx_util::start_zombie_spawning();"
@/
function start_zombie_spawning(){
    level flag::set("spawn_zombies");
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::goto_round( <round_number> )"
"Summary: Changes the round and recalculates everything correctly"
"MandatoryArg: round_number : The round number you want to go to"
"Module: Util"
"Example: zm_sphynx_util::goto_round( 15 );"
@/
function goto_round(round_number = undefined)
{
    if(!isdefined(round_number))
        round_number = zm::get_round_number();
    if(round_number == zm::get_round_number())
        return;
    if(round_number < 0)
        return;

    // kill_round by default only exists in debug mode
    /#
    level notify("kill_round");
    #/
    // level notify("restart_round");
    level notify("end_of_round");
    level.zombie_total = 0;
    zm::set_round_number(round_number);
    round_number = zm::get_round_number(); // get the clamped round number (max 255)

    zombie_utility::ai_calculate_health(round_number);
    SetRoundsPlayed(round_number);

    foreach(zombie in zombie_utility::get_round_enemy_array())
    {
        zombie Kill();
    }

    if(level.gamedifficulty == 0)
        level.zombie_move_speed = round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
    else
        level.zombie_move_speed = round_number * level.zombie_vars["zombie_move_speed_multiplier"];

    level.zombie_vars["zombie_spawn_delay"] = [[level.func_get_zombie_spawn_delay]](round_number);

    level.sndGotoRoundOccurred = true;
    level waittill("between_round_over");
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::easy_pickup_item( <targetname>, <item_name>, <activation_flag> )"
"Summary: Creates an pickup item on specified script_model"
"MandatoryArg: targetname : Targetname of the script_model"
"MandatoryArg: item_name : The name of the item [Displayed in the hintstring]"
"MandatoryArg: activation_flag : The flag that will be activated when the item is picked up"
"Module: Util"
"Example: zm_sphynx_util::easy_pickup_item( "targetname_script_model", "Summoning Key", "has_summoning_key" );"
@/
function easy_pickup_item(targetname, item_name, activation_flag, pickupAudio){
    level flag::init(activation_flag);
    wait(1); // wait for flags to init
    level flag::wait_till("initial_blackscreen_passed");

    array::thread_all( GetEntArray(targetname, "targetname"), &create_item_pickup_func, item_name, activation_flag, pickupAudio);
}

function create_item_pickup_func(item_name = "Item", activation_flag, pickupAudio){
    self.trigger = Spawn("trigger_radius_use", self.origin, 0, 64, 64);
    self.trigger TriggerIgnoreTeam();
    self.trigger SetVisibleToAll();
    self.trigger SetTeamForTrigger( "none" );
    self.trigger UseTriggerRequireLookAt();
    self.trigger SetCursorHint( "HINT_NOICON" );
    self.trigger SetHintString("Hold ^3&&1^7 to Pickup " + item_name);

    while(isdefined(self)){
        self.trigger waittill("trigger", player);

        if( player zm_utility::in_revive_trigger() || IS_DRINKING( player.is_drinking ) || !zm_utility::is_player_valid( player ))
            continue;

        PlaySoundAtPosition(pickupAudio, self.origin);

        level flag::set(activation_flag);
        self.trigger Delete();
        self Delete();
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::move_pack_a_punch( <origin>, <angles>, <accelerationTime>, <decelerationTime> )"
"Summary: Moves the original Pack-a-Punch"
"Module: Util"
"Example: zm_sphynx_util::move_pack_a_punch( origin.origin, origin.angles, 4, 4 );"
@/
function move_pack_a_punch(origin, angles, accelerationTime, decelerationTime){
    pap_trigger = level.pack_a_punch.triggers[0];
    pap_trigger EnableLinkTo();
    pap_trigger.clip LinkTo( pap_trigger.zbarrier );
    pap_trigger LinkTo( pap_trigger.zbarrier );
    pap_trigger.zbarrier LinkTo( pap_trigger, "tag_origin" );

    pap_trigger MoveTo(origin, accelerationTime, decelerationTime);
    pap_trigger RotateTo(angles, accelerationTime);
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::start_infinite_zombie_spawning()"
"Summary: Starts spawning infinite zombies, will not progress rounds"
"Module: Util"
"Example: zm_sphynx_util::start_infinite_zombie_spawning();"
@/
function start_infinite_zombie_spawning(){
    level flag::init("infinite_zombie_spawning");
    WAIT_SERVER_FRAME
    level flag::set("infinite_zombie_spawning");   

    while(level flag::get("infinite_zombie_spawning")){
        level flag::wait_till( "spawn_zombies" );

        if( zombie_utility::get_current_zombie_count() < level.zombie_ai_limit ) // only update if less than the ai limit
        {
            //spawner = array::random( level.zombie_spawners );
            //zombie = zombie_utility::spawn_zombie( spawner );
            level.zombie_total = level.zombie_ai_limit; // keep ai total at the ai limit
        }
        level.zombie_respawns++; // get ai back in the level faster
        wait( level.zombie_vars["zombie_spawn_delay"] );
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::stop_infinite_zombie_spawning( )"
"Summary: When infinite zombie spawning is enabled, this will disable it."
"Module: Util"
"Example: zm_sphynx_util::stop_infinite_zombie_spawning( );"
@/
function stop_infinite_zombie_spawning(){
    level flag::clear("infinite_zombie_spawning");
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::remove_perk_from_map( <w_weapon> )"
"Summary: Completely removes perk from the map."
"Module: Util"
"Example: zm_sphynx_util::remove_perk_from_map( "specialty_staminup" );"
@/
function remove_perk_from_map( perk ){
    zm_perks::perk_machine_removal( perk );
    level._custom_perks = Array::remove_index(level._custom_perks, perk, 1);
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::easy_shootable_ee_points( <targetname>, <points>, <specific_gun>, <need_upgraded>, <shotAudio> )"
"Summary: Enables shootable on specified targetname models, which grants points when shot and can play audio."
"Module: Util"
"Example: zm_sphynx_util::easy_shootable_ee_points( "targetname_script_models", 500, undefined, true, undefined);"
"Example: zm_sphynx_util::easy_shootable_ee_points( "targetname_script_models", 1250, "smg_standard", false, "shot_damage");"
@/
function easy_shootable_ee_points(targetname, points, specific_gun, need_upgraded_weapon, shotAudio){
    array::thread_all( GetEntArray(targetname, "targetname"), &_shootable_points_ee_func, points, specific_gun, need_upgraded_weapon, shotAudio);
}

function _shootable_points_ee_func(points, specific_gun, need_upgraded_weapon, shotAudio){

    self SetCanDamage(true);

    while(isdefined(self)){
        self waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type, STR_MODEL, str_tag, str_part, w_weapon);

        if(isdefined(specific_gun) && GetWeapon(specific_gun) != w_weapon)
            continue;

        if( IS_TRUE(need_upgraded_weapon) && !zm_weapons::is_weapon_upgraded( w_weapon ))
            continue;

        if(isdefined(shotAudio))
            e_attacker PlaySoundToPlayer(shotAudio, e_attacker);

        array::thread_all( GetPlayers(), &give_player_money, points);

        self Delete();
    }

}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::debug_print( <type>, <message> )"
"Summary: Better Debug print."
"Module: Util"
"Example: zm_sphynx_util::debug_print( 0, "This is a debug message" );"
@/
function debug_print(type, print){
       if(type == 0 || type == undefined || type == ""){
        IPrintLnBold("^1 Debug: ^7" + print);
        }else{
            IPrintLn("^1 Debug: ^7" + print);
        }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::give_player_money( <amount> )"
"Summary: Give a specified amount of money to player."
"Module: Player"
"Example: player zm_sphynx_util::give_player_money( 1250 );"
@/
function give_player_money( amount = 500 )
{
    self zm_score::add_to_player_score( amount );
    zm_utility::play_sound_at_pos( "purchase", self.origin );
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::take_player_money( <amount> )"
"Summary: Take a specified amount of money from player."
"Module: Player"
"Example: player zm_sphynx_util::take_player_money( 1250 );"
@/
function take_player_money( amount = 500 )
{
    self zm_score::minus_to_player_score( amount );
    zm_utility::play_sound_at_pos( "purchase", self.origin );
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::validatePosition( <current_self>, <distance_infront>, <model_to_drop>, <radius> )"
"Summary: Validate a position in front of self, and see if it can physicsdrop there"
"Module: Return Value"
"Example: final_pos = zm_sphynx_util::validatePosition(self, 40, model, 30);"
@/
function validatePosition(current_self, distance_infront = 40, model_to_drop, model_radius = 30){

    // Forward
    start = current_self.origin;
    forward_dir = AnglesToForward( current_self.angles );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // Left Diagonal
    forward_dir = AnglesToForward( current_self.angles - (0, 45, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // Right Diagonal
    forward_dir = AnglesToForward( current_self.angles + (0, 45, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // Left
    forward_dir = AnglesToForward( current_self.angles - (0, 90, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // Right Diagonal
    forward_dir = AnglesToForward( current_self.angles + (0, 90, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // left diagonal back
    forward_dir = AnglesToForward( current_self.angles - (0, 135, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // right diagonal back
    forward_dir = AnglesToForward( current_self.angles + (0, 135, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // back
    forward_dir = AnglesToForward( current_self.angles + (0, 180, 0) );
    end = start + (forward_dir * distance_infront);
    trace = BulletTrace(start, end, false, undefined);
    final_pos = trace["position"];

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;

    // If all fails, we need to drop the model at self
    final_pos = current_self.origin;

    if( model_to_drop can_land_on_point(start, final_pos, model_radius ) )
        return final_pos;
    
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::can_land_on_point( <start_origin>, <distance_infront>, <model_to_drop> )"
"Summary: Validate a position in front of self, and see if it can physicsdrop there"
"Module: Return Value"
"Example: final_pos = can_land_on_point(self.origin, trace["position"], 30);"
@/
function can_land_on_point(start, final_pos, radius){

    if( IsPointOnNavMesh( final_pos, ( radius * 2.5 ) ) && TracePassedOnNavMesh( start, final_pos, radius ) )
    {
        if( self MayMoveFromPointToPoint( start, final_pos, false, false ) )
        {
            return true;
        }
    }

    return false;
}

/@
"Author: DidUknowiPwn"
"Name: zm_sphynx_util::release_lock()"
"Summary: Player is released from all stopping mechanics."
"Module: Player"
"Example: player zm_sphynx_util::release_lock();"
@/
function release_lock()
{
    // stances
    if ( SessionModeIsMultiplayerGame() )
        self notify( "release_player" );
    self AllowCrouch( true );
    self AllowProne( true );
    self AllowStand( true );
    // movements
    self AllowJump( true );
    self AllowMelee( true );
    self AllowSprint( true );
    self SetMoveSpeedScale( 1 );
    // weapons
    self EnableWeaponCycling();
    self EnableOffhandWeapons();
}

/@
"Author: DidUknowiPwn"
"Name: zm_sphynx_util::lock_player( <stance> )"
"Summary: Player is locked from all movement mechanics."
"Module: Player"
"OptionalArg: [stance] : force a stance and lock the player to that one "
"Example: player zm_sphynx_util::lock_player( "crouch" );"
@/
function lock_player( stance = self GetStance() )
{
    // override player velocity to "completely" lock
    self SetVelocity( (0,0,0) );
    self SetStance( stance );
    // stances -- broken in MP, ZM works
    self AllowedStances( stance );
    if ( SessionModeIsMultiplayerGame() )
        self thread loop_stance( stance );
    // movements
    self AllowJump( false );
    self AllowMelee( false );
    self AllowSprint( false );
    self SetMoveSpeedScale( 0 );
    // weapons -- player weapons must be handled before locking them
    self DisableWeaponCycling();
    self DisableOffhandWeapons();
}

function loop_stance( stance )
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "entering_last_stand" ); // rejack
    self endon( "release_player" );

    while( true )
    {
        self SetStance( stance );
        WAIT_SERVER_FRAME;
    }
}

/@
"Author: Harrybo21"
"Name: zm_sphynx_util::give_hero_weapon( <w_weapon> )"
"Summary: Correctly give hero weapon"
"Module: util"
"CallOn: "
"MandatoryArg: w_weapon : Hero weapon you want to give the player"
"Example: self thread zm_sphynx_util::give_hero_weapon(GetWeapon("hero_gravityspikes_melee"));"
"SPMP: both"
@/
function give_hero_weapon( w_weapon )
{
    w_previous = self GetCurrentWeapon();
    self zm_weapons::weapon_give( w_weapon );
    self GadgetPowerSet( 0, 99 );
    self SwitchToWeapon( w_weapon );
    self waittill( "weapon_change_complete" );
    self SetLowReady( 1 ); 
    self SwitchToWeapon( w_previous );
    self util::waittill_any_timeout( 1.0, "weapon_change_complete" );
    self SetLowReady( 0 );
    self GadgetPowerSet( 0, 100 );
}

/@
"Author: Serious"
"Name: zm_sphynx_util::set_perk_limit_now( <perk_limit> )"
"Summary: Sets perk limit"
"Module: util"
"CallOn: "
"MandatoryArg: perk_limit : Perk limit to set"
"Example: zm_sphynx_util::set_perk_limit_now(6);"
"SPMP: both"
@/
function set_perk_limit_now( perk_limit )
{
    level endon("end_game");
    while(!isdefined(level.machine_assets))
    {
        wait(0.05);
    }
    level.perk_purchase_limit = perk_limit;
}

/@
"Author: Vertasea"
"Name: zm_sphynx_util::intro_screen_text( <text_1>, <text_2>, <text_3> )"
"Summary: Intro typewriter text"
"Module: util"
"CallOn: "
"MandatoryArg: text_1 : First text that shows up"
"MandatoryArg: text_2 : Second text that shows up"
"MandatoryArg: text_3 : Last text that shows up"
"Example: level thread zm_sphynx_util::intro_screen_text("", "", "");"
"SPMP: both"
@/
function intro_screen_text(text_1 = "", text_2 = "", text_3 = "")
{
    wait(1); // wait for flags to init
    level flag::wait_till("initial_blackscreen_passed");

    intro_hud = [];
    str_text = Array( text_1, text_2, text_3 ); // Edit these lines to say what you want

    for ( i = 0; i < str_text.size; i++ )
    {
        intro_hud[i] = NewHudElem();
        intro_hud[i].x = 20;
        intro_hud[i].y = -250 + ( 20 * i );
        intro_hud[i].fontscale = ( IsSplitScreen() ? 2.75 : 1.75 );
        intro_hud[i].alignx = "LEFT";
        intro_hud[i].aligny = "BOTTOM";
        intro_hud[i].horzalign = "LEFT";
        intro_hud[i].vertalign = "BOTTOM";
        intro_hud[i].color = (1.0, 1.0, 1.0);
        intro_hud[i].alpha = 1;
        intro_hud[i].sort = 0;
        intro_hud[i].foreground = true;
        intro_hud[i].hidewheninmenu = true;
        intro_hud[i].archived = false;
        intro_hud[i].showplayerteamhudelemtospectator = true;
        intro_hud[i] SetText(str_text[i]);
        intro_hud[i] SetTypewriterFX( 100, 10000 - ( 3000 * i ), 3000 );
        wait(3);
    }

    wait(10);
    foreach ( hudelem in intro_hud ) hudelem Destroy();
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::static_powerup_spawn_specific( <origin>, <powerup> )"
"Summary: Spawns a powerup on the specified origin."
"Module: util"
"MandatoryArg: origin : origin origin"
"OptionalArg: powerup : Powerup name"
"Example: zm_sphynx_util::static_powerup_spawn_specific(self.origin, "full_ammo");"
@/
function static_powerup_spawn_specific(origin, powerup){

    if(!isdefined(powerup))
        powerup = "full_ammo";

    while(!level.passed_introscreen)
        WAIT_SERVER_FRAME

    level thread zm_powerups::specific_powerup_drop( powerup, origin.origin, undefined, undefined, undefined, undefined, true );

}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::static_powerup_spawn_random( <origin>, <powerup> )"
"Summary: Spawns a powerup on the specified origin. Not specifying the drops yourself will random to; max, insta, firesale, doublepoints"
"Module: util"
"MandatoryArg: origin : origin origin"
"OptionalArg: drops_array : Powerup array"
"Example: drops = array("full_ammo", "fire_sale", "insta_kill", "double_points");"
"Example: zm_sphynx_util::static_powerup_spawn_random(self.origin, drops);"
"SPMP: both"
@/
function static_powerup_spawn_random(origin, drops_array ){

    if(!isdefined(drops_array))
        drops_array = array("full_ammo", "fire_sale", "insta_kill", "double_points");

    while(!level.passed_introscreen)
        WAIT_SERVER_FRAME

    level thread zm_powerups::specific_powerup_drop( array::random( drops_array ), origin.origin, undefined, undefined, undefined, undefined, true );

}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::entity_lookat_closest_player( <distance> )"
"Summary: Makes the entity look at the player in range"
"Module: util"
"OptionalArg: distance : Distance between entity and player before entity will change rotation"
"CallOn: "
"Example: entity zm_sphynx_util::entity_lookat_closest_player( 150 );"
"SPMP: both"
@/
function entity_lookat_closest_player( distance = 250 ){

    self endon("death");

    while(isdefined(self)){
        closest_plr = ArrayGetClosest(self.origin, GetPlayers());
        if(isdefined(closest_plr))
            {
                dist = Distance(self.origin, closest_plr.origin);
                if(dist < distance){
                    angles = self lookAt_func(closest_plr.origin);
                    self RotateTo(angles - (0,90,0), 0.2);
                }else{
                    if(self.angles != self.original_angles){
                        self RotateTo(self.original_angles, 0.5);
                    }
                }
            } 
        wait 0.3;
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::lookAt_func( <origin> )"
"Summary: Returns the angles for looking at the entity."
"Module: util"
"MandatoryArg: origin : Origin of the entity you want looking at"
"Example: self zm_sphynx_util::lookAt_func(player.origin);"
@/
function lookAt_func(origin){
    v_to_enemy = FLAT_ORIGIN( (origin - self.origin) );
    v_to_enemy = VectorNormalize( v_to_enemy );
    goalAngles = VectortoAngles( v_to_enemy );

    return goalAngles;
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::rotateFull( <rotateSpeed>)"
"Summary: Thread rotation function on the entity."
"Module: util"
"CallOn: "
"OptionalArg: rotateSpeed : Rotation speed"
"Example: self thread zm_sphynx_util::rotateFull(12);"
"SPMP: both"
@/
function rotateFull(rotateSpeed){
    while(isdefined(self)){
        self RotateYaw(360, rotateSpeed);
        wait rotateSpeed;
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::rotateRandomFull( <rotateSpeedMin>, <rotateSpeedMax> )"
"Summary: Thread rotation function on the entity."
"Module: util"
"CallOn: "
"OptionalArg: rotateSpeedMin : Minimal Rotation speed [Randomizes]"
"OptionalArg: rotateSpeedMax : Maximal Rotation speed [Randomizes]"
"Example: self thread zm_sphynx_util::rotateRandomFull(6.4, 7.8);"
"SPMP: both"
@/
function rotateRandomFull(rotateSpeedMin = 6, rotateSpeedMax = 7){
    while(isdefined(self)){
        rotationSpeed = RandomIntRange(rotateSpeedMin, rotateSpeedMax);
        self RotateYaw(360, rotationSpeed);
        wait rotationSpeed;
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::rotateAndBobItem( <bobbingTime>, <bobbingHeightMin>, <bobbingHeightMax>, <rotateSpeedMin>, <rotateSpeedMax> )"
"Summary: Thread the bobbing and rotation function on the entity."
"Module: util"
"CallOn: "
"OptionalArg: bobbingTime : Time the item will bob up and down"
"OptionalArg: bobbingHeightMin: Minimal Height of the bobbing item [Randomizes]"
"OptionalArg: bobbingHeightMax : Maximal Height of the bobbing item [Randomizes]"
"OptionalArg: rotateSpeedMin : Minimal Rotation speed [Randomizes]"
"OptionalArg: rotateSpeedMax : Maximal Rotation speed [Randomizes]"
"Example: self thread zm_sphynx_util::rotateAndBobItem(3.5, 6, 9, 6.4, 7.8);"
"SPMP: both"
@/
function rotateAndBobItem(bobbingTime = 3.5, bobbingHeightMin = 6, bobbingHeightMax = 9, rotateSpeedMin = 6, rotateSpeedMax = 7){

    self Bobbing( (0,0,1), bobbingTime, RandomIntRange(bobbingHeightMin,bobbingHeightMax));

    while(isdefined(self)){
        rotationSpeed = RandomIntRange(rotateSpeedMin, rotateSpeedMax);
        self RotateYaw(360, rotationSpeed);
        wait rotationSpeed;
    }
}

/@
"Author: Sphynx/Treyarch"
"Name: zm_sphynx_util::create_unitrigger_general( <str_hint>, <n_radius>, <func_prompt_and_visibility>, <func_unitrigger_logic>, <s_trigger_type> )"
"Summary: Create a unitrigger on entity/model, player specific trigger!"
"Module: util"
"CallOn: "
"MandatoryArg: str_hint : Start hintstring without it having gotten any updates"
"MandatoryArg: n_radius: Radius of the trigger [default = 64]"
"MandatoryArg: func_prompt_and_visibility : Function for prompt and visibility"
"OptionalArg: func_unitrigger_logic : Minimal Rotation speed [Randomizes]"
"OptionalArg: s_trigger_type : Trigger_type"
"Example: self zm_sphynx_util::create_unitrigger_general("Hold ^3&&1^7 to pickup Key", undefined, &key_prompt_and_visibility);"
"SPMP: both"
@/
function create_unitrigger_general(str_hint, n_radius = 64, func_prompt_and_visibility = &zm_unitrigger::unitrigger_prompt_and_visibility, func_unitrigger_logic = &unitrigger_logic, s_trigger_type = "unitrigger_radius_use"){

    self.s_unitrigger = SpawnStruct();
    self.s_unitrigger.origin = self.origin;
    self.s_unitrigger.angles = self.angles;
    self.s_unitrigger.script_unitrigger_type = "unitrigger_box_use";
    self.s_unitrigger.cursor_hint = "HINT_NOICON";
    self.s_unitrigger.hint_string = str_hint;
    self.s_unitrigger.script_width = 128;
    self.s_unitrigger.script_height = 128;
    self.s_unitrigger.script_length = 128;
    self.s_unitrigger.require_look_at = 0;
    self.s_unitrigger.related_parent = self;
    self.s_unitrigger.radius = n_radius;

    self.s_unitrigger.prompt_and_visibility_func = func_prompt_and_visibility;
    zm_unitrigger::register_static_unitrigger( self.s_unitrigger, func_unitrigger_logic );

}

/@
"Author: Sphynx/Treyarch"
"Name: zm_sphynx_util::create_unitrigger_for_player_specific( <str_hint>, <n_radius>, <func_prompt_and_visibility>, <func_unitrigger_logic>, <s_trigger_type> )"
"Summary: Create a unitrigger on entity/model, generic trigger not made for per-player specific hintstrings!"
"Module: util"
"CallOn: "
"MandatoryArg: str_hint : Start hintstring without it having gotten any updates"
"MandatoryArg: n_radius: Radius of the trigger [default = 64]"
"MandatoryArg: func_prompt_and_visibility : Function for prompt and visibility"
"OptionalArg: func_unitrigger_logic : Minimal Rotation speed [Randomizes]"
"OptionalArg: s_trigger_type : Trigger_type"
"Example: self zm_sphynx_util::create_unitrigger_for_player_specific("Hold ^3&&1^7 to pickup Key", undefined, &key_prompt_and_visibility);"
"SPMP: both"
@/
function create_unitrigger_for_player_specific(str_hint, n_radius = 64, func_prompt_and_visibility = &zm_unitrigger::unitrigger_prompt_and_visibility, func_unitrigger_logic = &unitrigger_logic, s_trigger_type = "unitrigger_radius_use"){

    self.s_unitrigger = SpawnStruct();
    self.s_unitrigger.origin = self.origin;
    self.s_unitrigger.angles = self.angles;
    self.s_unitrigger.script_unitrigger_type = "unitrigger_box_use";
    self.s_unitrigger.cursor_hint = "HINT_NOICON";
    self.s_unitrigger.hint_string = str_hint;
    self.s_unitrigger.script_width = 128;
    self.s_unitrigger.script_height = 128;
    self.s_unitrigger.script_length = 128;
    self.s_unitrigger.require_look_at = 0;
    self.s_unitrigger.related_parent = self;
    self.s_unitrigger.radius = n_radius;

    zm_unitrigger::unitrigger_force_per_player_triggers( self.s_unitrigger, 1 );
    self.s_unitrigger.prompt_and_visibility_func = func_prompt_and_visibility;
    zm_unitrigger::register_static_unitrigger( self.s_unitrigger, func_unitrigger_logic );

}

// self == unitrigger
function unitrigger_logic()
{
    self endon( "death" );

    while ( true )
    {
        self waittill( "trigger", player );

        if( player zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
        {
            continue;
        }

        if( IS_DRINKING( player.is_drinking ) )
        {
            continue;
        }

        if( !zm_utility::is_player_valid( player ) ) // ensure valid player
        {
            continue;
        }

        self.stub.related_parent notify( "trigger_activated", player );
    }
}

/@
"Author: Sphynx"
"Name: zm_sphynx_util::progress_bar( <targetname>, <hintstringUse>, <time>, <bar_string>, <craftingSoundLoop>, <craftingSoundComplete>, <offset> )"
"Summary: Spawns a trigger on a specified model/entity with progressbar"
"Module: Player"
"Example: self zm_sphynx_util::progress_bar( "test_progress_bar", "Inspect Gems", 2, "Inspecting Gems...", "zmb_craftable_loop", "quest_complete", (0,0,40) );"
"
@/
function progress_bar( targetname, hintstringUse, useTime, progressString, craftingSoundLoop, craftingSoundComplete, offset )
{
    progress_trigger = spawn_regular_trigger("Hold ^3&&1^7 to " + hintstringUse, "trigger_radius_use", GetEnt(targetname, "targetname").origin + offset, 40, 80);

    result = false;
    while(!result){
        progress_trigger waittill("trigger", player);

        result = self progress_bar_func( player, targetname, useTime, progressString, craftingSoundLoop );
    }

    player PlaySound( craftingSoundComplete );
    progress_trigger Delete();
}

function progress_bar_func( player, targetname, useTime, progressString, craftingSoundLoop ){
    if(isdefined(useTime))
        self.useTime = Int( useTime * 1000 );

    self thread zm_craftables::craftable_play_craft_fx( player );
    self thread progress_bar_use_hold_think_internal_override( player, targetname, progressString, craftingSoundLoop );
    retval = self util::waittill_any_return( "craft_succeed", "craft_failed" );

    if ( retval == "craft_succeed" )
    {
        return true;
    }

    return false;
}

function progress_bar_use_hold_think_internal_override( player, targetname, progressString, craftingSoundLoop )
{
    wait(0.01);

    if ( !isdefined( self ) )
    {
        //make sure the audio sounds go away
        if ( isdefined( player.craftableAudio ) )
        {
            player.craftableAudio delete();
            player.craftableAudio = undefined;
        }

        return;
    }
    
    if ( !isdefined( self.useTime ) )
    {
        self.useTime = Int( 3 * 1000 );
    }

    self.craft_time = self.useTime;
    self.craft_start_time = GetTime();
    craft_time = self.craft_time;
    craft_start_time = self.craft_start_time;

    if ( craft_time > 0 )
    {
        player zm_utility::disable_player_move_states( true );

        player zm_utility::increment_is_drinking();
        orgweapon = player GetCurrentWeapon();
        build_weapon = GetWeapon( "zombie_builder" );
        player GiveWeapon( build_weapon );
        player SwitchToWeapon( build_weapon );

        player thread player_progress_bar_override( craft_start_time, craft_time, progressString );

        while ( isdefined( self ) && player player_continue_crafting_override(targetname) && GetTime() - self.craft_start_time < self.craft_time )
        {
            wait(0.01);
            if ( isdefined( player ) && !isdefined( player.craftableAudio ) )
            {
                player.craftableAudio = spawn( "script_origin", player.origin );
                player.craftableAudio PlayLoopSound( craftingSoundLoop );
            }
        }

        //make sure the audio sounds go away
        if ( isdefined( player.craftableAudio ) )
        {
            player.craftableAudio delete();
            player.craftableAudio = undefined;
        }

        player notify( "craftable_progress_end" );

        player zm_weapons::switch_back_primary_weapon( orgweapon );
        //player SwitchToWeapon( orgweapon );
        player TakeWeapon( build_weapon );

        if ( IS_TRUE( player.is_drinking ) )
        {
            player zm_utility::decrement_is_drinking();
        }

        player zm_utility::enable_player_move_states();
    }

    if ( isdefined( self ) &&
            player player_continue_crafting_override( targetname ) &&
            ( self.craft_time <= 0 || getTime() - self.craft_start_time >= self.craft_time ) )
    {
        self notify( "craft_succeed" );
    }
    else
    {
        //make sure the audio sounds go away
        if ( isdefined( player.craftableAudio ) )
        {
            player.craftableAudio delete();
            player.craftableAudio = undefined;
        }

        self notify( "craft_failed" );
    }
}

function player_progress_bar_override( start_time, craft_time, progressString )
{
    self.useBar = self hud::createPrimaryProgressBar();
    self.useBarText = self hud::createPrimaryProgressBarText();

    if(!isdefined(progressString))
        progressString = &"ZOMBIE_BUILDING";

    self.useBarText setText( progressString );

    if ( isdefined( self ) && isdefined( start_time ) && isdefined( craft_time ) )
    {
        self zm_craftables::player_progress_bar_update( start_time, craft_time );
    }

    self.useBarText hud::destroyElem();
    self.useBar hud::destroyElem();
}

function player_continue_crafting_override(targetname)
{
    if ( self laststand::player_is_in_laststand() || self zm_utility::in_revive_trigger() )
    {
        return false;
    }

    if ( isdefined( self.screecher ) )
    {
        return false;
    }

    if ( !self UseButtonPressed() )
    {
        return false;
    }

    trigger = GetEnt(targetname, "targetname");
    script_unitrigger_type = "unitrigger_radius_use";
    radius = 40;

    if ( script_unitrigger_type == "unitrigger_radius_use" )
    {
        torigin = trigger.origin;
        porigin = self GetEye();
        radius_sq = ( 1.5 * 1.5 ) * radius * radius;

        if ( Distance2DSquared( torigin, porigin ) > radius_sq )
        {
            return false;
        }
    }
    else
    {
        if ( !isdefined( trigger ) || !trigger IsTouching( self ) ) //self IsTouching(trigger))
        {
            return false;
        }
    }

    if (!self util::is_player_looking_at( trigger.origin, 0.76 ) )
    {
        return false;
    }

    return true;
}

/@
"Author: HarryBo21"
"Name: zm_sphynx_util::get_player_loadout()"
"Summary: Gets the current player loadout. Useful for tombstone-like applications"
"Module: Player"
"Example: player_loadout = self zm_sphynx_util::get_player_loadout()"
"
@/
function get_player_loadout()
{
	s_loadout = spawnStruct(); 
	s_loadout.w_current_weapon = ( self getCurrentWeapon() != level.weaponNone && isWeapon( self getCurrentWeapon() ) && !zm_utility::is_offhand_weapon( self getCurrentWeapon() ) ? ( self getCurrentWeapon() ) : undefined );
	s_loadout.w_stowed_weapon = ( self getStowedWeapon() != level.weaponNone && isWeapon( self getStowedWeapon() ) ? ( self getStowedWeapon() ) : undefined );
	s_loadout.a_all_weapons = [];
	s_loadout.n_score = ( isDefined( self.score ) ? self.score : 0 );
	
	a_all_weapons = self getWeaponsList();
	for ( i = 0; i < a_all_weapons.size; i++ )
		if ( isDefined( a_all_weapons[ i ] ) && a_all_weapons[ i ] != level.weaponNone && zm_weapons::is_weapon_included( a_all_weapons[ i ] ) || zm_weapons::is_weapon_upgraded( a_all_weapons[ i ] ) )
			array::add( s_loadout.a_all_weapons, zm_weapons::get_player_weapondata( self, a_all_weapons[ i ] ), 0 );
	
	s_loadout.a_perks = ( ( isDefined( self zm_perks::get_perk_array() ) ) ? self zm_perks::get_perk_array() : [] );
	s_loadout.a_disabled_perks = ( isDefined( self.disabled_perks ) && isArray( self.disabled_perks ) ? self.disabled_perks : [] );
	s_loadout.a_additional_primary_weapons_lost = self.a_additional_primary_weapons_lost;

    s_loadout.a_location_info = []; s_loadout.a_location_info["origin"] = self.origin; s_loadout.a_location_info["angles"] = self.angles;
	
	return s_loadout; 
}

function is_perk_paused( perk )
{
	if ( !isDefined( self.disabled_perks ) )
		self.disabled_perks = [];
	
	if ( !isDefined( self.disabled_perks[ perk ] ) )
		self.disabled_perks[ perk ] = 0;
	
	return self.disabled_perks[ perk ];
}

function player_pause_perk( perk, retain_perk = 1 )
{
	if ( !isDefined( self.disabled_perks ) )
		self.disabled_perks = [];
	
	if ( IS_TRUE( self.disabled_perks[ perk ] ) )
		return;
	
	if ( !self hasPerk( perk ) )
		return;
	
	if ( IS_TRUE( retain_perk ) )
		self.disabled_perks[ perk ] = 1;
	else
		self.disabled_perks[ perk ] = 0;
	
	self unsetPerk( perk );
	self.num_perks--;
	
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].player_thread_take ) )
		self thread [[ level._custom_perks[ perk ].player_thread_take ]]( 1 );
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].clientfield_set ) )
		self thread [[ level._custom_perks[ perk ].clientfield_set ]]( 2 );
	
	self notify( perk + "_paused" );
}

function player_unpause_perk( perk )
{
	if ( !isDefined( self.disabled_perks ) )
		self.disabled_perks = [];
	
	if ( !IS_TRUE( self.disabled_perks[ perk ] ) )
		return;
	
	if ( self hasPerk( perk ) )
		return;
	
	self.disabled_perks[ perk ] = 0;
	
	self setPerk( perk );
	self.num_perks++;
	
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].player_thread_give ) )
		self thread [[ level._custom_perks[ perk ].player_thread_give ]]();
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].clientfield_set ) )
		self thread [[ level._custom_perks[ perk ].clientfield_set ]]( 1 );

	self notify( perk + "_unpaused" );
}

/@
"Author: HarryBo21"
"Name: zm_sphynx_util::give_player_loadout( <s_loadout>, <b_remove_player_weapons>, <b_immediate_weapon_switch>, <b_remove_player_perks>, <a_exclude_perks>, <a_exclude_guns> )"
"Summary: Gives the player a loadout, with options to preserve various of the player's current loadout"
"Module: Player"
"Example: self zm_sphynx_util::give_player_loadout( player_loadout )"
"
@/
function give_player_loadout( s_loadout, b_remove_player_weapons = 1, b_immediate_weapon_switch = 0, b_remove_player_perks = 0, b_set_location = 0, a_exclude_perks = [], a_exclude_guns = [] )
{
	DEFAULT( self.disabled_perks, [] );
	
	if ( IS_TRUE( b_remove_player_weapons ) )
		self takeAllWeapons();
	if ( IS_TRUE( b_remove_player_perks ) )
	{
		a_player_current_perks = ( ( isDefined( self zm_perks::get_perk_array() ) && isArray( self zm_perks::get_perk_array() ) ) ? self zm_perks::get_perk_array() : [] );
		a_player_current_perks = arrayCombine( a_player_current_perks, self.disabled_perks, 0, 1 );
		a_loadout_perks = arrayCombine( s_loadout.a_perks, s_loadout.a_disabled_perks, 0, 1 );
		a_perks_to_take = array::exclude( a_loadout_perks, a_player_current_perks );
		
		for ( i = 0; i < a_perks_to_take.size; i++ )
		{
			self [ [ level._custom_perks[ a_perks_to_take[ i ] ].clientfield_set ] ]( 0 );
			
			if ( self is_perk_paused( a_perks_to_take[ i ] ) )
				continue;
			
			self unsetPerk( a_perks_to_take[ i ] );
			self.num_perks--;
			self [ [ level._custom_perks[ a_perks_to_take[ i ] ].player_thread_take ] ]();
			self notify( a_perks_to_take[ i ] + "_stop" );
		}
	}
	
	a_perks = ( ( isDefined( s_loadout.a_perks ) ) ? s_loadout.a_perks : [] );
	if ( isDefined( s_loadout.a_disabled_perks ) && isArray( s_loadout.a_disabled_perks ) && s_loadout.a_disabled_perks.size > 0 )
		for ( i = 0; i < s_loadout.a_disabled_perks.size; i++ )
			if ( isDefined( s_loadout.a_disabled_perks[ i ] ) )
			{
				if ( !isInArray( a_perks, s_loadout.a_disabled_perks[ i ] ) )
					a_perks[ s_loadout.a_disabled_perks[ i ] ] = 1;
				
				self player_pause_perk( s_loadout.a_disabled_perks[ i ] );
			}
	
	for ( i = 0; i < a_perks.size; i++ )
	{
		if ( isInArray( a_exclude_perks, a_perks[ i ] ) )
			continue;
		if ( flag::exists( "solo_game" ) && flag::exists( "solo_revive" ) && level flag::get( "solo_game" ) && level flag::get( "solo_revive" ) && a_perks[ i ] == "specialty_quickrevive" )
			level.solo_lives_given--;
		else if ( a_perks[ i ] == "specialty_additionalprimaryweapon" && !self hasPerk( "specialty_additionalprimaryweapon" ) )
		{
			a_additional_primary_weapons_lost = ( isDefined( self.a_additional_primary_weapons_lost ) && isArray( self.a_additional_primary_weapons_lost ) ? self.a_additional_primary_weapons_lost : s_loadout.a_additional_primary_weapons_lost );
			self.a_additional_primary_weapons_lost = undefined;
			self zm_perks::give_perk( a_perks[ i ] );
			self.a_additional_primary_weapons_lost = a_additional_primary_weapons_lost;
		}
		else
			self zm_perks::give_perk( a_perks[ i ] );
	
	}
	
	for ( i = 0; i < s_loadout.a_all_weapons.size; i++ )
		if ( isDefined( s_loadout.a_all_weapons[ i ][ "weapon" ] ) && !isInArray( a_exclude_guns, s_loadout.a_all_weapons[ i ][ "weapon" ].name ) && ( zm_utility::is_offhand_weapon( s_loadout.a_all_weapons[ i ][ "weapon" ] ) || self getWeaponsListPrimaries().size < zm_utility::get_player_weapon_limit( self ) ) )
			self zm_weapons::weapondata_give( s_loadout.a_all_weapons[ i ] );
	
	if ( isDefined( s_loadout.w_stowed_weapon ) && self hasWeapon( s_loadout.w_stowed_weapon ) )
		self setStowedWeapon( s_loadout.w_stowed_weapon );
	
	ptr_weapon_switch = ( IS_TRUE( b_immediate_weapon_switch ) ? &switchToWeaponImmediate : &switchToWeapon );
	if ( !isDefined( s_loadout.w_current_weapon ) )
		self [ [ ptr_weapon_switch ] ]();
	else
		self [ [ ptr_weapon_switch ] ]( s_loadout.w_current_weapon );
	
	if( IS_TRUE(b_set_location) )
    {
        self SetOrigin(s_loadout.a_location_info["origin"]);
        self SetPlayerAngles(s_loadout.a_location_info["angles"]);
    }
}