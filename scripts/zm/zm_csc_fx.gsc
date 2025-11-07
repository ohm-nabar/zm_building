#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

REGISTER_SYSTEM( "zm_csc_fx", &__init__, undefined )

// For shared FX and scripts without existing CSCs
function __init__()
{
    level clientfield::register( "scriptmover", "fx_floating_orb_glow", VERSION_SHIP, 1, "int" );
    level clientfield::register( "missile", "semtex_light", VERSION_SHIP, 1, "int" );
    level clientfield::register( "scriptmover", "healing_aura", VERSION_SHIP, 1, "int" );
    level clientfield::register( "actor", "diedrich_explo", VERSION_SHIP, 1, "int" );
    level clientfield::register( "scriptmover", "pickup_glint", VERSION_SHIP, 1, "int" );
    level clientfield::register( "actor", "trap_flame", VERSION_SHIP, 1, "int" );
    level clientfield::register( "scriptmover", "turret_light", VERSION_SHIP, 1, "int" );
    level clientfield::register( "allplayers", "cherry_explode", VERSION_SHIP, 1, "int" );
}