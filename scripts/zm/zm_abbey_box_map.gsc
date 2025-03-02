#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\zm_room_manager;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_abbey_box_map;

REGISTER_SYSTEM_EX( "zm_abbey_box_map", &__init__, &__main__, undefined )

function __init__()
{
    clientfield::register( "world", "boxLightToggle1", VERSION_SHIP, 4, "int" );
	clientfield::register( "world", "boxLightFlashToggle1", VERSION_SHIP, 2, "int" );
	
	clientfield::register( "world", "boxLightToggle2", VERSION_SHIP, 4, "int" );
	clientfield::register( "world", "boxLightFlashToggle2", VERSION_SHIP, 2, "int" );
	
	clientfield::register( "world", "boxLightToggle3", VERSION_SHIP, 4, "int" );
	clientfield::register( "world", "boxLightFlashToggle3", VERSION_SHIP, 2, "int" );
	
	clientfield::register( "world", "boxLightToggle4", VERSION_SHIP, 4, "int" );
	clientfield::register( "world", "boxLightFlashToggle4", VERSION_SHIP, 2, "int" );

    level.abbey_box_location_indices = [];

    if(GetDvarString("ui_mapname") == "zm_building")
    {
        level.abbey_box_location_indices["chest_2"] = 0; // Spawn Room
        level.abbey_box_location_indices["chest_1"] = 1; // Staminarch
        level.abbey_box_location_indices["start_chest_1"] = 2; // Lion Room
        level.abbey_box_location_indices["start_chest_2"] = 3; // Downstairs Room
    }
    else
    {
        level.abbey_box_location_indices["chest_1"] = 0; // Bell Tower
        level.abbey_box_location_indices["chest_2"] = 1; // Radio Gallery
        level.abbey_box_location_indices["chest_3"] = 2; // Choir
        level.abbey_box_location_indices["chest_4"] = 3; // Basilica
        level.abbey_box_location_indices["start_chest_1"] = 4; // Airfield
        level.abbey_box_location_indices["chest_5"] = 5; // Merveille de Verite
        level.abbey_box_location_indices["chest_6"] = 6; // Courtyard
        level.abbey_box_location_indices["chest_7"] = 7; // Lower Pilgrimage Stairs
        level.abbey_box_location_indices["start_chest_2"] = 8; // URM Labs
        level.abbey_box_location_indices["chest_8"] = 9; // No Man's Land
    }
}

function __main__()
{
    for(i = 1; i <= 4; i++)
    {
        level thread box_map_think(i);
    }
}

function box_map_think(gen_num)
{
    level flag::wait_till("power_on" + gen_num);

    level thread fire_sale_monitor(gen_num);

    while(true)
    {
        cur_chest = level.chests[level.chest_index];
        index = level.abbey_box_location_indices[cur_chest.script_noteworthy];

        level clientfield::set("boxLightToggle" + gen_num, index);

        level flag::wait_till("moving_chest_now");

        level clientfield::set("boxLightFlashToggle" + gen_num, 1);

        while(level flag::get("moving_chest_now") || level.zombie_vars["zombie_powerup_fire_sale_on"])
        {
            wait(0.05);
        }

        level clientfield::set("boxLightFlashToggle" + gen_num, 0);
    }
}

function fire_sale_monitor(gen_num)
{
    while(true)
    {
        if(level.zombie_vars["zombie_powerup_fire_sale_on"])
        {
            level clientfield::set("boxLightToggle" + gen_num, 10);
            level clientfield::set("boxLightFlashToggle" + gen_num, 2);
            while(level.zombie_vars["zombie_powerup_fire_sale_on"])
            {
                wait(0.05);
            }
            if(! level flag::get("moving_chest_now"))
            {
                cur_chest = level.chests[level.chest_index];
                index = level.abbey_box_location_indices[cur_chest.script_noteworthy];
                level clientfield::set("boxLightFlashToggle" + gen_num, 0);
                level clientfield::set("boxLightToggle" + gen_num, index);
            }
        }
        wait(0.05);
    }
}