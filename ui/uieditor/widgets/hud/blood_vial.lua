CoD.BloodVial = InheritFrom(LUI.UIElement)

function CoD.BloodVial.new(HudRef, InstanceRef)
    local BloodVial = LUI.UIElement.new()
    BloodVial:setClass(CoD.BloodVial)
    BloodVial:setLeftRight(false, true, -83, 0)
    BloodVial:setTopBottom(true, false, 20, 103)
    BloodVial.id = "BloodVial"
    BloodVial.soundSet = "default"

    
    local Image = LUI.UIImage.new()
    Image:setLeftRight(true, true)
    Image:setTopBottom(true, true)
    Image:hide()
    
    local function BloodVialShow(ModelRef)
        if IsParamModelEqualToString(ModelRef, "blood_vial_update") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                Image:hide()
            elseif NotifyData[1] == 1 then
                Image:setImage(RegisterImage("i_bloodvialempty"))
                Image:show()
            else
                Image:setImage(RegisterImage("i_bloodvialfull"))
                Image:show()
            end
        end
    end
	Image:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", BloodVialShow)
 
 	BloodVial:addElement(Image)

    local function UpdateVisibility(ModelRef)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
			if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
				BloodVial:hide()
			else
				BloodVial:show()
			end
		else
			BloodVial:hide()
		end
    end
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), UpdateVisibility)
	
	BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), UpdateVisibility)
	
	local function JournalVisibility(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                UpdateVisibility(ModelRef)
            else
                BloodVial:hide()
            end
        end
    end
    BloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), JournalVisibility)

    return BloodVial
end