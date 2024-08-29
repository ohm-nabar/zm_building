
// GSC
visionset_mgr::register_info("visionset", "name_of_vision_file", VERSION_SHIP, 61, 1, true);

visionset_mgr::activate("visionset", "name_of_vision_file", player);
visionset_mgr::deactivate("visionset", "name_of_vision_file", player);

// Zone
rawfile,vision/name_of_vision_file.vision

// CSC
visionset_mgr::register_visionset_info("str_VisionInternalName", VERSION_SHIP, 1, "str_VisionFileNameFrom", "str_VisionFileNameTo");


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// How they Work


There are a couple of stage to the vision set, the first is a simple color tint and the next a color ramp, the ramp is a lot more complex and not something one can
easily make tweaks to so it may be best left at the default. The tint section of the key words are very similar in the options when compared to the very basic grading
of past COD’s.

// [VTWEAK_TINT]

"vkTT", FLOAT

"vkTS", FLOAT

"vkTC", VEC4

"vkTO", VEC3

vkTT is the white point color temp adjustment, the default is 6500 and valid values are 1667 to 25000 range. As the value gets below 6500 everything will get warmer,
above and it will get cooler.

vkTS controls the saturation 0 remains the same -1 should be black and white with 1 increasing the saturation.

vkTC is a color tint, the first 3 values are Red, Green and Blue which are in the range of 0 to 1, the last value is the intensity which is in stops so the computed
intensity done in game code is pow(2, value) 0 is the default.

vkTO is a color offset, that is added with the 3 values being Red, Green and Blue valid ranges are -1 to 1 with 0 being the default.




The color ramp has the following key words

// [VTWEAK_RAMP]

"vkRGB0", VEC3

"vkL0", FLOAT

"vkM0", FLOAT

"vkRGB1", VEC3

"vkL1", FLOAT

"vkM1", FLOAT

"vkRGB2", VEC3

"vkL2", FLOAT

"vkRGB3", VEC3

"vkL3", FLOAT

"vkM3", FLOAT

"vkRGB4", VEC3

"vkL4", FLOAT

"vkM4", FLOAT

"vkRM", FLOAT






This a bit more complex but it is a color tint based on the images intensity, using 5 colors the intensity is in the range of 0 to 1 with 5 points (0 -> 4)

vkRGB0 .. 1 .. 2 .. 3 .. 4 are the colors at these points (Red, Green and Blue in the 0 to 1 range). vkL0 .. 1 .. 2 .. 3 .. 4 are the anchor points position that are
in the 0 to 1 range. vKM0 .. 1 .. 2 .. 3 .. 4 are the mid points that control where the 50% blend will happen between the colors the ramp is basically processed in this
order

// COLOR RAMP // 0 .. X (M0) .. 1 .. Y(M1) .. 2 .. Z(M3) .. 3 .. W(M4) .. 4

vkRM is the blend amount for the ramp, 0 = 0% ramp 1 = 100% ramp









// Example Code

function activate( type, name, player, opt_param_1, opt_param_2, opt_param_3 )
{
    if ( level.vsmgr[type].info[name].state.should_activate_per_player )
    {
        activate_per_player( type, name, player, opt_param_1, opt_param_2, opt_param_3 );
        return;
    }

    state = level.vsmgr[type].info[name].state;

    if ( state.ref_count_lerp_thread )
    {
        state.ref_count++;
        if ( 1 < state.ref_count )
        {
            return;
        }
    }

    if ( isdefined( state.lerp_thread ) )
    {
        state thread lerp_thread_wrapper( state.lerp_thread, opt_param_1, opt_param_2, opt_param_3 );
    }
    else
    {
        players = GetPlayers();
        for ( player_index = 0; player_index < players.size; player_index++ )
        {
            state set_state_active( players[player_index], 1 );
        }
    }
}