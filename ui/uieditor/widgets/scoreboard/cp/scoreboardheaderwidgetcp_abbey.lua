require("ui.uieditor.widgets.Lobby.Common.FE_ButtonPanelShaderContainer")
require("ui.uieditor.widgets.HelperWidgets.TextWithBg")
require("ui.uieditor.widgets.Scoreboard.ScoreboardPingHeader")
CoD.ScoreboardHeaderWidgetCP = InheritFrom(LUI.UIElement)
CoD.ScoreboardHeaderWidgetCP.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ScoreboardHeaderWidgetCP)
	Widget.id = "ScoreboardHeaderWidgetCP"
	Widget.soundSet = "default"
	Widget:setLeftRight(true, false, 0, 750)
	Widget:setTopBottom(true, false, 0, 32)
	Widget.anyChildUsesUpdateState = true
	local f1_local1 = CoD.FE_ButtonPanelShaderContainer.new(HudRef, InstanceRef)
	f1_local1:setLeftRight(true, true, 0, -13)
	f1_local1:setTopBottom(true, true, 0, 0)
	f1_local1:setRGB(0.6, 0.6, 0.6)
	--Widget:addElement(f1_local1)
	Widget.Panel = f1_local1
	
	local f1_local2 = CoD.TextWithBg.new(HudRef, InstanceRef)
	f1_local2:setLeftRight(false, true, -444.5, -357.5)
	f1_local2:setTopBottom(true, false, 0, 32)
	f1_local2:setAlpha(1)
	f1_local2:setScale(LanguageOverrideNumber("fulljapanese", 0.7, LanguageOverrideNumber("japanese", 0.7, 1)))
	f1_local2.Bg:setRGB(0.31, 0.31, 0.31)
	f1_local2.Bg:setAlpha(0)
	f1_local2.Text:setRGB(1, 1, 1)
	f1_local2.Text:setAlpha(1)
	f1_local2.Text:setText("Points")
	f1_local2.Text:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local2.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget:addElement(f1_local2)
	Widget.ScoreColumn1Header = f1_local2
	
	local f1_local3 = CoD.TextWithBg.new(HudRef, InstanceRef)
	f1_local3:setLeftRight(false, true, -355.5, -268.5)
	f1_local3:setTopBottom(true, false, 0, 32)
	f1_local3:setAlpha(1)
	f1_local3:setScale(LanguageOverrideNumber("fulljapanese", 0.7, LanguageOverrideNumber("japanese", 0.7, 1)))
	f1_local3.Bg:setRGB(0.31, 0.31, 0.31)
	f1_local3.Bg:setAlpha(0)
	f1_local3.Text:setRGB(1, 1, 1)
	f1_local3.Text:setAlpha(1)
	f1_local3.Text:setText("Kills")
	f1_local3.Text:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local3.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget:addElement(f1_local3)
	Widget.ScoreColumn2Header = f1_local3
	
	local f1_local4 = CoD.TextWithBg.new(HudRef, InstanceRef)
	f1_local4:setLeftRight(false, true, -269.5, -182.5)
	f1_local4:setTopBottom(true, false, 0, 32)
	f1_local4:setAlpha(1)
	f1_local4:setScale(LanguageOverrideNumber("fulljapanese", 0.7, LanguageOverrideNumber("japanese", 0.7, 1)))
	f1_local4.Bg:setRGB(0.31, 0.31, 0.31)
	f1_local4.Bg:setAlpha(0)
	f1_local4.Text:setRGB(1, 1, 1)
	f1_local4.Text:setAlpha(1)
	f1_local4.Text:setText("Revives")
	f1_local4.Text:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local4.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget:addElement(f1_local4)
	Widget.ScoreColumn3Header = f1_local4
	
	local f1_local5 = CoD.TextWithBg.new(HudRef, InstanceRef)
	f1_local5:setLeftRight(false, true, -183.5, -96.5)
	f1_local5:setTopBottom(true, false, 0, 32)
	f1_local5:setAlpha(1)
	f1_local5:setScale(LanguageOverrideNumber("fulljapanese", 0.7, LanguageOverrideNumber("japanese", 0.7, 1)))
	f1_local5.Bg:setRGB(0.31, 0.31, 0.31)
	f1_local5.Bg:setAlpha(0)
	f1_local5.Text:setRGB(1, 1, 1)
	f1_local5.Text:setAlpha(1)
	f1_local5.Text:setText("Downs")
	f1_local5.Text:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local5.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget:addElement(f1_local5)
	Widget.ScoreColumn4Header = f1_local5
	
	local f1_local6 = CoD.TextWithBg.new(HudRef, InstanceRef)
	f1_local6:setLeftRight(false, true, -98.5, -10)
	f1_local6:setTopBottom(true, false, 0, 32)
	f1_local6:setAlpha(1)
	f1_local6:setScale(LanguageOverrideNumber("fulljapanese", 0.7, LanguageOverrideNumber("japanese", 0.7, 1)))
	f1_local6.Bg:setRGB(0.31, 0.31, 0.31)
	f1_local6.Bg:setAlpha(0)
	f1_local6.Text:setRGB(1, 1, 1)
	f1_local6.Text:setAlpha(1)
	f1_local6.Text:setText("Headshots")
	f1_local6.Text:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local6.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget:addElement(f1_local6)
	Widget.ScoreColumn5Header = f1_local6
	
	local f1_local7 = LUI.UIText.new()
	f1_local7:setLeftRight(true, false, 12, 351)
	f1_local7:setTopBottom(true, false, 6.5, 25.5)
	f1_local7:setAlpha(0.8)
	f1_local7:setText(Engine.Localize("MENU_SCOREBOARD_HEADER_CP"))
	f1_local7:setTTF("fonts/escom.ttf")
	f1_local7:setLetterSpacing(2)
	f1_local7:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	f1_local7:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f1_local7)
	Widget.Title = f1_local7
	
	local f1_local8 = CoD.ScoreboardPingHeader.new(HudRef, InstanceRef)
	f1_local8:setLeftRight(false, true, -15, 24)
	f1_local8:setTopBottom(true, false, 0, 32)
	f1_local8:setAlpha(GetScoreboardPingValueAlpha(1))
	Widget:addElement(f1_local8)
	Widget.PingHeader = f1_local8
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(1)
		f1_local1:completeAnimation()
		Widget.Panel:setAlpha(1)
		Widget.clipFinished(f1_local1, {})
	end}, GenesisEndGame = {DefaultClip = function ()
		Widget:setupElementClipCounter(1)
		f1_local1:completeAnimation()
		Widget.Panel:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
	end}}
	Widget:mergeStateConditions({{stateName = "GenesisEndGame", condition = function (HudRef, ItemRef, UpdateTable)
		local f4_local0 = Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED)
		if f4_local0 then
			f4_local0 = IsMapName("zm_genesis")
			if f4_local0 then
				f4_local0 = IsGenesisEECompleted(InstanceRef)
			end
		end
		return f4_local0
	end}})
	Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED})
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.Panel:close()
		Sender.ScoreColumn1Header:close()
		Sender.ScoreColumn2Header:close()
		Sender.ScoreColumn3Header:close()
		Sender.ScoreColumn4Header:close()
		Sender.ScoreColumn5Header:close()
		Sender.PingHeader:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

