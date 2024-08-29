CoD.WeaponBPControl = InheritFrom(LUI.UIElement)

function CoD.WeaponBPControl.new(HudRef, InstanceRef)
    local WeaponBPControl = LUI.UIElement.new()
    WeaponBPControl:setClass(CoD.WeaponBPControl)
    WeaponBPControl:setLeftRight(true, true)
    WeaponBPControl:setTopBottom(true, true)
    WeaponBPControl.id = "WeaponBPControl"
    WeaponBPControl.soundSet = "default"

    local BPTable = {"weapon_bp_0_0_0", "weapon_bp_0_0_1", "weapon_bp_0_1_0", "weapon_bp_0_1_1", "weapon_bp_1_0_0", "weapon_bp_1_0_1", "weapon_bp_1_1_0", "weapon_bp_1_1_1"}

    local BPImage = LUI.UIImage.new()
    BPImage:setImage(RegisterImage(BPTable[1]))
    BPImage:setLeftRight(true, true)
    BPImage:setTopBottom(true, true)

 	local function WeaponBPUpdate(ModelRef)
 		local NotifyData = Engine.GetModelValue(ModelRef)
 		if NotifyData then
 			BPImage:setImage(RegisterImage(BPTable[NotifyData + 1]))
 		end
 	end
 	WeaponBPControl:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "weaponBPUpdate"), WeaponBPUpdate)

 	WeaponBPControl:addElement(BPImage)

    return WeaponBPControl
end