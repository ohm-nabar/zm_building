CoD.ShadowPerks = InheritFrom(LUI.UIElement)

function CoD.ShadowPerks.new(HudRef, InstanceRef)
    local ShadowPerks = LUI.UIElement.new()
    ShadowPerks:setClass(CoD.ShadowPerks)
    ShadowPerks:setLeftRight(true, false, 0.000000, 151.000000)
	ShadowPerks:setTopBottom(true, false, 0.000000, 36.000000)
    ShadowPerks.id = "ShadowPerks"
    ShadowPerks.soundSet = "default"

    local ShadowPerkLookup = { 
        {"shadow_quick", "shadow_cherry"}, 
        {"shadow_poseidon", "shadow_deadshot"}, 
        {"shadow_stamin", "shadow_mule"},
        {"shadow_double", "shadow_phd"}
	}

    local LeftPos = 0
    local RightPos = 36
    local TopPos = -77
    local BottomPos = -41
    local XOffset = 38
    local PerkImages = {}
    local LeftPoses = {}
    local RightPoses = {}

    --[[
    local NotificationImage = LUI.UIImage.new()
    NotificationImage:setLeftRight(true, false, 592.5, 628.5)
    NotificationImage:setTopBottom(true, false, -356, -320)
    NotificationImage:setImage(RegisterImage("shadow_quick"))
    ShadowPerks:addElement(NotificationImage)

    local NotificationImage2 = LUI.UIImage.new()
    NotificationImage2:setLeftRight(true, false, 630.5, 666.5)
    NotificationImage2:setTopBottom(true, false, -356, -320)
    NotificationImage2:setImage(RegisterImage("shadow_cherry"))
    ShadowPerks:addElement(NotificationImage2)
    --]]

    for i=1,8 do
        local PerkImage = LUI.UIImage.new()
        PerkImage:hide()
        PerkImages[i] = PerkImage
        ShadowPerks:addElement(PerkImage)
        LeftPoses[i] = LeftPos
        RightPoses[i] = RightPos
        
        LeftPos = LeftPos + XOffset
        RightPos = RightPos + XOffset

        if i % 2 == 0 then
            PerkImage:setLeftRight(true, false, 630.5, 666.5)
            PerkImage:setTopBottom(true, false, -356, -320)
        else
            PerkImage:setLeftRight(true, false, 592.5, 628.5)
            PerkImage:setTopBottom(true, false, -356, -320)
        end

        PerkImage.clipsPerState = {
            DefaultState = { --DefaultState is the element state if no other condition is met.
                DefaultClip = function() --This is the default clip to play for this specified state.
                    PerkImage:setupElementClipCounter(1) --This function tells the clip handler to expect 1 calls of clipFinished() before it can say that the clip has ended.

                    PerkImage:completeAnimation() --Finishes any animation transition currently occuring on the element. If the animation has been tied to an event, it will pass interrupted onto the Event object (Covered later).

                    PerkImage:beginAnimation("keyframe", 1800, false, false, CoD.TweenType.Linear)
                    
                    PerkImage:setLeftRight(true, false, LeftPoses[i], RightPoses[i])
                    PerkImage:setTopBottom(false, true, TopPos, BottomPos)
                end
            }
        }
    end

    local CurrentIndex = 1

 	local function AddShadowPerks(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                for i=1,8 do
                    local PerkImage = PerkImages[i]
                    PerkImage:hide()
                    if i % 2 == 0 then
                        PerkImage:setLeftRight(true, false, 630.5, 666.5)
                        PerkImage:setTopBottom(true, false, -356, -320)
                    else
                        PerkImage:setLeftRight(true, false, 592.5, 628.5)
                        PerkImage:setTopBottom(true, false, -356, -320)
                    end
                end
                CurrentIndex = 1
            else
                local ImageNames = ShadowPerkLookup[NotifyData]
                for i=1,2 do
                    local PerkImage = PerkImages[CurrentIndex]
                    PerkImage:setImage(RegisterImage(ImageNames[i]))
                    PerkImage:show()
                    PlayClip(PerkImage, "DefaultClip", InstanceRef)
                    CurrentIndex = CurrentIndex + 1
                end
            end
        end
    end
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "shadowPerks"), AddShadowPerks)

    local function UpdateVisibility(ModelRef)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
			if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
				ShadowPerks:hide()
			else
				ShadowPerks:show()
			end
		else
			ShadowPerks:hide()
		end
    end
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), UpdateVisibility)
	
	ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), UpdateVisibility)
	
	local function JournalVisibility(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                UpdateVisibility(ModelRef)
            else
                ShadowPerks:hide()
            end
        end
    end
    ShadowPerks:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), JournalVisibility)

    return ShadowPerks
end