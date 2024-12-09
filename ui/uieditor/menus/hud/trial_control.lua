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
    local TrialTextWidth = 450
    local PBWidth = 125
    local GumWidth = 50
    local TextWidth = 150
    local DividerWidth = 962

    local IconStartX = 16
    local NameTextStartX = 14
    local TrialTextStartX = 256
    local PBStartX = IconStartX + IconWidth - 5
    local GumStartX = PBStartX + PBWidth - 4
    local TextStartX = GumStartX + (GumWidth / 2) - (TextWidth / 2)
    local XOffset = PBWidth + GumWidth - 6
    local DividerStartX = 0

    local IconHeight = 60
    local NameTextHeight = 21
    local TrialTextHeight = NameTextHeight
    local PBHeight = 5
    local GumHeight = GumWidth
    local TextHeight = 17
    local DividerHeight = 1

    local IconStartY = 30
    local NameTextStartY = 5
    local TrialTextStartY = NameTextStartY
    local PBStartY = IconStartY + (IconHeight / 3)
    local GumStartY = PBStartY + (PBHeight / 2) - (GumHeight / 2)
    local TextStartY = GumStartY + GumHeight + 1
    local DividerStartY = TextStartY + TextHeight + 1
    local YOffset = 95

    local IconTable = {}
    local NameTextTable = {}
    local TrialTextTable = {}
    local PBTable = {}
    local GumTable = {}
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
        TrialText:setText(Engine.Localize("Trial: Complete Rounds"))
        TrialText:setRGB(1, 1, 0)

        local Divider = LUI.UIImage.new()
        Divider:setLeftRight(true, false, DividerLeft, DividerRight)
        Divider:setTopBottom(true, false, DividerTop, DividerBottom)
        Divider:setRGB(1, 1, 1)

        IconTable[i] = Icon
        NameTextTable[i] = NameText
        TrialTextTable[i] = TrialText
        PBTable[i] = {}
        GumTable[i] = {}
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

            local ProgressBar = LUI.UIImage.new()
            ProgressBar:setLeftRight(true, false, PBLeft, PBRight)
            ProgressBar:setTopBottom(true, false, PBTop, PBBottom)
            ProgressBar:setRGB(0.75, 0.75, 0.75)

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

            PBTable[i][j] = ProgressBar
            GumTable[i][j] = Gum
            TextTable[i][j] = Text

            TrialControl:addElement(PBTable[i][j])
            TrialControl:addElement(GumTable[i][j])
            TrialControl:addElement(TextTable[i][j])
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

    TrialTextTable[1]:setText("Trial: Complete Rounds")
    TrialTextTable[2]:setText("Trial: Obtain Headshot Kills")
    TrialTextTable[3]:setText("Trial: Obtain Melee Kills")
    TrialTextTable[4]:setText("Trial: Obtain Kills in the Middle Pilgrimage Stairs (New Trial in 5 Rounds)")
    
    return TrialControl
end