CoD.AbbeyNotification = InheritFrom(LUI.UIElement)

function CoD.AbbeyNotification.new(HudRef, InstanceRef)
    local AbbeyNotification = LUI.UIElement.new()
    AbbeyNotification:setClass(CoD.AbbeyNotification)
    AbbeyNotification:setLeftRight(false, false, -200, 200)
    AbbeyNotification:setTopBottom(true, false, 0, 200)
    AbbeyNotification.id = "AbbeyNotification"
    AbbeyNotification.soundSet = "default"

    local NotificationImageLookup = {
        "splash_blood_obtained",
        "splash_blood_team",
        "splash_blood_user",
        "splash_blueprints_diedrich",
        "splash_blueprints_healing",
        "splash_blueprints_phd",
        "splash_blueprints_poseidon",
        "splash_blueprints_trident",
		"splash_blueprints_deadshot",
        "splash_perk_complete_cherry",
        "splash_perk_complete_double",
        "splash_perk_complete_mule",
        "splash_perk_complete_phd",
        "splash_perk_complete_poseidon",
        "splash_perk_complete_quick",
        "splash_perk_complete_stamin",
		"splash_perk_complete_deadshot",
		"splash_perk_new_cherry",
        "splash_perk_new_double",
        "splash_perk_new_mule",
        "splash_perk_new_phd",
        "splash_perk_new_poseidon",
        "splash_perk_new_quick",
        "splash_perk_new_stamin",
		"splash_perk_new_deadshot",
        "splash_shadow_attack_generator1",
        "splash_shadow_attack_generator2",
        "splash_shadow_attack_generator3",
        "splash_shadow_attack_generator4",
        "splash_shadow_complete_generator1",
        "splash_shadow_complete_generator2",
        "splash_shadow_complete_generator3",
        "splash_shadow_complete_generator4",
        "splash_trial_filled",
        "splash_trial_area_assault",
		"splash_trial_area_defense",
		"splash_trial_high_ground",
		"splash_trial_mystery_box",
		"splash_trial_wallbuy",
		"splash_trial_weapon_class",
		"splash_trial_headshot",
		"splash_hud_toggle",
		"splash_pause",
		"splash_blood_activated",
		"splash_shadow_over"
    }

    local AbbeyNotificationImage = LUI.UIImage.new()
    AbbeyNotificationImage:setLeftRight(true, true)
    AbbeyNotificationImage:setTopBottom(true, false, -200, 0)
    AbbeyNotificationImage:hide()

	local BloodGenerator = CoD.BloodGenerator.new(HudRef, InstanceRef)
    BloodGenerator:setLeftRight(true, false, 97, 302)
    BloodGenerator:setTopBottom(true, false, -25, 200)
	BloodGenerator:hide()

    AbbeyNotificationImage.clipsPerState = {
        DefaultState = { --DefaultState is the element state if no other condition is met.
            DefaultClip = function() --This is the default clip to play for this specified state.
                AbbeyNotificationImage:setupElementClipCounter(1) --This function tells the clip handler to expect 1 calls of clipFinished() before it can say that the clip has ended.

                AbbeyNotificationImage:completeAnimation() --Finishes any animation transition currently occuring on the element. If the animation has been tied to an event, it will pass interrupted onto the Event object (Covered later).

                AbbeyNotificationImage:beginAnimation("keyframe", 1000, false, false, CoD.TweenType.Linear)
                
                AbbeyNotificationImage:setTopBottom(true, true)
            end
        }
    }

 	local function NotificationImageShow(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_image_show") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
			if (NotifyData[1] >= 25 and NotifyData[1] <= 32) or NotifyData[1] >= 43 then
				BloodGenerator:show()
			else
				AbbeyNotificationImage:setImage( RegisterImage( NotificationImageLookup[NotifyData[1] + 1] ) )
				AbbeyNotificationImage:show()
				PlayClip(AbbeyNotificationImage, "DefaultClip", InstanceRef)
			end
        end
    end
	AbbeyNotificationImage:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationImageShow)

 	AbbeyNotification:addElement(AbbeyNotificationImage)
	AbbeyNotification:addElement(BloodGenerator)

    local function FlashDPad(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_text_show") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
			EnableGlobals()
			if NotifyData[1] == 0 then
            	PlayClip(DPadRightFlash, "Flash", InstanceRef)
			elseif NotifyData[1] == 1 then
				PlayClip(DPadLeftFlash, "Flash", InstanceRef)
			else
				PlayClip(DPadBottomFlash, "Flash", InstanceRef)
			end
			DisableGlobals()
        end
    end
	AbbeyNotification:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", FlashDPad)
    
	local function NotificationHide(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_hide") then
            AbbeyNotificationImage:hide()
			AbbeyNotificationImage:setTopBottom(true, false, -200, 0)
			BloodGenerator:hide()
        end
    end
	AbbeyNotification:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationHide)
	
    local function UpdateVisibility(ModelRef)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
			if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
				AbbeyNotification:hide()
			else
				AbbeyNotification:show()
			end
		else
			AbbeyNotification:hide()
		end
    end

	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), UpdateVisibility)
	
	AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), UpdateVisibility)
	
	local function JournalVisibility(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                UpdateVisibility(ModelRef)
            else
                AbbeyNotification:hide()
				AbbeyNotification.visible = false
            end
        end
    end
    AbbeyNotification:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), JournalVisibility)
	
	return AbbeyNotification
end