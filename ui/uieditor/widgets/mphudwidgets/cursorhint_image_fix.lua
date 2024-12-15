CoD.cursorhint_image = InheritFrom(LUI.UIElement)
CoD.cursorhint_image.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.cursorhint_image)
	Widget.id = "cursorhint_image"
	Widget.soundSet = "HUD"
	Widget:setLeftRight(true, false, 0, 108)
	Widget:setTopBottom(true, false, 0, 54)
	local f1_local1 = LUI.UIImage.new()
	f1_local1:setLeftRight(true, true, 0, -54)
	f1_local1:setTopBottom(true, true, 0, 0)
	f1_local1:setAlpha(0)
	--FV
	f1_local1:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", function(ModelRef)
		if IsParamModelEqualToString(ModelRef, "set_cursor_hint_image") then
			local data = CoD.GetScriptNotifyData(ModelRef)
			local index = data[1]
			if index then
				local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
				local bgbName = Engine.TableLookup(nil, tableName, 1, index, 0)
				bgbName = string.sub(bgbName, 4)
				local image = "t7_hud_zm_" .. bgbName
				f1_local1:setImage(RegisterImage(image))
			end
		end
	end)
	--f1_local1:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintImage", function (ModelRef)
	--	local ModelValue = Engine.GetModelValue(ModelRef)
	--	if ModelValue then
	--		f1_local1:setImage(RegisterImage("t7_hud_zm_bgb_flavor_hexed"))
	--	end
	--end)
	Widget:addElement(f1_local1)
	Widget.c1x1 = f1_local1
	
	local f1_local2 = LUI.UIImage.new()
	f1_local2:setLeftRight(true, true, 0, 0)
	f1_local2:setTopBottom(true, true, 13.5, -13.5)
	--FV
	f1_local2:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", function(ModelRef)
		if IsParamModelEqualToString(ModelRef, "set_cursor_hint_image") then
			local data = CoD.GetScriptNotifyData(ModelRef)
			local index = data[1]
			if index then
				local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
				local bgbName = Engine.TableLookup(nil, tableName, 1, index, 0)
				bgbName = string.sub(bgbName, 4)
				local image = "t7_hud_zm_" .. bgbName
				f1_local1:setImage(RegisterImage(image))
			end
		end
	end)
	--f1_local2:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintImage", function (ModelRef)
	--	local ModelValue = Engine.GetModelValue(ModelRef)
	--	if ModelValue then
	--		f1_local2:setImage(RegisterImage("t7_hud_zm_bgb_flavor_hexed"))
	--	end
	--end)
	Widget:addElement(f1_local2)
	Widget.x1x4 = f1_local2
	
	local f1_local3 = LUI.UIImage.new()
	f1_local3:setLeftRight(true, true, 0, 0)
	f1_local3:setTopBottom(true, true, 0, 0)
	f1_local3:setAlpha(0)
	--FV
	f1_local3:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", function(ModelRef)
		if IsParamModelEqualToString(ModelRef, "set_cursor_hint_image") then
			local data = CoD.GetScriptNotifyData(ModelRef)
			local index = data[1]
			if index then
				local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
				local bgbName = Engine.TableLookup(nil, tableName, 1, index, 0)
				bgbName = string.sub(bgbName, 4)
				local image = "t7_hud_zm_" .. bgbName
				f1_local1:setImage(RegisterImage(image))
			end
		end
	end)
	--f1_local3:subscribeToGlobalModel(InstanceRef, "HUDItems", "cursorHintImage", function (ModelRef)
	--	local ModelValue = Engine.GetModelValue(ModelRef)
	--	if ModelValue then
	--		f1_local3:setImage(RegisterImage("t7_hud_zm_bgb_flavor_hexed"))
	--	end
	--end)
	Widget:addElement(f1_local3)
	Widget.c1x2 = f1_local3
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.c1x1:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.x1x4:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.c1x2:setAlpha(0)
		Widget.clipFinished(f1_local3, {})
	end}, Active_1x1 = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.c1x1:setAlpha(1)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.x1x4:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.c1x2:setAlpha(0)
		Widget.clipFinished(f1_local3, {})
	end}, Active_2x1 = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.c1x1:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.x1x4:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.c1x2:setAlpha(1)
		Widget.clipFinished(f1_local3, {})
	end}, Active_4x1 = {DefaultClip = function ()
		Widget:setupElementClipCounter(3)
		f1_local1:completeAnimation()
		Widget.c1x1:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.x1x4:setAlpha(1)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.c1x2:setAlpha(0)
		Widget.clipFinished(f1_local3, {})
	end}, Out = {DefaultClip = function ()
		Widget:setupElementClipCounter(0)
	end}}
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.c1x1:close()
		Sender.x1x4:close()
		Sender.c1x2:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

