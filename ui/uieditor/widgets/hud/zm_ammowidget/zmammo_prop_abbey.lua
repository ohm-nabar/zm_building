require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadIconSide" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadIconBgm" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadIconMine" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadIconShield" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadIconSword" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadMeterSword" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_DpadAmmoNumbers" )

local PreLoadFunc = function ( self, controller )
	local f1_local0 = Engine.GetModel( Engine.GetModelForController( controller ), "hudItems" )
	Engine.CreateModel( f1_local0, "actionSlot0ammo" )
	Engine.CreateModel( f1_local0, "actionSlot1ammo" )
	Engine.CreateModel( f1_local0, "actionSlot2ammo" )
	Engine.CreateModel( f1_local0, "actionSlot3ammo" )
end

CoD.ZmAmmo_Prop = InheritFrom( LUI.UIElement )
CoD.ZmAmmo_Prop.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.ZmAmmo_Prop )
	self.id = "ZmAmmo_Prop"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 233 )
	self:setTopBottom( true, false, 0, 144 )
	self.anyChildUsesUpdateState = true

	--[[
	
	local BulbSmFill = LUI.UIImage.new()
	BulbSmFill:setLeftRight( true, false, 4.31, 172.31 )
	BulbSmFill:setTopBottom( true, false, 34, 122 )
	BulbSmFill:setImage( RegisterImage( "uie_t7_zm_hud_ammo_bulbsmfill" ) )
	self:addElement( BulbSmFill )
	self.BulbSmFill = BulbSmFill
	
	local BulbSmEdge = LUI.UIImage.new()
	BulbSmEdge:setLeftRight( true, false, 4.31, 172.31 )
	BulbSmEdge:setTopBottom( true, false, 34, 122 )
	BulbSmEdge:setImage( RegisterImage( "uie_t7_zm_hud_ammo_bulbsmedge" ) )
	BulbSmEdge:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( BulbSmEdge )
	self.BulbSmEdge = BulbSmEdge
	
	local BulbLgFill = LUI.UIImage.new()
	BulbLgFill:setLeftRight( true, false, -39.69, 160.31 )
	BulbLgFill:setTopBottom( true, false, 29, 125 )
	BulbLgFill:setAlpha( 0 )
	BulbLgFill:setImage( RegisterImage( "uie_t7_zm_hud_ammo_bulblrgfill" ) )
	self:addElement( BulbLgFill )
	self.BulbLgFill = BulbLgFill
	
	local BulbLgEdge = LUI.UIImage.new()
	BulbLgEdge:setLeftRight( true, false, -40.69, 159.31 )
	BulbLgEdge:setTopBottom( true, false, 29, 125 )
	BulbLgEdge:setAlpha( 0 )
	BulbLgEdge:setImage( RegisterImage( "uie_t7_zm_hud_ammo_bulblrgedge" ) )
	BulbLgEdge:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( BulbLgEdge )
	self.BulbLgEdge = BulbLgEdge
	
	local BulbFlmnt = LUI.UIImage.new()
	BulbFlmnt:setLeftRight( true, false, 9.31, 169.31 )
	BulbFlmnt:setTopBottom( true, false, 37, 125 )
	BulbFlmnt:setImage( RegisterImage( "uie_t7_zm_hud_ammo_bulbflmnt" ) )
	BulbFlmnt:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_multiply" ) )
	self:addElement( BulbFlmnt )
	self.BulbFlmnt = BulbFlmnt

	local Glow1 = LUI.UIImage.new()
	Glow1:setLeftRight( true, false, 0, 191 )
	Glow1:setTopBottom( true, false, 28, 122 )
	Glow1:setRGB( 1, 0.31, 0 )
	Glow1:setAlpha( 0.23 )
	Glow1:setZRot( -4 )
	Glow1:setImage( RegisterImage( "uie_t7_core_hud_mapwidget_panelglow" ) )
	self:addElement( Glow1 )
	self.Glow1 = Glow1
	--]]
	
	local DpadElement = LUI.UIImage.new()
	DpadElement:setLeftRight( true, false, 115.96, 252.66 )
	DpadElement:setTopBottom( true, false, 22.65, 171.35 )
	DpadElement:setImage( RegisterImage( "uie_t7_zm_hud_ammo_dpadelement_new" ) )
	self:addElement( DpadElement )
	self.DpadElement = DpadElement

	local BloodWrapper = LUI.UIImage.new()
	BloodWrapper:setLeftRight( true, false, -105, 252.66 )
	BloodWrapper:setTopBottom( true, false, -20, 211 )
	BloodWrapper:setImage( RegisterImage( "uie_t7_zm_derriese_hud_ammo_projection_small" ) )
	self:addElement( BloodWrapper )
	self.BloodWrapper = BloodWrapper
	
	local DpadIconWpn = CoD.ZmAmmo_DpadIconSide.new( menu, controller )
	DpadIconWpn:setLeftRight( true, false, 140, 156 )
	DpadIconWpn:setTopBottom( true, false, 76, 92 )
	DpadIconWpn:setAlpha( 0 )
	DpadIconWpn:mergeStateConditions( {
		{
			stateName = "New",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		}
	} )
	self:addElement( DpadIconWpn )
	self.DpadIconWpn = DpadIconWpn
	
	local DpadIconBgm = CoD.ZmAmmo_DpadIconBgm.new( menu, controller )
	DpadIconBgm:setLeftRight( true, false, 173.31, 189.31 )
	DpadIconBgm:setTopBottom( true, false, 41, 57 )
	DpadIconBgm:subscribeToGlobalModel(controller, "PerController", "bgb_invalid_use", function (model)
		PulseElementToStateAndBack(DpadIconBgm, "InvalidUse")
	end)
	DpadIconBgm:mergeStateConditions( {
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
	DpadIconBgm:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "bgb_activations_remaining" ), function ( model )
		menu:updateElementState( DpadIconBgm, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "bgb_activations_remaining"
		} )
	end )
	DpadIconBgm:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadUp" ), function ( model )
		menu:updateElementState( DpadIconBgm, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.showDpadUp"
		} )
	end )
	self:addElement( DpadIconBgm )
	self.DpadIconBgm = DpadIconBgm
	
	local DpadIconMine = CoD.ZmAmmo_DpadIconMine.new( menu, controller )
	DpadIconMine:setLeftRight( true, false, 200.21, 216.21 )
	DpadIconMine:setTopBottom( true, false, 87, 103 )
	DpadIconMine:mergeStateConditions( {
		{
			stateName = "Ready",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadRight", 1 ) and IsModelValueGreaterThan( controller, "hudItems.actionSlot3ammo", 0 )
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
				return IsModelValueEqualTo( controller, "hudItems.showDpadRight", 1 )
			end
		}
	} )
	DpadIconMine:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadRight" ), function ( model )
		menu:updateElementState( DpadIconMine, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.showDpadRight"
		} )
	end )
	DpadIconMine:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( model )
		menu:updateElementState( DpadIconMine, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.actionSlot3ammo"
		} )
	end )
	self:addElement( DpadIconMine )
	self.DpadIconMine = DpadIconMine

	EnableGlobals()
   	DPadRightFlash = LUI.UIImage.new()
    DPadRightFlash:setImage(RegisterImage("uie_t7_zm_derriese_hud_ammo_dpadmtr_right_flash"))
    DPadRightFlash:setTopBottom(true, false, 38, 171)
    DPadRightFlash:setLeftRight(true, false, 170, 245)
    DPadRightFlash:setAlpha( 0 )
	self:addElement(DPadRightFlash)

	DPadLeftFlash = LUI.UIImage.new()
    DPadLeftFlash:setImage(RegisterImage("uie_t7_zm_derriese_hd_hud_ammo_cover_flash"))
    DPadLeftFlash:setTopBottom(true, false, 45, 156)
    DPadLeftFlash:setLeftRight(true, false, 105, 180)
    DPadLeftFlash:setAlpha( 0 )
	self:addElement(DPadLeftFlash)

	DPadBottomFlash = LUI.UIImage.new()
    DPadBottomFlash:setImage(RegisterImage("uie_t7_zm_derriese_hud_ammo_dpadmtr_bottom_flash"))
    DPadBottomFlash:setTopBottom(true, false, 100, 174)
    DPadBottomFlash:setLeftRight(true, false, 120, 223)
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

	local DpadIconScroll = LUI.UIImage.new()
	DpadIconScroll:setLeftRight( true, false, 201.5, 244.5 )
	DpadIconScroll:setTopBottom( true, false, 75, 125 )
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
	DpadIconPause:setLeftRight( true, false, 146, 216 )
	DpadIconPause:setTopBottom( true, false, 115, 185 )
	self:addElement(DpadIconPause)

	local function IconPauseDisplay(ModelRef)
        if IsParamModelEqualToString(ModelRef, "abbey_pause") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                DpadIconPause:setImage( RegisterImage( "game_played" ) )
			else
                DpadIconPause:setImage( RegisterImage( "game_paused" ) )
            end
        end
    end
    DpadIconPause:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", IconPauseDisplay)

	local DpadIconNoHud = LUI.UIImage.new()
	DpadIconNoHud:setImage( RegisterImage ( "no_hud_0_0" ) )
	DpadIconNoHud:setLeftRight( true, false, 126.5, 146.5 )
	DpadIconNoHud:setTopBottom( true, false, 85, 115 )
	self:addElement(DpadIconNoHud)

	local function NoHudToggle(ModelRef)
        if IsParamModelEqualToString(ModelRef, "abbey_no_hud") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                DpadIconNoHud:setImage( RegisterImage( "no_hud_0_0" ) )
			elseif NotifyData[1] == 1 then
                DpadIconNoHud:setImage( RegisterImage( "no_hud_0_1" ) )
            else
				DpadIconNoHud:setImage( RegisterImage( "no_hud_1_1" ) )
			end
        end
    end
    DpadIconNoHud:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", NoHudToggle)

	local DpadIconMule = LUI.UIImage.new()
	DpadIconMule:setImage( RegisterImage ( "i_thirdguninfo" ) )
	DpadIconMule:setLeftRight( true, false, 113, 146 )
	DpadIconMule:setTopBottom( true, false, 151, 184 )
	DpadIconMule:hide()
	self:addElement(DpadIconMule)

	local function IconPauseDisplay(ModelRef)
        if IsParamModelEqualToString(ModelRef, "mule_indicator") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                DpadIconMule:hide()
			else
                DpadIconMule:show()
            end
        end
    end
    DpadIconMule:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", IconPauseDisplay)
	
	local function IconPauseAvailable(ModelRef)
        if IsParamModelEqualToString(ModelRef, "abbey_pause_available") then
			local NotifyData = CoD.GetScriptNotifyData(ModelRef)

            if NotifyData[1] == 0 then
                DpadIconPause:setRGB(1, 1, 1)
			else
                DpadIconPause:setRGB(0.5, 0.5, 0.5)
            end
        end
    end
	DpadIconPause:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", IconPauseAvailable)
	
	local DpadIconShld = CoD.ZmAmmo_DpadIconShield.new( menu, controller )
	DpadIconShld:setLeftRight( false, false, 166.31, 181.31 )
	DpadIconShld:setTopBottom( true, false, 122, 137 )
	DpadIconShld:mergeStateConditions( {
		{
			stateName = "Ready",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadDown", 1 )
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
				return AlwaysFalse()
			end
		}
	} )
	DpadIconShld:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( model )
		menu:updateElementState( DpadIconShld, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.showDpadDown"
		} )
	end )
	self:addElement( DpadIconShld )
	self.DpadIconShld = DpadIconShld
	
	local DpadIconSword = CoD.ZmAmmo_DpadIconSword.new( menu, controller )
	DpadIconSword:setLeftRight( true, false, 160.31, 192.31 )
	DpadIconSword:setTopBottom( true, false, 72, 104 )
	self:addElement( DpadIconSword )
	self.DpadIconSword = DpadIconSword
	
	local ZmAmmoDpadMeterSword0 = CoD.ZmAmmo_DpadMeterSword.new( menu, controller )
	ZmAmmoDpadMeterSword0:setLeftRight( true, false, 156, 204 )
	ZmAmmoDpadMeterSword0:setTopBottom( true, false, 62, 118 )
	self:addElement( ZmAmmoDpadMeterSword0 )
	self.ZmAmmoDpadMeterSword0 = ZmAmmoDpadMeterSword0
	
	local DpadAmmoNumbersRight = CoD.ZmAmmo_DpadAmmoNumbers.new( menu, controller )
	DpadAmmoNumbersRight:setLeftRight( true, false, 225.31, 243.31 )
	DpadAmmoNumbersRight:setTopBottom( true, false, 85, 103 )
	DpadAmmoNumbersRight:mergeStateConditions( {
		{
			stateName = "ShowZ",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		},
		{
			stateName = "Show5",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 5 )
			end
		},
		{
			stateName = "Show4",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 4 )
			end
		},
		{
			stateName = "Show3",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 3 )
			end
		},
		{
			stateName = "Show2",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 2 )
			end
		},
		{
			stateName = "Show1",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 1 )
			end
		},
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	DpadAmmoNumbersRight:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( model )
		menu:updateElementState( DpadAmmoNumbersRight, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.actionSlot3ammo"
		} )
	end )
	self:addElement( DpadAmmoNumbersRight )
	self.DpadAmmoNumbersRight = DpadAmmoNumbersRight
	
	local DpadAmmoNumbersTop = CoD.ZmAmmo_DpadAmmoNumbers.new( menu, controller )
	DpadAmmoNumbersTop:setLeftRight( true, false, 171.31, 189.31 )
	DpadAmmoNumbersTop:setTopBottom( true, false, 132.35, 150.35 )
	DpadAmmoNumbersTop:mergeStateConditions( {
		{
			stateName = "ShowZ",
			condition = function ( menu, element, event )
				return AlwaysFalse()
			end
		},
		{
			stateName = "Show5",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot1ammo", 5 )
			end
		},
		{
			stateName = "Show4",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot1ammo", 4 )
			end
		},
		{
			stateName = "Show3",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot1ammo", 3 )
			end
		},
		{
			stateName = "Show2",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot1ammo", 2 )
			end
		},
		{
			stateName = "Show1",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot1ammo", 1 )
			end
		},
		{
			stateName = "Show0",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadDown", 1 )
			end
		},
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	DpadAmmoNumbersTop:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot1ammo" ), function ( model )
		menu:updateElementState( DpadAmmoNumbersTop, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.actionSlot1ammo"
		} )
	end )
	DpadAmmoNumbersTop:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( model )
		menu:updateElementState( DpadAmmoNumbersTop, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.showDpadDown"
		} )
	end )
	self:addElement( DpadAmmoNumbersTop )
	self.DpadAmmoNumbersTop = DpadAmmoNumbersTop
	
	local DpadAmmoNumbersBottom = CoD.ZmAmmo_DpadAmmoNumbers.new( menu, controller )
	DpadAmmoNumbersBottom:setLeftRight( true, false, 177.31, 197.31 )
	DpadAmmoNumbersBottom:setTopBottom( true, false, 25, 43 )
	DpadAmmoNumbersBottom:mergeStateConditions( {
		{
			stateName = "ShowZ",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 7 )
			end
		},
		{
			stateName = "ShowCross",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 6 )
			end
		},
		{
			stateName = "Show5",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 5 )
			end
		},
		{
			stateName = "Show4",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 4 )
			end
		},
		{
			stateName = "Show3",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 3 )
			end
		},
		{
			stateName = "Show2",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 2 )
			end
		},
		{
			stateName = "Show1",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "bgb_activations_remaining", 1 )
			end
		},
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	} )
	DpadAmmoNumbersBottom:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "bgb_activations_remaining" ), function ( model )
		menu:updateElementState( DpadAmmoNumbersBottom, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "bgb_activations_remaining"
		} )
	end )
	self:addElement( DpadAmmoNumbersBottom )
	self.DpadAmmoNumbersBottom = DpadAmmoNumbersBottom
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				--[[
				BulbSmFill:completeAnimation()
				self.BulbSmFill:setAlpha( 1 )
				self.clipFinished( BulbSmFill, {} )
				BulbSmEdge:completeAnimation()
				self.BulbSmEdge:setAlpha( 1 )
				self.clipFinished( BulbSmEdge, {} )
				BulbLgFill:completeAnimation()
				self.BulbLgFill:setAlpha( 0 )
				self.clipFinished( BulbLgFill, {} )
				BulbLgEdge:completeAnimation()
				self.BulbLgEdge:setAlpha( 0 )
				self.clipFinished( BulbLgEdge, {} )
				--]]
			end
		},
		WeaponDual = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				--[[
				BulbSmFill:completeAnimation()
				self.BulbSmFill:setAlpha( 0 )
				self.clipFinished( BulbSmFill, {} )
				BulbSmEdge:completeAnimation()
				self.BulbSmEdge:setAlpha( 0 )
				self.clipFinished( BulbSmEdge, {} )
				BulbLgFill:completeAnimation()
				self.BulbLgFill:setAlpha( 0.93 )
				self.clipFinished( BulbLgFill, {} )
				BulbLgEdge:completeAnimation()
				self.BulbLgEdge:setAlpha( 1 )
				self.clipFinished( BulbLgEdge, {} )
				--]]
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "WeaponDual",
			condition = function ( menu, element, event )
				return IsModelValueGreaterThanOrEqualTo( controller, "currentWeapon.ammoInDWClip", 0 )
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.ammoInDWClip" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "currentWeapon.ammoInDWClip"
		} )
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.DpadIconWpn:close()
		element.DpadIconBgm:close()
		element.DpadIconMine:close()
		element.DpadIconShld:close()
		element.DpadIconSword:close()
		element.ZmAmmoDpadMeterSword0:close()
		element.DpadAmmoNumbersRight:close()
		element.DpadAmmoNumbersTop:close()
		element.DpadAmmoNumbersBottom:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

