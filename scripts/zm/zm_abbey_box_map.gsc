#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\zm\zm_room_manager;

#precache( "fx", "light/fx_light_button_green_traincar_zod_zmb" );

function main()
{
    level.abbey_box_location_indices = [];

    if(GetDvarString("ui_mapname") == "zm_building")
    {
        level.abbey_box_location_indices["chest_2"] = 0; // Spawn Room
        level.abbey_box_location_indices["chest_1"] = 1; // Staminarch
        level.abbey_box_location_indices["start_chest_1"] = 2; // Lion Room
        level.abbey_box_location_indices["start_chest_2"] = 3; // Downstairs Room
    }
    
    box_maps = GetEntArray("abbey_box_map", "targetname");
    level array::thread_all(box_maps, &box_map_think);
}

function box_map_think()
{
    if(self.script_int != 1)
    {
        return;
    }
    level flag::wait_till("power_on" + self.script_int);

    self thread fire_sale_monitor();

    while(true)
    {
        cur_chest = level.chests[level.chest_index];
        index = level.abbey_box_location_indices[cur_chest.script_noteworthy];

        level exploder::exploder("abbey_box_map_light" + self.script_int + "" + index);

        level flag::wait_till("moving_chest_now");

        self thread bulb_flash(0.25);

        while(level flag::get("moving_chest_now") || level.zombie_vars["zombie_powerup_fire_sale_on"])
        {
            wait(0.05);
        }

        self notify(#"bulb_flash_stop");
        for(i = 0; i < 4; i++)
        {
            level exploder::stop_exploder("abbey_box_map_light" + self.script_int + "" + i);
        }
    }
}

function fire_sale_monitor()
{
    while(true)
    {
        if(level.zombie_vars["zombie_powerup_fire_sale_on"])
        {
            self thread bulb_flash(0.3);
            while(level.zombie_vars["zombie_powerup_fire_sale_on"])
            {
                wait(0.05);
            }
            if(! level flag::get("moving_chest_now"))
            {
                self notify(#"bulb_flash_stop");
                cur_chest = level.chests[level.chest_index];
                index = level.abbey_box_location_indices[cur_chest.script_noteworthy];
                for(i = 0; i < 4; i++)
                {
                    if(i == index)
                    {
                        level exploder::exploder("abbey_box_map_light" + self.script_int + "" + i);
                    }
                    else
                    {
                        level exploder::stop_exploder("abbey_box_map_light" + self.script_int + "" + i);
                    }
                }
            }
        }
        wait(0.05);
    }
}

function bulb_flash(interval)
{
    self notify(#"bulb_flash_stop");
    self endon(#"bulb_flash_stop");

    while(true)
    {
        for(i = 0; i < 4; i++)
        {
            level exploder::exploder("abbey_box_map_light" + self.script_int + "" + i);
        }
        wait(interval);
        for(i = 0; i < 4; i++)
        {
            level exploder::stop_exploder("abbey_box_map_light" + self.script_int + "" + i);
        }
        wait(interval);
    }
}