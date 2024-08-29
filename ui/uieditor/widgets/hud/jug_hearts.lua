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
 		if IsParamModelEqualToString(ModelRef, "jug_hearts_update") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            JugHeartsIcon:setImage( RegisterImage( JugHeartsImages[NotifyData[1] + 1] ) )
        end
 	end
 	JugHeartsIcon:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", JugHeartsUpdate)

 	JugHearts:addElement(JugHeartsIcon)

    return JugHearts
end