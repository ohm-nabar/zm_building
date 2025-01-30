CoD.JugHearts = InheritFrom(LUI.UIElement)

function CoD.JugHearts.new(HudRef, InstanceRef)
    local JugHearts = LUI.UIElement.new()
    JugHearts:setClass(CoD.JugHearts)
    JugHearts.id = "JugHearts"
    JugHearts.soundSet = "default"

    local JugHeartsImages = { "jug_hearts_no", "jug_hearts_low", "jug_hearts_mid", "jug_hearts_full"}

    local JugHeartsIcon = LUI.UIImage.new()
    JugHeartsIcon:setImage( RegisterImage( "jug_hearts_no" ) )
    JugHeartsIcon:setLeftRight(true, true)
    JugHeartsIcon:setTopBottom(true, true)

 	local function JugHeartsUpdate(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
            JugHeartsIcon:setImage( RegisterImage( JugHeartsImages[NotifyData + 1] ) )
        end
 	end
 	JugHeartsIcon:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "jugHeartsUpdate"), JugHeartsUpdate)

 	JugHearts:addElement(JugHeartsIcon)

    return JugHearts
end