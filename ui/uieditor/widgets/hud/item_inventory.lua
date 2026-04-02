require("ui.uieditor.widgets.HUD.item")

CoD.ItemInventory = InheritFrom(LUI.UIElement)

function CoD.ItemInventory.new(HudRef, InstanceRef)
    local ItemInventory = LUI.UIElement.new()
    ItemInventory:setClass(CoD.ItemInventory)
    ItemInventory:setLeftRight(true, false, 0.000000, 220.000000)
    ItemInventory:setTopBottom(true, false, 0.000000, 40.000000)
    ItemInventory.id = "ItemInventory"
    ItemInventory.soundSet = "default"

    local ItemStartX  = 0
    local ItemStartY  = 0
    local ItemWidth   = 40
    local ItemHeight  = 40
    local ItemSpacing = -4

    local ItemCountTop = ItemStartY + ItemHeight - 12
    local ItemCountBottom = ItemStartY + ItemHeight + 6

    local MaxItems = 5
    local ItemSlots = {}
    local SlotUsed  = {}

    for i = 1, MaxItems do
        local Item = CoD.Item.new(HudRef, InstanceRef)
        Item:setLeftRight(true, false, 0, ItemWidth)
        Item:setTopBottom(true, false, ItemStartY, ItemStartY + ItemHeight)
        Item.ItemCount:setTopBottom(true, false, ItemCountTop, ItemCountBottom)
        Item:hide()
        ItemInventory:addElement(Item)
        ItemSlots[i] = Item
        SlotUsed[i]  = false
    end

    -- Ordered list of active items: { type = string, slotIndex = number }
    local ActiveItems = {}

    local function RepositionItems()
        for i = 1, #ActiveItems do
            local Left = ItemStartX + (i - 1) * (ItemWidth + ItemSpacing)
            local Right = Left + ItemWidth
            local CountLeft = Right - 3
            local CountRight = Right + 7
            ItemSlots[ActiveItems[i].slotIndex]:setLeftRight(true, false, Left, Right)
            ItemSlots[ActiveItems[i].slotIndex].ItemCount:setLeftRight(true, false, CountLeft, CountRight)
        end
    end

    local function FindActive(itemType)
        for i = 1, #ActiveItems do
            if ActiveItems[i].type == itemType then
                return i
            end
        end
        return nil
    end

    local function FindFreeSlot()
        for i = 1, MaxItems do
            if not SlotUsed[i] then return i end
        end
        return nil
    end

    local function AddItem(itemType, count, imageKey)
        local ActiveIdx = FindActive(itemType)
        if ActiveIdx then
            local Slot = ItemSlots[ActiveItems[ActiveIdx].slotIndex]
            if count > 1 then
                Slot.ItemCount:setText(count)
                Slot.ItemCount:show()
            else
                Slot.ItemCount:hide()
            end
            return
        end

        local SlotIdx = FindFreeSlot()
        if not SlotIdx then return end

        SlotUsed[SlotIdx] = true
        local Slot = ItemSlots[SlotIdx]
        Slot.ItemImage:setImage(RegisterImage(imageKey))
        Slot.ItemImage:show()
        if count > 1 then
            Slot.ItemCount:setText(count)
            Slot.ItemCount:show()
        else
            Slot.ItemCount:hide()
        end
        Slot:show()

        ActiveItems[#ActiveItems + 1] = { type = itemType, slotIndex = SlotIdx }
        RepositionItems()
    end

    local function RemoveItem(itemType)
        local ActiveIdx = FindActive(itemType)
        if not ActiveIdx then return end

        local SlotIdx = ActiveItems[ActiveIdx].slotIndex
        local Slot = ItemSlots[SlotIdx]
        Slot.ItemImage:hide()
        Slot.ItemCount:hide()
        Slot:hide()

        SlotUsed[SlotIdx] = false
        table.remove(ActiveItems, ActiveIdx)
        RepositionItems()
    end

    local function UpdateItemCount(ItemType, ItemCount, ItemImage)
        if ItemCount == 0 then
            RemoveItem(ItemType)
        else
            AddItem(ItemType, ItemCount, ItemImage)
        end
    end

    local function UpdateBribeCount(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            UpdateItemCount("bribe", NotifyData, "abbey_bribe")
        end
    end
    ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "bribeCount"), UpdateBribeCount)

    local function UpdateArtifactCount(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            UpdateItemCount("artifact", NotifyData, "abbey_bribe")
        end
    end
    ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "artifactCount"), UpdateArtifactCount)

    local function UpdateVisibility(ModelRef)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
			if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
				ItemInventory:hide()
			else
				ItemInventory:show()
			end
		else
			ItemInventory:hide()
		end
    end

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), UpdateVisibility)

	ItemInventory:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), UpdateVisibility)

    return ItemInventory
end