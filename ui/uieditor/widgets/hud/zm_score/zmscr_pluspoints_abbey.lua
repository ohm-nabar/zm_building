CoD.ZMScr_PlusPoints = InheritFrom(LUI.UIElement)

CoD.ZMScr_PlusPoints.IsVisible = function(InstanceRef)
    if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
            return false
        else
            return true
        end
    else
        return false
    end
end

CoD.ZMScr_PlusPoints.UpdateVisibility = function(Elem, InstanceRef)
    if CoD.ZMScr_PlusPoints.IsVisible(InstanceRef) then
        Elem:setAlpha(1)
        Elem.visible = true
    else
        Elem:setAlpha(0)
        Elem.visible = false
    end
end

function CoD.ZMScr_PlusPoints.new(HudRef, InstanceRef)
	local Elem = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Elem, InstanceRef)
	end
	Elem:setUseStencil(false)
	Elem:setClass(CoD.ZMScr_PlusPoints)
	Elem.id = "ZMScr_PlusPoints"
	Elem.soundSet = "HUD"
	Elem:setLeftRight(true, false, 0.000000, 85.000000)
    Elem:setTopBottom(true, false, 0.000000, 66.000000)
    
	local label2 = LUI.UITightText.new()
	label2:setLeftRight(true, false, 18.000000, 84.000000)
	label2:setTopBottom(true, false, 14.380000, 51.380000)
	label2:setRGB(1.000000, 0.520000, 0.000000)
	label2:setAlpha(0.010000)
	label2:setZoom(-8.000000)
	label2:setText(Engine.Localize("+50"))
	label2:setTTF("fonts/WEARETRIPPINShort.ttf")
	label2:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	label2:setShaderVector(0.000000, 0.210000, 0.000000, 0.000000, 0.000000)
	label2:setShaderVector(1.000000, 0.000000, 0.000000, 0.000000, 0.000000)
	label2:setShaderVector(2.000000, 1.000000, 0.000000, 0.000000, 0.000000)
	label2:setLetterSpacing(0.900000)
	--Elem:addElement(label2)
    Elem.Label2 = label2
    
	local label1 = LUI.UITightText.new()
	label1:setLeftRight(true, false, 50.000000, 83.000000)
	label1:setTopBottom(true, false, 0, 30)
	label1:setRGB(1, 1, 0)
	label1:setAlpha(0.000000)
	label1:setText(Engine.Localize("+50"))
	label1:setTTF("fonts/WEARETRIPPINShort.ttf")
	Elem:addElement(label1)
    Elem.Label1 = label1
    
	local glow = LUI.UIImage.new()
	glow:setLeftRight(true, false, 0.000000, 85.000000)
	glow:setTopBottom(true, false, 0.000000, 65.750000)
	glow:setRGB(1.000000, 0.260000, 0.000000)
	glow:setAlpha(0.010000)
	glow:setImage(RegisterImage("uie_t7_core_hud_mapwidget_panelglow"))
	glow:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	--Elem:addElement(glow)
	Elem.Glow = glow

	Elem.visible = true
    
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), function(ModelRef)
        CoD.ZMScr_PlusPoints.UpdateVisibility(Elem, InstanceRef)
	end)

	local function DSDefaultClip()
		Elem:setupElementClipCounter(3.000000)
		local function Label2_DSDefaultClip_1(Element, Event)
			local function Label2_DSDefaultClip_2(Element, Event)
				local function Label2_DSDefaultClip_3(Element, Event)
					local function Label2_DSDefaultClip_4(Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 169.000000, false, false, CoD.TweenType.Bounce)
						end
						Element:setAlpha(0.000000)
						if Event.interrupted then
							Elem.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
						end
					end

					if Event.interrupted then
						Label2_DSDefaultClip_4(Element, Event)
						return
					end
					Element:beginAnimation("keyframe", 330.000000, false, false, CoD.TweenType.Linear)
					Element:registerEventHandler("transition_complete_keyframe", Label2_DSDefaultClip_4)
				end

				if Event.interrupted then
					Label2_DSDefaultClip_3(Element, Event)
					return
				end
				Element:beginAnimation("keyframe", 140.000000, false, false, CoD.TweenType.Bounce)
				Element:registerEventHandler("transition_complete_keyframe", Label2_DSDefaultClip_3)
			end

			if Event.interrupted then
				Label2_DSDefaultClip_2(Element, Event)
				return
			end
			Element:beginAnimation("keyframe", 129.000000, false, false, CoD.TweenType.Bounce)
			Element:setAlpha(1.0000)
			Element:registerEventHandler("transition_complete_keyframe", Label2_DSDefaultClip_2)
		end

		label2:completeAnimation()
		Elem.Label2:setAlpha(0.000000)

        Label2_DSDefaultClip_1(label2, {})
        
		local function Label1_DSDefaultClip_1(Element, Event)
			local function Label1_DSDefaultClip_2(Element, Event)
				local function Label1_DSDefaultClip_3(Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 100.000000, false, false, CoD.TweenType.Bounce)
					end
					Element:setAlpha(0.000000)
					if Event.interrupted then
						Elem.clipFinished(Element, Event)
					else
						Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
					end
				end

				if Event.interrupted then
					Label1_DSDefaultClip_3(Element, Event)
					return
				end
				Element:beginAnimation("keyframe", 579.000000, false, false, CoD.TweenType.Linear)
				Element:registerEventHandler("transition_complete_keyframe", Label1_DSDefaultClip_3)
			end

			if Event.interrupted then
				Label1_DSDefaultClip_2(Element, Event)
				return
			end
			Element:beginAnimation("keyframe", 70.000000, false, false, CoD.TweenType.Linear)
			Element:setAlpha(1.000000)
			Element:registerEventHandler("transition_complete_keyframe", Label1_DSDefaultClip_2)
		end

		label1:completeAnimation()
		Elem.Label1:setAlpha(0.000000)

        Label1_DSDefaultClip_1(label1, {})
        
        local function Glow_DSDefaultClip_1(Element, Event)
			local function Glow_DSDefaultClip_2(Element, Event)
				local function Glow_DSDefaultClip_3(Element, Event)
					local function __FUNC_1997_(Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 189.000000, false, false, CoD.TweenType.Bounce)
						end
						Element:setAlpha(0.000000)
						if Event.interrupted then
							Elem.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
						end
					end

					if Event.interrupted then
						__FUNC_1997_(Element, Event)
						return
					end
					Element:beginAnimation("keyframe", 469.000000, false, false, CoD.TweenType.Linear)
					Element:setAlpha(0.340000)
					Element:registerEventHandler("transition_complete_keyframe", __FUNC_1997_)
				end

				if Event.interrupted then
					Glow_DSDefaultClip_3(Element, Event)
					return
				end
				Element:beginAnimation("keyframe", 60.000000, false, false, CoD.TweenType.Bounce)
				Element:setAlpha(0.420000)
				Element:registerEventHandler("transition_complete_keyframe", Glow_DSDefaultClip_3)
			end

			if Event.interrupted then
				Glow_DSDefaultClip_2(Element, Event)
				return
			end
			Element:beginAnimation("keyframe", 39.000000, false, false, CoD.TweenType.Linear)
			Element:setAlpha(1.000000)
			Element:registerEventHandler("transition_complete_keyframe", Glow_DSDefaultClip_2)
		end

		glow:completeAnimation()
		Elem.Glow:setAlpha(0.000000)

		Glow_DSDefaultClip_1(glow, {})
	end

	local function DSNegativeScore()
		Elem:setupElementClipCounter(3.000000)
		local function Label2_DSNegativeScore_1(Element, Event)
			local function Label2_DSNegativeScore_2(Element, Event)
				local function Label2_DSNegativeScore_3(Element, Event)
					local function Label2_DSNegativeScore_4(Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 169.000000, false, false, CoD.TweenType.Bounce)
						end
						Element:setRGB(0.451, 0, 0.059)
						Element:setAlpha(0.000000)
						if Event.interrupted then
							Elem.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
						end
					end

					if Event.interrupted then
						Label2_DSNegativeScore_4(Element, Event)
						return
					end
					Element:beginAnimation("keyframe", 330.000000, false, false, CoD.TweenType.Linear)
					Element:registerEventHandler("transition_complete_keyframe", Label2_DSNegativeScore_4)
				end

				if Event.interrupted then
					Label2_DSNegativeScore_3(Element, Event)
					return
				end
				Element:beginAnimation("keyframe", 140.000000, false, false, CoD.TweenType.Bounce)
				Element:registerEventHandler("transition_complete_keyframe", Label2_DSNegativeScore_3)
			end

			if Event.interrupted then
				Label2_DSNegativeScore_2(Element, Event)
				return
			end
			Element:beginAnimation("keyframe", 129.000000, false, false, CoD.TweenType.Bounce)
			Element:setAlpha(0.430000)
			Element:registerEventHandler("transition_complete_keyframe", Label2_DSNegativeScore_2)
		end

		label2:completeAnimation()
		Elem.Label2:setRGB(0.451, 0, 0.059)
		Elem.Label2:setAlpha(0.000000)

        Label2_DSNegativeScore_1(label2, {})

		local function Label1_DSNegativeScore_1(Element, Event)
			local function Label1_DSNegativeScore_2(Element, Event)
				local function Label1_DSNegativeScore_3(Element, Event)
					if not Event.interrupted then
						Element:beginAnimation("keyframe", 100.000000, false, false, CoD.TweenType.Bounce)
					end
					Element:setRGB(0.3, 0, 0.039)
					Element:setAlpha(0.000000)
					if Event.interrupted then
						Elem.clipFinished(Element, Event)
					else
						Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
					end
				end

				if Event.interrupted then
					Label1_DSNegativeScore_3(Element, Event)
					return
				end
				Element:beginAnimation("keyframe", 579.000000, false, false, CoD.TweenType.Linear)
				Element:registerEventHandler("transition_complete_keyframe", Label1_DSNegativeScore_3)
			end

			if Event.interrupted then
				Label1_DSNegativeScore_2(Element, Event)
				return
			end
			Element:beginAnimation("keyframe", 70.000000, false, false, CoD.TweenType.Linear)
			Element:setAlpha(1.000000)
			Element:registerEventHandler("transition_complete_keyframe", Label1_DSNegativeScore_2)
		end

		label1:completeAnimation()
		Elem.Label1:setRGB(0.3, 0, 0.039)
		Elem.Label1:setAlpha(0.000000)

        Label1_DSNegativeScore_1(label1, {})
        
		local function Glow_DSNegativeScore_1(Element, Event)
			local function Glow_DSNegativeScore_2(Element, Event)
				local function Glow_DSNegativeScore_3(Element, Event)
					local function Glow_DSNegativeScore_4(Element, Event)
						if not Event.interrupted then
							Element:beginAnimation("keyframe", 189.000000, false, false, CoD.TweenType.Bounce)
						end
						Element:setAlpha(0.000000)
						if Event.interrupted then
							Elem.clipFinished(Element, Event)
						else
							Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
						end
					end

					if Event.interrupted then
						Glow_DSNegativeScore_4(Element, Event)
						return
					end
					Element:beginAnimation("keyframe", 469.000000, false, false, CoD.TweenType.Linear)
					Element:setAlpha(0.340000)
					Element:registerEventHandler("transition_complete_keyframe", Glow_DSNegativeScore_4)
				end

				if Event.interrupted then
					Glow_DSNegativeScore_3(Element, Event)
					return
				end
				Element:beginAnimation("keyframe", 60.000000, false, false, CoD.TweenType.Bounce)
				Element:setAlpha(0.420000)
				Element:registerEventHandler("transition_complete_keyframe", Glow_DSNegativeScore_3)
			end

			if Event.interrupted then
				Glow_DSNegativeScore_2(Element, Event)
				return
			end
			Element:beginAnimation("keyframe", 39.000000, false, false, CoD.TweenType.Linear)
			Element:setAlpha(1.000000)
			Element:registerEventHandler("transition_complete_keyframe", Glow_DSNegativeScore_2)
		end

		glow:completeAnimation()
		Elem.Glow:setAlpha(0.000000)

        Glow_DSNegativeScore_1(glow, {})
	end

    Elem.clipsPerState = 
    {
        DefaultState =
        {
            DefaultClip = DSDefaultClip,
            NegativeScore = DSNegativeScore
        }
    }

	if PostLoadFunc then
		PostLoadFunc(Elem, InstanceRef, HudRef)
	end
	return Elem
end