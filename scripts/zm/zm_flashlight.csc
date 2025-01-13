/*
				By Holofya and an unknown person
*/

#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\zm_flashlight.gsh;

#precache("client_fx", "custom/flashlight/flashlight_loop");
#precache("client_fx", "custom/flashlight/flashlight_loop_50");
#precache("client_fx", "custom/flashlight/flashlight_loop_25");
#precache("client_fx", "custom/flashlight/flashlight_loop_world");
#precache("client_fx", "custom/flashlight/flashlight_uv_loop");
#precache("client_fx", "custom/flashlight/flashlight_uv_loop_world");
#precache("client_fx", "custom/flashlight/flashlight_loop_view_moths"); // this is just moth fx if you don't want them just comment them out here

#namespace zm_flashlight;

REGISTER_SYSTEM("zm_flashlight", &__init__, undefined)

function __init__()
{
	thread fx_init();
	thread clientfield_init();
}

function fx_init()
{
	level._effect["flashlight_fx_loop_view"] = "custom/flashlight/flashlight_loop";
	level._effect["flashlight_fx_loop_view_50"] = "custom/flashlight/flashlight_loop_50";
	level._effect["flashlight_fx_loop_view_25"] = "custom/flashlight/flashlight_loop_25";
	level._effect["flashlight_fx_loop_view_moths"] = "custom/flashlight/flashlight_loop_view_moths";
	level._effect["flashlight_fx_loop_world"] = "custom/flashlight/flashlight_loop_world";
	level._effect["flashlight_fx_uv_loop_view"] = "custom/flashlight/flashlight_uv_loop";
	level._effect["flashlight_fx_uv_loop_world"] = "custom/flashlight/flashlight_uv_loop_world";
}

function clientfield_init()
{
	clientfield::register("toplayer", "flashlight_fx_view", VERSION_SHIP, 2, "int", &flashlight_fx_view, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);
	clientfield::register("allplayers", "flashlight_fx_world", VERSION_SHIP, 2, "int", &flashlight_fx_world, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);
}

function flashlight_fx_view(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump) // self == player
{
	if(newVal == 0)
	{
		if(IsDefined(self.fx_flashlight_view))
		{
			KillFx(localClientNum, self.fx_flashlight_view);
			self.fx_flashlight_view = undefined;

			PlaySound(localClientNum, "1_flashlight_click", self.origin);
		}

		if(IsDefined(self.fx_flashlight_moth))
		{
			KillFx(localClientNum, self.fx_flashlight_moth);
			self.fx_flashlight_moth = undefined;
		}
	}
	else if(newVal == 1)
	{
		if(IsDefined(self.fx_flashlight_view))
		{
			KillFx(localClientNum, self.fx_flashlight_view);
		}

		if(IsDefined(self.fx_flashlight_moth))
		{
			KillFx(localClientNum, self.fx_flashlight_moth);
		}

		flash_fx_view = level._effect["flashlight_fx_loop_view"];
		self.fx_flashlight_view = PlayViewmodelFx(localclientnum, flash_fx_view, FLASHLIGHT_VIEW_FX_TAG);

		flash_fx_moth = level._effect["flashlight_fx_loop_view_moths"];
		self.fx_flashlight_moth = PlayFxOnTag(localClientNum, flash_fx_moth, self, "j_spine4");

		PlaySound(localClientNum, "1_flashlight_click", self.origin);
	}
	else if(newVal == 2)
	{
		if(IsDefined(self.fx_flashlight_view))
		{
			KillFx(localClientNum, self.fx_flashlight_view);
		}

		if(IsDefined(self.fx_flashlight_moth))
		{
			KillFx(localClientNum, self.fx_flashlight_moth);
		}

		flash_fx_view = level._effect["flashlight_fx_loop_view_50"];
		self.fx_flashlight_view = PlayViewmodelFx(localclientnum, flash_fx_view, FLASHLIGHT_VIEW_FX_TAG);

		flash_fx_moth = level._effect["flashlight_fx_loop_view_moths"];
		self.fx_flashlight_moth = PlayFxOnTag(localClientNum, flash_fx_moth, self, "j_spine4");

		PlaySound(localClientNum, "1_flashlight_click", self.origin);
	}
	else if(newVal == 3)
	{
		if(IsDefined(self.fx_flashlight_view))
		{
			KillFx(localClientNum, self.fx_flashlight_view);
		}

		if(IsDefined(self.fx_flashlight_moth))
		{
			KillFx(localClientNum, self.fx_flashlight_moth);
		}

		flash_fx_view = level._effect["flashlight_fx_loop_view_25"];
		self.fx_flashlight_view = PlayViewmodelFx(localclientnum, flash_fx_view, FLASHLIGHT_VIEW_FX_TAG);

		flash_fx_moth = level._effect["flashlight_fx_loop_view_moths"];
		self.fx_flashlight_moth = PlayFxOnTag(localClientNum, flash_fx_moth, self, "j_spine4");

		PlaySound(localClientNum, "1_flashlight_click", self.origin);
	}
}

function flashlight_fx_world(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump) // self == player
{
	if(newVal == 0)
	{
		if(IsDefined(self.fx_flashlight_world))
		{
			KillFx(localClientNum, self.fx_flashlight_world);
			self.fx_flashlight_world = undefined;
		}
	}
	else if(newVal == 1)
	{
		curr_player = GetLocalPlayer(localClientNum);

		if(IsDefined(self.fx_flashlight_world))
		{
			KillFx(localClientNum, self.fx_flashlight_world);
		}

		if(curr_player != self)
		{
			flash_fx_world = level._effect["flashlight_fx_loop_world"];
			self.fx_flashlight_world = PlayFxOnTag(localClientNum, flash_fx_world, self, FLASHLIGHT_VIEW_FX_TAG);
		}
	}
	else if(newVal == 2)
	{
		curr_player = GetLocalPlayer(localClientNum);

		if(IsDefined(self.fx_flashlight_world))
		{
			KillFx(localClientNum, self.fx_flashlight_world);
		}

		if(curr_player != self)
		{
			flash_fx_world = level._effect["flashlight_fx_loop_world"];
			self.fx_flashlight_world = PlayFxOnTag(localClientNum, flash_fx_world, self, FLASHLIGHT_VIEW_FX_TAG);
		}
	}
}
