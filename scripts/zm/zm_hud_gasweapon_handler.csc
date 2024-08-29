// Simple script that sends gas weapon data from CSC to lua
// Credits: 
// Lilrifa - CSC
// Raptroes - Sending me a gas weapon and needing me to do a HUD

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

function autoexec init() {
    callback::on_localplayer_spawned(&OnSpawned);
}

function OnSpawned(localClientNum) {
	if(self != GetLocalPlayer(localClientNum))
		return;

	self thread HandleGasWeapon(localClientNum);
    // If you determine that you don't need a force refresh, comment the following out
    self thread ForceUpdateHUDOnWeaponChange(localClientNum);
}

// I needed this because I have a progress bar that fills based on % of heat / ammo in clip. This can likely be avoided in your HUD
function ForceUpdateHUDOnWeaponChange(localClientNum) {
    refreshModel = CreateUIModel(GetUIModelForController(localClientNum), "weaponAmmo.forceRefresh");
    for(;;) {
        self waittill("weapon_change");

        SetUIModelValue(refreshModel, 1);
        wait(0.01);
        SetUIModelValue(refreshModel, 0);
    }
}

// Sends heatLevel and status to lua
// Status Breakdown: 0 == not in use, 1 == in use/overheating, 2 == overheated
function HandleGasWeapon(localClientNum) {
	self endon("disconnect");
	self endon("entityshutdown");
    self endon("death");

	self.heatLevel = 0;
	self.overheatStatus = 0;
    counter = 0;
	for(;;) {
        weapon = GetCurrentWeapon(localClientNum);
        overheating = isweaponoverheating(localClientNum, 0, weapon);
        self.heatLevel = -1;
        self.overheatStatus = -1;
        if(weapon.weapClass == "gas")
        {
            self.heatLevel = 100 - Int(isweaponoverheating(localClientNum, 1, weapon));

            // These track heatLevel and overheated vals to determine if its in use/overheating, overheated, or not in use and ready to go
            if(overheating == 0 && self.heatLevel > 0 && self.heatLevel < 100 && self IsPlayerFiring()) {
                self.overheatStatus = 1;
            }
            else if(overheating == 1 && self.heatLevel < 100) {
                self.overheatStatus = 2;
            }
            else {
                self.overheatStatus = 0;
            }
        }

        // Use these uimodels to check the heat level and overheat status
        SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "weaponAmmo.heatLevel"), self.heatLevel);
        SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "weaponAmmo.overheatStatus"), self.overheatStatus);

        counter += 1;
		wait 0.01;
	}
}