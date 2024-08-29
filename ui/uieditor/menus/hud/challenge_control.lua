CoD.ChallengeControl = InheritFrom(LUI.UIElement)

function CoD.ChallengeControl.new(HudRef, InstanceRef)
    local ChallengeControl = LUI.UIElement.new()
    ChallengeControl:setClass(CoD.ChallengeControl)
    ChallengeControl:setLeftRight(true, true)
    ChallengeControl:setTopBottom(true, true)
    ChallengeControl.id = "ChallengeControl"
    ChallengeControl.soundSet = "default"

    local CherryIcon = LUI.UIImage.new()
    CherryIcon:setLeftRight(true, false, 16, 76)
    CherryIcon:setTopBottom(true, false, 26, 86)
    CherryIcon:setImage(RegisterImage("specialty_blue_electric_cherry_zombies"))

    local CherryChallengeText = LUI.UIText.new()
    CherryChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_CHERRY"))
    CherryChallengeText:setLeftRight(true, false, 81, 98)
    CherryChallengeText:setTopBottom(true, false, 16, 43)
    CherryChallengeText:setRGB(1, 1, 1)

    local CherryRewardText = LUI.UIText.new()
    CherryRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_CHERRY_REWARD"))
    CherryRewardText:setLeftRight(true, false, 81, 98)
    CherryRewardText:setTopBottom(true, false, 46, 73)
    CherryRewardText:setRGB(1, 1, 1)

    local CherryStatusText = LUI.UIText.new()
    CherryStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    CherryStatusText:setLeftRight(true, false, 81, 98)
    CherryStatusText:setTopBottom(true, false, 76, 96)
    CherryStatusText:setAlpha(0.9)
    CherryStatusText:setRGB(1, 0, 0)

    local CherryBackgroundCircle = LUI.UIImage.new()
    CherryBackgroundCircle:setLeftRight(true, false, 406, 456)
    CherryBackgroundCircle:setTopBottom(true, false, 16, 66)
    CherryBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    CherryBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    CherryBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    CherryBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local CherryProgressCircle = LUI.UIImage.new()
    CherryProgressCircle:setLeftRight(true, false, 406, 456)
    CherryProgressCircle:setTopBottom(true, false, 16, 66)
    CherryProgressCircle:setRGB(0.97, 0.79, 0.09)
    CherryProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    CherryProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    CherryProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local CherryProgressText = LUI.UIText.new()
    CherryProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    CherryProgressText:setLeftRight(true, false, 411, 456)
    CherryProgressText:setTopBottom(true, false, 66, 86)
    CherryProgressText:setAlpha(0.9)
    CherryProgressText:setRGB(1, 0, 0)

    local StaminIcon = LUI.UIImage.new()
    StaminIcon:setLeftRight(true, false, 16, 76)
    StaminIcon:setTopBottom(true, false, 122, 182)
    StaminIcon:setImage(RegisterImage("specialty_giant_marathon_zombies"))

    local StaminChallengeText = LUI.UIText.new()
    StaminChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_STAMIN"))
    StaminChallengeText:setLeftRight(true, false, 81, 98)
    StaminChallengeText:setTopBottom(true, false, 112, 139)
    StaminChallengeText:setRGB(1, 1, 1)

    local StaminRewardText = LUI.UIText.new()
    StaminRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_STAMIN_REWARD"))
    StaminRewardText:setLeftRight(true, false, 81, 98)
    StaminRewardText:setTopBottom(true, false, 142, 169)
    StaminRewardText:setRGB(1, 1, 1)

    local StaminStatusText = LUI.UIText.new()
    StaminStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    StaminStatusText:setLeftRight(true, false, 81, 98)
    StaminStatusText:setTopBottom(true, false, 172, 192)
    StaminStatusText:setAlpha(0.9)
    StaminStatusText:setRGB(1, 0, 0)

    local StaminBackgroundCircle = LUI.UIImage.new()
    StaminBackgroundCircle:setLeftRight(true, false, 406, 456)
    StaminBackgroundCircle:setTopBottom(true, false, 112, 162)
    StaminBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    StaminBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    StaminBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    StaminBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local StaminProgressCircle = LUI.UIImage.new()
    StaminProgressCircle:setLeftRight(true, false, 406, 456)
    StaminProgressCircle:setTopBottom(true, false, 112, 162)
    StaminProgressCircle:setRGB(0.97, 0.79, 0.09)
    StaminProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    StaminProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    StaminProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local StaminProgressText = LUI.UIText.new()
    StaminProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    StaminProgressText:setLeftRight(true, false, 411, 456)
    StaminProgressText:setTopBottom(true, false, 162, 182)
    StaminProgressText:setAlpha(0.9)
    StaminProgressText:setRGB(1, 0, 0)

    local DoubleIcon = LUI.UIImage.new()
    DoubleIcon:setLeftRight(true, false, 16, 76)
    DoubleIcon:setTopBottom(true, false, 218, 278)
    DoubleIcon:setImage(RegisterImage("specialty_doubletap_zombies"))

    local DoubleChallengeText = LUI.UIText.new()
    DoubleChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_DOUBLE"))
    DoubleChallengeText:setLeftRight(true, false, 81, 98)
    DoubleChallengeText:setTopBottom(true, false, 208, 235)
    DoubleChallengeText:setRGB(1, 1, 1)

    local DoubleRewardText = LUI.UIText.new()
    DoubleRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_DOUBLE_REWARD"))
    DoubleRewardText:setLeftRight(true, false, 81, 98)
    DoubleRewardText:setTopBottom(true, false, 238, 265)
    DoubleRewardText:setRGB(1, 1, 1)

    local DoubleStatusText = LUI.UIText.new()
    DoubleStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    DoubleStatusText:setLeftRight(true, false, 81, 98)
    DoubleStatusText:setTopBottom(true, false, 268, 288)
    DoubleStatusText:setAlpha(0.9)
    DoubleStatusText:setRGB(1, 0, 0)

    local DoubleBackgroundCircle = LUI.UIImage.new()
    DoubleBackgroundCircle:setLeftRight(true, false, 406, 456)
    DoubleBackgroundCircle:setTopBottom(true, false, 208, 258)
    DoubleBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    DoubleBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    DoubleBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    DoubleBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local DoubleProgressCircle = LUI.UIImage.new()
    DoubleProgressCircle:setLeftRight(true, false, 406, 456)
    DoubleProgressCircle:setTopBottom(true, false, 208, 258)
    DoubleProgressCircle:setRGB(0.97, 0.79, 0.09)
    DoubleProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    DoubleProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    DoubleProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local DoubleProgressText = LUI.UIText.new()
    DoubleProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    DoubleProgressText:setLeftRight(true, false, 411, 456)
    DoubleProgressText:setTopBottom(true, false, 258, 278)
    DoubleProgressText:setAlpha(0.9)
    DoubleProgressText:setRGB(1, 0, 0)

    local MuleIcon = LUI.UIImage.new()
    MuleIcon:setLeftRight(true, false, 16, 76)
    MuleIcon:setTopBottom(true, false, 314, 374)
    MuleIcon:setImage(RegisterImage("specialty_giant_three_guns_zombies"))

    local MuleChallengeText = LUI.UIText.new()
    MuleChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_MULE"))
    MuleChallengeText:setLeftRight(true, false, 81, 98)
    MuleChallengeText:setTopBottom(true, false, 304, 331)
    MuleChallengeText:setRGB(1, 1, 1)

    local MuleRewardText = LUI.UIText.new()
    MuleRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_MULE_REWARD"))
    MuleRewardText:setLeftRight(true, false, 81, 98)
    MuleRewardText:setTopBottom(true, false, 334, 361)
    MuleRewardText:setRGB(1, 1, 1)

    local MuleStatusText = LUI.UIText.new()
    MuleStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    MuleStatusText:setLeftRight(true, false, 81, 98)
    MuleStatusText:setTopBottom(true, false, 364, 384)
    MuleStatusText:setAlpha(0.9)
    MuleStatusText:setRGB(1, 0, 0)

    local MuleBackgroundCircle = LUI.UIImage.new()
    MuleBackgroundCircle:setLeftRight(true, false, 406, 456)
    MuleBackgroundCircle:setTopBottom(true, false, 304, 354)
    MuleBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    MuleBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    MuleBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    MuleBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local MuleProgressCircle = LUI.UIImage.new()
    MuleProgressCircle:setLeftRight(true, false, 406, 456)
    MuleProgressCircle:setTopBottom(true, false, 304, 354)
    MuleProgressCircle:setRGB(0.97, 0.79, 0.09)
    MuleProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    MuleProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    MuleProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local MuleProgressText = LUI.UIText.new()
    MuleProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    MuleProgressText:setLeftRight(true, false, 411, 456)
    MuleProgressText:setTopBottom(true, false, 354, 374)
    MuleProgressText:setAlpha(0.9)
    MuleProgressText:setRGB(1, 0, 0)

    local PoseidonIcon = LUI.UIImage.new()
    PoseidonIcon:setLeftRight(true, false, 506, 566)
    PoseidonIcon:setTopBottom(true, false, 26, 86)
    PoseidonIcon:setImage(RegisterImage("specialty_poseidon_zombies"))

    local PoseidonChallengeText = LUI.UIText.new()
    PoseidonChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_POSEIDON"))
    PoseidonChallengeText:setLeftRight(true, false, 571, 588)
    PoseidonChallengeText:setTopBottom(true, false, 16, 43)
    PoseidonChallengeText:setRGB(1, 1, 1)

    local PoseidonRewardText = LUI.UIText.new()
    PoseidonRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_POSEIDON_REWARD"))
    PoseidonRewardText:setLeftRight(true, false, 571, 588)
    PoseidonRewardText:setTopBottom(true, false, 46, 73)
    PoseidonRewardText:setRGB(1, 1, 1)

    local PoseidonStatusText = LUI.UIText.new()
    PoseidonStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    PoseidonStatusText:setLeftRight(true, false, 571, 588)
    PoseidonStatusText:setTopBottom(true, false, 76, 96)
    PoseidonStatusText:setAlpha(0.9)
    PoseidonStatusText:setRGB(1, 0, 0)

    local PoseidonBackgroundCircle = LUI.UIImage.new()
    PoseidonBackgroundCircle:setLeftRight(true, false, 896, 946)
    PoseidonBackgroundCircle:setTopBottom(true, false, 16, 66)
    PoseidonBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    PoseidonBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    PoseidonBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    PoseidonBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local PoseidonProgressCircle = LUI.UIImage.new()
    PoseidonProgressCircle:setLeftRight(true, false, 896, 946)
    PoseidonProgressCircle:setTopBottom(true, false, 16, 66)
    PoseidonProgressCircle:setRGB(0.97, 0.79, 0.09)
    PoseidonProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    PoseidonProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    PoseidonProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local PoseidonProgressText = LUI.UIText.new()
    PoseidonProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    PoseidonProgressText:setLeftRight(true, false, 901, 946)
    PoseidonProgressText:setTopBottom(true, false, 66, 86)
    PoseidonProgressText:setAlpha(0.9)
    PoseidonProgressText:setRGB(1, 0, 0)

    local QuickIcon = LUI.UIImage.new()
    QuickIcon:setLeftRight(true, false, 506, 566)
    QuickIcon:setTopBottom(true, false, 122, 182)
    QuickIcon:setImage(RegisterImage("specialty_giant_quickrevive_zombies"))

    local QuickChallengeText = LUI.UIText.new()
    QuickChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_QUICK"))
    QuickChallengeText:setLeftRight(true, false, 571, 588)
    QuickChallengeText:setTopBottom(true, false, 112, 139)
    QuickChallengeText:setRGB(1, 1, 1)

    local QuickRewardText = LUI.UIText.new()
    QuickRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_QUICK_REWARD"))
    QuickRewardText:setLeftRight(true, false, 571, 588)
    QuickRewardText:setTopBottom(true, false, 142, 169)
    QuickRewardText:setRGB(1, 1, 1)

    local QuickStatusText = LUI.UIText.new()
    QuickStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    QuickStatusText:setLeftRight(true, false, 571, 588)
    QuickStatusText:setTopBottom(true, false, 172, 192)
    QuickStatusText:setAlpha(0.9)
    QuickStatusText:setRGB(1, 0, 0)

    local QuickBackgroundCircle = LUI.UIImage.new()
    QuickBackgroundCircle:setLeftRight(true, false, 896, 946)
    QuickBackgroundCircle:setTopBottom(true, false, 112, 162)
    QuickBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    QuickBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    QuickBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    QuickBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local QuickProgressCircle = LUI.UIImage.new()
    QuickProgressCircle:setLeftRight(true, false, 896, 946)
    QuickProgressCircle:setTopBottom(true, false, 112, 162)
    QuickProgressCircle:setRGB(0.97, 0.79, 0.09)
    QuickProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    QuickProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    QuickProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local QuickProgressText = LUI.UIText.new()
    QuickProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    QuickProgressText:setLeftRight(true, false, 901, 946)
    QuickProgressText:setTopBottom(true, false, 162, 182)
    QuickProgressText:setAlpha(0.9)
    QuickProgressText:setRGB(1, 0, 0)

    local function QuickRewardUpdate(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 1 then
                QuickRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_QUICK_REWARD_SOLO"))
            else
                QuickRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_QUICK_REWARD"))
            end
        end
    end
    QuickRewardText:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "quickReward"), QuickRewardUpdate)

    local PHDIcon = LUI.UIImage.new()
    PHDIcon:setLeftRight(true, false, 506, 566)
    PHDIcon:setTopBottom(true, false, 218, 278)
    PHDIcon:setImage(RegisterImage("specialty_phdlite_zombies"))

    local PHDChallengeText = LUI.UIText.new()
    PHDChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_PHD"))
    PHDChallengeText:setLeftRight(true, false, 571, 588)
    PHDChallengeText:setTopBottom(true, false, 208, 235)
    PHDChallengeText:setRGB(1, 1, 1)

    local PHDRewardText = LUI.UIText.new()
    PHDRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_PHD_REWARD"))
    PHDRewardText:setLeftRight(true, false, 571, 588)
    PHDRewardText:setTopBottom(true, false, 238, 265)
    PHDRewardText:setRGB(1, 1, 1)

    local PHDStatusText = LUI.UIText.new()
    PHDStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    PHDStatusText:setLeftRight(true, false, 571, 588)
    PHDStatusText:setTopBottom(true, false, 268, 288)
    PHDStatusText:setAlpha(0.9)
    PHDStatusText:setRGB(1, 0, 0)

    local PHDBackgroundCircle = LUI.UIImage.new()
    PHDBackgroundCircle:setLeftRight(true, false, 896, 946)
    PHDBackgroundCircle:setTopBottom(true, false, 208, 258)
    PHDBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    PHDBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    PHDBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    PHDBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local PHDProgressCircle = LUI.UIImage.new()
    PHDProgressCircle:setLeftRight(true, false, 896, 946)
    PHDProgressCircle:setTopBottom(true, false, 208, 258)
    PHDProgressCircle:setRGB(0.97, 0.79, 0.09)
    PHDProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    PHDProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    PHDProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local PHDProgressText = LUI.UIText.new()
    PHDProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    PHDProgressText:setLeftRight(true, false, 901, 946)
    PHDProgressText:setTopBottom(true, false, 258, 278)
    PHDProgressText:setAlpha(0.9)
    PHDProgressText:setRGB(1, 0, 0)

    local DeadshotIcon = LUI.UIImage.new()
    DeadshotIcon:setLeftRight(true, false, 506, 566)
    DeadshotIcon:setTopBottom(true, false, 314, 374)
    DeadshotIcon:setImage(RegisterImage("specialty_deadshot_zombies"))

    local DeadshotChallengeText = LUI.UIText.new()
    DeadshotChallengeText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_DEADSHOT"))
    DeadshotChallengeText:setLeftRight(true, false, 571, 588)
    DeadshotChallengeText:setTopBottom(true, false, 304, 331)
    DeadshotChallengeText:setRGB(1, 1, 1)

    local DeadshotRewardText = LUI.UIText.new()
    DeadshotRewardText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_DEADSHOT_REWARD"))
    DeadshotRewardText:setLeftRight(true, false, 571, 588)
    DeadshotRewardText:setTopBottom(true, false, 334, 361)
    DeadshotRewardText:setRGB(1, 1, 1)

    local DeadshotStatusText = LUI.UIText.new()
    DeadshotStatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    DeadshotStatusText:setLeftRight(true, false, 571, 588)
    DeadshotStatusText:setTopBottom(true, false, 364, 384)
    DeadshotStatusText:setAlpha(0.9)
    DeadshotStatusText:setRGB(1, 0, 0)

    local DeadshotBackgroundCircle = LUI.UIImage.new()
    DeadshotBackgroundCircle:setLeftRight(true, false, 896, 946)
    DeadshotBackgroundCircle:setTopBottom(true, false, 304, 354)
    DeadshotBackgroundCircle:setRGB(0.75, 0.75, 0.75)
    DeadshotBackgroundCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    DeadshotBackgroundCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    DeadshotBackgroundCircle:setShaderVector(0, 1, 1, 1, 1)

    local DeadshotProgressCircle = LUI.UIImage.new()
    DeadshotProgressCircle:setLeftRight(true, false, 896, 946)
    DeadshotProgressCircle:setTopBottom(true, false, 304, 354)
    DeadshotProgressCircle:setRGB(0.97, 0.79, 0.09)
    DeadshotProgressCircle:setImage(RegisterImage("uie_t7_hud_interact_meter_thick"))
    DeadshotProgressCircle:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
    DeadshotProgressCircle:setShaderVector(0, 0, 1, 1, 1)

    local DeadshotProgressText = LUI.UIText.new()
    DeadshotProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
    DeadshotProgressText:setLeftRight(true, false, 901, 946)
    DeadshotProgressText:setTopBottom(true, false, 354, 374)
    DeadshotProgressText:setAlpha(0.9)
    DeadshotProgressText:setRGB(1, 1, 1)

    local GoalTable = {10, 5, 3, 10, 8, 8, 8, 10}
    local StatusTextTable = {CherryStatusText, StaminStatusText, DoubleStatusText, MuleStatusText, PoseidonStatusText, QuickStatusText, PHDStatusText, DeadshotStatusText}
    local ProgressCircleTable = {CherryProgressCircle, StaminProgressCircle, DoubleProgressCircle, MuleProgressCircle, PoseidonProgressCircle, QuickProgressCircle, PHDProgressCircle, DeadshotProgressCircle}
    local ProgressTextTable = {CherryProgressText, StaminProgressText, DoubleProgressText, MuleProgressText, PoseidonProgressText, QuickProgressText, PHDProgressText, DeadshotProgressText}
    local ProgressTextXTable = {431, 431, 431, 431, 921, 921, 921, 921}

    local function StatusUpdate(StatusText, ProgressCircle, ProgressText, Data, Goal)
        if Data == Goal + 1 then
            StatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
            StatusText:setRGB(1, 0, 0)
            ProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
            ProgressText:setRGB(1, 0, 0)
            ProgressCircle:setShaderVector(0, 0, 1, 1, 1)
        elseif Data == Goal + 2 then
            StatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE_SHADOW"))
            StatusText:setRGB(1, 0, 1)
            ProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_INACTIVE"))
            ProgressText:setRGB(1, 0, 1)
            ProgressCircle:setShaderVector(0, 0, 1, 1, 1)
        elseif Data == Goal + 3 then
            StatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_ACTIVE"))
            StatusText:setRGB(0, 1, 0)
        else
            StatusText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_COMPLETE"))
            StatusText:setRGB(0, 1, 0)
            ProgressCircle:setShaderVector(0, 1, 1, 1, 1)
            ProgressText:setText(Engine.Localize("ZM_ABBEY_CHALLENGE_COMPLETE"))
            ProgressText:setRGB(0, 1, 0)
        end
    end

    local function ProgressUpdate(ProgressCircle, ProgressText, ProgressTextX, Data, Goal)
        local ProgressString = Data .. "/" .. Goal
        ProgressText:setText(Data .. "/" .. Goal)
        ProgressText:setRGB(0, 1, 0)
        ProgressCircle:setShaderVector(0, Data / Goal, 1, 1, 1)
    end

    local function ChallengeControlUpdate(PerkID, Data)
        local Goal = GoalTable[PerkID]
        local StatusText = StatusTextTable[PerkID]
        local ProgressCircle = ProgressCircleTable[PerkID]
        local ProgressText = ProgressTextTable[PerkID]
        local ProgressTextX = ProgressTextXTable[PerkID]

        if Data > Goal then
            StatusUpdate(StatusText, ProgressCircle, ProgressText, Data, Goal)
        else
            ProgressUpdate(ProgressCircle, ProgressText, ProgressTextX, Data, Goal)
        end

        local TextStart = ProgressTextX - math.floor((ProgressText:getTextWidth() / 2) + 0.5)
        ProgressText:setLeftRight(true, false, TextStart, 946)
    end

    local function CherryUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(1, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "cherryUpdate"), CherryUpdate)

    local function StaminUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(2, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "staminUpdate"), StaminUpdate)

    local function DoubleUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(3, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "doubleUpdate"), DoubleUpdate)

    local function MuleUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(4, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "muleUpdate"), MuleUpdate)

    local function PoseidonUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(5, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "poseidonUpdate"), PoseidonUpdate)

    local function QuickUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(6, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "quickUpdate"), QuickUpdate)

    local function PHDUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(7, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "PHDUpdate"), PHDUpdate)

    local function DeadshotUpdate(ModelRef)
       local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            ChallengeControlUpdate(8, NotifyData)
        end
    end
    ChallengeControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "deadshotUpdate"), DeadshotUpdate)

    ChallengeControl:addElement(CherryIcon)
    ChallengeControl:addElement(CherryChallengeText)
    ChallengeControl:addElement(CherryRewardText)
    ChallengeControl:addElement(CherryStatusText)
    ChallengeControl:addElement(CherryBackgroundCircle)
    ChallengeControl:addElement(CherryProgressCircle)
    ChallengeControl:addElement(CherryProgressText)

    ChallengeControl:addElement(StaminIcon)
    ChallengeControl:addElement(StaminChallengeText)
    ChallengeControl:addElement(StaminRewardText)
    ChallengeControl:addElement(StaminStatusText)
    ChallengeControl:addElement(StaminBackgroundCircle)
    ChallengeControl:addElement(StaminProgressCircle)
    ChallengeControl:addElement(StaminProgressText)

    ChallengeControl:addElement(DoubleIcon)
    ChallengeControl:addElement(DoubleChallengeText)
    ChallengeControl:addElement(DoubleRewardText)
    ChallengeControl:addElement(DoubleStatusText)
    ChallengeControl:addElement(DoubleBackgroundCircle)
    ChallengeControl:addElement(DoubleProgressCircle)
    ChallengeControl:addElement(DoubleProgressText)

    ChallengeControl:addElement(MuleIcon)
    ChallengeControl:addElement(MuleChallengeText)
    ChallengeControl:addElement(MuleRewardText)
    ChallengeControl:addElement(MuleStatusText)
    ChallengeControl:addElement(MuleBackgroundCircle)
    ChallengeControl:addElement(MuleProgressCircle)
    ChallengeControl:addElement(MuleProgressText)

    ChallengeControl:addElement(PoseidonIcon)
    ChallengeControl:addElement(PoseidonChallengeText)
    ChallengeControl:addElement(PoseidonRewardText)
    ChallengeControl:addElement(PoseidonStatusText)
    ChallengeControl:addElement(PoseidonBackgroundCircle)
    ChallengeControl:addElement(PoseidonProgressCircle)
    ChallengeControl:addElement(PoseidonProgressText)

    ChallengeControl:addElement(QuickIcon)
    ChallengeControl:addElement(QuickChallengeText)
    ChallengeControl:addElement(QuickRewardText)
    ChallengeControl:addElement(QuickStatusText)
    ChallengeControl:addElement(QuickBackgroundCircle)
    ChallengeControl:addElement(QuickProgressCircle)
    ChallengeControl:addElement(QuickProgressText)

    ChallengeControl:addElement(PHDIcon)
    ChallengeControl:addElement(PHDChallengeText)
    ChallengeControl:addElement(PHDRewardText)
    ChallengeControl:addElement(PHDStatusText)
    ChallengeControl:addElement(PHDBackgroundCircle)
    ChallengeControl:addElement(PHDProgressCircle)
    ChallengeControl:addElement(PHDProgressText)

    ChallengeControl:addElement(DeadshotIcon)
    ChallengeControl:addElement(DeadshotChallengeText)
    ChallengeControl:addElement(DeadshotRewardText)
    ChallengeControl:addElement(DeadshotStatusText)
    ChallengeControl:addElement(DeadshotBackgroundCircle)
    ChallengeControl:addElement(DeadshotProgressCircle)
    ChallengeControl:addElement(DeadshotProgressText)

    return ChallengeControl
end