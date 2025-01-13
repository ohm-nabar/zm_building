require("ui.uieditor.menus.hud.challenge_control")
require("ui.uieditor.menus.hud.trial_control")
require("ui.uieditor.menus.hud.perkbp_control")
require("ui.uieditor.menus.hud.weaponbp_control")

CoD.InventoryControl = InheritFrom(LUI.UIElement)

function CoD.InventoryControl.new(HudRef, InstanceRef)
    local InventoryControl = LUI.UIElement.new()
    InventoryControl:setClass(CoD.InventoryControl)
    InventoryControl.id = "InventoryControl"
    InventoryControl.soundSet = "default"
    InventoryControl:setLeftRight(false, false, -481, 481)
    InventoryControl:setTopBottom(false, false, -220, 200)
    InventoryControl:hide()

    local function InventoryControlDisplay(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                InventoryControl:hide()
            else
                InventoryControl:show()
            end
        end
    end
    InventoryControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), InventoryControlDisplay)

    local TabBackground = LUI.UIImage.new()
    TabBackground:setLeftRight(true, true)
    TabBackground:setTopBottom(true, false, -45, 0)
    TabBackground:setRGB(0.12, 0.12, 0.11)

    local ChallengeTab = LUI.UIImage.new()
    ChallengeTab:setLeftRight(true, false, 2, 240)
    ChallengeTab:setTopBottom(true, false, -43, -2)
    ChallengeTab:setRGB(1, 1, 1)

    local ChallengeIcon = LUI.UIImage.new()
    ChallengeIcon:setLeftRight(true, false, 5, 40)
    ChallengeIcon:setTopBottom(true, false, -40, -5)
    ChallengeIcon:setImage(RegisterImage("perk_challenge"))

    local ChallengeText = LUI.UIText.new()
    ChallengeText:setLeftRight(true, false, 45, 240)
    ChallengeText:setTopBottom(true, false, -42, -3)
    ChallengeText:setText(Engine.Localize("ZM_ABBEY_JOURNAL_HEADER_CHALLENGE"))
    ChallengeText:setRGB(0, 0, 0)

    local TrialTab = LUI.UIImage.new()
    TrialTab:setLeftRight(true, false, 242, 480)
    TrialTab:setTopBottom(true, false, -43, -2)
    TrialTab:setRGB(0.87, 0.88, 0.90)

    local TrialIcon = LUI.UIImage.new()
    TrialIcon:setLeftRight(true, false, 245, 280)
    TrialIcon:setTopBottom(true, false, -40, -5)
    TrialIcon:setImage(RegisterImage("divinium_trial"))

    local TrialText = LUI.UIText.new()
    TrialText:setLeftRight(true, false, 285, 480)
    TrialText:setTopBottom(true, false, -42, -3)
    TrialText:setText(Engine.Localize("ZM_ABBEY_JOURNAL_HEADER_BGB"))
    TrialText:setRGB(0, 0, 0)

    local PerkBPTab = LUI.UIImage.new()
    PerkBPTab:setLeftRight(true, false, 482, 720)
    PerkBPTab:setTopBottom(true, false, -43, -2)
    PerkBPTab:setRGB(0.87, 0.88, 0.90)

    local PerkBPIcon = LUI.UIImage.new()
    PerkBPIcon:setLeftRight(true, false, 485, 520)
    PerkBPIcon:setTopBottom(true, false, -40, -5)
    PerkBPIcon:setImage(RegisterImage("perk_blueprint"))

    local PerkBPText = LUI.UIText.new()
    PerkBPText:setLeftRight(true, false, 525, 720)
    PerkBPText:setTopBottom(true, false, -42, -3)
    PerkBPText:setText(Engine.Localize("ZM_ABBEY_JOURNAL_HEADER_PERKBP"))
    PerkBPText:setRGB(0, 0, 0)

    local WeaponBPTab = LUI.UIImage.new()
    WeaponBPTab:setLeftRight(true, false, 722, 960)
    WeaponBPTab:setTopBottom(true, false, -43, -2)
    WeaponBPTab:setRGB(0.87, 0.88, 0.90)

    local WeaponBPIcon = LUI.UIImage.new()
    WeaponBPIcon:setLeftRight(true, false, 725, 760)
    WeaponBPIcon:setTopBottom(true, false, -42, -3)
    WeaponBPIcon:setImage(RegisterImage("weapon_blueprint"))

    local WeaponBPText = LUI.UIText.new()
    WeaponBPText:setLeftRight(true, false, 765, 960)
    WeaponBPText:setTopBottom(true, false, -40, -4)
    WeaponBPText:setText(Engine.Localize("ZM_ABBEY_JOURNAL_HEADER_WEAPONBP"))
    WeaponBPText:setRGB(0, 0, 0)

    local Background = LUI.UIImage.new()
    Background:setLeftRight(true, true)
    Background:setTopBottom(true, true)
    Background:setRGB(0.17, 0.17, 0.16)

    local ChallengeControl = CoD.ChallengeControl.new(HudRef, InstanceRef)
    local TrialControl = CoD.TrialControl.new(HudRef, InstanceRef)
    local PerkBPControl = CoD.PerkBPControl.new(HudRef, InstanceRef)
    local WeaponBPControl = CoD.WeaponBPControl.new(HudRef, InstanceRef)

    TrialControl:hide()
    PerkBPControl:hide()
    WeaponBPControl:hide()

    
    local function SwitchTab(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControl:hide()
            TrialControl:hide()
            PerkBPControl:hide()
            WeaponBPControl:hide()

            ChallengeTab:setRGB(0.87, 0.88, 0.90)
            TrialTab:setRGB(0.87, 0.88, 0.90)
            PerkBPTab:setRGB(0.87, 0.88, 0.90)
            WeaponBPTab:setRGB(0.87, 0.88, 0.90)

            if NotifyData == 0 then
                ChallengeControl:show()
                ChallengeTab:setRGB(1, 1, 1)
            elseif NotifyData == 1 then
                TrialControl:show()
                TrialTab:setRGB(1, 1, 1)
            elseif NotifyData == 2 then
                PerkBPControl:show()
                PerkBPTab:setRGB(1, 1, 1)
            else
                WeaponBPControl:show()
                WeaponBPTab:setRGB(1, 1, 1)
            end
        end
    end
    InventoryControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "currentTab"), SwitchTab)

    local NavigationInfo = LUI.UIText.new()
    NavigationInfo:setText(Engine.Localize("ZM_ABBEY_JOURNAL_NAVIGATION_INFO"))
    NavigationInfo:setLeftRight(true, false, 16, 76)
    NavigationInfo:setTopBottom(true, false, 395, 415)
    NavigationInfo:setAlpha(0.9)
    NavigationInfo:setRGB(1, 1, 1)

    local AthosPromptX = NavigationInfo:getTextWidth() + 21
        TrialControl.AthosPrompt:setLeftRight(true, false, AthosPromptX, AthosPromptX + 100)

    local function NavigationInfoUpdate(Element, Event)
        NavigationInfo:setText(Engine.Localize("ZM_ABBEY_JOURNAL_NAVIGATION_INFO"))

        AthosPromptX = NavigationInfo:getTextWidth() + 21
        TrialControl.AthosPrompt:setLeftRight(true, false, AthosPromptX, AthosPromptX + 100)
    end
    InventoryControl:registerEventHandler( "input_source_changed", NavigationInfoUpdate)

    InventoryControl:addElement(TabBackground)

    InventoryControl:addElement(ChallengeTab)
    InventoryControl:addElement(ChallengeIcon)
    InventoryControl:addElement(ChallengeText)

    InventoryControl:addElement(TrialTab)
    InventoryControl:addElement(TrialIcon)
    InventoryControl:addElement(TrialText)

    InventoryControl:addElement(PerkBPTab)
    InventoryControl:addElement(PerkBPIcon)
    InventoryControl:addElement(PerkBPText)

    InventoryControl:addElement(WeaponBPTab)
    InventoryControl:addElement(WeaponBPIcon)
    InventoryControl:addElement(WeaponBPText)

    InventoryControl:addElement(Background)
    InventoryControl:addElement(ChallengeControl)
    InventoryControl:addElement(TrialControl)
    InventoryControl:addElement(PerkBPControl)
    InventoryControl:addElement(WeaponBPControl)
    InventoryControl:addElement(NavigationInfo)
    return InventoryControl
end