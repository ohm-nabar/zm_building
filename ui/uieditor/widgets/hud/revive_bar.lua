CoD.ReviveBar = InheritFrom(LUI.UIElement)

function CoD.ReviveBar.new(HudRef, InstanceRef)
    local ReviveBar = LUI.UIElement.new()
    ReviveBar:setClass(CoD.ReviveBar)
    ReviveBar.id = "ReviveBar"
    ReviveBar.soundSet = "default"

    -- height: 25, gap: 10
    local text = LUI.UIText.new()
    text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    text:setLeftRight(true, true)
    text:setTopBottom(false, true, -57, -17)
    text:setText("Reviving")
    text:setAlpha(0)
    ReviveBar:addElement(text)

    local barBG = LUI.UIImage.new()
    barBG:setLeftRight(true, true)
    barBG:setTopBottom(true, true)
    barBG:setImage(RegisterImage("$black"))
    barBG:setAlpha(0)
    ReviveBar:addElement(barBG)

    local bar = LUI.UIImage.new()
    bar:setLeftRight(true, true)
    bar:setTopBottom(true, true)
    bar:setImage(RegisterImage("$white"))
    bar:setMaterial(RegisterMaterial("uie_wipe"))
    bar:setShaderVector(1, 0, 0, 0, 0)
    bar:setShaderVector(2, 1, 0, 0, 0)
    bar:setShaderVector(3, 0, 0, 0, 0)
    bar:setAlpha(0)
    ReviveBar:addElement(bar)
    
    local timer = LUI.UITimer.newElementTimer(1, false, tick_fn)

    local total_time_passed = 0
    local revive_time = 3000
    local function tick_fn(timer_event)
        total_time_passed = total_time_passed + timer_event.timeElapsed
        bar:setShaderVector(0, total_time_passed / revive_time, 0, 0, 0)
    end

    local function ReviveBarThink(ModelRef)
        if IsParamModelEqualToString(ModelRef, "revive_info") then
            local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                text:setAlpha(0)
                barBG:setAlpha(0)
                bar:setAlpha(0)
                timer:close()
                total_time_passed = 0
            else
                if NotifyData[2] == 0 then
                    revive_time = 3000
                else
                    revive_time = 1500
                end

                text:setAlpha(1)
                barBG:setAlpha(0.5)
                bar:setAlpha(1)
                
                timer = LUI.UITimer.newElementTimer(1, false, tick_fn)
                ReviveBar:addElement(timer)
            end
        end
    end
    ReviveBar:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", ReviveBarThink)

    --[[
 	local function NotificationImageShow(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_image_show") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            AbbeyNotificationImage:setImage( RegisterImage( NotificationImageLookup[NotifyData[1] + 1] ) )
            AbbeyNotificationImage:show()
        end
    end
	AbbeyNotificationImage:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationImageShow)

 	AbbeyNotification:addElement(AbbeyNotificationImage)

    
    local function NotificationTextShow(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_text_show") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            AbbeyNotificationText:setText( NotificationTextLookup[NotifyData[1] + 1] )
            AbbeyNotificationText:setLeftRight(true, false, 200 - math.floor(AbbeyNotificationText:getTextWidth() / 2), 200 + math.floor(AbbeyNotificationText:getTextWidth() / 2))
            AbbeyNotificationText:show()
        end
    end
	AbbeyNotificationText:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationTextShow)
 
 	AbbeyNotification:addElement(AbbeyNotificationText)
    -

    local function NotificationHide(ModelRef)
        if IsParamModelEqualToString(ModelRef, "notification_hide") then
            AbbeyNotificationImage:hide()
            AbbeyNotificationText:hide()
        end
    end
	AbbeyNotification:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NotificationHide)
    --]]
    return ReviveBar
end