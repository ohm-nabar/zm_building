CoD.TrialControl = InheritFrom(LUI.UIElement)

function CoD.TrialControl.new(HudRef, InstanceRef)
    local TrialControl = LUI.UIElement.new()
    TrialControl:setClass(CoD.TrialControl)
    TrialControl:setLeftRight(true, true)
    TrialControl:setTopBottom(true, true)
    TrialControl.id = "TrialControl"
    TrialControl.soundSet = "default"

    local IconWidth = 69
    local NameTextWidth = 100
    local TrialTextWidth = 550
    local PBWidth = 125
    local GumWidth = 50
    local QuantityWidth = 20
    local TextWidth = 150
    local DividerWidth = 962

    local IconStartX = 16
    local NameTextStartX = 14
    local TrialTextStartX = 206
    local PBStartX = IconStartX + IconWidth - 5
    local GumStartX = PBStartX + PBWidth - 4
    local QuantityStartX = GumStartX + GumWidth - 7 -- (0.42 * getTextWidth) - 13.68
    local TextStartX = GumStartX + (GumWidth / 2) - (TextWidth / 2)
    local XOffset = PBWidth + GumWidth - 6
    local DividerStartX = 0

    local IconHeight = 60
    local NameTextHeight = 21
    local TrialTextHeight = NameTextHeight
    local PBHeight = 5
    local GumHeight = GumWidth
    local QuantityHeight = 18
    local TextHeight = 17
    local DividerHeight = 1

    local IconStartY = 30
    local NameTextStartY = 5
    local TrialTextStartY = NameTextStartY
    local PBStartY = IconStartY + (IconHeight / 3)
    local GumStartY = PBStartY + (PBHeight / 2) - (GumHeight / 2)
    local QuantityStartY = GumStartY - 5
    local TextStartY = GumStartY + GumHeight + 1
    local DividerStartY = TextStartY + TextHeight + 1
    local YOffset = 95

    local IconTable = {}
    local NameTextTable = {}
    local TrialTextTable = {}
    local PBBTable = {}
    local PBTable = {}
    local GumTable = {}
    local QuantityTable = {}
    local TextTable = {}
    local DividerTable = {}

    local IconLeft = IconStartX -- yes i know it's redundant i just want to keep the pattern up
    local IconRight = IconLeft + IconWidth

    local NameTextLeft = NameTextStartX -- same here
    local NameTextRight = NameTextLeft + NameTextWidth

    local TrialTextLeft = TrialTextStartX -- same here
    local TrialTextRight = TrialTextLeft + TrialTextWidth

    local DividerLeft = DividerStartX -- same here
    local DividerRight = DividerLeft + DividerWidth

    for i=1,4 do
        local IconTop = IconStartY + (YOffset * (i - 1))
        local IconBottom = IconTop + IconHeight

        local NameTextTop = NameTextStartY + (YOffset * (i - 1))
        local NameTextBottom = NameTextTop + NameTextHeight

        local TrialTextTop = TrialTextStartY + (YOffset * (i - 1))
        local TrialTextBottom = TrialTextTop + TrialTextHeight

        local PBTop = PBStartY + (YOffset * (i - 1))
        local PBBottom = PBTop + PBHeight

        local GumTop = GumStartY + (YOffset * (i - 1))
        local GumBottom = GumTop + GumHeight

        local QuantityTop = QuantityStartY + (YOffset * (i - 1))
        local QuantityBottom = QuantityTop + QuantityHeight

        local TextTop = TextStartY + (YOffset * (i - 1))
        local TextBottom = TextTop + TextHeight

        local DividerTop = DividerStartY + (YOffset * (i - 1))
        local DividerBottom = DividerTop + DividerHeight

        local Icon = LUI.UIImage.new()
        Icon:setLeftRight(true, false, IconLeft, IconRight)
        Icon:setTopBottom(true, false, IconTop, IconBottom)
        Icon:setImage(RegisterImage("solo_trial_icon"))

        local NameText = LUI.UIText.new()
        NameText:setLeftRight(true, false, NameTextLeft, NameTextRight)
        NameText:setTopBottom(true, false, NameTextTop, NameTextBottom)
        NameText:setText(Engine.Localize("Judge D'Artagnan"))
        NameText:setRGB(1, 1, 1)

        local TrialText = LUI.UIText.new()
        TrialText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
        TrialText:setLeftRight(true, false, TrialTextLeft, TrialTextRight)
        TrialText:setTopBottom(true, false, TrialTextTop, TrialTextBottom)
        TrialText:setText(Engine.Localize("Complete Rounds"))
        TrialText:setRGB(1, 1, 1)
        TrialText:setTTF("fonts/CaslonAntique-Bold.ttf")

        local Divider = LUI.UIImage.new()
        Divider:setLeftRight(true, false, DividerLeft, DividerRight)
        Divider:setTopBottom(true, false, DividerTop, DividerBottom)
        Divider:setRGB(1, 1, 1)

        IconTable[i] = Icon
        NameTextTable[i] = NameText
        TrialTextTable[i] = TrialText
        PBBTable[i] = {}
        PBTable[i] = {}
        GumTable[i] = {}
        QuantityTable[i] = {}
        TextTable[i] = {}
        DividerTable[i] = Divider

        TrialControl:addElement(IconTable[i])
        TrialControl:addElement(NameTextTable[i])
        TrialControl:addElement(TrialTextTable[i])
        TrialControl:addElement(DividerTable[i])

        for j=1,5 do
            local PBLeft = PBStartX + (XOffset * (j - 1))
            local PBRight = PBLeft + PBWidth

            local GumLeft = GumStartX + (XOffset * (j - 1))
            local GumRight = GumLeft + GumWidth

            local TextLeft = TextStartX + (XOffset * (j - 1))
            local TextRight = TextLeft + TextWidth

            local ProgressBarBackground = LUI.UIImage.new()
            ProgressBarBackground:setLeftRight(true, false, PBLeft, PBRight)
            ProgressBarBackground:setTopBottom(true, false, PBTop, PBBottom)
            ProgressBarBackground:setRGB(0.75, 0.75, 0.75)

            local ProgressBar = LUI.UIImage.new()
            ProgressBar:setLeftRight(true, false, PBLeft, PBRight)
            ProgressBar:setTopBottom(true, false, PBTop, PBBottom)
            ProgressBar:setImage(RegisterImage("uie_t7_my_fancy_image"))
            ProgressBar:setMaterial(RegisterMaterial("uie_wipe_normal"))
            ProgressBar:setRGB(0.97, 0.79, 0.09)
            ProgressBar:setShaderVector(1, 0, 0, 0, 0)
            ProgressBar:setShaderVector(2, 1, 0, 0, 0)
            ProgressBar:setShaderVector(3, 0, 0, 0, 0)

            local Gum = LUI.UIImage.new()
            Gum:setLeftRight(true, false, GumLeft, GumRight)
            Gum:setTopBottom(true, false, GumTop, GumBottom)
            Gum:setImage(RegisterImage("t7_hud_zm_bgb_immolation_liquidation"))

            local Text = LUI.UIText.new()
            Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
            Text:setLeftRight(true, false, TextLeft, TextRight)
            Text:setTopBottom(true, false, TextTop, TextBottom)
            Text:setRGB(1, 1, 1)
            Text:setText("Immolation Liquidation")

            PBBTable[i][j] = ProgressBarBackground
            PBTable[i][j] = ProgressBar
            GumTable[i][j] = Gum
            TextTable[i][j] = Text

            TrialControl:addElement(PBBTable[i][j])
            TrialControl:addElement(PBTable[i][j])
            TrialControl:addElement(GumTable[i][j])
            TrialControl:addElement(TextTable[i][j])

            if j < 5 then
                local QuantityLeft = QuantityStartX + (XOffset * (j - 1))
                local QuantityRight = QuantityLeft + QuantityWidth

                local Quantity = LUI.UIText.new()
                Quantity:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
                Quantity:setLeftRight(true, false, QuantityLeft, QuantityRight)
                Quantity:setTopBottom(true, false, QuantityTop, QuantityBottom)
                Quantity:setRGB(1, 1, 1)
                Quantity:setText("99")
                
                QuantityTable[i][j] = Quantity

                TrialControl:addElement(QuantityTable[i][j])
            end
        end
    end

    for i=1,4 do
        GumTable[i][5]:setImage(RegisterImage("t7_hud_zm_bgb_im_feelin_lucky"))
        TextTable[i][5]:setText("Random GargoyleGum")
    end

    NameTextTable[1]:setText("Judge Aramis")
    NameTextTable[2]:setText("Judge Porthos")
    NameTextTable[3]:setText("Judge D'Artagnan")
    NameTextTable[4]:setText("Judge Athos")

    TrialTextTable[1]:setText("Complete Rounds")
    TrialTextTable[2]:setText("Obtain Headshot Kills")
    TrialTextTable[3]:setText("Obtain Melee Kills")
    TrialTextTable[4]:setText("Unknown Trial")

    local Tier1GumLookup = {"t7_hud_zm_bgb_stock_option", "t7_hud_zm_bgb_sword_flay", "t7_hud_zm_bgb_temporal_gift", "t7_hud_zm_bgb_in_plain_sight", "t7_hud_zm_bgb_im_feelin_lucky"}
    local Tier2GumLookup = {"t7_hud_zm_bgb_immolation_liquidation", "t7_hud_zm_bgb_pop_shocks", "t7_hud_zm_bgb_challenge_rejected", "t7_hud_zm_bgb_flavor_hexed", "t7_hud_zm_bgb_crate_power", "t7_hud_zm_bgb_aftertaste_blood", "t7_hud_zm_bgb_extra_credit"}
    local Tier3GumLookup = {"t7_hud_zm_bgb_on_the_house", "t7_hud_zm_bgb_unquenchable", "t7_hud_zm_bgb_head_drama", "t7_hud_zm_bgb_alchemical_antithesis"}
    local TierGumLookup = {Tier1GumLookup, Tier2GumLookup, Tier3GumLookup}

    local Tier1TextLookup = {"ZMUI_BGB_STOCK_OPTION", "ZMUI_BGB_SWORD_FLAY", "ZMUI_BGB_TEMPORAL_GIFT", "ZMUI_BGB_IN_PLAIN_SIGHT", "ZMUI_BGB_IM_FEELIN_LUCKY"}
    local Tier2TextLookup = {"ZMUI_BGB_IMMOLATION_LIQUIDATION", "ZMUI_BGB_POP_SHOCKS", "ZMUI_BGB_CHALLENGE_REJECTED", "ZMUI_BGB_FLAVOR_HEXED", "ZMUI_BGB_CRATE_POWER", "ZMUI_BGB_AFTERTASTE_BLOOD", "ZMUI_BGB_EXTRA_CREDIT"}
    local Tier3TextLookup = {"ZMUI_BGB_ON_THE_HOUSE", "ZMUI_BGB_UNQUENCHABLE", "ZMUI_BGB_HEAD_DRAMA", "ZMUI_BGB_ALCHEMICAL_ANTITHESIS"}
    local TierTextLookup = {Tier1TextLookup, Tier2TextLookup, Tier3TextLookup}

    for i=1,#TierGumLookup do
        for j=1,#TierGumLookup[i] do
            TierGumLookup[i][j] = RegisterImage(TierGumLookup[i][j])
            TierTextLookup[i][j] = Engine.Localize(TierTextLookup[i][j])
        end
    end

    local Tier1Gum = { GumTable[1][1], GumTable[1][2], GumTable[1][3], GumTable[2][1], GumTable[3][1] }
    local Tier2Gum = { GumTable[1][4], GumTable[2][2], GumTable[2][3], GumTable[3][2], GumTable[3][3], GumTable[4][1], GumTable[4][2] }
    local Tier3Gum = { GumTable[2][4], GumTable[3][4], GumTable[4][3], GumTable[4][4] }
    local TierGum = {Tier1Gum, Tier2Gum, Tier3Gum}

    local Tier1Text = { TextTable[1][1], TextTable[1][2], TextTable[1][3], TextTable[2][1], TextTable[3][1] }
    local Tier2Text = { TextTable[1][4], TextTable[2][2], TextTable[2][3], TextTable[3][2], TextTable[3][3], TextTable[4][1], TextTable[4][2] }
    local Tier3Text = { TextTable[2][4], TextTable[3][4], TextTable[4][3], TextTable[4][4] }
    local TierText = {Tier1Text, Tier2Text, Tier3Text}

    local Tier1Quantity = { QuantityTable[1][1], QuantityTable[1][2], QuantityTable[1][3], QuantityTable[2][1], QuantityTable[3][1] }
    local Tier2Quantity = { QuantityTable[1][4], QuantityTable[2][2], QuantityTable[2][3], QuantityTable[3][2], QuantityTable[3][3], QuantityTable[4][1], QuantityTable[4][2] }
    local Tier3Quantity = { QuantityTable[2][4], QuantityTable[3][4], QuantityTable[4][3], QuantityTable[4][4] }
    local TierQuantity = {Tier1Quantity, Tier2Quantity, Tier3Quantity}

    local CurrentIndices = {1, 1, 1, 1}

    local ExtraCreditIndex = 1
    local HeadDramaIndex = 1
    
    local function SetQuantityLR(i, j)
        local QuantityLeft = GumStartX + GumWidth + (0.42 * QuantityTable[i][j]:getTextWidth()) - 13.68 + (XOffset * (j - 1))
        local QuantityRight = QuantityLeft + QuantityWidth
        QuantityTable[i][j]:setLeftRight(true, false, QuantityLeft, QuantityRight)
    end
    
    local function ResetQuantity(i, j)
        QuantityTable[i][j]:setText("0")
        QuantityTable[i][j]:setRGB(1, 0, 0)
        SetQuantityLR(i, j)
    end

    local function IncrementQuantity(i, j)
        QuantityTable[i][j]:setText(QuantityTable[i][j]:getText() + 1)
        QuantityTable[i][j]:setRGB(1, 1, 1)
        SetQuantityLR(i, j)
    end

    local function DecrementQuantity(i, j)
        QuantityTable[i][j]:setText(QuantityTable[i][j]:getText() - 1)
        if tonumber(QuantityTable[i][j]:getText()) == 0 then
            QuantityTable[i][j]:setRGB(1, 0, 0)
        end
        SetQuantityLR(i, j)
    end

    local function SetGum(Factoradic, Tier)
        local PermTable = {}

        local N = #TierGum[Tier]
        local Quotient = Factoradic

        for i=1,N do
            local TableIndex = (N - i) + 1
            PermTable[TableIndex] = Quotient % i
            Quotient = math.floor(Quotient / i)
        end

        for i=1,(N-1) do
            local TableIndex = N - i
            for j=(TableIndex+1),N do
                if PermTable[j] >= PermTable[TableIndex] then
                    PermTable[j] = PermTable[j] + 1
                end
            end
        end

        for i=1,N do
            local TableVal = PermTable[i] + 1
            if Tier == 2 and TableVal == 7 then
                ExtraCreditIndex = i
            elseif Tier == 3 and TableVal == 3 then
                HeadDramaIndex = i
            end
            TierGum[Tier][i]:setImage(TierGumLookup[Tier][TableVal])
            TierText[Tier][i]:setText(TierTextLookup[Tier][TableVal])
            TierQuantity[Tier][i]:setText("0")
            TierQuantity[Tier][i]:setRGB(1, 0, 0)
        end
    end
    
    local function SetTier1Gum(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 0 then
            SetGum(NotifyData, 1)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.tier1"), SetTier1Gum)
    
    local function SetTier2Gum(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        
        if NotifyData and NotifyData >= 0 then
            SetGum(NotifyData, 2)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.tier2"), SetTier2Gum)

    local function SetTier3Gum(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 0 then
            SetGum(NotifyData, 3)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.tier3"), SetTier3Gum)
    
    local AthosRounds = 1
    local AthosRoundsString = ""
    local AthosTrialString = "Unknown Trial"

    local function GargoyleProgress(GargNum, NotifyData)
        if NotifyData == -1 then
            CurrentIndices[GargNum] = 1

            for i=1,#PBTable[GargNum] do
                PBTable[GargNum][i]:setShaderVector(0, 0, 0, 0, 0)
            end

            for i=1,#QuantityTable[GargNum] do
                ResetQuantity(GargNum, i)
            end

            AthosRounds = 1
            AthosRoundsString = ""
            AthosTrialString = "Unknown Trial"
        elseif NotifyData == 1 then
            local CurrentIndex = CurrentIndices[GargNum]
            if CurrentIndex >= #GumTable[GargNum] then
                PBTable[GargNum][CurrentIndex]:setShaderVector(0, 0, 0, 0, 0)
            else
                PBTable[GargNum][CurrentIndex]:setShaderVector(0, 1, 0, 0, 0)
                IncrementQuantity(GargNum, CurrentIndex)
                CurrentIndices[GargNum] = CurrentIndices[GargNum] + 1
            end
        else
            local CurrentIndex = CurrentIndices[GargNum]
            PBTable[GargNum][CurrentIndex]:setShaderVector(0, NotifyData, 0, 0, 0)
        end
    end

    local function AramisProgress(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            GargoyleProgress(1, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.aramis"), AramisProgress)

    local function PorthosProgress(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            GargoyleProgress(2, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.porthos"), PorthosProgress)

    local function DartProgress(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            GargoyleProgress(3, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.dart"), DartProgress)

    local function AthosProgress(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            GargoyleProgress(4, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.athos"), AthosProgress)

    local function AramisRandom(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 1 and NotifyData <= 4 then
            IncrementQuantity(1, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.aramisRandom"), AramisRandom)

    local function PorthosRandom(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 1 and NotifyData <= 4 then
            IncrementQuantity(2, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.porthosRandom"), PorthosRandom)

    local function DartRandom(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 1 and NotifyData <= 4 then
            IncrementQuantity(3, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.dartRandom"), DartRandom)

    local function AthosRandom(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 1 and NotifyData <= 4 then
            IncrementQuantity(4, NotifyData)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.athosRandom"), AthosRandom)
    
    local function GumEaten(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData > 0  then
            local Val = NotifyData - 1
            local GargNum = math.floor(Val / 4) + 1
            local Index = (Val % 4) + 1
            DecrementQuantity(GargNum, Index)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "gumEaten"), GumEaten)

    local WallbuyTable = {"Kar98k", "Gewehr 43", "M1 Garand", "Trench Gun", "MP40", "Double Barreled Shotgun", "Sten Mk. IV", "MAS-38", "Thompson M1A1", "StG-44", "SVT-40", "BAR", "Type 11"}
    
    local AthosPrompt = LUI.UIText.new()
    AthosPrompt:setText(Engine.Localize("^3[{+activate}]^7 Toggle Athos Waypoint"))
    AthosPrompt:setLeftRight(true, false, 350, 450)
    AthosPrompt:setTopBottom(true, false, 395, 415)
    AthosPrompt:setAlpha(0.9)
    AthosPrompt:setRGB(1, 1, 1)

    TrialControl:addElement(AthosPrompt)
    TrialControl.AthosPrompt = AthosPrompt

    local function AthosTrialUpdate(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData <= 1 then
                AthosRounds = NotifyData + 1
                if AthosRounds > 1 then
                    AthosRoundsString = " (New Trial in " .. AthosRounds .. " Rounds)"
                else
                    AthosRoundsString = " (New Trial in " .. AthosRounds .. " Round)"
                end
            else
                AthosRounds = 3
                AthosRoundsString = " (New Trial in " .. AthosRounds .. " Rounds)"
                if NotifyData >= 2 and NotifyData <= 14 then
                    AthosTrialString = "Obtain kills with the " .. WallbuyTable[NotifyData - 1]
                end
            end
            TrialTextTable[4]:setText(AthosTrialString .. AthosRoundsString)
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "athosTrial"), AthosTrialUpdate)

    local function PlayerCountChange(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                TierGumLookup[2][7] = RegisterImage("t7_hud_zm_bgb_extra_credit")
                TierGumLookup[3][3] = RegisterImage("t7_hud_zm_bgb_head_drama")

                TierTextLookup[2][7] = Engine.Localize("ZMUI_BGB_EXTRA_CREDIT")
                TierTextLookup[3][3] = Engine.Localize("ZMUI_BGB_HEAD_DRAMA")

                TierGum[2][ExtraCreditIndex]:setImage(RegisterImage("t7_hud_zm_bgb_extra_credit"))
                TierGum[3][HeadDramaIndex]:setImage(RegisterImage("t7_hud_zm_bgb_head_drama"))
                
                TierText[2][ExtraCreditIndex]:setText(Engine.Localize("ZMUI_BGB_EXTRA_CREDIT"))
                TierText[3][HeadDramaIndex]:setText(Engine.Localize("ZMUI_BGB_HEAD_DRAMA"))
            else
                TierGumLookup[2][7] = RegisterImage("t7_hud_zm_bgb_profit_sharing")
                TierGumLookup[3][3] = RegisterImage("t7_hud_zm_bgb_phoenix_up")

                TierTextLookup[2][7] = Engine.Localize("ZMUI_BGB_PROFIT_SHARING")
                TierTextLookup[3][3] = Engine.Localize("ZMUI_BGB_PHOENIX_UP")

                TierGum[2][ExtraCreditIndex]:setImage(RegisterImage("t7_hud_zm_bgb_profit_sharing"))
                TierGum[3][HeadDramaIndex]:setImage(RegisterImage("t7_hud_zm_bgb_phoenix_up"))

                TierText[2][ExtraCreditIndex]:setText(Engine.Localize("ZMUI_BGB_PROFIT_SHARING"))
                TierText[3][HeadDramaIndex]:setText(Engine.Localize("ZMUI_BGB_PHOENIX_UP"))
            end
        end
    end
    TrialControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.playerCountChange"), PlayerCountChange)
    return TrialControl
end