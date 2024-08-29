/*
				By Holofya
*/

// SETTINGS
// ======================================================================================================
// NOTE: UNLESS YOU WANT TO COMPLETELY CHANGE THE FUNCTIONALITY OF THE FLASHLIGHT, YOU ONLY NEED TO CHANGE THESE VALUES

#define FLASHLIGHT_TYPE				"normal"			// Change this to change the type of flashlight, "normal" and "automatic" are the only values that work
#define FLASHLIGHT_ACTIVATE			"normal"			// Change this to change how the flashlight can be activated, "normal" allows the player to activate it (with both types of flashlight) and "in_area" only activates in specified areas (only works with "automatic")

#define FLASHLIGHT_WAIT				""					// A notify for the flashlight to wait for, if left as "" it will always be available
#define FLASHLIGHT_WAIT_TYPE		"all_players"		// How the flashlight is activated when FLASHLIGHT_WAIT is used (not ""), valid values are "per_player" or "all_players"

#define USE_LIGHT_DISABLE			false				// Whether or not the light gets disabled when throwing grenades, this was originally used for stopping a light issue and should only be used with "tag_flash"
#define FLASHLIGHT_VIEW_FX_TAG		"tag_flashlight"	// Which tag the flashlight fx plays on, original was "tag_flash"

// -------- UV light
#define FLASHLIGHT_USE_UV			true				// Whether or not the flashlight will use the UV version
#define FLASHLIGHT_UV_WAIT			""					// A notify for the UV light to wait for, if left as "" it will always be available
#define FLASHLIGHT_UV_WAIT_TYPE		"all_players"		// How the UV light is activated when FLASHLIGHT_UV_WAIT is used (not ""), valid values are "per_player" or "all_players"
#define UV_VISIBILITY_DIST			256					// the maximum distance a UV ent can be seen from with the UV light
