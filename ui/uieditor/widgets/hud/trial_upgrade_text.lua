CoD.TrialUpgradeText = InheritFrom(LUI.UIElement)

function CoD.TrialUpgradeText.new(HudRef, InstanceRef)
    local TrialUpgradeText = LUI.UIElement.new()
    TrialUpgradeText:setClass(CoD.TrialUpgradeText)
    TrialUpgradeText:setLeftRight(true, false, 200, 350)
    TrialUpgradeText:setTopBottom(true, false, 90, 115)
    TrialUpgradeText.id = "TrialUpgradeText"
    TrialUpgradeText.soundSet = "default"

    
    local Text = LUI.UIText.new()
    Text:setText(Engine.Localize("ZM_ABBEY_TRIAL_UPGRADE"))
    Text:setLeftRight(true, true)
    Text:setTopBottom(true, true)
    Text:hide()
    
    local function TrialUpgradeTextShow(ModelRef)
        if IsParamModelEqualToString(ModelRef, "trial_upgrade_text_show") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                Text:hide()
            else
                Text:show()
            end
        end
    end
	Text:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", TrialUpgradeTextShow)
 
 	TrialUpgradeText:addElement(Text)

    return TrialUpgradeText
end