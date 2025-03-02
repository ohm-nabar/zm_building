#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_abbey_box_map;

REGISTER_SYSTEM( "zm_abbey_box_map", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "world", "boxLightToggle1", VERSION_SHIP, 4, "int", &box_light_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "world", "boxLightFlashToggle1", VERSION_SHIP, 2, "int", &box_light_flash_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	clientfield::register( "world", "boxLightToggle2", VERSION_SHIP, 4, "int", &box_light_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "world", "boxLightFlashToggle2", VERSION_SHIP, 2, "int", &box_light_flash_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	clientfield::register( "world", "boxLightToggle3", VERSION_SHIP, 4, "int", &box_light_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "world", "boxLightFlashToggle3", VERSION_SHIP, 2, "int", &box_light_flash_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	clientfield::register( "world", "boxLightToggle4", VERSION_SHIP, 4, "int", &box_light_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "world", "boxLightFlashToggle4", VERSION_SHIP, 2, "int", &box_light_flash_toggle, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function box_light_toggle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	gen_num = 1;
	if(IsSubStr(fieldName, "2"))
	{
		gen_num = 2;
	}
	else if(IsSubStr(fieldName, "3"))
	{
		gen_num = 3;
	}
	else if(IsSubStr(fieldName, "4"))
	{
		gen_num = 4;
	}
	if(newVal < 10)
	{
		level exploder::exploder("abbey_box_map_light" + gen_num + "" + newVal, localClientNum);
	}
}

function box_light_flash_toggle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	gen_num = 1;
	if(IsSubStr(fieldName, "2"))
	{
		gen_num = 2;
	}
	else if(IsSubStr(fieldName, "3"))
	{
		gen_num = 3;
	}
	else if(IsSubStr(fieldName, "4"))
	{
		gen_num = 4;
	}

	if(newVal == 0)
	{
		level notify(localClientNum + "bulb_flash_stop" + gen_num);
		for(i = 0; i < 10; i++)
        {
            level exploder::stop_exploder("abbey_box_map_light" + gen_num + "" + i, localClientNum);
        }
	}
	else if(newVal == 1)
	{
		level thread bulb_flash(250, gen_num, localClientNum);
	}
	else
	{
		level thread bulb_flash(300, gen_num, localClientNum);
	}
}

function bulb_flash(interval, gen_num, localClientNum)
{
    level notify(localClientNum + "bulb_flash_stop" + gen_num);
    level endon(localClientNum + "bulb_flash_stop" + gen_num);

    while(true)
    {
        for(i = 0; i < 10; i++)
        {
            level exploder::exploder("abbey_box_map_light" + gen_num + "" + i, localClientNum);
        }
		start_time = GetTime();
		while(GetTime() < start_time + interval)
		{
			WAIT_CLIENT_FRAME
		}
        for(i = 0; i < 10; i++)
        {
            level exploder::stop_exploder("abbey_box_map_light" + gen_num + "" + i, localClientNum);
        }
        start_time = GetTime();
		while(GetTime() < start_time + interval)
		{
			WAIT_CLIENT_FRAME
		}
    }
}