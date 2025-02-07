CoD.AbbeyNotification = InheritFrom(LUI.UIElement)

function CoD.AbbeyNotification.new(HudRef, InstanceRef)
    local AbbeyNotification = LUI.UIElement.new()
    AbbeyNotification:setClass(CoD.AbbeyNotification)
    AbbeyNotification.id = "AbbeyNotification"
    AbbeyNotification.soundSet = "default"

    local BloodNotifLookup = {
        "notif_blueprint_perk_deadshot",
        "notif_blueprint_perk_phd",
        "notif_blueprint_perk_poseidon",
        "notif_blueprint_weap_diedrich",
        "notif_blueprint_weap_healing",
        "notif_blueprint_weap_trident",
        "notif_global_hud_toggle",
        "notif_global_pause",
        "notif_gum_aramis",
        "notif_gum_porthos",
        "notif_gum_dart",
        "notif_gum_athos",
        "notif_perk_up_cherry",
        "notif_perk_up_deadshot",
        "notif_perk_up_double",
        "notif_perk_up_mule",
        "notif_perk_up_phd",
        "notif_perk_up_poseidon",
        "notif_perk_up_revive",
        "notif_perk_up_stamin",
        "notif_power_bg",
        "notif_power_team"
    }

    local GargoyleLookup = {
        "notif_garg_stock_option",
        "notif_garg_sword_flay",
        "notif_garg_temporal_gift",
        "notif_garg_in_plain_sight",
        "notif_garg_im_feelin_lucky",
        "notif_garg_immolation_liquidation",
        "notif_garg_phoenix_up",
        "notif_garg_pop_shocks",
        "notif_garg_challenge_rejected",
        "notif_garg_on_the_house",
        "notif_garg_profit_sharing",
        "notif_garg_flavor_hexed",
        "notif_garg_crate_power",
        "notif_garg_unquenchable",
        "notif_garg_alchemical_antithesis",
        "notif_garg_extra_credit",
        "notif_garg_head_drama",
        "notif_garg_aftertaste_blood",
        "notif_garg_perkaholic"
    }

    local FlashLookup = {
        "flash_left",
        "flash_right",
        "flash_down"
    }

	local BloodGenerator = CoD.BloodGenerator.new(HudRef, InstanceRef)
    BloodGenerator:setLeftRight(true, false, 21, 216)
    BloodGenerator:setTopBottom(true, false, -10, 193)
    BloodGenerator:setAlpha(0)
    AbbeyNotification:addElement(BloodGenerator)

    local BloodNotif = LUI.UIImage.new()
    BloodNotif:setLeftRight(true, false, -65, 245)
    BloodNotif:setTopBottom(true, false, 145, 224)
    BloodNotif:setAlpha(0)
    AbbeyNotification:addElement(BloodNotif)

    local Gargoyle = LUI.UIImage.new()
    Gargoyle:setLeftRight(true, false, -65, 245)
    Gargoyle:setTopBottom(true, false, 145, 224)
    Gargoyle:setAlpha(0)
    AbbeyNotification:addElement(Gargoyle)

    local FadeInTime = 1250
    BloodNotif.clipsPerState = {
        DefaultState = { --DefaultState is the element state if no other condition is met.
            DefaultClip = function() --This is the default clip to play for this specified state.
                BloodNotif:setupElementClipCounter(1) --This function tells the clip handler to expect 1 calls of clipFinished() before it can say that the clip has ended.

                BloodNotif:completeAnimation() --Finishes any animation transition currently occuring on the element. If the animation has been tied to an event, it will pass interrupted onto the Event object (Covered later).

                BloodNotif:beginAnimation("keyframe", FadeInTime, false, false, CoD.TweenType.Linear)
                
                BloodNotif:setAlpha(1)
            end
        }
    }

    Gargoyle.clipsPerState = {
        DefaultState = { --DefaultState is the element state if no other condition is met.
            DefaultClip = function() --This is the default clip to play for this specified state.
                Gargoyle:setupElementClipCounter(1) --This function tells the clip handler to expect 1 calls of clipFinished() before it can say that the clip has ended.

                Gargoyle:completeAnimation() --Finishes any animation transition currently occuring on the element. If the animation has been tied to an event, it will pass interrupted onto the Event object (Covered later).

                Gargoyle:beginAnimation("keyframe", FadeInTime, false, false, CoD.TweenType.Linear)
                
                Gargoyle:setAlpha(1)
            end
        }
    }

    BloodGenerator.clipsPerState = {
        DefaultState = { --DefaultState is the element state if no other condition is met.
            DefaultClip = function() --This is the default clip to play for this specified state.
                BloodGenerator:setupElementClipCounter(1) --This function tells the clip handler to expect 1 calls of clipFinished() before it can say that the clip has ended.

                BloodGenerator:completeAnimation() --Finishes any animation transition currently occuring on the element. If the animation has been tied to an event, it will pass interrupted onto the Event object (Covered later).

                BloodGenerator:beginAnimation("keyframe", 1000, false, false, CoD.TweenType.Linear)
                
                BloodGenerator:setAlpha(1)
            end
        }
    }

 	local function NotificationShow(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_show") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
			local BloodNotifIndex = NotifyData[1] + 1
            local BloodNotifVal = RegisterImage(BloodNotifLookup[BloodNotifIndex])

            BloodNotif:setImage(BloodNotifVal)
            PlayClip(BloodNotif, "DefaultClip", InstanceRef)
        end
    end
	BloodNotif:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationShow)
 	AbbeyNotification:addElement(BloodNotif)

    local function NotificationFlash(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_flash") then
            local NotifyData = CoD.GetScriptNotifyData(ModelRef)
            local FlashVal = NotifyData[1]
            EnableGlobals()
            if FlashVal == 0 then
                PlayClip(DPadLeftFlash, "Flash", InstanceRef)
            elseif FlashVal == 1 then
                PlayClip(DPadRightFlash, "Flash", InstanceRef)
            else
                PlayClip(DPadBottomFlash, "Flash", InstanceRef)
            end
            DisableGlobals()
        end
    end
	AbbeyNotification:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationFlash)

    local function NotificationGargoyle(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_gargoyle") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
			local GargoyleIndex = NotifyData[1] + 1
            local GargoyleVal = RegisterImage(GargoyleLookup[GargoyleIndex])

            Gargoyle:setImage(GargoyleVal)
            PlayClip(Gargoyle, "DefaultClip", InstanceRef)
        end
    end
	BloodNotif:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationGargoyle)
    
	local function NotificationHide(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_hide") then
            BloodNotif:setAlpha(0)
            Gargoyle:setAlpha(0)
        end
    end
	AbbeyNotification:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationHide)
    
	local function GeneratorVisible(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_visible") then
            local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                for i=1,4 do
                    BloodGenerator.OverlayTableS[i]:completeAnimation()
                end
			    BloodGenerator:setAlpha(0)
            else
                PlayClip(BloodGenerator, "DefaultClip", InstanceRef)
            end
        end
    end
	AbbeyNotification:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", GeneratorVisible)
	
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