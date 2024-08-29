require("ui.uieditor.widgets.HUD.ZM_Revive.ZM_ReviveWidget")
require("ui.uieditor.widgets.HUD.ZM_Revive.ZM_ReviveClampedArrow")
CoD.ZM_Revive = InheritFrom(LUI.UIElement)
CoD.ZM_Revive.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ZM_Revive)
	Widget.id = "ZM_Revive"
	Widget.soundSet = "default"
	Widget:setLeftRight(true, false, 0, 1)
	Widget:setTopBottom(true, false, 0, 1)
	Widget.anyChildUsesUpdateState = true
	local f1_local1 = LUI.UITightText.new()
	f1_local1:setLeftRight(true, false, 89, 267.69)
	f1_local1:setTopBottom(true, false, -44, 6)
	f1_local1:setRGB(1, 0.75, 0.44)
	f1_local1:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local1:setLetterSpacing(1)
	f1_local1:linkToElementModel(Widget, "playerName", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local1:setText(ModelValue)
		end
	end)
	--Widget:addElement(f1_local1)
	Widget.playerName = f1_local1
	
	local f1_local2 = LUI.UITightText.new()
	f1_local2:setLeftRight(true, false, 89, 178)
	f1_local2:setTopBottom(true, false, 3, 43)
	f1_local2:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local2:setLetterSpacing(1)
	f1_local2:linkToElementModel(Widget, "prompt", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local2:setText(Engine.Localize(ModelValue))
		end
	end)
	--Widget:addElement(f1_local2)
	Widget.prompt = f1_local2
	
	local f1_local3 = CoD.ZM_ReviveWidget.new(HudRef, InstanceRef)
	f1_local3:setLeftRight(true, false, -109.5, 110.5)
	f1_local3:setTopBottom(true, false, -110, 110)
	f1_local3:linkToElementModel(Widget, nil, false, function (ModelRef)
		f1_local3:setModel(ModelRef, InstanceRef)
	end)
	--Widget:addElement(f1_local3)
	Widget.ZMReviveWidget = f1_local3
	
	local f1_local4 = CoD.ZM_ReviveClampedArrow.new(HudRef, InstanceRef)
	f1_local4:setLeftRight(false, false, -118.37, 141.63)
	f1_local4:setTopBottom(false, false, -32, 32)
	f1_local4:linkToElementModel(Widget, "arrowAngle", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local4:setZRot(ModelValue)
		end
	end)
	--Widget:addElement(f1_local4)
	Widget.ZMReviveClampedArrow = f1_local4
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.playerName:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.prompt:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local4:completeAnimation()
		Widget.ZMReviveClampedArrow:setAlpha(0)
		Widget.clipFinished(f1_local4, {})
	end}, Clamped = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.playerName:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.prompt:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local4:completeAnimation()
		Widget.ZMReviveClampedArrow:setAlpha(1)
		Widget.clipFinished(f1_local4, {})
	end}, Visible_Reviving = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.playerName:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.prompt:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local4:completeAnimation()
		Widget.ZMReviveClampedArrow:setAlpha(0)
		Widget.clipFinished(f1_local4, {})
	end}, Visible = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.playerName:setAlpha(1)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.prompt:setAlpha(1)
		Widget.clipFinished(f1_local2, {})
		f1_local4:completeAnimation()
		Widget.ZMReviveClampedArrow:setAlpha(0)
		Widget.clipFinished(f1_local4, {})
	end}}
	Widget:mergeStateConditions({{stateName = "Clamped", condition = function (HudRef, ItemRef, UpdateTable)
		local f10_local0 = IsBleedOutVisible(ItemRef, InstanceRef)
		if f10_local0 then
			f10_local0 = IsSelfModelValueEnumBitSet(ItemRef, InstanceRef, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_CLAMPED)
		end
		return f10_local0
	end}, {stateName = "Visible_Reviving", condition = function (HudRef, ItemRef, UpdateTable)
		local f11_local0 = IsBleedOutVisible(ItemRef, InstanceRef)
		if f11_local0 then
			f11_local0 = IsSelfModelValueEnumBitSet(ItemRef, InstanceRef, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_BEING_REVIVED)
		end
		return f11_local0
	end}, {stateName = "Visible", condition = function (HudRef, ItemRef, UpdateTable)
		return IsBleedOutVisible(ItemRef, InstanceRef)
	end}})
	Widget:linkToElementModel(Widget, "bleedingOut", true, function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "bleedingOut"})
	end)
	Widget:linkToElementModel(Widget, "beingRevived", true, function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "beingRevived"})
	end)
	Widget:linkToElementModel(Widget, "stateFlags", true, function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "stateFlags"})
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.ZMReviveWidget:close()
		Sender.ZMReviveClampedArrow:close()
		Sender.playerName:close()
		Sender.prompt:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

