CoD.Item = InheritFrom(LUI.UIElement)

function CoD.Item.new(HudRef, InstanceRef)
    local Item = LUI.UIElement.new()
    Item:setClass(CoD.Item)
    Item:setLeftRight(true, false, 0.000000, 151.000000)
	Item:setTopBottom(true, false, 0.000000, 36.000000)
    Item.id = "Item"
    Item.soundSet = "default"

    Item.type = ""

    Item.ItemImage = LUI.UIImage.new()
    Item.ItemImage:setLeftRight(true, true)
    Item.ItemImage:setTopBottom(true, true)
    Item:addElement(Item.ItemImage)
    
    Item.ItemCount = LUI.UIText.new()
    Item.ItemCount:setLeftRight(true, true)
    Item.ItemCount:setTopBottom(true, true)
    Item.ItemCount:setRGB(1, 1, 1)
    Item:addElement(Item.ItemCount)

    return Item
end