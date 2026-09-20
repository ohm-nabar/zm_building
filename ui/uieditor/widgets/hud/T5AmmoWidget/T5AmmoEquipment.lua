require( "ui.uieditor.widgets.HUD.T5AmmoWidget.T5AmmoEquipmentListItem" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_EquipTac_Abbey" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadIconBgm_Abbey" )


local SetWeaponName = function ( controller, element )
	local weaponNameModel = Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.weaponName" )
	local aatIconModel = Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.aatIcon" )

	local weaponName = Engine.GetModelValue( weaponNameModel )
	local aatIcon = Engine.GetModelValue( aatIconModel )

	if weaponName == nil or aatIcon == nil then
		return
	end

	if aatIcon ~= "blacktransparent" then
		weaponName = (weaponName .. " ^B" .. aatIcon:gsub( "t7_icon_", "t5_" ) .. "^")
	end

	element:setText( Engine.Localize( weaponName ) )
end

DataSources.T5AmmoEquipmentLethals = DataSourceHelpers.ListSetup( "T5AmmoEquipmentLethals", function ( controller, element )
	local primaryOffhand = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.primaryOffhand" ) )
	local primaryOffhandCount = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.primaryOffhandCount" ) )

	if primaryOffhand == "uie_t7_zm_hud_inv_icnlthl" then
		primaryOffhand = "t5_grenadeicon"
	end

	local lethals = {}

	if primaryOffhand ~= nil and primaryOffhandCount ~= nil then
		for index = 1, primaryOffhandCount do
			table.insert( lethals, {
				models = {
					image = primaryOffhand,
					alpha = 0.5
				}
			} )
		end

		if next( lethals ) ~= nil then
			lethals[1].models.alpha = 1
		end
	end

	return lethals
end, true )

DataSources.T5AmmoEquipmentTacticals = DataSourceHelpers.ListSetup( "T5AmmoEquipmentTacticals", function ( controller, element )
	local secondaryOffhand = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhand" ) )
	local secondaryOffhandCount = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhandCount" ) )

	if secondaryOffhand == "hud_cymbal_monkey_bo3" then
		secondaryOffhand = "t5_hud_cymbal_monkey"
	end

	local tacticals = {}

	if secondaryOffhand ~= nil and secondaryOffhandCount ~= nil then
		for index = 1, secondaryOffhandCount do
			table.insert( tacticals, {
				models = {
					image = secondaryOffhand,
					alpha = 0.5
				}
			} )
		end

		if next( tacticals ) ~= nil then
			tacticals[1].models.alpha = 1
		end
	end

	return tacticals
end, true )

DataSources.T5AmmoEquipmentMines = DataSourceHelpers.ListSetup( "T5AmmoEquipmentMines", function ( controller, element )
	local actionSlot3ammo = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ) )

	local mines = {}

	if actionSlot3ammo ~= nil then
		for index = 1, actionSlot3ammo do
			table.insert( mines, {
				models = {
					image = "t7_hud_icon_menu_bouncebetty",
					alpha = 0.5
				}
			} )
		end

		if next( mines ) ~= nil then
			mines[1].models.alpha = 1
		end
	end

	return mines
end, true )

