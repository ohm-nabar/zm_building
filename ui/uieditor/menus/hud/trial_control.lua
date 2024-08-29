CoD.TrialControl = InheritFrom(LUI.UIElement)

function CoD.TrialControl.new(HudRef, InstanceRef)
    local TrialControl = LUI.UIElement.new()
    TrialControl:setClass(CoD.TrialControl)
    TrialControl:setLeftRight(true, true)
    TrialControl:setTopBottom(true, true)
    TrialControl.id = "TrialControl"
    TrialControl.soundSet = "default"

    local SoloIcon = LUI.UIImage.new()
    SoloIcon:setLeftRight(true, false, 120, 180)
    SoloIcon:setTopBottom(true, false, 26, 86)
    SoloIcon:setImage(RegisterImage("solo_trial_icon"))

    local SoloTrialText = LUI.UIText.new()
    SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_INACTVE"))
    SoloTrialText:setLeftRight(true, false, 185, 212)
    SoloTrialText:setTopBottom(true, false, 16, 43)
    SoloTrialText:setRGB(1, 1, 1)

    local SoloRewardText = LUI.UIText.new()
    SoloRewardText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_REWARD"))
    SoloRewardText:setLeftRight(true, false, 185, 212)
    SoloRewardText:setTopBottom(true, false, 46, 73)
    SoloRewardText:setRGB(1, 1, 1 )

    local SoloStatusText = LUI.UIText.new()
    SoloStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    SoloStatusText:setLeftRight(true, false, 185, 212)
    SoloStatusText:setTopBottom(true, false, 76, 96)
    SoloStatusText:setAlpha(0.9)
    SoloStatusText:setRGB(1, 0, 0)

    local SoloBackgroundCircle = LUI.UIImage.new()
    SoloBackgroundCircle:setLeftRight(true, false, 780, 830)
    SoloBackgroundCircle:setTopBottom(true, false, 16, 66)
    SoloBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    SoloBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    SoloBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    SoloBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local SoloProgressCircle = LUI.UIImage.new()
    SoloProgressCircle:setLeftRight(true, false, 780, 830)
    SoloProgressCircle:setTopBottom(true, false, 16, 66)
    SoloProgressCircle:setRGB(0.97, 0.79, 0.09)
    SoloProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    SoloProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    SoloProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local SoloProgressText = LUI.UIText.new()
    SoloProgressText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    SoloProgressText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_NO_REWARD"))
    SoloProgressText:setLeftRight(true, false, 751, 863)
    SoloProgressText:setTopBottom(true, false, 66, 86)
    SoloProgressText:setRGB(1, 0, 0)

    local SoloInfoText = LUI.UIText.new()
    SoloInfoText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_INFO"))
    SoloInfoText:setLeftRight(false, false)
    SoloInfoText:setTopBottom(true, false, 101, 128)
    SoloInfoText:setRGB(1, 1, 1)

 	local GumTable = {"t7_hud_zm_bgb_stock_option", "t7_hud_zm_bgb_sword_flay", "t7_hud_zm_bgb_temporal_gift", "t7_hud_zm_bgb_in_plain_sight", "t7_hud_zm_bgb_im_feelin_lucky", "t7_hud_zm_bgb_immolation_liquidation", "t7_hud_zm_bgb_phoenix_up", "t7_hud_zm_bgb_pop_shocks", "t7_hud_zm_bgb_cache_back", "t7_hud_zm_bgb_on_the_house", "t7_hud_zm_bgb_profit_sharing", "t7_hud_zm_bgb_wall_power", "t7_hud_zm_bgb_crate_power", "t7_hud_zm_bgb_unquenchable", "t7_hud_zm_bgb_alchemical_antithesis", "t7_hud_zm_bgb_perkaholic"}
    local GumNameTable = {Engine.Localize("ZM_ABBEY_BGB_STOCK_OPTION"), Engine.Localize("ZM_ABBEY_BGB_SWORD_FLAY"), Engine.Localize("ZM_ABBEY_BGB_TEMPORAL_GIFT"), Engine.Localize("ZM_ABBEY_BGB_IN_PLAIN_SIGHT"), Engine.Localize("ZM_ABBEY_BGB_IM_FEELIN_LUCKY"), Engine.Localize("ZM_ABBEY_BGB_IMMOLATION_LIQUIDATION"), Engine.Localize("ZM_ABBEY_BGB_PHOENIX_UP"), Engine.Localize("ZM_ABBEY_BGB_POP_SHOCKS"), Engine.Localize("ZM_ABBEY_BGB_CACHE_BACK"), Engine.Localize("ZM_ABBEY_BGB_ON_THE_HOUSE"), Engine.Localize("ZM_ABBEY_BGB_PROFIT_SHARING"), Engine.Localize("ZM_ABBEY_BGB_WALL_POWER"), Engine.Localize("ZM_ABBEY_BGB_CRATE_POWER"), Engine.Localize("ZM_ABBEY_BGB_UNQUENCHABLE"), Engine.Localize("ZM_ABBEY_BGB_ALCHEMICAL_ANTITHESIS"), Engine.Localize("ZM_ABBEY_BGB_PERKAHOLIC")}
    local QuantityTable = {1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ""}

 	local CurrentPackText = LUI.UIText.new()
    CurrentPackText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_PACK_NEXT"))
    CurrentPackText:setTopBottom(true, false, 138, 165)
    CurrentPackText:setLeftRight(true, false, 480 - math.floor(CurrentPackText:getTextWidth() / 2), 480 + math.floor(CurrentPackText:getTextWidth() / 2))
    CurrentPackText:setRGB(1, 1, 1)

    local CurrentCircle1 = LUI.UIImage.new()
    CurrentCircle1:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    CurrentCircle1:setTopBottom(true, false, 170, 235)
    CurrentCircle1:setLeftRight(true, false, 162, 227)

    local CurrentText1 = LUI.UIText.new()
    CurrentText1:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    CurrentText1:setTopBottom(true, false, 240, 260)
    CurrentText1:setLeftRight(true, false, 38, 350)
    CurrentText1:setRGB(1, 1, 1)

    local CurrentCircle2 = LUI.UIImage.new()
    CurrentCircle2:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    CurrentCircle2:setTopBottom(true, false, 170, 235)
    CurrentCircle2:setLeftRight(true, false, 305, 370)

    local CurrentText2 = LUI.UIText.new()
    CurrentText2:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    CurrentText2:setTopBottom(true, false, 240, 260)
    CurrentText2:setLeftRight(true, false, 181, 493)
    CurrentText2:setRGB(1, 1, 1)

    local CurrentCircle3 = LUI.UIImage.new()
    CurrentCircle3:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    CurrentCircle3:setTopBottom(true, false, 170, 235)
    CurrentCircle3:setLeftRight(true, false, 448, 513)

    local CurrentText3 = LUI.UIText.new()
    CurrentText3:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    CurrentText3:setTopBottom(true, false, 240, 260)
    CurrentText3:setLeftRight(true, false, 324, 636)
    CurrentText3:setRGB(1, 1, 1)

    local CurrentCircle4 = LUI.UIImage.new()
    CurrentCircle4:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    CurrentCircle4:setTopBottom(true, false, 170, 235)
    CurrentCircle4:setLeftRight(true, false, 591, 656)

    local CurrentText4 = LUI.UIText.new()
    CurrentText4:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    CurrentText4:setTopBottom(true, false, 240, 260)
    CurrentText4:setLeftRight(true, false, 467, 779)
    CurrentText4:setRGB(1, 1, 1)

    local CurrentCircle5 = LUI.UIImage.new()
    CurrentCircle5:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    CurrentCircle5:setTopBottom(true, false, 170, 235)
    CurrentCircle5:setLeftRight(true, false, 734, 799)

    local CurrentText5 = LUI.UIText.new()
    CurrentText5:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    CurrentText5:setTopBottom(true, false, 240, 260)
    CurrentText5:setLeftRight(true, false, 610, 922)
    CurrentText5:setRGB(1, 1, 1)

    local CurrentQuantity1 = LUI.UIText.new()
    CurrentQuantity1:setTopBottom(true, false, 161, 188)
    CurrentQuantity1:setLeftRight(true, false, 229 - CurrentQuantity1:getTextWidth(), 400)
    CurrentQuantity1:setRGB(1, 1, 1)

    local CurrentQuantity2 = LUI.UIText.new()
    CurrentQuantity2:setTopBottom(true, false, 161, 188)
    CurrentQuantity2:setLeftRight(true, false, 372 - CurrentQuantity1:getTextWidth(), 500)
    CurrentQuantity2:setRGB(1, 1, 1)

    local CurrentQuantity3 = LUI.UIText.new()
    CurrentQuantity3:setTopBottom(true, false, 161, 188)
    CurrentQuantity3:setLeftRight(true, false, 515 - CurrentQuantity1:getTextWidth(), 600)
    CurrentQuantity3:setRGB(1, 1, 1)

    local CurrentQuantity4 = LUI.UIText.new()
    CurrentQuantity4:setTopBottom(true, false, 161, 188)
    CurrentQuantity4:setLeftRight(true, false, 658 - CurrentQuantity1:getTextWidth(), 700)
    CurrentQuantity4:setRGB(1, 1, 1)

    local CurrentQuantity5 = LUI.UIText.new()
    CurrentQuantity5:setTopBottom(true, false, 161, 188)
    CurrentQuantity5:setLeftRight(true, false, 801 - CurrentQuantity1:getTextWidth(), 900)
    CurrentQuantity5:setRGB(1, 1, 1)

    local CurrentIndex1 = 1
    local CurrentIndex2 = 1
    local CurrentIndex3 = 1
    local CurrentIndex4 = 1
    local CurrentIndex5 = 1

    local NextPackText = LUI.UIText.new()
    NextPackText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_PACK_NEXT"))
    NextPackText:setTopBottom(true, false, 265, 292)
    NextPackText:setLeftRight(true, false, 480 - math.floor(NextPackText:getTextWidth() / 2), 480 + math.floor(NextPackText:getTextWidth() / 2))
    NextPackText:setRGB(1, 1, 1)

    local NextCircle1 = LUI.UIImage.new()
    NextCircle1:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    NextCircle1:setTopBottom(true, false, 297, 362)
    NextCircle1:setLeftRight(true, false, 162, 227)

    local NextText1 = LUI.UIText.new()
    NextText1:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    NextText1:setTopBottom(true, false, 365, 385)
    NextText1:setLeftRight(true, false, 38, 350)
    NextText1:setRGB(1, 1, 1)

    local NextCircle2 = LUI.UIImage.new()
    NextCircle2:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    NextCircle2:setTopBottom(true, false, 297, 362)
    NextCircle2:setLeftRight(true, false, 305, 370)

    local NextText2 = LUI.UIText.new()
    NextText2:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    NextText2:setTopBottom(true, false, 365, 385)
    NextText2:setLeftRight(true, false, 181, 493)
    NextText2:setRGB(1, 1, 1)

    local NextCircle3 = LUI.UIImage.new()
    NextCircle3:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    NextCircle3:setTopBottom(true, false, 297, 362)
    NextCircle3:setLeftRight(true, false, 448, 513)

    local NextText3 = LUI.UIText.new()
    NextText3:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    NextText3:setTopBottom(true, false, 365, 385)
    NextText3:setLeftRight(true, false, 324, 636)
    NextText3:setRGB(1, 1, 1)

    local NextCircle4 = LUI.UIImage.new()
    NextCircle4:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    NextCircle4:setTopBottom(true, false, 297, 362)
    NextCircle4:setLeftRight(true, false, 591, 656)

    local NextText4 = LUI.UIText.new()
    NextText4:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    NextText4:setTopBottom(true, false, 365, 385)
    NextText4:setLeftRight(true, false, 467, 779)
    NextText4:setRGB(1, 1, 1)

    local NextCircle5 = LUI.UIImage.new()
    NextCircle5:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))
    NextCircle5:setTopBottom(true, false, 297, 362)
    NextCircle5:setLeftRight(true, false, 734, 799)

    local NextText5 = LUI.UIText.new()
    NextText5:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    NextText5:setTopBottom(true, false, 365, 385)
    NextText5:setLeftRight(true, false, 610, 922)
    NextText5:setRGB(1, 1, 1)

    local NextQuantity1 = LUI.UIText.new()
    NextQuantity1:setTopBottom(true, false, 288, 315)
    NextQuantity1:setLeftRight(true, false, 229 - NextQuantity1:getTextWidth(), 400)
    NextQuantity1:setRGB(1, 1, 1)

    local NextQuantity2 = LUI.UIText.new()
    NextQuantity2:setTopBottom(true, false, 288, 315)
    NextQuantity2:setLeftRight(true, false, 372 - NextQuantity2:getTextWidth(), 500)
    NextQuantity2:setRGB(1, 1, 1)

    local NextQuantity3 = LUI.UIText.new()
    NextQuantity3:setTopBottom(true, false, 288, 315)
    NextQuantity3:setLeftRight(true, false, 515 - NextQuantity3:getTextWidth(), 600)
    NextQuantity3:setRGB(1, 1, 1)

    local NextQuantity4 = LUI.UIText.new()
    NextQuantity4:setTopBottom(true, false, 288, 315)
    NextQuantity4:setLeftRight(true, false, 658 - NextQuantity4:getTextWidth(), 700)
    NextQuantity4:setRGB(1, 1, 1)

    local NextQuantity5 = LUI.UIText.new()
    NextQuantity5:setTopBottom(true, false, 288, 315)
    NextQuantity5:setLeftRight(true, false, 801 - NextQuantity5:getTextWidth(), 900)
    NextQuantity5:setRGB(1, 1, 1)

    local NextIndex1 = 1
    local NextIndex2 = 1
    local NextIndex3 = 1
    local NextIndex4 = 1
    local NextIndex5 = 1

 	local function CurrentGGUpdate(ModelRef)
 		local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
 			if NotifyData < 16 then
 				CurrentIndex1 = NotifyData + 1
				CurrentCircle1:setImage(RegisterImage(GumTable[CurrentIndex1]))
				CurrentCircle1:setAlpha(1)
				CurrentQuantity1:setText(QuantityTable[CurrentIndex1])
                CurrentQuantity1:setLeftRight(true, false, 229 - CurrentQuantity1:getTextWidth(), 400)
                CurrentQuantity1:setRGB(1, 1, 1)
                if QuantityTable[CurrentIndex1] == 0 then
                    CurrentQuantity1:setRGB(1, 0, 0)
                end
                CurrentText1:setText(GumNameTable[CurrentIndex1])
 			elseif NotifyData < 32 then
 				CurrentIndex2 = NotifyData - 15
				CurrentCircle2:setImage(RegisterImage(GumTable[CurrentIndex2]))
				CurrentCircle2:setAlpha(1)
				CurrentQuantity2:setText(QuantityTable[CurrentIndex2])
				CurrentQuantity2:setLeftRight(true, false, 372 - CurrentQuantity1:getTextWidth(), 500)
                CurrentQuantity2:setRGB(1, 1, 1)
                if QuantityTable[CurrentIndex2] == 0 then
                    CurrentQuantity2:setRGB(1, 0, 0)
                end
                CurrentText2:setText(GumNameTable[CurrentIndex2])
			elseif NotifyData < 48 then
 				CurrentIndex3 = NotifyData - 31
				CurrentCircle3:setImage(RegisterImage(GumTable[CurrentIndex3]))
				CurrentCircle3:setAlpha(1)
				CurrentQuantity3:setText(QuantityTable[CurrentIndex3])
				CurrentQuantity3:setLeftRight(true, false, 515 - CurrentQuantity3:getTextWidth(), 600)
                CurrentQuantity3:setRGB(1, 1, 1)
                if QuantityTable[CurrentIndex3] == 0 then
                    CurrentQuantity3:setRGB(1, 0, 0)
                end
                CurrentText3:setText(GumNameTable[CurrentIndex3])
			elseif NotifyData < 64 then
 				CurrentIndex4 = NotifyData - 47
				CurrentCircle4:setImage(RegisterImage(GumTable[CurrentIndex4]))
				CurrentCircle4:setAlpha(1)
				CurrentQuantity4:setText(QuantityTable[CurrentIndex4])
				CurrentQuantity4:setLeftRight(true, false, 658 - CurrentQuantity4:getTextWidth(), 700)
                CurrentQuantity4:setRGB(1, 1, 1)
                if QuantityTable[CurrentIndex4] == 0 then
                    CurrentQuantity4:setRGB(1, 0, 0)
                end
                CurrentText4:setText(GumNameTable[CurrentIndex4])
			else
				CurrentIndex5 = NotifyData - 63
				CurrentCircle5:setImage(RegisterImage(GumTable[CurrentIndex5]))
				CurrentCircle5:setAlpha(1)
				CurrentQuantity5:setText(QuantityTable[CurrentIndex5])
				CurrentQuantity5:setLeftRight(true, false, 801 - CurrentQuantity5:getTextWidth(), 900)
                CurrentQuantity5:setRGB(1, 1, 1)
                if QuantityTable[CurrentIndex5] == 0 then
                    CurrentQuantity5:setRGB(1, 0, 0)
                end
                CurrentText5:setText(GumNameTable[CurrentIndex5])
 			end
 		end
 	end
 	TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "currentGGUpdate"), CurrentGGUpdate)

 	local function NextGGUpdate(ModelRef)
 		local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
 			if NotifyData < 16 then
 				NextIndex1 = NotifyData + 1
				NextCircle1:setImage(RegisterImage(GumTable[NextIndex1]))
				NextQuantity1:setText(QuantityTable[NextIndex1])
				NextQuantity1:setLeftRight(true, false, 229 - NextQuantity1:getTextWidth(), 400)
                NextQuantity1:setRGB(1, 1, 1)
                if QuantityTable[NextIndex1] == 0 then
                    NextQuantity1:setRGB(1, 0, 0)
                end
                NextText1:setText(GumNameTable[NextIndex1])
 			elseif NotifyData < 32 then
 				NextIndex2 = NotifyData - 15
				NextCircle2:setImage(RegisterImage(GumTable[NextIndex2]))
				NextQuantity2:setText(QuantityTable[NextIndex2])
				NextQuantity2:setLeftRight(true, false, 372 - NextQuantity2:getTextWidth(), 500)
                NextQuantity2:setRGB(1, 1, 1)
                if QuantityTable[NextIndex2] == 0 then
                    NextQuantity2:setRGB(1, 0, 0)
                end
                NextText2:setText(GumNameTable[NextIndex2])
			elseif NotifyData < 48 then
 				NextIndex3 = NotifyData - 31
				NextCircle3:setImage(RegisterImage(GumTable[NextIndex3]))
				NextQuantity3:setText(QuantityTable[NextIndex3])
				NextQuantity3:setLeftRight(true, false, 515 - NextQuantity3:getTextWidth(), 600)
                NextQuantity3:setRGB(1, 1, 1)
                if QuantityTable[NextIndex3] == 0 then
                    NextQuantity3:setRGB(1, 0, 0)
                end
                NextText3:setText(GumNameTable[NextIndex3])
			elseif NotifyData < 64 then
 				NextIndex4 = NotifyData - 47
				NextCircle4:setImage(RegisterImage(GumTable[NextIndex4]))
				NextQuantity4:setText(QuantityTable[NextIndex4])
				NextQuantity4:setLeftRight(true, false, 658 - NextQuantity4:getTextWidth(), 700)
                NextQuantity4:setRGB(1, 1, 1)
                if QuantityTable[NextIndex4] == 0 then
                    NextQuantity4:setRGB(1, 0, 0)
                end
                NextText4:setText(GumNameTable[NextIndex4])
			else
				NextIndex5 = NotifyData - 63
				NextCircle5:setImage(RegisterImage(GumTable[NextIndex5]))
				NextQuantity5:setText(QuantityTable[NextIndex5])
				NextQuantity5:setLeftRight(true, false, 801 - NextQuantity5:getTextWidth(), 900)
                NextQuantity5:setRGB(1, 1, 1)
                if QuantityTable[NextIndex5] == 0 then
                    NextQuantity5:setRGB(1, 0, 0)
                end
                NextText5:setText(GumNameTable[NextIndex5])
 			end
 		end
 	end
 	TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "nextGGUpdate"), NextGGUpdate)

    local FadedFlag = false
 	local function CurrentGGFaded(ModelRef)
        if not FadedFlag then
            FadedFlag = true
            return
        end
 		local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
 			if NotifyData == 0 then
				CurrentCircle1:setAlpha(0.5)
 			elseif NotifyData == 1 then
 				CurrentCircle2:setAlpha(0.5)
			elseif NotifyData == 2 then
 				CurrentCircle3:setAlpha(0.5)
			elseif NotifyData == 3 then
 				CurrentCircle4:setAlpha(0.5)
			else
				CurrentCircle5:setAlpha(0.5)
 			end
 		end
 	end
 	TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "currentGGFaded"), CurrentGGFaded)

    local function QuantityUpdate()
        CurrentQuantity1:setText(QuantityTable[CurrentIndex1])
        CurrentQuantity1:setLeftRight(true, false, 229 - CurrentQuantity1:getTextWidth(), 400)
        CurrentQuantity1:setRGB(1, 1, 1)
        if QuantityTable[CurrentIndex1] == 0 then
            CurrentQuantity1:setRGB(1, 0, 0)
        end
        
        CurrentQuantity2:setText(QuantityTable[CurrentIndex2])
        CurrentQuantity2:setLeftRight(true, false, 372 - CurrentQuantity1:getTextWidth(), 500)
        CurrentQuantity2:setRGB(1, 1, 1)
        if QuantityTable[CurrentIndex2] == 0 then
            CurrentQuantity2:setRGB(1, 0, 0)
        end

        CurrentQuantity3:setText(QuantityTable[CurrentIndex3])
        CurrentQuantity3:setLeftRight(true, false, 515 - CurrentQuantity3:getTextWidth(), 600)
        CurrentQuantity3:setRGB(1, 1, 1)
        if QuantityTable[CurrentIndex3] == 0 then
            CurrentQuantity3:setRGB(1, 0, 0)
        end

        CurrentQuantity4:setText(QuantityTable[CurrentIndex4])
        CurrentQuantity4:setLeftRight(true, false, 658 - CurrentQuantity4:getTextWidth(), 700)
        CurrentQuantity4:setRGB(1, 1, 1)
        if QuantityTable[CurrentIndex4] == 0 then
            CurrentQuantity4:setRGB(1, 0, 0)
        end

        CurrentQuantity5:setText(QuantityTable[CurrentIndex5])
        CurrentQuantity5:setLeftRight(true, false, 801 - CurrentQuantity5:getTextWidth(), 900)
        CurrentQuantity5:setRGB(1, 1, 1)
        if QuantityTable[CurrentIndex5] == 0 then
            CurrentQuantity5:setRGB(1, 0, 0)
        end
        
        NextQuantity1:setText(QuantityTable[NextIndex1])
        NextQuantity1:setLeftRight(true, false, 229 - NextQuantity1:getTextWidth(), 400)
        NextQuantity1:setRGB(1, 1, 1)
        if QuantityTable[NextIndex1] == 0 then
            NextQuantity1:setRGB(1, 0, 0)
        end

        NextQuantity2:setText(QuantityTable[NextIndex2])
        NextQuantity2:setLeftRight(true, false, 372 - NextQuantity2:getTextWidth(), 500)
        NextQuantity2:setRGB(1, 1, 1)
        if QuantityTable[NextIndex2] == 0 then
            NextQuantity2:setRGB(1, 0, 0)
        end

        NextQuantity3:setText(QuantityTable[NextIndex3])
        NextQuantity3:setLeftRight(true, false, 515 - NextQuantity3:getTextWidth(), 600)
        NextQuantity3:setRGB(1, 1, 1)
        if QuantityTable[NextIndex3] == 0 then
            NextQuantity3:setRGB(1, 0, 0)
        end

        NextQuantity4:setText(QuantityTable[NextIndex4])
        NextQuantity4:setLeftRight(true, false, 658 - NextQuantity4:getTextWidth(), 700)
        NextQuantity4:setRGB(1, 1, 1)
        if QuantityTable[NextIndex4] == 0 then
            NextQuantity4:setRGB(1, 0, 0)
        end

        NextQuantity5:setText(QuantityTable[NextIndex5])
        NextQuantity5:setLeftRight(true, false, 801 - NextQuantity5:getTextWidth(), 900)
        NextQuantity5:setRGB(1, 1, 1)
        if QuantityTable[NextIndex5] == 0 then
            NextQuantity5:setRGB(1, 0, 0)
        end
    end

    local EatenFlag = false
 	local function GGEaten(ModelRef)
        if not EatenFlag then
            EatenFlag = true
            return
        end
 		local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
            if QuantityTable[NotifyData + 1] ~= "" then
                QuantityTable[NotifyData + 1] = QuantityTable[NotifyData + 1] - 1
                QuantityUpdate()
            end
 		end
 	end
 	TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "GGEaten"), GGEaten)
    
    local function TrialProgress(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            SoloProgressCircle:setShaderVector(0, NotifyData, 1, 1, 1)
        end
 	end
 	TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trialProgress"), TrialProgress)
    
    local function TrialReward(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                SoloProgressText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_NO_REWARD"))
                SoloProgressText:setRGB(1, 0, 0)
            elseif NotifyData == 1 then
                SoloProgressText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_YES_REWARD"))
                SoloProgressText:setRGB(0, 1, 0)
                for i=1,table.getn(QuantityTable) - 1 do 
                    if QuantityTable[i] ~= "" then
                        QuantityTable[i] = QuantityTable[i] + 2
                    end
                end
                QuantityUpdate()
            end
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trialReward"), TrialReward)
    
    local TotalSeconds = 90
    
    local function ClockTime()
        local Minutes = math.floor(TotalSeconds / 60)
        local Seconds = TotalSeconds % 60
        if Seconds < 10 then
            Seconds = "0" .. Seconds 
        end
        return Minutes .. ":" .. Seconds
    end

    local function TrialTimer(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                SoloStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
                SoloStatusText:setRGB(1, 0, 0)
            elseif NotifyData == 1 then
                TotalSeconds = TotalSeconds - 1
                SoloStatusText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_TIMER") .. ClockTime())
                SoloStatusText:setRGB(0, 1, 0)
            end
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trialTimer"), TrialTimer)
    
    local WallbuyTable = {"Sten Mk. IV", "Thompson M1A1", "Type 11", "BAR", "M1897 Trench Gun", "StG-44", "Double Barreled Shotgun", "MAS 38"}
    local RoomTable = {Engine.Localize("ZM_ABBEY_ROOM_SPAWN_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_STAMINARCH"), Engine.Localize("ZM_ABBEY_ROOM_WATER_TOWER"), Engine.Localize("ZM_ABBEY_ROOM_CLEAN_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_LION_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_DOWNSTAIRS_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_SPAWN_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_STAMINARCH"), Engine.Localize("ZM_ABBEY_ROOM_WATER_TOWER"), Engine.Localize("ZM_ABBEY_ROOM_CLEAN_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_LION_ROOM"), Engine.Localize("ZM_ABBEY_ROOM_DOWNSTAIRS_ROOM")}
    local ClassTable = {"Pistols", "Submachine Guns", "Assault Rifles", "Light Machine Guns"}

    local function TrialName(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_INACTIVE"))
            elseif NotifyData < 11 then
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_WALLBUY") .. WallbuyTable[NotifyData])
                TotalSeconds = 150
            elseif NotifyData < 21 then
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_ADEFENSE") .. RoomTable[NotifyData - 10])
                TotalSeconds = 90
            elseif NotifyData < 31 then
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_AASSAULT") .. RoomTable[NotifyData - 20])
                TotalSeconds = 90
            elseif NotifyData < 35 then
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_CLASS") .. ClassTable[NotifyData - 30])
                TotalSeconds = 90
            elseif NotifyData < 36 then
                TotalSeconds = 90
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_HEADSHOT"))
            elseif NotifyData < 37 then
                TotalSeconds = 150
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_BOX"))
            else
                TotalSeconds = 90
                SoloTrialText:setText(Engine.Localize("ZM_ABBEY_TRIAL_DESC_ELEVATION"))
            end

            local width = math.max(SoloTrialText:getTextWidth(), SoloRewardText:getTextWidth())
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trialName"), TrialName)
    
    local function ResetQuantities(ModelRef)
        if IsParamModelEqualToString(ModelRef, "GGReset") then
            QuantityTable = {1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ""}
            QuantityUpdate()
        end
    end
    TrialControl:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", ResetQuantities)
    
    TrialControl:addElement(SoloIcon)
    TrialControl:addElement(SoloTrialText)
    TrialControl:addElement(SoloRewardText)
    TrialControl:addElement(SoloStatusText)
    TrialControl:addElement(SoloBackgroundCircle)
    TrialControl:addElement(SoloProgressCircle)
    TrialControl:addElement(SoloProgressText)
    TrialControl:addElement(SoloInfoText)

    TrialControl:addElement(CurrentPackText)
    TrialControl:addElement(CurrentCircle1)
    TrialControl:addElement(CurrentCircle2)
    TrialControl:addElement(CurrentCircle3)
    TrialControl:addElement(CurrentCircle4)
    TrialControl:addElement(CurrentCircle5)

    TrialControl:addElement(CurrentText1)
    TrialControl:addElement(CurrentText2)
    TrialControl:addElement(CurrentText3)
    TrialControl:addElement(CurrentText4)
    TrialControl:addElement(CurrentText5)

    TrialControl:addElement(CurrentQuantity1)
    TrialControl:addElement(CurrentQuantity2)
    TrialControl:addElement(CurrentQuantity3)
    TrialControl:addElement(CurrentQuantity4)
    TrialControl:addElement(CurrentQuantity5)

    TrialControl:addElement(NextPackText)
    TrialControl:addElement(NextCircle1)
    TrialControl:addElement(NextCircle2)
    TrialControl:addElement(NextCircle3)
    TrialControl:addElement(NextCircle4)
    TrialControl:addElement(NextCircle5)

    TrialControl:addElement(NextText1)
    TrialControl:addElement(NextText2)
    TrialControl:addElement(NextText3)
    TrialControl:addElement(NextText4)
    TrialControl:addElement(NextText5)

    TrialControl:addElement(NextQuantity1)
    TrialControl:addElement(NextQuantity2)
    TrialControl:addElement(NextQuantity3)
    TrialControl:addElement(NextQuantity4)
    TrialControl:addElement(NextQuantity5)

    return TrialControl
end