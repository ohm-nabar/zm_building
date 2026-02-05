require("ui.uieditor.widgets.HUD.ZM_Score.ZMScr_PlusPoints")

CoD.ZMScr_PlusPointsContainer = InheritFrom(LUI.UIElement)

CoD.ZMScr_PlusPointsContainer.IsVisible = function(InstanceRef)
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

CoD.ZMScr_PlusPointsContainer.UpdateVisibility = function(Elem, InstanceRef)
    if CoD.ZMScr_PlusPointsContainer.IsVisible(InstanceRef) then
        Elem:setAlpha(1)
        Elem.visible = true
    else
        Elem:setAlpha(0)
        Elem.visible = false
    end
end

function CoD.ZMScr_PlusPointsContainer.new(HudRef, InstanceRef)
	local Elem = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Elem, InstanceRef)
	end
	Elem:setUseStencil(false)
	Elem:setClass(CoD.ZMScr_PlusPointsContainer)
	Elem.id = "ZMScr_PlusPointsContainer"
	Elem.soundSet = "HUD"
	Elem:setLeftRight(true, false, 0.000000, 85.000000)
	Elem:setTopBottom(true, false, 0.000000, 66.000000)
    Elem.anyChildUsesUpdateState = true
    
	local zmScrPlusPoints = CoD.ZMScr_PlusPoints.new(HudRef, InstanceRef)
	zmScrPlusPoints:setLeftRight(true, false, 68.910000, 153.910000)
	zmScrPlusPoints:setTopBottom(true, false, 46.880000, 112.630000)
	zmScrPlusPoints.Label2:setText(Engine.Localize("+50"))
	zmScrPlusPoints.Label1:setText(Engine.Localize("+50"))
	Elem:addElement(zmScrPlusPoints)
    Elem.ZMScrPlusPoints = zmScrPlusPoints

	Elem.visible = true
    
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
	Elem:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), function(ModelRef)
        CoD.ZMScr_PlusPointsContainer.UpdateVisibility(Elem, InstanceRef)
	end)
    
	local function DSDefaultClip()
		Elem:setupElementClipCounter(0.000000)
	end

	local function DSAnim1()
		Elem:setupElementClipCounter(1.000000)
		local function Anim1_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -182.500000, -97.500000)
			Element:setTopBottom(true, false, -57.190000, 8.560000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
        end
        
		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
        Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)
        
		Anim1_2(zmScrPlusPoints, {})
	end

	local function DSAnim2()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim2_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -182.970000, -97.970000)
			Element:setTopBottom(true, false, -15.350000, 50.400000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
        Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)
        
		DSAnim2_2(zmScrPlusPoints, {})
	end

	local function DSAnim3()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim3_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -162.810000, -77.810000)
			Element:setTopBottom(true, false, 44.650000, 110.400000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
        Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)
        
		DSAnim3_2(zmScrPlusPoints, {})
	end

	local function DSAnim4()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim4_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -168.440000, -83.440000)
			Element:setTopBottom(true, false, -15.350000, 50.400000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
		Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)

        DSAnim4_2(zmScrPlusPoints, {})
	end

	local function DSAnim5()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim5_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -140.780000, -55.780000)
			Element:setTopBottom(true, false, -43.480000, 22.270000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
		Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)

        DSAnim5_2(zmScrPlusPoints, {})
	end

	local function DSAnim6()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim6_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -167.500000, -82.500000)
			Element:setTopBottom(true, false, 30.940000, 96.690000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
        Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)
        
		DSAnim6_2(zmScrPlusPoints, {})
	end

	local function DSAnim7()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim7_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -169.380000, -84.380000)
			Element:setTopBottom(true, false, -38.440000, 27.310000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
        Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)
        
		DSAnim7_2(zmScrPlusPoints, {})
	end

	local function DSAnim8()
		Elem:setupElementClipCounter(1.000000)
		local function DSAnim8_2(Element, Event)
			if not Event.interrupted then
				Element:beginAnimation("keyframe", 750.000000, false, false, CoD.TweenType.Linear)
			end
			Element:setLeftRight(true, false, -153.910000, -68.910000)
			Element:setTopBottom(true, false, 46.880000, 112.630000)
			if Event.interrupted then
				Elem.clipFinished(Element, Event)
			else
				Element:registerEventHandler("transition_complete_keyframe", Elem.clipFinished)
			end
		end

		zmScrPlusPoints:completeAnimation()
		Elem.ZMScrPlusPoints:setLeftRight(true, false, 0.000000, 85.000000)
        Elem.ZMScrPlusPoints:setTopBottom(true, false, 0.000000, 65.750000)
        
		DSAnim8_2(zmScrPlusPoints, {})
	end

    Elem.clipsPerState = 
    {
        DefaultState =
        {
            DefaultClip = DSDefaultClip,
            Anim1 = DSAnim1,
            Anim2 = DSAnim2,
            Anim3 = DSAnim3,
            Anim4 = DSAnim4,
            Anim5 = DSAnim5,
            Anim6 = DSAnim6,
            Anim7 = DSAnim7,
            Anim8 = DSAnim8
        }
    }
	local function CloseEvent(SenderObj)
		SenderObj.ZMScrPlusPoints:close()
	end

	LUI.OverrideFunction_CallOriginalSecond(Elem, "close", CloseEvent)
	if PostLoadFunc then
		PostLoadFunc(Elem, InstanceRef, HudRef)
	end
	return Elem
end

