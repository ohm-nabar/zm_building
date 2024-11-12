#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

REGISTER_SYSTEM_EX( "zm_sphynx_util", &__init__, &__main__, undefined )

function __init__()
{
    
}

function __main__()
{
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
"Example: zm_sphynx_util::create_perk_loc( origin.origin, origin.angles, "specialty_staminup", "t7_perk_machine_staminup", ,  );"
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