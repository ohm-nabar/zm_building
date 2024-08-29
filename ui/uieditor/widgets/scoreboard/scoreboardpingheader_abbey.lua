require("ui.uieditor.widgets.EndGameFlow.Top3PlayerScoreBlurBox")
require("ui.uieditor.widgets.Lobby.Common.FE_ButtonPanel")
require("ui.uieditor.widgets.HelperWidgets.TextWithBg")
CoD.ScoreboardPingHeader = InheritFrom(LUI.UIElement)
CoD.ScoreboardPingHeader.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ScoreboardPingHeader)
	Widget.id = "ScoreboardPingHeader"
	Widget.soundSet = "default"
	Widget:setLeftRight(true, false, 0, 36)
	Widget:setTopBottom(true, false, 0, 38)
	local f1_local1 = CoD.Top3PlayerScoreBlurBox.new(HudRef, InstanceRef)
	f1_local1:setLeftRight(true, true, 0, 0)
	f1_local1:setTopBottom(true, true, 0, 0)
	f1_local1:setRFTMaterial(LUI.UIImage.GetCachedMaterial("uie_scene_blur_pass_2"))
	f1_local1:setShaderVector(0, 10, 10, 0, 0)
	--Widget:addElement(f1_local1)
	Widget.Top3PlayerScoreBlurBox00 = f1_local1
	
	local f1_local2 = CoD.FE_ButtonPanel.new(HudRef, InstanceRef)
	f1_local2:setLeftRight(true, true, 0, 0)
	f1_local2:setTopBottom(true, true, 0, 0)
	f1_local2:setRGB(0, 0, 0)
	f1_local2:setAlpha(0.45)
	--Widget:addElement(f1_local2)
	Widget.VSpanel0 = f1_local2
	
	local f1_local3 = CoD.TextWithBg.new(HudRef, InstanceRef)
	f1_local3:setLeftRight(false, true, -61.5, 25.5)
	f1_local3:setTopBottom(true, false, 0, 32)
	f1_local3:setAlpha(1)
	f1_local3:setScale(LanguageOverrideNumber("fulljapanese", 0.7, LanguageOverrideNumber("japanese", 0.7, 1)))
	f1_local3.Bg:setRGB(0.31, 0.31, 0.31)
	f1_local3.Bg:setAlpha(0)
	f1_local3.Text:setRGB(1, 1, 1)
	f1_local3.Text:setAlpha(1)
	f1_local3.Text:setText(Engine.Localize("CGAME_SB_PING"))
	f1_local3.Text:setTTF("fonts/RefrigeratorDeluxe-Regular.ttf")
	f1_local3.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget:addElement(f1_local3)
	Widget.ScoreColumn5Header = f1_local3
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(1)
		f1_local1:completeAnimation()
		Widget.Top3PlayerScoreBlurBox00:setAlpha(1)
		Widget.clipFinished(f1_local1, {})
	end}, GenesisEndGame = {DefaultClip = function ()
		Widget:setupElementClipCounter(1)
		f1_local1:completeAnimation()
		Widget.Top3PlayerScoreBlurBox00:setAlpha(0)
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
		Sender.Top3PlayerScoreBlurBox00:close()
		Sender.VSpanel0:close()
		Sender.ScoreColumn5Header:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

