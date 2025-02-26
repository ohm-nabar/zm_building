CoD.BloodGenerator = InheritFrom(LUI.UIElement)

function CoD.BloodGenerator.new(HudRef, InstanceRef)
    local BloodGenerator = LUI.UIElement.new()
    BloodGenerator:setClass(CoD.BloodGenerator)
    BloodGenerator:setLeftRight(true, true)
    BloodGenerator:setTopBottom(true, true)
    BloodGenerator.id = "BloodGenerator"
    BloodGenerator.soundSet = "default"
    BloodGenerator.shouldFlash = true

    
    local Background = LUI.UIImage.new()
    Background:setLeftRight(true, true)
    Background:setTopBottom(true, true)
    Background:setImage(RegisterImage("generator_bg"))
 
 	BloodGenerator:addElement(Background)

    local Overlay1 = LUI.UIImage.new()
    Overlay1:setLeftRight(true, true)
    Overlay1:setTopBottom(true, true)
    Overlay1:setImage(RegisterImage("generator_1"))
    Overlay1:hide()

    BloodGenerator:addElement(Overlay1)

    local Overlay2 = LUI.UIImage.new()
    Overlay2:setLeftRight(true, true)
    Overlay2:setTopBottom(true, true)
    Overlay2:setImage(RegisterImage("generator_2"))
    Overlay2:hide()

    BloodGenerator:addElement(Overlay2)

    local Overlay3 = LUI.UIImage.new()
    Overlay3:setLeftRight(true, true)
    Overlay3:setTopBottom(true, true)
    Overlay3:setImage(RegisterImage("generator_3"))
    Overlay3:hide()

    BloodGenerator:addElement(Overlay3)

    local Overlay4 = LUI.UIImage.new()
    Overlay4:setLeftRight(true, true)
    Overlay4:setTopBottom(true, true)
    Overlay4:setImage(RegisterImage("generator_4"))
    Overlay4:hide()

    BloodGenerator:addElement(Overlay4)

    local OverlaySkull = LUI.UIImage.new()
    OverlaySkull:setLeftRight(true, true)
    OverlaySkull:setTopBottom(true, true)
    OverlaySkull:setImage(RegisterImage("skull_all_on"))
    OverlaySkull:hide()

    BloodGenerator:addElement(OverlaySkull)

    local Overlay1S = LUI.UIImage.new()
    Overlay1S:setLeftRight(true, true)
    Overlay1S:setTopBottom(true, true)
    Overlay1S:setImage(RegisterImage("generator_1s"))
    Overlay1S:hide()

    BloodGenerator:addElement(Overlay1S)

    local Overlay2S = LUI.UIImage.new()
    Overlay2S:setLeftRight(true, true)
    Overlay2S:setTopBottom(true, true)
    Overlay2S:setImage(RegisterImage("generator_2s"))
    Overlay2S:hide()

    BloodGenerator:addElement(Overlay2S)

    local Overlay3S = LUI.UIImage.new()
    Overlay3S:setLeftRight(true, true)
    Overlay3S:setTopBottom(true, true)
    Overlay3S:setImage(RegisterImage("generator_3s"))
    Overlay3S:hide()

    BloodGenerator:addElement(Overlay3S)

    local Overlay4S = LUI.UIImage.new()
    Overlay4S:setLeftRight(true, true)
    Overlay4S:setTopBottom(true, true)
    Overlay4S:setImage(RegisterImage("generator_4s"))
    Overlay4S:hide()

    BloodGenerator:addElement(Overlay4S)

    local OverlaySkullS = LUI.UIImage.new()
    OverlaySkullS:setLeftRight(true, true)
    OverlaySkullS:setTopBottom(true, true)
    OverlaySkullS:setImage(RegisterImage("skull_all_s"))
    OverlaySkullS:hide()

    BloodGenerator:addElement(OverlaySkullS)

    local OverlayTable = {Overlay1, Overlay2, Overlay3, Overlay4}
    local OverlayTableS = {Overlay1S, Overlay2S, Overlay3S, Overlay4S}
    local GeneratorsActive = 0
    local GeneratorsShadowed = 0

    BloodGenerator.OverlayTableS = OverlayTableS

    OverlaySkull.clipsPerState = {
        DefaultState = {
            DefaultClip = function()
                OverlaySkull:completeAnimation()
                OverlaySkull:beginAnimation( "keyframe", 2500, false, false, CoD.TweenType.Linear )
                OverlaySkull:show()
            end,
            Hide = function()
                OverlaySkull:completeAnimation()
                OverlaySkull:beginAnimation( "keyframe", 2500, false, false, CoD.TweenType.Linear )
                OverlaySkull:hide()
            end
        }
    }

    OverlaySkullS.clipsPerState = {
        DefaultState = {
            DefaultClip = function()
                OverlaySkullS:completeAnimation()
                OverlaySkullS:beginAnimation( "keyframe", 2500, false, false, CoD.TweenType.Linear )
                OverlaySkullS:show()
            end
        }
    }

    for i=1,4 do
        OverlayTable[i].clipsPerState = {
            DefaultState = {
                DefaultClip = function()
                    OverlayTable[i]:completeAnimation()
                    OverlayTable[i]:beginAnimation( "keyframe", 2500, false, false, CoD.TweenType.Linear )
                    OverlayTable[i]:show()
                end
            }
        }
        
        OverlayTableS[i].clipsPerState = {
            DefaultState = {
                DefaultClip = function()
                    OverlayTableS[i]:completeAnimation()
                    OverlayTableS[i]:beginAnimation( "keyframe", 2500, false, false, CoD.TweenType.Linear )
                    OverlayTableS[i]:show()
                end, 
                Attacking = function ()
                    BloodGenerator:setupElementClipCounter( 2 )
                    local OverlaySFrame2 = function ( OverlayS, event )
                        local OverlaySFrame3 = function ( OverlayS, event )
                            local OverlaySFrame4 = function ( OverlayS, event )
                                local OverlaySFrame5 = function ( OverlayS, event )
                                    local OverlaySFrame6 = function ( OverlayS, event )
                                        local OverlaySFrame7 = function ( OverlayS, event )
                                            if not event.interrupted then
                                                OverlayS:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
                                            end
                                            OverlayS:setAlpha( 0 )

                                            if event.interrupted then
                                                BloodGenerator.clipFinished( OverlayS, event )
                                            else
                                                OverlayS:registerEventHandler( "transition_complete_keyframe", BloodGenerator.clipFinished )
                                            end
                                        end
                                        
                                        if event.interrupted then
                                            OverlaySFrame7( OverlayS, event )
                                            return 
                                        else
                                            OverlayS:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
                                            OverlayS:setAlpha( 1 )
                                            OverlayS:registerEventHandler( "transition_complete_keyframe", OverlaySFrame7 )
                                        end
                                    end
                                    
                                    if event.interrupted then
                                        OverlaySFrame6( OverlayS, event )
                                        return 
                                    else
                                        OverlayS:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
                                        OverlayS:setAlpha( 0.3 )
                                        OverlayS:registerEventHandler( "transition_complete_keyframe", OverlaySFrame6 )
                                    end
                                end
                                
                                if event.interrupted then
                                    OverlaySFrame5( OverlayS, event )
                                    return 
                                else
                                    OverlayS:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
                                    OverlayS:setAlpha( 1 )
                                    OverlayS:registerEventHandler( "transition_complete_keyframe", OverlaySFrame5 )
                                end
                            end
                            
                            if event.interrupted then
                                OverlaySFrame4( OverlayS, event )
                                return 
                            else
                                OverlayS:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
                                OverlayS:setAlpha( 0.3 )
                                OverlayS:registerEventHandler( "transition_complete_keyframe", OverlaySFrame4 )
                            end
                        end
                        
                        if event.interrupted then
                            OverlaySFrame3( OverlayS, event )
                            return 
                        else
                            OverlayS:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
                            OverlayS:setAlpha( 1 )
                            OverlayS:registerEventHandler( "transition_complete_keyframe", OverlaySFrame3 )
                        end
                    end
                    
                    OverlayTableS[i]:completeAnimation()
                    OverlayTableS[i]:setAlpha( 0 )
                    OverlaySFrame2( OverlayTableS[i], {} )
                end
            }
        }
    end

    local function GeneratorActivated(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_activated") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
            local Index = NotifyData[1] + 1
            GeneratorsActive = GeneratorsActive + 1
            if BloodGenerator.shouldFlash then
                PlayClip(OverlayTable[Index], "DefaultClip", InstanceRef)
                if GeneratorsActive == 4 then
                    PlayClip(OverlaySkull, "DefaultClip", InstanceRef)
                end
            else
                OverlayTable[Index]:show()
                if GeneratorsActive == 4 then
                    OverlaySkull:show()
                end
            end
        end
    end
    BloodGenerator:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", GeneratorActivated)

    local function GeneratorShadowed(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_shadowed") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)
            local Index = NotifyData[1] + 1
            GeneratorsShadowed = GeneratorsShadowed + 1
            if BloodGenerator.shouldFlash then
                PlayClip(OverlayTableS[Index], "DefaultClip", InstanceRef)
                if GeneratorsActive == 4 then
                    PlayClip(OverlaySkull, "Hide", InstanceRef)
                end
                if GeneratorsShadowed == 4 then
                    PlayClip(OverlaySkullS, "DefaultClip", InstanceRef)
                end
            else
                OverlayTableS[Index]:show()
                if GeneratorsActive == 4 then
                    OverlaySkull:hide()
                end
                if GeneratorsShadowed == 4 then
                    OverlaySkullS:show()
                end
            end
        end
    end
    BloodGenerator:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", GeneratorShadowed)

    local function ShadowRoundEnded(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_unshadowed") then
            for i=1,4 do
                OverlayTableS[i]:hide()
            end
            OverlaySkullS:hide()
            GeneratorsShadowed = 0
            
            if GeneratorsActive == 4 then
                OverlaySkull:show()
            end
        end
    end
	BloodGenerator:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", ShadowRoundEnded)

    local function GeneratorAttacked(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_attacked") then
            local NotifyData = CoD.GetScriptNotifyData(ModelRef)
            local Index = NotifyData[1] + 1
            if BloodGenerator.shouldFlash then
                PlayClip(OverlayTableS[Index], "Attacking", InstanceRef)
            end
        end
    end
	BloodGenerator:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", GeneratorAttacked)

	local function UpdateVisibility(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_hide") then
            Background:hide()
            OverlaySkull:hide()
            OverlaySkullS:hide()
            for i=1,4 do
                OverlayTable[i]:hide()
                OverlayTableS[i]:hide()
            end
        end
    end
	BloodGenerator:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", UpdateVisibility)

    local function ResetVisibility(ModelRef)
        if IsParamModelEqualToString(ModelRef, "generator_reset") then
            Background:show()
            OverlaySkull:hide()
            OverlaySkullS:hide()
            for i=1,4 do
                OverlayTable[i]:hide()
                OverlayTableS[i]:hide()
            end
            GeneratorsActive = 0
            GeneratorsShadowed = 0
        end
    end
	BloodGenerator:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", ResetVisibility)

    return BloodGenerator
end