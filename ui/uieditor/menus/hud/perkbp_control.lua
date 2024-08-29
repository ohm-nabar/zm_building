CoD.PerkBPControl = InheritFrom(LUI.UIElement)

function CoD.PerkBPControl.new(HudRef, InstanceRef)
    local PerkBPControl = LUI.UIElement.new()
    PerkBPControl:setClass(CoD.PerkBPControl)
    PerkBPControl:setLeftRight(true, true)
    PerkBPControl:setTopBottom(true, true)
    PerkBPControl.id = "PerkBPControl"
    PerkBPControl.soundSet = "default"

	local BPTable = {"perk_bp_0_0_0", "perk_bp_0_0_1", "perk_bp_0_1_0", "perk_bp_0_1_1", "perk_bp_1_0_0", "perk_bp_1_0_1", "perk_bp_1_1_0", "perk_bp_1_1_1"}

    local BPImage = LUI.UIImage.new()
    BPImage:setImage(RegisterImage(BPTable[1]))
    BPImage:setLeftRight(true, true)
    BPImage:setTopBottom(true, true)

 	local function PerkBPUpdate(ModelRef)
 		local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
 			BPImage:setImage(RegisterImage(BPTable[NotifyData + 1]))
 		end
 	end
 	PerkBPControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "perkBPUpdate"), PerkBPUpdate)
 	PerkBPControl:addElement(BPImage)

    return PerkBPControl
end