CoD.T5AmmoEquipment = InheritFrom( LUI.UIElement )
CoD.T5AmmoEquipment.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T5AmmoEquipment )
	self.id = "T5AmmoEquipment"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.DpadBlood = LUI.UIImage.new()
	self.DpadBlood:setLeftRight( false, true, -357, 0 )
	self.DpadBlood:setTopBottom( false, true, -206.5, 24.5 )
	self.DpadBlood:setImage( RegisterImage( "uie_t7_zm_derriese_hud_ammo_projection_small" ) )
	self:addElement( self.DpadBlood )

	self.DpadOuterFrame = LUI.UIImage.new()
	self.DpadOuterFrame:setLeftRight( false, true, -140, 0 ) -- 137
	self.DpadOuterFrame:setTopBottom( false, true, -165, -15 ) -- 150
	self.DpadOuterFrame:setImage( RegisterImage( "uie_t7_zm_hud_ammo_dpadelement_new" ) )
	self:addElement( self.DpadOuterFrame )

	local DpadIconScroll = LUI.UIImage.new()
	DpadIconScroll:setLeftRight( false, true, -50, -7 )
	DpadIconScroll:setTopBottom( false, true, -113, -63 )
	DpadIconScroll:setImage( RegisterImage( "scroll_inactive" ) )
	self:addElement(DpadIconScroll)

	local function IconScrollDisplay(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                DpadIconScroll:setImage( RegisterImage( "scroll_inactive" ) )
            else
                DpadIconScroll:setImage( RegisterImage( "scroll_active" ) )
            end
        end
    end
    DpadIconScroll:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), IconScrollDisplay)

	local DpadIconPause = LUI.UIImage.new()
	DpadIconPause:setImage( RegisterImage ( "game_played" ) )
	DpadIconPause:setLeftRight( false, true, -110, -40 )
	DpadIconPause:setTopBottom( false, true, -72, -2 )
	self:addElement(DpadIconPause)

	local function IconPauseDisplay(ModelRef)
		local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                DpadIconPause:setImage( RegisterImage( "game_played" ) )
			else
                DpadIconPause:setImage( RegisterImage( "game_paused" ) )
            end
        end
    end
    DpadIconPause:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "abbeyPause"), IconPauseDisplay)
	
	local function IconPauseAvailable(ModelRef)
		local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                DpadIconPause:setRGB(0.5, 0.5, 0.5)
			else
                DpadIconPause:setRGB(1, 1, 1)
            end
        end
    end
	DpadIconPause:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "abbeyPauseAvailable"), IconPauseAvailable)

	local DpadIconNoHud = LUI.UIImage.new()
	DpadIconNoHud:setImage( RegisterImage ( "no_hud_0_0" ) )
	DpadIconNoHud:setLeftRight( false, true, -129.5, -109.5 )
	DpadIconNoHud:setTopBottom( false, true, -100, -70 )
	self:addElement(DpadIconNoHud)

	local function NoHudToggle(ModelRef)
		local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                DpadIconNoHud:setImage( RegisterImage( "no_hud_0_0" ) )
			elseif NotifyData == 1 then
                DpadIconNoHud:setImage( RegisterImage( "no_hud_0_1" ) )
            else
				DpadIconNoHud:setImage( RegisterImage( "no_hud_1_1" ) )
			end
        end
    end
    DpadIconNoHud:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "abbeyNoHUD"), NoHudToggle)

	local function IconDpadAvailable(ModelRef)
		local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                DpadIconScroll:setRGB(0.5, 0.5, 0.5)
				DpadIconNoHud:setRGB(0.5, 0.5, 0.5)
			else
                DpadIconScroll:setRGB(1, 1, 1)
				DpadIconNoHud:setRGB(1, 1, 1)
            end
        end
    end
	DpadIconScroll:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "abbeyDpadAvailable"), IconDpadAvailable)

	
	self.DpadIconBgm = CoD.ZmAmmo_DpadIconBgmAbbey.new( menu, controller )
	self.DpadIconBgm:setLeftRight( false, true, -81, -65 )
	self.DpadIconBgm:setTopBottom( false, true, -145, -129 )
	self.DpadIconBgm:subscribeToGlobalModel(controller, "PerController", "bgb_invalid_use", function (model)
		PulseElementToStateAndBack(self.DpadIconBgm, "InvalidUse")
	end)
	self.DpadIconBgm:mergeStateConditions( {
		{
			stateName = "Ready",
			condition = function ( menu, element, event )
				return IsModelValueGreaterThan( controller, "bgb_activations_remaining", 0 )
			end
		},
		{
			stateName = "New",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		},
		{
			stateName = "Unavailable",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadUp", 1 )
			end
		}
	} )
	self.DpadIconBgm:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "bgb_activations_remaining" ), function ( model )
		menu:updateElementState( self.DpadIconBgm, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "bgb_activations_remaining"
		} )
	end )
	self.DpadIconBgm:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "bgb_display" ), function ( model )
		menu:updateElementState( self.DpadIconBgm, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.showDpadUp"
		} )
	end )
	self:addElement( self.DpadIconBgm )

	self.DpadAmmoNumbersTop = LUI.UIText.new()
	self.DpadAmmoNumbersTop:setLeftRight( false, true, -85, -69 )
	self.DpadAmmoNumbersTop:setTopBottom( false, true, -165, -138 )
	self.DpadAmmoNumbersTop:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "bgb_activations_remaining" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue and modelValue > 0 then
			self.DpadAmmoNumbersTop:setText(modelValue)
		end
	end )
	self.DpadAmmoNumbersTop:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "bgb_display" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue == 0 then
			self.DpadAmmoNumbersTop:setAlpha(0)
		else
			self.DpadAmmoNumbersTop:setAlpha(1)
		end
	end )
	self:addElement( self.DpadAmmoNumbersTop )

	self.DpadIconMule = LUI.UIImage.new()
	self.DpadIconMule:setImage( RegisterImage ( "i_thirdguninfo" ) )
	self.DpadIconMule:setLeftRight( false, true, -140, -110 )
	self.DpadIconMule:setTopBottom( false, true, -50, -20 )
	self.DpadIconMule:hide()
	self:addElement(self.DpadIconMule)

	local function IconMuleDisplay(ModelRef)
		local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                self.DpadIconMule:hide()
			else
                self.DpadIconMule:show()
            end
        end
    end
	self.DpadIconMule:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "muleIndicator"), IconMuleDisplay);

	EnableGlobals()
   	DPadRightFlash = LUI.UIImage.new()
    DPadRightFlash:setImage(RegisterImage("uie_t7_zm_derriese_hud_ammo_dpadmtr_right_flash"))
    DPadRightFlash:setTopBottom(false, true, -146, -19)
    DPadRightFlash:setLeftRight(false, true, -85, -6)
    DPadRightFlash:setAlpha( 0 )
	self:addElement(DPadRightFlash)

	DPadLeftFlash = LUI.UIImage.new()
    DPadLeftFlash:setImage(RegisterImage("uie_t7_zm_derriese_hd_hud_ammo_cover_flash"))
    DPadLeftFlash:setTopBottom(false, true, -139, -33)
    DPadLeftFlash:setLeftRight(false, true, -150, -76)
    DPadLeftFlash:setAlpha( 0 )
	self:addElement(DPadLeftFlash)

	DPadBottomFlash = LUI.UIImage.new()
    DPadBottomFlash:setImage(RegisterImage("uie_t7_zm_derriese_hud_ammo_dpadmtr_bottom_flash"))
    DPadBottomFlash:setTopBottom(false, true, -87, -13)
    DPadBottomFlash:setLeftRight(false, true, -132, -34)
    DPadBottomFlash:setAlpha( 0 )
	self:addElement(DPadBottomFlash)

	local DPadFlashes = {DPadRightFlash, DPadLeftFlash, DPadBottomFlash}

	for i=1,3 do
		DPadFlashes[i].clipsPerState = {
			DefaultState = { --DefaultState is the element state if no other condition is met.
				Flash = function ()
					self:setupElementClipCounter( 2 )
					local DPadFlashFrame2 = function ( DPadFlash, event )
						local DPadFlashFrame3 = function ( DPadFlash, event )
							local DPadFlashFrame4 = function ( DPadFlash, event )
								local DPadFlashFrame5 = function ( DPadFlash, event )
									local DPadFlashFrame6 = function ( DPadFlash, event )
										local DPadFlashFrame7 = function ( DPadFlash, event )
											local DPadFlashFrame8 = function ( DPadFlash, event )
												local DPadFlashFrame9 = function ( DPadFlash, event )
													local DPadFlashFrame10 = function ( DPadFlash, event )
														local DPadFlashFrame11 = function ( DPadFlash, event )
															if not event.interrupted then
																DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
															end
															DPadFlash:setAlpha( 0 )
															if event.interrupted then
																self.clipFinished( DPadFlash, event )
															else
																DPadFlash:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
															end
														end
														
														if event.interrupted then
															DPadFlashFrame11( DPadFlash, event )
															return 
														else
															DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
															DPadFlash:setAlpha( 1 )
															DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame11 )
														end
													end
													
													if event.interrupted then
														DPadFlashFrame10( DPadFlash, event )
														return 
													else
														DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
														DPadFlash:setAlpha( 0.3 )
														DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame10 )
													end
												end
												
												if event.interrupted then
													DPadFlashFrame9( DPadFlash, event )
													return 
												else
													DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
													DPadFlash:setAlpha( 1 )
													DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame9 )
												end
											end
											
											if event.interrupted then
												DPadFlashFrame8( DPadFlash, event )
												return 
											else
												DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
												DPadFlash:setAlpha( 0.3 )
												DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame8 )
											end
										end
										
										if event.interrupted then
											DPadFlashFrame7( DPadFlash, event )
											return 
										else
											DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
											DPadFlash:setAlpha( 1 )
											DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame7 )
										end
									end
									
									if event.interrupted then
										DPadFlashFrame6( DPadFlash, event )
										return 
									else
										DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
										DPadFlash:setAlpha( 0.3 )
										DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame6 )
									end
								end
								
								if event.interrupted then
									DPadFlashFrame5( DPadFlash, event )
									return 
								else
									DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
									DPadFlash:setAlpha( 1 )
									DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame5 )
								end
							end
							
							if event.interrupted then
								DPadFlashFrame4( DPadFlash, event )
								return 
							else
								DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
								DPadFlash:setAlpha( 0.3 )
								DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame4 )
							end
						end
						
						if event.interrupted then
							DPadFlashFrame3( DPadFlash, event )
							return 
						else
							DPadFlash:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
							DPadFlash:setAlpha( 1 )
							DPadFlash:registerEventHandler( "transition_complete_keyframe", DPadFlashFrame3 )
						end
					end
					
					DPadFlashes[i]:completeAnimation()
					DPadFlashes[i]:setAlpha( 0 )
					DPadFlashFrame2( DPadFlashes[i], {} )
				end
			}
		}
	end
    DisableGlobals()

	self.DpadOuterFrameRim = LUI.UIImage.new()
	self.DpadOuterFrameRim:setLeftRight( false, true, -132, 6 )
	self.DpadOuterFrameRim:setTopBottom( false, true, -133.5, 4.5 )
	self.DpadOuterFrameRim:setImage( RegisterImage( "t5_hud_dpad_outer_frame_rim" ) )
	--self:addElement( self.DpadOuterFrameRim )

	self.DpadLines = LUI.UIImage.new()
	self.DpadLines:setLeftRight( false, true, -268, -75 )
	self.DpadLines:setTopBottom( false, true, -83.5, 11.5 )
	self.DpadLines:setImage( RegisterImage( "t5_hud_dpad_lines" ) )
	--self:addElement( self.DpadLines )

	self.DpadLinesFade = LUI.UIImage.new()
	self.DpadLinesFade:setLeftRight( false, true, -271.5, -78.5 )
	self.DpadLinesFade:setTopBottom( false, true, -83.5, 11.5 )
	self.DpadLinesFade:setImage( RegisterImage( "t5_hud_dpad_lines_fade" ) )
	--self:addElement( self.DpadLinesFade )

	self.DpadXenon = LUI.UIImage.new()
	self.DpadXenon:setLeftRight( false, true, -132, 6 )
	self.DpadXenon:setTopBottom( false, true, -133.5, 4.5 )
	self.DpadXenon:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadXenon:setScale( 0.48 )
	self.DpadXenon:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local last_input = Engine.GetModelValue( model )

		if last_input then
			if last_input > 0 then
				self.DpadXenon:setImage( RegisterImage( "blacktransparent" ) )
			else
				self.DpadXenon:setImage( RegisterImage( "t5_hud_dpad_xenon" ) )
			end
		end
	end )
	--self:addElement( self.DpadXenon )

	self.DpadOverlayX = LUI.UIImage.new()
	self.DpadOverlayX:setLeftRight( false, true, -132, 6 )
	self.DpadOverlayX:setTopBottom( false, true, -133.5, 4.5 )
	self.DpadOverlayX:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadOverlayX:setScale( 0.48 )
	self.DpadOverlayX:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local last_input = Engine.GetModelValue( model )

		if last_input then
			if last_input > 0 then
				self.DpadOverlayX:setImage( RegisterImage( "blacktransparent" ) )
			else
				self.DpadOverlayX:setImage( RegisterImage( "t5_hud_dpad_overlay_x" ) )
			end
		end
	end )
	--self:addElement( self.DpadOverlayX )

	self.DpadOuterFrameUp = LUI.UIImage.new()
	self.DpadOuterFrameUp:setLeftRight( false, true, -134.5, 3.5 )
	self.DpadOuterFrameUp:setTopBottom( false, true, -166.5, -28.5 )
	self.DpadOuterFrameUp:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadOuterFrameUp:subscribeToGlobalModel( controller, "PerController", "bgb_timer", function ( model )
		local bgb_timer = Engine.GetModelValue( model )

		if bgb_timer then
			if bgb_timer > 0 then
				self.DpadOuterFrameUp:setImage( RegisterImage( "t5_hud_dpad_outer_frame_highlight_up" ) )
			else
				self.DpadOuterFrameUp:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	--self:addElement( self.DpadOuterFrameUp )

	self.DpadOuterFrameUpPrompt = LUI.UIText.new()
	self.DpadOuterFrameUpPrompt:setLeftRight( false, true, -632, 506 )
	self.DpadOuterFrameUpPrompt:setTopBottom( false, true, -96.5, -70.5 )
	self.DpadOuterFrameUpPrompt:setText( Engine.Localize( "" ) )
    self.DpadOuterFrameUpPrompt:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self.DpadOuterFrameUpPrompt:setScale( 0.5 )
	self.DpadOuterFrameUpPrompt:setRGB( 0.6, 0.6, 0.6 )
	self.DpadOuterFrameUpPrompt:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.DpadOuterFrameUpPrompt:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local last_input = Engine.GetModelValue( model )

		if last_input then
			if last_input > 0 then
				self.DpadOuterFrameUpPrompt:setText( Engine.Localize( "[[{+actionslot 1}]]" ) )
			else
				self.DpadOuterFrameUpPrompt:setText( Engine.Localize( "" ) )
			end
		end
	end )
	--self:addElement( self.DpadOuterFrameUpPrompt )

	self.DpadOuterFrameDown = LUI.UIImage.new()
	self.DpadOuterFrameDown:setLeftRight( false, true, -129.5, 8.5 )
	self.DpadOuterFrameDown:setTopBottom( false, true, -100.5, 37.5 )
	self.DpadOuterFrameDown:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadOuterFrameDown:setZRot( 180 )
	self.DpadOuterFrameDown:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( model )
		local showDpadDown = Engine.GetModelValue( model )

		if showDpadDown then
			if showDpadDown == 1 then
				self.DpadOuterFrameDown:setImage( RegisterImage( "t5_hud_dpad_outer_frame_highlight_up" ) )
			else
				self.DpadOuterFrameDown:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.DpadOuterFrameDown )

	self.DpadOuterFrameDownPrompt = LUI.UIText.new()
	self.DpadOuterFrameDownPrompt:setLeftRight( false, true, -632, 506 )
	self.DpadOuterFrameDownPrompt:setTopBottom( false, true, -57.5, -31.5 )
	self.DpadOuterFrameDownPrompt:setText( Engine.Localize( "" ) )
    self.DpadOuterFrameDownPrompt:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self.DpadOuterFrameDownPrompt:setScale( 0.5 )
	self.DpadOuterFrameDownPrompt:setRGB( 0.6, 0.6, 0.6 )
	self.DpadOuterFrameDownPrompt:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.DpadOuterFrameDownPrompt:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local last_input = Engine.GetModelValue( model )

		if last_input then
			if last_input > 0 then
				self.DpadOuterFrameDownPrompt:setText( Engine.Localize( "[[{+actionslot 2}]]" ) )
			else
				self.DpadOuterFrameDownPrompt:setText( Engine.Localize( "" ) )
			end
		end
	end )
	--self:addElement( self.DpadOuterFrameDownPrompt )

	self.DpadOuterFrameDownIcon = LUI.UIImage.new()
	self.DpadOuterFrameDownIcon:setLeftRight( false, true, -132, 6 )
	self.DpadOuterFrameDownIcon:setTopBottom( false, true, -90.5, 47.5 )
	self.DpadOuterFrameDownIcon:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadOuterFrameDownIcon:setScale( 0.2 )
	self.DpadOuterFrameDownIcon:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( model )
		local showDpadDown = Engine.GetModelValue( model )

		if showDpadDown then
			if showDpadDown == 1 then
				self.DpadOuterFrameDownIcon:setImage( RegisterImage( "t5_rocketshield" ) )
			else
				self.DpadOuterFrameDownIcon:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self.DpadOuterFrameDownIcon:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "ZMInventory.shield_health" ), function ( model )
		local shield_health = Engine.GetModelValue( model )

		if shield_health then
			self.DpadOuterFrameDownIcon:setRGB( 1, shield_health, shield_health )
		end
	end )
	self:addElement( self.DpadOuterFrameDownIcon )

	self.DpadOuterFrameLeft = LUI.UIImage.new()
	self.DpadOuterFrameLeft:setLeftRight( false, true, -166, -28 )
	self.DpadOuterFrameLeft:setTopBottom( false, true, -132, 6 )
	self.DpadOuterFrameLeft:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadOuterFrameLeft:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadLeft" ), function ( model )
		local showDpadLeft = Engine.GetModelValue( model )

		if showDpadLeft then
			if showDpadLeft == 1 then
				self.DpadOuterFrameLeft:setImage( RegisterImage( "t5_hud_dpad_outer_frame_highlight_side" ) )
			else
				self.DpadOuterFrameLeft:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.DpadOuterFrameLeft )

	self.DpadOuterFrameLeftPrompt = LUI.UIText.new()
	self.DpadOuterFrameLeftPrompt:setLeftRight( false, true, -648, 490 )
	self.DpadOuterFrameLeftPrompt:setTopBottom( false, true, -77, -51 )
	self.DpadOuterFrameLeftPrompt:setText( Engine.Localize( "" ) )
    self.DpadOuterFrameLeftPrompt:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self.DpadOuterFrameLeftPrompt:setScale( 0.5 )
	self.DpadOuterFrameLeftPrompt:setRGB( 0.6, 0.6, 0.6 )
	self.DpadOuterFrameLeftPrompt:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.DpadOuterFrameLeftPrompt:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local last_input = Engine.GetModelValue( model )

		if last_input then
			if last_input > 0 then
				self.DpadOuterFrameLeftPrompt:setText( Engine.Localize( "[[{+actionslot 3}]]" ) )
			else
				self.DpadOuterFrameLeftPrompt:setText( Engine.Localize( "" ) )
			end
		end
	end )
	--self:addElement( self.DpadOuterFrameLeftPrompt )

	self.DpadOuterFrameRight = LUI.UIImage.new()
	self.DpadOuterFrameRight:setLeftRight( false, true, -98, 40 )
	self.DpadOuterFrameRight:setTopBottom( false, true, -135, 3 )
	self.DpadOuterFrameRight:setImage( RegisterImage( "blacktransparent" ) )
	self.DpadOuterFrameRight:setZRot( 180 )
	self.DpadOuterFrameRight:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( model )
		local actionSlot3ammo = Engine.GetModelValue( model )

		if actionSlot3ammo then
			if actionSlot3ammo > 0 then
				self.DpadOuterFrameRight:setImage( RegisterImage( "t5_hud_dpad_outer_frame_highlight_side" ) )
			else
				self.DpadOuterFrameRight:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.DpadOuterFrameRight )

	self.DpadOuterFrameRightPrompt = LUI.UIText.new()
	self.DpadOuterFrameRightPrompt:setLeftRight( false, true, -616, 522 )
	self.DpadOuterFrameRightPrompt:setTopBottom( false, true, -77, -51 )
	self.DpadOuterFrameRightPrompt:setText( Engine.Localize( "" ) )
    self.DpadOuterFrameRightPrompt:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self.DpadOuterFrameRightPrompt:setScale( 0.5 )
	self.DpadOuterFrameRightPrompt:setRGB( 0.6, 0.6, 0.6 )
	self.DpadOuterFrameRightPrompt:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.DpadOuterFrameRightPrompt:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local last_input = Engine.GetModelValue( model )

		if last_input then
			if last_input > 0 then
				self.DpadOuterFrameRightPrompt:setText( Engine.Localize( "[[{+actionslot 4}]]" ) )
			else
				self.DpadOuterFrameRightPrompt:setText( Engine.Localize( "" ) )
			end
		end
	end )
	--self:addElement( self.DpadOuterFrameRightPrompt )

	self.DpadOuterFrameRightIcon = LUI.UIList.new( menu, controller, -21, 0, nil, false, false, 0, 0, false, false )
	self.DpadOuterFrameRightIcon:makeFocusable()
	self.DpadOuterFrameRightIcon:setLeftRight( false, true, 0, -5 )
	self.DpadOuterFrameRightIcon:setTopBottom( false, true, 0, -50 )
	self.DpadOuterFrameRightIcon:setWidgetType( CoD.T5AmmoEquipmentListItem )
	self.DpadOuterFrameRightIcon:setHorizontalCount( 4 )
	self.DpadOuterFrameRightIcon:setDataSource( "T5AmmoEquipmentMines" )
	self.DpadOuterFrameRightIcon:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( model )
		self.DpadOuterFrameRightIcon:updateDataSource()
	end )
	self:addElement( self.DpadOuterFrameRightIcon )

	self.WeaponNameShadow = LUI.UIText.new()
	self.WeaponNameShadow:setLeftRight( true, true, 1, 259 )
	self.WeaponNameShadow:setTopBottom( false, true, -96, -51 )
	self.WeaponNameShadow:setText( Engine.Localize( "" ) )
    self.WeaponNameShadow:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self.WeaponNameShadow:setRGB( 0, 0, 0 )
	self.WeaponNameShadow:setScale( 0.5 )
	self.WeaponNameShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.WeaponNameShadow:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.weaponName" ), function ( model )
		SetWeaponName( controller, self.WeaponNameShadow )
	end )
	self.WeaponNameShadow:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.aatIcon" ), function ( model )
		SetWeaponName( controller, self.WeaponNameShadow )
	end )
	--self:addElement( self.WeaponNameShadow )

	self.WeaponName = LUI.UIText.new()
	self.WeaponName:setLeftRight( true, true, -5, 253 )
	self.WeaponName:setTopBottom( false, true, -77, -32 )
	self.WeaponName:setText( Engine.Localize( "" ) )
    self.WeaponName:setTTF( "fonts/RefrigeratorDeluxe-Regular.ttf" )
	self.WeaponName:setScale( 0.5 )
	self.WeaponName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.WeaponName:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.weaponName" ), function ( model )
		SetWeaponName( controller, self.WeaponName )
	end )
	self.WeaponName:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.aatIcon" ), function ( model )
		SetWeaponName( controller, self.WeaponName )
	end )
	self:addElement( self.WeaponName )

	self.Special = LUI.UIImage.new()
	self.Special:setLeftRight( false, true, -132, 6 )
	self.Special:setTopBottom( false, true, -133.5, 4.5 )
	self.Special:setImage( RegisterImage( "blacktransparent" ) )
	self.Special:setScale( 0.25 )
	self.Special:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( model )
		local swordEnergy = Engine.GetModelValue( model )

		if swordEnergy then
			if swordEnergy > 0 then
				self.Special:setImage( RegisterImage( "t5_specialweapon" ) )
			else
				self.Special:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.Special )

	self.SpecialMeter = LUI.UIImage.new()
	self.SpecialMeter:setLeftRight( false, true, -132, 6 )
	self.SpecialMeter:setTopBottom( false, true, -133.5, 4.5 )
	self.SpecialMeter:setImage( RegisterImage( "uie_t7_zm_hud_revive_ringtop" ) )
	self.SpecialMeter:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_clock_normal" ) )
	self.SpecialMeter:setRGB( 1, 1, 1 )
	self.SpecialMeter:setScale( 0.5 )
	self.SpecialMeter:setShaderVector( 0, 1, 0, 0, 0 )
	self.SpecialMeter:setShaderVector( 1, 0.5, 0, 0, 0 )
	self.SpecialMeter:setShaderVector( 2, 0.5, 0, 0, 0 )
	self.SpecialMeter:setShaderVector( 3, 0, 0, 0, 0 )
	self.SpecialMeter:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( model )
		local swordEnergy = Engine.GetModelValue( model )

		if swordEnergy then
			self.SpecialMeter:setShaderVector( 0, AdjustStartEnd( 0, 1,
				CoD.GetVectorComponentFromString( swordEnergy, 1 ),
				CoD.GetVectorComponentFromString( swordEnergy, 2 ),
				CoD.GetVectorComponentFromString( swordEnergy, 3 ),
				CoD.GetVectorComponentFromString( swordEnergy, 4 ) ) )
		end
	end )
	self:addElement( self.SpecialMeter )

	self.LethalImage = CoD.ZmAmmo_EquipTacAbbey.new( menu, controller )
	self.LethalImage:setLeftRight( false, true, -157, -90 )
	self.LethalImage:setTopBottom( false, true, -147, -115 )
	self.LethalImage:setRGB( 1, 0.99, 0.93 )
	self.LethalImage:setAlpha( 0.79 )
	--self.LethalImage:setRFTMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self.LethalImage:subscribeToGlobalModel( controller, "CurrentPrimaryOffhand", "primaryOffhand", function ( model )
		local primaryOffhand = Engine.GetModelValue( model )
		if primaryOffhand then
			self.LethalImage.Tactical0b:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical0:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical1b:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical1:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical1:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical2b:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical2:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical3b:setImage( RegisterImage( primaryOffhand ) )
			self.LethalImage.Tactical3:setImage( RegisterImage( primaryOffhand ) )
		end
	end )
	self.LethalImage:mergeStateConditions( {
		{
			stateName = "Single",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "currentPrimaryOffhand.primaryOffhandCount", 1 )
			end
		},
		{
			stateName = "Double",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "currentPrimaryOffhand.primaryOffhandCount", 2 )
			end
		},
		{
			stateName = "Triple",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "currentPrimaryOffhand.primaryOffhandCount", 3 )
			end
		},
		{
			stateName = "Quad",
			condition = function ( menu, element, event )
				return IsModelValueGreaterThanOrEqualTo( controller, "currentPrimaryOffhand.primaryOffhandCount", 4 )
			end
		}
	} )
	self.LethalImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentPrimaryOffhand.primaryOffhandCount" ), function ( model )
		menu:updateElementState( self.LethalImage, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "currentPrimaryOffhand.primaryOffhandCount"
		} )
	end )
	self:addElement( self.LethalImage )

	self.TacticalImage = CoD.ZmAmmo_EquipTacAbbey.new( menu, controller )
	self.TacticalImage:setLeftRight( false, true, -187, -150 )
	self.TacticalImage:setTopBottom( false, true, -134, -102 )
	self.TacticalImage:setRGB( 1, 0.99, 0.93 )
	self.TacticalImage:setAlpha( 0.79 )
	--self.TacticalImage:setRFTMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self.TacticalImage:subscribeToGlobalModel( controller, "CurrentSecondaryOffhand", "secondaryOffhand", function ( model )
		local secondaryOffhand = Engine.GetModelValue( model )
		if secondaryOffhand then
			self.TacticalImage.Tactical0b:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical0:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical1b:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical1:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical1:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical2b:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical2:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical3b:setImage( RegisterImage( secondaryOffhand ) )
			self.TacticalImage.Tactical3:setImage( RegisterImage( secondaryOffhand ) )
		end
	end )
	self.TacticalImage:mergeStateConditions( {
		{
			stateName = "Single",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "currentSecondaryOffhand.secondaryOffhandCount", 1 )
			end
		},
		{
			stateName = "Double",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "currentSecondaryOffhand.secondaryOffhandCount", 2 )
			end
		},
		{
			stateName = "Triple",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "currentSecondaryOffhand.secondaryOffhandCount", 3 )
			end
		},
		{
			stateName = "Quad",
			condition = function ( menu, element, event )
				return IsModelValueGreaterThanOrEqualTo( controller, "currentSecondaryOffhand.secondaryOffhandCount", 4 )
			end
		}
	} )
	self.TacticalImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhandCount" ), function ( model )
		menu:updateElementState( self.TacticalImage, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "currentSecondaryOffhand.secondaryOffhandCount"
		} )
	end )
	self:addElement( self.TacticalImage )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.DpadBlood:close()
		element.DpadOuterFrame:close()
		element.DpadIconBgm:close()
		element.DpadAmmoNumbersTop:close()
		element.DpadOuterFrameRim:close()
		element.DpadLines:close()
		element.DpadLinesFade:close()
		element.DpadXenon:close()
		element.DpadOverlayX:close()
		element.DpadOuterFrameUp:close()
		element.DpadOuterFrameUpPrompt:close()
		element.DpadOuterFrameDown:close()
		element.DpadOuterFrameDownPrompt:close()
		element.DpadOuterFrameDownIcon:close()
		element.DpadOuterFrameLeft:close()
		element.DpadOuterFrameLeftPrompt:close()
		element.DpadOuterFrameRight:close()
		element.DpadOuterFrameRightPrompt:close()
		element.DpadOuterFrameRightIcon:close()
		element.WeaponNameShadow:close()
		element.WeaponName:close()
		element.Special:close()
		element.SpecialMeter:close()
		element.LethalImage:close()
		element.TacticalImage:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
