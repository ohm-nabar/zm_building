CoD.RoomManager = InheritFrom(LUI.UIElement)

function CoD.RoomManager.new(HudRef, InstanceRef)
    local RoomManager = LUI.UIElement.new()
    RoomManager:setClass(CoD.RoomManager)
    RoomManager:setLeftRight( true, true )
    RoomManager:setTopBottom( true, true )
    RoomManager.id = "RoomManager"
    RoomManager.soundSet = "default"
    
    local RoomLookup = {"ZM_ABBEY_ROOM_CRASH_SITE", "ZM_ABBEY_ROOM_RED_ROOM", "ZM_ABBEY_ROOM_BELL_TOWER", "ZM_ABBEY_ROOM_RADIO_GALLERY", "ZM_ABBEY_ROOM_SCAFFOLDING", "ZM_ABBEY_ROOM_CHOIR", "ZM_ABBEY_ROOM_CENTRE", "ZM_ABBEY_ROOM_BASILICA", "ZM_ABBEY_ROOM_AIRFIELD", "ZM_ABBEY_ROOM_DORMITORY", "ZM_ABBEY_ROOM_CLOITRE", "ZM_ABBEY_ROOM_MERVEILLE", "ZM_ABBEY_ROOM_GUARD_TOWER", "ZM_ABBEY_ROOM_COURTYARD", "ZM_ABBEY_ROOM_COURTROOM", "ZM_ABBEY_ROOM_VERITE_LIBRARY", "ZM_ABBEY_ROOM_LOWER_PILGRIMAGE", "ZM_ABBEY_ROOM_CATWALK", "ZM_ABBEY_ROOM_BRIDGE", "ZM_ABBEY_ROOM_URM_LABORATORY", "ZM_ABBEY_ROOM_UPPER_PILGRIMAGE", "ZM_ABBEY_ROOM_MIDDLE_PILGRIMAGE", "ZM_ABBEY_ROOM_BRIDGE_V2", "ZM_ABBEY_ROOM_KNIGHTS_HALL", "ZM_ABBEY_ROOM_NO_MANS_LAND", "ZM_ABBEY_ROOM_ALLEYWAY"}
    local RoomLookupBuilding = {"ZM_ABBEY_ROOM_SPAWN_ROOM", "ZM_ABBEY_ROOM_STAMINARCH", "ZM_ABBEY_ROOM_WATER_TOWER", "ZM_ABBEY_ROOM_CLEAN_ROOM", "ZM_ABBEY_ROOM_LION_ROOM", "ZM_ABBEY_ROOM_DOWNSTAIRS_ROOM"}
	
    local RoomName = LUI.UIText.new()
    RoomName:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	RoomName:setLeftRight( true, true )
	RoomName:setTopBottom( true, true )

	local function RoomDisplay(ModelRef)
		local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if CoD.Zombie.GetUIMapName() == "zm_building" then
                RoomName:setText(Engine.Localize(RoomLookupBuilding[NotifyData + 1]))
            else
                RoomName:setText(Engine.Localize(RoomLookup[NotifyData + 1]))
            end
        end
    end
	RoomName:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "abbeyRoom"), RoomDisplay)
 
 	RoomManager:addElement(RoomName)

    local function UpdateVisibility(ModelRef)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
			if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
				RoomManager:hide()
			else
				RoomManager:show()
			end
		else
			RoomManager:hide()
		end
    end
	
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), UpdateVisibility)
	RoomManager:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), UpdateVisibility)

    return RoomManager
end