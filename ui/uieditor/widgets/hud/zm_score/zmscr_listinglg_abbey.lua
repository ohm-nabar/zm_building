require("ui.uieditor.widgets.HUD.CP_DamageWidget.DamageWidgetMP_PanelContainer")
require("ui.uieditor.widgets.onOffImage")
require("ui.uieditor.widgets.HUD.jug_hearts")
require("ui.uieditor.widgets.HUD.solo_lives")

CoD.ZMScr_ListingLg = InheritFrom(LUI.UIElement)

function CoD.ZMScr_ListingLg.new(HudRef, InstanceRef)
	local Elem = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Elem, InstanceRef)
	end
	Elem:setUseStencil(false)
	Elem:setClass(CoD.ZMScr_ListingLg)
	Elem.id = "ZMScr_ListingLg"
	Elem.soundSet = "HUD"
	Elem:setLeftRight(true, false, 0.000000, 134.000000)
	Elem:setTopBottom(true, false, 0.000000, 58.000000)
	Elem.anyChildUsesUpdateState = true

	local panel = CoD.DamageWidgetMP_PanelContainer.new(HudRef, InstanceRef)
	panel:setLeftRight(true, false, 0.000000, 45.000000)
	panel:setTopBottom(false, false, -18.250000, 28.750000)
	panel:setRGB(0.610000, 0.610000, 0.610000)
	panel.PanelAmmo0:setShaderVector(0.000000, 30.000000, 10.000000, 0.000000, 0.000000)
	--Elem:addElement(panel)
	Elem.Panel = panel

	local blood = LUI.UIImage.new()
	blood:setLeftRight(true, false, 1144, 1258)
	blood:setTopBottom(true, false, 12, 52.5)
	blood:setRGB(0.64, 0.03, 0.05)

	Elem:addElement(blood)
	Elem.Blood = blood

	local score = LUI.UITightText.new()
	score:setLeftRight(true, false, 1151, 1228)
	score:setTopBottom(true, false, 15, 52)
	score:setTTF("fonts/CaslonAntique-Bold.ttf")

	local name = LUI.UITightText.new()
	name:setLeftRight(true, false, 45, 82)
	name:setTopBottom(true, false, 7.5, 44.5)
	name:setTTF("fonts/CaslonAntique-Bold.ttf")
	
	local nameLookup = {"Charlie", "Jean-Paul", "Archie", "Rico"}
	Elem:addElement(name)
	Elem.Name = name

	local healthWidget = CoD.JugHearts.new(HudRef, InstanceRef)
	healthWidget:setLeftRight(true, false, 1.5, 101.5)
    healthWidget:setTopBottom(true, false, 20, 120)
	Elem:addElement(healthWidget)
	Elem.HealthWidget = healthWidget

	local livesWidget = CoD.SoloLives.new(HudRef, InstanceRef)
	livesWidget:setLeftRight(true, false, 102, 145)
    livesWidget:setTopBottom(true, false, 44, 87)
	Elem:addElement(livesWidget)
	Elem.LivesWidget = livesWidget

	local bloodVial = LUI.UIImage.new()
	bloodVial:setLeftRight(true, false, 82, 112)
    bloodVial:setTopBottom(true, false, 12, 42)
	bloodVial:setImage(RegisterImage("i_bloodvialempty"))
	Elem:addElement(bloodVial)
	Elem.BloodVial = bloodVial

	local function ScoreSetColor(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			score:setRGB(ZombieClientScoreboardColor(ModelValue))
			name:setRGB(ZombieClientScoreboardColor(ModelValue))
		end
	end

	score:linkToElementModel(Elem, "clientNum", true, ScoreSetColor)

	local function ScoreChange(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			score:setText(Engine.Localize(ModelValue))
		end
	end

	score:linkToElementModel(Elem, "playerScore", true, ScoreChange)
	local function scoreSetText(Element, unk1)
		ScaleWidgetToLabel(Elem, Element, 0.000000)
	end

	LUI.OverrideFunction_CallOriginalFirst(score, "setText", scoreSetText)

	Elem:addElement(score)
	Elem.Score = score

	local PortraitIcon = CoD.onOffImage.new(HudRef, InstanceRef)
	PortraitIcon:setLeftRight(true, false, 5.000000, 40.000000)
	PortraitIcon:setTopBottom(true, false, 8.5, 43.5)
	local function PortraitIconLinkModel(Model)
		PortraitIcon:setModel(Model, InstanceRef)
	end

	PortraitIcon:linkToElementModel(Elem, nil, false, PortraitIconLinkModel)

	local CharNumLookupTable = {3, 1, 4, 2}
	local function PortraitIconChange(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			PortraitIcon.image:setImage(RegisterImage(ModelValue))
			local charNumStr = string.sub(ModelValue, -1)
			blood:setImage(RegisterImage("score_blood" .. charNumStr))
			
			local charNum = tonumber(charNumStr)
			if charNum then
				local nameStr = nameLookup[charNum]
				name:setText(nameStr)
				local x = 45 + name:getTextWidth() - 5
				local x2 = x + 30
				bloodVial:setLeftRight(true, false, x, x2)

				local function BloodVialShow(ModelRef)
					local NotifyData = Engine.GetModelValue(ModelRef)
					if NotifyData then
						if NotifyData == 0 then
							bloodVial:hide()
						elseif NotifyData <= 4 then
							local BloodCharNumIndex = NotifyData
							local BloodCharNum = CharNumLookupTable[BloodCharNumIndex]
							if charNum == BloodCharNum then
								bloodVial:setImage(RegisterImage("i_bloodvialempty"))
								bloodVial:show()
							end
						else
							local BloodCharNumIndex = NotifyData - 4
							local BloodCharNum = CharNumLookupTable[BloodCharNumIndex]
							if charNum == BloodCharNum then
								bloodVial:setImage(RegisterImage("i_bloodvialfull"))
								bloodVial:show()
							end
						end
					end
				end
				bloodVial:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "bloodVial"), BloodVialShow)
			end
		end
	end

	PortraitIcon:linkToElementModel(Elem, "zombiePlayerIcon", true, PortraitIconChange)

	local function PortraitIconShown(arg0, arg2, arg3)
		return IsSelfModelValueEqualTo(arg2, InstanceRef, "zombieWearableIcon", "blacktransparent")
	end

	PortraitIcon:mergeStateConditions({{stateName = "On", condition = PortraitIconShown}})

	local function PortraitIconShownUpdate(ModelRef)
		HudRef:updateElementState(PortraitIcon, {name = "model_validation", menu = HudRef,
			modelValue = Engine.GetModelValue(ModelRef),
			modelName = "zombieWearableIcon"
		})
	end

	PortraitIcon:linkToElementModel(PortraitIcon, "zombieWearableIcon", true, PortraitIconShownUpdate)
	Elem:addElement(PortraitIcon)
	Elem.portraitIcon = PortraitIcon

	local PortraitIcon0 = CoD.onOffImage.new(HudRef, InstanceRef)
	PortraitIcon0:setLeftRight(true, false, 2.000000, 43.000000)
	PortraitIcon0:setTopBottom(true, false, 13.220000, 54.220000)
	local function PortraitIcon0LinkModel(Model)
		PortraitIcon0:setModel(Model, InstanceRef)
	end

	PortraitIcon0:linkToElementModel(Elem, nil, false, PortraitIcon0LinkModel)

	local function PortraitIcon0Change(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			PortraitIcon0.image:setImage(RegisterImage(ModelValue))
		end
	end

	PortraitIcon0:linkToElementModel(Elem, "zombieWearableIcon", true, PortraitIcon0Change)

	local function PortraitIcon0Shown(arg0, arg2, arg3)
		return not IsSelfModelValueEqualTo(arg2, InstanceRef, "zombieWearableIcon", "blacktransparent")
	end

	PortraitIcon0:mergeStateConditions({{stateName = "On",condition = PortraitIcon0Shown}})

	local function PortraitIcon0ShownUpdate(ModelRef)
		HudRef:updateElementState(PortraitIcon0, {name = "model_validation",menu = HudRef,
			modelValue = Engine.GetModelValue(ModelRef),
			modelName = "zombieWearableIcon"
		})
	end

	PortraitIcon0:linkToElementModel(PortraitIcon0, "zombieWearableIcon", true, PortraitIcon0ShownUpdate)

	Elem:addElement(PortraitIcon0)
	Elem.portraitIcon0 = PortraitIcon0

	local image0 = LUI.UIImage.new()
	image0:setLeftRight(true, false, 0.000000, 28.000000)
	image0:setTopBottom(false, true, -28.000000, 0.000000)

	local function image0Change(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			image0:setImage(RegisterImage(ModelValue))
		end
	end

	image0:linkToElementModel(Elem, "zombieInventoryIcon", true, image0Change)
	Elem:addElement(image0)
	Elem.Image0 = image0

	local function DSDefaultClip()
		Elem:setupElementClipCounter(4.000000)
		panel:completeAnimation()
		Elem.Panel:setAlpha(0.000000)
		Elem.clipFinished(panel, {})
		score:completeAnimation()
		Elem.Score:setAlpha(0.000000)
		Elem.clipFinished(score, {})
		image0:completeAnimation()
		Elem.Image0:setAlpha(0.000000)
		Elem.clipFinished(image0, {})
		Elem.Blood:setAlpha(0.000000)
		Elem.clipFinished(blood, {})
		Elem.Name:setAlpha(0.000000)
		Elem.clipFinished(name, {})
		Elem.HealthWidget:setAlpha(0)
		Elem.clipFinished(healthWidget, {})
		Elem.LivesWidget:setAlpha(0)
		Elem.clipFinished(livesWidget, {})
		Elem.BloodVial:setAlpha(0)
		Elem.clipFinished(bloodVial, {})
	end

	local function DSVisible()
		Elem:setupElementClipCounter(4.000000)
		local function Panel_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		panel:completeAnimation()
		Elem.Panel:setAlpha(0.000000)

		Panel_DSVisible_1(panel, {})

		local function Score_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		score:completeAnimation()
		Elem.Score:setAlpha(0.000000)

		Score_DSVisible_1(score, {})

		local function Image0_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		image0:completeAnimation()
		Elem.Image0:setAlpha(0.000000)

		Image0_DSVisible_1(image0, {})

		local function Blood_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end
		
		blood:completeAnimation()
		Elem.Blood:setAlpha(0.000000)
		
		Blood_DSVisible_1(blood, {})

		local function Name_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end
		
		name:completeAnimation()
		Elem.Name:setAlpha(0.000000)
		
		Name_DSVisible_1(name, {})

		local function HealthWidget_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end
		
		healthWidget:completeAnimation()
		Elem.HealthWidget:setAlpha(0.000000)
		
		HealthWidget_DSVisible_1(healthWidget, {})

		local function LivesWidget_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end
		
		livesWidget:completeAnimation()
		Elem.LivesWidget:setAlpha(0.000000)
		
		LivesWidget_DSVisible_1(livesWidget, {})

		local function BloodVial_DSVisible_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end
		
		bloodVial:completeAnimation()
		Elem.BloodVial:setAlpha(0.000000)
		
		BloodVial_DSVisible_1(bloodVial, {})
	end

	local function DSVisibleTomb()
		Elem:setupElementClipCounter(4.000000)
		local function Panel_DSVisibleTomb_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		panel:completeAnimation()
		Elem.Panel:setAlpha(0.000000)

		Panel_DSVisibleTomb_1(panel, {})

		local function Score_DSVisibleTomb_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		score:completeAnimation()
		Elem.Score:setAlpha(0.000000)

		Score_DSVisibleTomb_1(score, {})

		local function Image0_DSVisibleTomb_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 300.000000, false, false, CoD.TweenType.Bounce)
			end
			Element:setLeftRight(true, false, -21.000000, 7.000000)
			Element:setTopBottom(false, true, -31.780000, -3.780000)
			Element:setAlpha(1.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		image0:completeAnimation()
		Elem.Image0:setLeftRight(true, false, -21.000000, 7.000000)
		Elem.Image0:setTopBottom(false, true, -31.780000, -3.780000)
		Elem.Image0:setAlpha(0.000000)

		Image0_DSVisibleTomb_1(image0, {})
	end

	local function VTDefaultClip()
		Elem:setupElementClipCounter(4.000000)
		panel:completeAnimation()
		Elem.Panel:setAlpha(1.000000)
		Elem.clipFinished(panel, {})
		score:completeAnimation()
		Elem.Score:setAlpha(1.000000)
		Elem.clipFinished(score, {})
		image0:completeAnimation()
		Elem.Image0:setLeftRight(true, false, -21.000000, 7.000000)
		Elem.Image0:setTopBottom(false, true, -31.780000, -3.780000)
		Elem.Image0:setAlpha(1.000000)
		Elem.clipFinished(image0, {})
		Elem.Blood:setAlpha(1)
		Elem.clipFinished(blood, {})
		Elem.Name:setAlpha(1)
		Elem.clipFinished(name, {})
		Elem.HealthWidget:setAlpha(1)
		Elem.clipFinished(healthWidget, {})
		Elem.LivesWidget:setAlpha(1)
		Elem.clipFinished(livesWidget, {})
		Elem.BloodVial:setAlpha(1)
		Elem.clipFinished(bloodVial, {})
	end

	local function VTDefaultState()
		Elem:setupElementClipCounter(4.000000)
		local function Panel_VTDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		panel:completeAnimation()
		Elem.Panel:setAlpha(1.000000)

		Panel_VTDefaultState_1(panel, {})

		local function Score_VTDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		score:completeAnimation()
		Elem.Score:setAlpha(1.000000)

		Score_VTDefaultState_1(score, {})

		local function Image0_VTDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		image0:completeAnimation()
		Elem.Image0:setAlpha(1.000000)

		Image0_VTDefaultState_1(image0, {})
	end

	local function VDefaultClip()
		Elem:setupElementClipCounter(4.000000)
		panel:completeAnimation()
		Elem.Panel:setAlpha(1.000000)
		Elem.clipFinished(panel, {})
		score:completeAnimation()
		Elem.Score:setAlpha(1.000000)
		Elem.clipFinished(score, {})
		image0:completeAnimation()
		Elem.Image0:setAlpha(1.000000)
		Elem.clipFinished(image0, {})
		Elem.Blood:setAlpha(1)
		Elem.clipFinished(blood, {})
		Elem.Name:setAlpha(1)
		Elem.clipFinished(name, {})
		Elem.LivesWidget:setAlpha(1)
		Elem.clipFinished(livesWidget, {})
		Elem.BloodVial:setAlpha(1)
		Elem.clipFinished(bloodVial, {})
	end

	local function VDefaultState()
		Elem:setupElementClipCounter(4.000000)
		local function Panel_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		panel:completeAnimation()
		Elem.Panel:setAlpha(1.000000)

		Panel_VDefaultState_1(panel, {})

		local function Score_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		score:completeAnimation()
		Elem.Score:setAlpha(1.000000)

		Score_VDefaultState_1(score, {})

		local function Image0_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		image0:completeAnimation()
		Elem.Image0:setAlpha(1.000000)

		Image0_VDefaultState_1(image0, {})

		local function Blood_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		blood:completeAnimation()
		Elem.Blood:setAlpha(1.000000)

		Blood_VDefaultState_1(blood, {})

		local function Name_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		name:completeAnimation()
		Elem.Name:setAlpha(1.000000)

		Name_VDefaultState_1(name, {})

		local function HealthWidget_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		healthWidget:completeAnimation()
		Elem.HealthWidget:setAlpha(1.000000)

		HealthWidget_VDefaultState_1(healthWidget, {})

		local function LivesWidget_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		livesWidget:completeAnimation()
		Elem.LivesWidget:setAlpha(1.000000)

		LivesWidget_VDefaultState_1(livesWidget, {})

		local function BloodVial_VDefaultState_1(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 200.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setAlpha(0.000000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end
		
		bloodVial:completeAnimation()
		Elem.BloodVial:setAlpha(1.000000)

		BloodVial_VDefaultState_1(bloodVial, {})
	end

	Elem.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = DSDefaultClip,
			Visible = DSVisible,
			VisibleTomb = DSVisibleTomb
		},
		VisibleTomb =
		{
			DefaultClip = VTDefaultClip,
			DefaultState = VTDefaultState
		},
		Visible =
		{
			DefaultClip = VDefaultClip,
			DefaultState = VDefaultState
		}
	}

	local function TombCondition(arg0, arg2, arg3)
		local isTomb = false
		if not IsSelfModelValueEqualTo(arg2, InstanceRef, "playerScoreShown", 0.000000) then
			isTomb = IsMapName("zm_tomb")
		end
		return isTomb
	end

	local function SeeCondition(arg0, arg2, arg3)
		return not IsSelfModelValueEqualTo(arg2, InstanceRef, "playerScoreShown", 0.000000)
	end

	Elem:mergeStateConditions({{stateName = "VisibleTomb", condition = TombCondition},{stateName = "Visible", condition = SeeCondition}})
	local function PlayerScrShwn(ModelRef)
		HudRef:updateElementState(Elem, {name = "model_validation", menu = HudRef,
			modelValue = Engine.GetModelValue(ModelRef),
			modelName = "playerScoreShown"
		})
	end

	Elem:linkToElementModel(Elem, "playerScoreShown", true, PlayerScrShwn)
	local function CloseEvent(SenderObj)
		SenderObj.Panel:close()
		SenderObj.portraitIcon:close()
		SenderObj.portraitIcon0:close()
		SenderObj.Score:close()
		SenderObj.Image0:close()
		SenderObj.Name:close()
		SenderObj.Blood:close()
		SenderObj.HealthWidget:close()
		SenderObj.LivesWidget:close()
		SenderObj.BloodVial:close()
	end

	LUI.OverrideFunction_CallOriginalSecond(Elem, "close", CloseEvent)
	if PostLoadFunc then
		PostLoadFunc(Elem, InstanceRef, HudRef)
	end
	return Elem
end

