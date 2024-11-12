CoD.SoloLives = InheritFrom(LUI.UIElement)

function CoD.SoloLives.new(HudRef, InstanceRef)
    local SoloLives = LUI.UIElement.new()
    SoloLives:setClass(CoD.SoloLives)
    SoloLives.id = "SoloLives"
    SoloLives.soundSet = "default"

    local SoloLivesImages = {"tombstone_1", "tombstone_2", "tombstone_3"}

    local SoloLivesIcon = LUI.UIImage.new()
    SoloLivesIcon:setImage( RegisterImage( "tombstone_3" ) )
    SoloLivesIcon:setLeftRight(true, true)
    SoloLivesIcon:setTopBottom(true, true)
    SoloLivesIcon:hide()

 	local function SoloLivesUpdate(ModelRef)
 		if IsParamModelEqualToString(ModelRef, "solo_lives_update") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
            if NotifyData[1] == 0 then
                SoloLivesIcon:hide()
            else
                SoloLivesIcon:setImage( RegisterImage( SoloLivesImages[NotifyData[1]] ) )
                SoloLivesIcon:show()
            end
        end
 	end
 	SoloLivesIcon:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", SoloLivesUpdate)

 	SoloLives:addElement(SoloLivesIcon)

    return SoloLives
end