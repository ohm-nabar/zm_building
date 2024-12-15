require("ui.uieditor.widgets.HUD.ZM_Notif.ZmNotif1_CursorHint")
require("ui.uieditor.widgets.MPHudWidgets.cursorhint_image")
CoD.ZMCursorHint = InheritFrom(LUI.UIElement)
CoD.ZMCursorHint.new = function (HudRef, InstanceRef)
	local f1_local0 = LUI.UIHorizontalList.new({left = 0, top = 0, right = 0, bottom = 0, leftAnchor = true, topAnchor = true, rightAnchor = true, bottomAnchor = true, spacing = 0})
	f1_local0:setAlignment(LUI.Alignment.Center)
	if PreLoadFunc then
		PreLoadFunc(f1_local0, InstanceRef)
	end
	f1_local0:setUseStencil(false)
	f1_local0:setClass(CoD.ZMCursorHint)
	f1_local0.id = "ZMCursorHint"
	f1_local0.soundSet = "HUD"
	f1_local0:setLeftRight(true, false, 0, 500)
	f1_local0:setTopBottom(true, false, 0, 90)
	f1_local0.anyChildUsesUpdateState = true
	local f1_local1 = CoD.ZmNotif1_CursorHint.new(HudRef, InstanceRef)
	f1_local1:setLeftRight(false, false, -242.5, 120.17)
	f1_local1:setTopBottom(true, false, 0, 19)
	f1_local1:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintText", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local1.CursorHintText:setText(Engine.Localize(ModelValue))
		end
	end)
	f1_local0:addElement(f1_local1)
	f1_local0.cursorhinttext0 = f1_local1
	
	local f1_local2 = LUI.UIImage.new()
	f1_local2:setLeftRight(true, false, 370.17, 384.5)
	f1_local2:setTopBottom(true, false, -46.37, 81.63)
	f1_local2:setAlpha(0)
	f1_local0:addElement(f1_local2)
	f1_local0.Image0 = f1_local2
	
	local f1_local3 = CoD.cursorhint_image.new(HudRef, InstanceRef)
	f1_local3:setLeftRight(false, false, 134.5, 242.5)
	f1_local3:setTopBottom(true, false, -17.5, 36.5)
	f1_local3:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", function(ModelRef)
		if IsParamModelEqualToString(ModelRef, "set_cursor_hint_image") then
			local data = CoD.GetScriptNotifyData(ModelRef)
			local index = data[1]
			if index then
				local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
				local bgbName = Engine.TableLookup(nil, tableName, 1, index, 0)
				bgbName = string.sub(bgbName, 4)
				local image = "t7_hud_zm_" .. bgbName
				f1_local3.c1x1:setImage(RegisterImage(image))
			end
		end
	end)
	--f1_local3:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintImage", function (ModelRef)
	--	local ModelValue = Engine.GetModelValue(ModelRef)
	--	if ModelValue then
	--		f1_local3.c1x1:setImage(RegisterImage("t7_hud_zm_bgb_flavor_hexed"))
	--	end
	--end)
	f1_local3:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", function(ModelRef)
		if IsParamModelEqualToString(ModelRef, "set_cursor_hint_image") then
			local data = CoD.GetScriptNotifyData(ModelRef)
			local index = data[1]
			if index then
				local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
				local bgbName = Engine.TableLookup(nil, tableName, 1, index, 0)
				bgbName = string.sub(bgbName, 4)
				local image = "t7_hud_zm_" .. bgbName
				f1_local3.x1x4:setImage(RegisterImage(image))
			end
		end
	end)
	--f1_local3:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintImage", function (ModelRef)
	--	local ModelValue = Engine.GetModelValue(ModelRef)
	--	if ModelValue then
	--		f1_local3.x1x4:setImage(RegisterImage("t7_hud_zm_bgb_flavor_hexed"))
	--	end
	--end)
	f1_local3:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", function(ModelRef)
		if IsParamModelEqualToString(ModelRef, "set_cursor_hint_image") then
			local data = CoD.GetScriptNotifyData(ModelRef)
			local index = data[1]
			if index then
				local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
				local bgbName = Engine.TableLookup(nil, tableName, 1, index, 0)
				bgbName = string.sub(bgbName, 4)
				local image = "t7_hud_zm_" .. bgbName
				f1_local3.c1x2:setImage(RegisterImage(image))
			end
		end
	end)
	--f1_local3:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintImage", function (ModelRef)
	--	local ModelValue = Engine.GetModelValue(ModelRef)
	--	if ModelValue then
	--		f1_local3.c1x2:setImage(RegisterImage("t7_hud_zm_bgb_flavor_hexed"))
	--	end
	--end)
	f1_local3:mergeStateConditions({{stateName = "Active_1x1", condition = function (HudRef, ItemRef, UpdateTable)
		return IsModelValueEqualTo(InstanceRef, "hudItems.cursorHintIconRatio", 1)
	end}, {stateName = "Active_2x1", condition = function (HudRef, ItemRef, UpdateTable)
		return IsModelValueEqualTo(InstanceRef, "hudItems.cursorHintIconRatio", 2)
	end}, {stateName = "Active_4x1", condition = function (HudRef, ItemRef, UpdateTable)
		return IsModelValueEqualTo(InstanceRef, "hudItems.cursorHintIconRatio", 4)
	end}})
	f1_local3:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "hudItems.cursorHintIconRatio"), function (ModelRef)
		HudRef:updateElementState(f1_local3, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "hudItems.cursorHintIconRatio"})
	end)
	f1_local0:addElement(f1_local3)
	f1_local0.cursorhintimage0 = f1_local3
	
	f1_local0.clipsPerState = {DefaultState = {DefaultClip = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(0)
		f1_local0.clipFinished(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setLeftRight(false, false, 120.17, 228.17)
		f1_local0.cursorhintimage0:setTopBottom(true, false, -17.5, 36.5)
		f1_local0.cursorhintimage0:setAlpha(0)
		f1_local0.clipFinished(f1_local3, {})
	end}, Active_1x1 = {DefaultClip = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(0.44)
		local f11_local0 = function (f20_arg0, f20_arg1)
			if not f20_arg1.interrupted then
				f20_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f20_arg0:setAlpha(1)
			if f20_arg1.interrupted then
				f1_local0.clipFinished(f20_arg0, f20_arg1)
			else
				f20_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f11_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setLeftRight(false, false, 120.17, 228.17)
		f1_local0.cursorhintimage0:setTopBottom(true, false, -17.5, 36.5)
		f1_local0.cursorhintimage0:setAlpha(0.36)
		local f11_local1 = function (f21_arg0, f21_arg1)
			if not f21_arg1.interrupted then
				f21_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f21_arg0:setLeftRight(false, false, 120.17, 228.17)
			f21_arg0:setTopBottom(true, false, -17.5, 36.5)
			f21_arg0:setAlpha(1)
			if f21_arg1.interrupted then
				f1_local0.clipFinished(f21_arg0, f21_arg1)
			else
				f21_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f11_local1(f1_local3, {})
	end, DefaultState = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(1)
		local f12_local0 = function (f22_arg0, f22_arg1)
			if not f22_arg1.interrupted then
				f22_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f22_arg0:setAlpha(0)
			if f22_arg1.interrupted then
				f1_local0.clipFinished(f22_arg0, f22_arg1)
			else
				f22_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f12_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setAlpha(1)
		local f12_local1 = function (f23_arg0, f23_arg1)
			if not f23_arg1.interrupted then
				f23_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f23_arg0:setAlpha(0)
			if f23_arg1.interrupted then
				f1_local0.clipFinished(f23_arg0, f23_arg1)
			else
				f23_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f12_local1(f1_local3, {})
	end}, Active_2x1 = {DefaultClip = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(0.41)
		local f13_local0 = function (f24_arg0, f24_arg1)
			if not f24_arg1.interrupted then
				f24_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f24_arg0:setAlpha(1)
			if f24_arg1.interrupted then
				f1_local0.clipFinished(f24_arg0, f24_arg1)
			else
				f24_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f13_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setLeftRight(false, false, 120.17, 228.17)
		f1_local0.cursorhintimage0:setTopBottom(true, false, -17.5, 36.5)
		f1_local0.cursorhintimage0:setAlpha(0.37)
		local f13_local1 = function (f25_arg0, f25_arg1)
			if not f25_arg1.interrupted then
				f25_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f25_arg0:setLeftRight(false, false, 120.17, 228.17)
			f25_arg0:setTopBottom(true, false, -17.5, 36.5)
			f25_arg0:setAlpha(1)
			if f25_arg1.interrupted then
				f1_local0.clipFinished(f25_arg0, f25_arg1)
			else
				f25_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f13_local1(f1_local3, {})
	end, DefaultState = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(1)
		local f14_local0 = function (f26_arg0, f26_arg1)
			if not f26_arg1.interrupted then
				f26_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f26_arg0:setAlpha(0)
			if f26_arg1.interrupted then
				f1_local0.clipFinished(f26_arg0, f26_arg1)
			else
				f26_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f14_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setAlpha(1)
		local f14_local1 = function (f27_arg0, f27_arg1)
			if not f27_arg1.interrupted then
				f27_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f27_arg0:setAlpha(0)
			if f27_arg1.interrupted then
				f1_local0.clipFinished(f27_arg0, f27_arg1)
			else
				f27_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f14_local1(f1_local3, {})
	end}, Active_4x1 = {DefaultClip = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(0.45)
		local f15_local0 = function (f28_arg0, f28_arg1)
			if not f28_arg1.interrupted then
				f28_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f28_arg0:setAlpha(1)
			if f28_arg1.interrupted then
				f1_local0.clipFinished(f28_arg0, f28_arg1)
			else
				f28_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f15_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setLeftRight(false, false, 120.17, 228.17)
		f1_local0.cursorhintimage0:setTopBottom(true, false, -17.5, 36.5)
		f1_local0.cursorhintimage0:setAlpha(0.32)
		local f15_local1 = function (f29_arg0, f29_arg1)
			if not f29_arg1.interrupted then
				f29_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f29_arg0:setLeftRight(false, false, 120.17, 228.17)
			f29_arg0:setTopBottom(true, false, -17.5, 36.5)
			f29_arg0:setAlpha(1)
			if f29_arg1.interrupted then
				f1_local0.clipFinished(f29_arg0, f29_arg1)
			else
				f29_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f15_local1(f1_local3, {})
	end, DefaultState = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(1)
		local f16_local0 = function (f30_arg0, f30_arg1)
			if not f30_arg1.interrupted then
				f30_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f30_arg0:setAlpha(0.45)
			if f30_arg1.interrupted then
				f1_local0.clipFinished(f30_arg0, f30_arg1)
			else
				f30_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f16_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setAlpha(1)
		local f16_local1 = function (f31_arg0, f31_arg1)
			if not f31_arg1.interrupted then
				f31_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f31_arg0:setAlpha(0.32)
			if f31_arg1.interrupted then
				f1_local0.clipFinished(f31_arg0, f31_arg1)
			else
				f31_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f16_local1(f1_local3, {})
	end}, Active_NoImage = {DefaultClip = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(0.45)
		local f17_local0 = function (f32_arg0, f32_arg1)
			if not f32_arg1.interrupted then
				f32_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Bounce)
			end
			f32_arg0:setAlpha(1)
			if f32_arg1.interrupted then
				f1_local0.clipFinished(f32_arg0, f32_arg1)
			else
				f32_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f17_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setLeftRight(false, false, 120.17, 120.17)
		f1_local0.cursorhintimage0:setTopBottom(true, false, -17.5, 36.5)
		f1_local0.clipFinished(f1_local3, {})
	end}, Out = {DefaultClip = function ()
		f1_local0:setupElementClipCounter(2)
		f1_local1:completeAnimation()
		f1_local0.cursorhinttext0:setAlpha(1)
		local f18_local0 = function (f33_arg0, f33_arg1)
			if not f33_arg1.interrupted then
				f33_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f33_arg0:setAlpha(0)
			if f33_arg1.interrupted then
				f1_local0.clipFinished(f33_arg0, f33_arg1)
			else
				f33_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f18_local0(f1_local1, {})
		f1_local3:completeAnimation()
		f1_local0.cursorhintimage0:setAlpha(1)
		local f18_local1 = function (f34_arg0, f34_arg1)
			if not f34_arg1.interrupted then
				f34_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Bounce)
			end
			f34_arg0:setAlpha(0)
			if f34_arg1.interrupted then
				f1_local0.clipFinished(f34_arg0, f34_arg1)
			else
				f34_arg0:registerEventHandler("transition_complete_keyframe", f1_local0.clipFinished)
			end
		end

		f18_local1(f1_local3, {})
	end}}
	LUI.OverrideFunction_CallOriginalSecond(f1_local0, "close", function (Sender)
		Sender.cursorhinttext0:close()
		Sender.cursorhintimage0:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(f1_local0, InstanceRef, HudRef)
	end
	return f1_local0
end

