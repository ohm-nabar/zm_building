CoD.ZmAmmo_BBGumMeterWidget = InheritFrom(LUI.UIElement)
CoD.ZmAmmo_BBGumMeterWidget.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ZmAmmo_BBGumMeterWidget)
	Widget.id = "ZmAmmo_BBGumMeterWidget"
	Widget.soundSet = "HUD"
	Widget:setLeftRight(true, false, 0, 53)
	Widget:setTopBottom(true, false, 0, 53)
	local f1_local1 = LUI.UIImage.new()
	f1_local1:setLeftRight(true, false, -4.99, 57.87)
	f1_local1:setTopBottom(true, false, -4.93, 57.93)
	f1_local1:setRGB(1, 0.64, 0)
	f1_local1:setAlpha(0.9)
	f1_local1:setImage(RegisterImage("uie_t7_core_hud_ammowidget_abilityswirl"))
	f1_local1:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f1_local1)
	Widget.AbilitySwirl = f1_local1
	
	local f1_local2 = LUI.UIImage.new()
	f1_local2:setLeftRight(true, false, 0, 53)
	f1_local2:setTopBottom(true, false, 0, 53)
	f1_local2:setAlpha(0.1)
	f1_local2:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgummeterringbacker"))
	Widget:addElement(f1_local2)
	Widget.BBGumRingBacker = f1_local2
	
	local f1_local3 = LUI.UIImage.new()
	f1_local3:setLeftRight(true, false, 0, 53)
	f1_local3:setTopBottom(true, false, 0, 53)
	f1_local3:setRGB(1, 0.85, 0)
	f1_local3:setAlpha(0.5)
	f1_local3:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgummeterringblur3"))
	f1_local3:setMaterial(LUI.UIImage.GetCachedMaterial("uie_clock_normal"))
	f1_local3:setShaderVector(1, 0.5, 0, 0, 0)
	f1_local3:setShaderVector(2, 0.5, 0, 0, 0)
	f1_local3:setShaderVector(3, 0.08, 0, 0, 0)
	f1_local3:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_timer", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local3:setShaderVector(0, CoD.GetVectorComponentFromString(ModelValue, 1), CoD.GetVectorComponentFromString(ModelValue, 2), CoD.GetVectorComponentFromString(ModelValue, 3), CoD.GetVectorComponentFromString(ModelValue, 4))
		end
	end)
	Widget:addElement(f1_local3)
	Widget.BBGumRing000 = f1_local3
	
	local f1_local4 = LUI.UIImage.new()
	f1_local4:setLeftRight(true, false, 0, 53)
	f1_local4:setTopBottom(true, false, 0, 53)
	f1_local4:setRGB(1, 0.69, 0)
	f1_local4:setAlpha(0.5)
	f1_local4:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgummeterringblur1"))
	f1_local4:setMaterial(LUI.UIImage.GetCachedMaterial("uie_clock_normal"))
	f1_local4:setShaderVector(1, 0.5, 0, 0, 0)
	f1_local4:setShaderVector(2, 0.5, 0, 0, 0)
	f1_local4:setShaderVector(3, 0.08, 0, 0, 0)
	f1_local4:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_timer", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local4:setShaderVector(0, CoD.GetVectorComponentFromString(ModelValue, 1), CoD.GetVectorComponentFromString(ModelValue, 2), CoD.GetVectorComponentFromString(ModelValue, 3), CoD.GetVectorComponentFromString(ModelValue, 4))
		end
	end)
	Widget:addElement(f1_local4)
	Widget.BBGumRing00 = f1_local4
	
	local f1_local5 = LUI.UIImage.new()
	f1_local5:setLeftRight(true, false, 0, 53)
	f1_local5:setTopBottom(true, false, 0, 53)
	f1_local5:setRGB(1, 0.78, 0)
	f1_local5:setAlpha(0.5)
	f1_local5:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgummeterringblur1"))
	f1_local5:setMaterial(LUI.UIImage.GetCachedMaterial("uie_clock_normal"))
	f1_local5:setShaderVector(1, 0.5, 0, 0, 0)
	f1_local5:setShaderVector(2, 0.5, 0, 0, 0)
	f1_local5:setShaderVector(3, 0.08, 0, 0, 0)
	f1_local5:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_timer", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local5:setShaderVector(0, CoD.GetVectorComponentFromString(ModelValue, 1), CoD.GetVectorComponentFromString(ModelValue, 2), CoD.GetVectorComponentFromString(ModelValue, 3), CoD.GetVectorComponentFromString(ModelValue, 4))
		end
	end)
	Widget:addElement(f1_local5)
	Widget.BBGumRing0 = f1_local5
	
	local f1_local6 = LUI.UIImage.new()
	f1_local6:setLeftRight(true, false, 0, 52.89)
	f1_local6:setTopBottom(true, false, 0, 52.88)
	f1_local6:setRGB(1, 0.96, 0.75)
	f1_local6:setAlpha(0.75)
	f1_local6:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgummeterring"))
	f1_local6:setMaterial(LUI.UIImage.GetCachedMaterial("uie_clock_normal"))
	f1_local6:setShaderVector(1, 0.5, 0, 0, 0)
	f1_local6:setShaderVector(2, 0.5, 0, 0, 0)
	f1_local6:setShaderVector(3, 0.08, 0, 0, 0)
	f1_local6:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_timer", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local6:setShaderVector(0, CoD.GetVectorComponentFromString(ModelValue, 1), CoD.GetVectorComponentFromString(ModelValue, 2), CoD.GetVectorComponentFromString(ModelValue, 3), CoD.GetVectorComponentFromString(ModelValue, 4))
		end
	end)
	Widget:addElement(f1_local6)
	Widget.BBGumRing = f1_local6
	
	local f1_local7 = LUI.UIImage.new()
	f1_local7:setLeftRight(true, false, 0, 52.89)
	f1_local7:setTopBottom(true, false, 0, 52.88)
	f1_local7:setRGB(1, 0.83, 0.08)
	f1_local7:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgummeterring"))
	f1_local7:setMaterial(LUI.UIImage.GetCachedMaterial("uie_clock_normal"))
	f1_local7:setShaderVector(1, 0.5, 0, 0, 0)
	f1_local7:setShaderVector(2, 0.5, 0, 0, 0)
	f1_local7:setShaderVector(3, 0.08, -0.22, 0, 0)
	f1_local7:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_timer", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f1_local7:setShaderVector(0, CoD.GetVectorComponentFromString(ModelValue, 1), CoD.GetVectorComponentFromString(ModelValue, 2), CoD.GetVectorComponentFromString(ModelValue, 3), CoD.GetVectorComponentFromString(ModelValue, 4))
		end
	end)
	Widget:addElement(f1_local7)
	Widget.BBGumRingEdge = f1_local7
	
	local f1_local8 = LUI.UIImage.new()
	f1_local8:setLeftRight(true, false, 8, 44)
	f1_local8:setTopBottom(true, false, 8, 44)
	f1_local8:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_current", function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			local tableName = "gamedata/weapons/zm/zm_levelcommon_bgb.csv"
			local bgbName = Engine.TableLookup(nil, tableName, 1, ModelValue, 0)
			bgbName = string.sub(bgbName, 4)
			f1_local8:setImage(RegisterImage("t7_hud_zm_" .. bgbName))
		end
	end)
	Widget:addElement(f1_local8)
	Widget.BBGumTexture = f1_local8
	
	local f1_local9 = LUI.UIImage.new()
	f1_local9:setLeftRight(true, false, -3.56, 55.44)
	f1_local9:setTopBottom(true, false, -2.56, 56.44)
	f1_local9:setRGB(1, 0.28, 0)
	f1_local9:setAlpha(0.75)
	f1_local9:setZRot(-4)
	f1_local9:setScale(1.2)
	f1_local9:setImage(RegisterImage("uie_t7_core_hud_mapwidget_panelglow"))
	f1_local9:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f1_local9)
	Widget.Glow1 = f1_local9
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(9)
		f1_local1:completeAnimation()
		Widget.AbilitySwirl:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.BBGumRingBacker:setAlpha(0)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.BBGumRing000:setRGB(1, 0.85, 0)
		Widget.BBGumRing000:setAlpha(0)
		Widget.clipFinished(f1_local3, {})
		f1_local4:completeAnimation()
		Widget.BBGumRing00:setRGB(1, 0.69, 0)
		Widget.BBGumRing00:setAlpha(0)
		Widget.clipFinished(f1_local4, {})
		f1_local5:completeAnimation()
		Widget.BBGumRing0:setRGB(1, 0.78, 0)
		Widget.BBGumRing0:setAlpha(0)
		Widget.clipFinished(f1_local5, {})
		f1_local6:completeAnimation()
		Widget.BBGumRing:setRGB(1, 0.96, 0.75)
		Widget.BBGumRing:setAlpha(0)
		Widget.clipFinished(f1_local6, {})
		f1_local7:completeAnimation()
		Widget.BBGumRingEdge:setRGB(1, 0.83, 0.08)
		Widget.BBGumRingEdge:setAlpha(0)
		Widget.clipFinished(f1_local7, {})
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setAlpha(0)
		Widget.BBGumTexture:setScale(1)
		Widget.clipFinished(f1_local8, {})
		f1_local9:completeAnimation()
		Widget.Glow1:setAlpha(0)
		Widget.clipFinished(f1_local9, {})
	end}, ActiveLow = {DefaultClip = function ()
		Widget:setupElementClipCounter(9)
		f1_local1:completeAnimation()
		Widget.AbilitySwirl:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.BBGumRingBacker:setAlpha(0.1)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.BBGumRing000:setRGB(1, 0.07, 0)
		Widget.BBGumRing000:setAlpha(0.5)
		Widget.clipFinished(f1_local3, {})
		f1_local4:completeAnimation()
		Widget.BBGumRing00:setRGB(1, 0.08, 0)
		Widget.BBGumRing00:setAlpha(0.5)
		Widget.clipFinished(f1_local4, {})
		f1_local5:completeAnimation()
		Widget.BBGumRing0:setRGB(1, 0.18, 0)
		Widget.BBGumRing0:setAlpha(0.5)
		Widget.clipFinished(f1_local5, {})
		f1_local6:completeAnimation()
		Widget.BBGumRing:setRGB(1, 0.77, 0.75)
		Widget.BBGumRing:setAlpha(0.7)
		Widget.clipFinished(f1_local6, {})
		f1_local7:completeAnimation()
		Widget.BBGumRingEdge:setRGB(1, 0.21, 0.12)
		Widget.BBGumRingEdge:setAlpha(1)
		Widget.clipFinished(f1_local7, {})
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setLeftRight(true, false, 8, 44)
		Widget.BBGumTexture:setTopBottom(true, false, 8, 44)
		Widget.BBGumTexture:setAlpha(1)
		Widget.clipFinished(f1_local8, {})
		f1_local9:beginAnimation("keyframe", 2000, false, false, CoD.TweenType.Linear)
		f1_local9:setAlpha(0)
		f1_local9:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
	end, DefaultState = function ()
		Widget:setupElementClipCounter(1)
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setAlpha(1)
		Widget.BBGumTexture:setScale(0)
		local f10_local0 = function (f27_arg0, f27_arg1)
			local f27_local0 = function (f28_arg0, f28_arg1)
				local f28_local0 = function (f29_arg0, f29_arg1)
					local f29_local0 = function (f30_arg0, f30_arg1)
						local f30_local0 = function (f31_arg0, f31_arg1)
							local f31_local0 = function (f32_arg0, f32_arg1)
								local f32_local0 = function (f33_arg0, f33_arg1)
									local f33_local0 = function (f34_arg0, f34_arg1)
										local f34_local0 = function (f35_arg0, f35_arg1)
											if not f35_arg1.interrupted then
												f35_arg0:beginAnimation("keyframe", 200, false, false, CoD.TweenType.Linear)
											end
											f35_arg0:setAlpha(1)
											f35_arg0:setScale(0)
											if f35_arg1.interrupted then
												Widget.clipFinished(f35_arg0, f35_arg1)
											else
												f35_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
											end
										end

										if f34_arg1.interrupted then
											f34_local0(f34_arg0, f34_arg1)
											return 
										else
											f34_arg0:beginAnimation("keyframe", 309, false, false, CoD.TweenType.Linear)
											f34_arg0:registerEventHandler("transition_complete_keyframe", f34_local0)
										end
									end

									if f33_arg1.interrupted then
										f33_local0(f33_arg0, f33_arg1)
										return 
									else
										f33_arg0:beginAnimation("keyframe", 169, false, false, CoD.TweenType.Linear)
										f33_arg0:setScale(1)
										f33_arg0:registerEventHandler("transition_complete_keyframe", f33_local0)
									end
								end

								if f32_arg1.interrupted then
									f32_local0(f32_arg0, f32_arg1)
									return 
								else
									f32_arg0:beginAnimation("keyframe", 160, false, false, CoD.TweenType.Linear)
									f32_arg0:setScale(0.8)
									f32_arg0:registerEventHandler("transition_complete_keyframe", f32_local0)
								end
							end

							if f31_arg1.interrupted then
								f31_local0(f31_arg0, f31_arg1)
								return 
							else
								f31_arg0:beginAnimation("keyframe", 149, false, false, CoD.TweenType.Linear)
								f31_arg0:setScale(1.2)
								f31_arg0:registerEventHandler("transition_complete_keyframe", f31_local0)
							end
						end

						if f30_arg1.interrupted then
							f30_local0(f30_arg0, f30_arg1)
							return 
						else
							f30_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
							f30_arg0:registerEventHandler("transition_complete_keyframe", f30_local0)
						end
					end

					if f29_arg1.interrupted then
						f29_local0(f29_arg0, f29_arg1)
						return 
					else
						f29_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
						f29_arg0:setScale(1)
						f29_arg0:registerEventHandler("transition_complete_keyframe", f29_local0)
					end
				end

				if f28_arg1.interrupted then
					f28_local0(f28_arg0, f28_arg1)
					return 
				else
					f28_arg0:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
					f28_arg0:setScale(0.8)
					f28_arg0:registerEventHandler("transition_complete_keyframe", f28_local0)
				end
			end

			if f27_arg1.interrupted then
				f27_local0(f27_arg0, f27_arg1)
				return 
			else
				f27_arg0:beginAnimation("keyframe", 189, false, false, CoD.TweenType.Linear)
				f27_arg0:setScale(1.2)
				f27_arg0:registerEventHandler("transition_complete_keyframe", f27_local0)
			end
		end

		f10_local0(f1_local8, {})
	end}, Active = {DefaultClip = function ()
		Widget:setupElementClipCounter(9)
		f1_local1:completeAnimation()
		Widget.AbilitySwirl:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.BBGumRingBacker:setAlpha(0.1)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.BBGumRing000:setRGB(1, 0.85, 0)
		Widget.BBGumRing000:setAlpha(0.5)
		Widget.clipFinished(f1_local3, {})
		f1_local4:completeAnimation()
		Widget.BBGumRing00:setRGB(1, 0.69, 0)
		Widget.BBGumRing00:setAlpha(0.5)
		Widget.clipFinished(f1_local4, {})
		f1_local5:completeAnimation()
		Widget.BBGumRing0:setRGB(1, 0.78, 0)
		Widget.BBGumRing0:setAlpha(0.5)
		Widget.clipFinished(f1_local5, {})
		f1_local6:completeAnimation()
		Widget.BBGumRing:setRGB(1, 0.96, 0.75)
		Widget.BBGumRing:setAlpha(0.7)
		Widget.clipFinished(f1_local6, {})
		f1_local7:completeAnimation()
		Widget.BBGumRingEdge:setRGB(1, 0.71, 0.12)
		Widget.BBGumRingEdge:setAlpha(1)
		Widget.clipFinished(f1_local7, {})
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setLeftRight(true, false, 8, 44)
		Widget.BBGumTexture:setTopBottom(true, false, 8, 44)
		Widget.BBGumTexture:setAlpha(1)
		Widget.BBGumTexture:setScale(1)
		Widget.clipFinished(f1_local8, {})
		f1_local9:beginAnimation("keyframe", 2000, false, false, CoD.TweenType.Linear)
		f1_local9:setAlpha(0)
		f1_local9:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
	end, DefaultState = function ()
		Widget:setupElementClipCounter(1)
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setAlpha(1)
		Widget.BBGumTexture:setScale(0)
		local f12_local0 = function (f36_arg0, f36_arg1)
			local f36_local0 = function (f37_arg0, f37_arg1)
				local f37_local0 = function (f38_arg0, f38_arg1)
					local f38_local0 = function (f39_arg0, f39_arg1)
						local f39_local0 = function (f40_arg0, f40_arg1)
							local f40_local0 = function (f41_arg0, f41_arg1)
								local f41_local0 = function (f42_arg0, f42_arg1)
									local f42_local0 = function (f43_arg0, f43_arg1)
										local f43_local0 = function (f44_arg0, f44_arg1)
											if not f44_arg1.interrupted then
												f44_arg0:beginAnimation("keyframe", 200, false, false, CoD.TweenType.Linear)
											end
											f44_arg0:setAlpha(1)
											f44_arg0:setScale(0)
											if f44_arg1.interrupted then
												Widget.clipFinished(f44_arg0, f44_arg1)
											else
												f44_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
											end
										end

										if f43_arg1.interrupted then
											f43_local0(f43_arg0, f43_arg1)
											return 
										else
											f43_arg0:beginAnimation("keyframe", 309, false, false, CoD.TweenType.Linear)
											f43_arg0:registerEventHandler("transition_complete_keyframe", f43_local0)
										end
									end

									if f42_arg1.interrupted then
										f42_local0(f42_arg0, f42_arg1)
										return 
									else
										f42_arg0:beginAnimation("keyframe", 169, false, false, CoD.TweenType.Linear)
										f42_arg0:setScale(1)
										f42_arg0:registerEventHandler("transition_complete_keyframe", f42_local0)
									end
								end

								if f41_arg1.interrupted then
									f41_local0(f41_arg0, f41_arg1)
									return 
								else
									f41_arg0:beginAnimation("keyframe", 160, false, false, CoD.TweenType.Linear)
									f41_arg0:setScale(0.8)
									f41_arg0:registerEventHandler("transition_complete_keyframe", f41_local0)
								end
							end

							if f40_arg1.interrupted then
								f40_local0(f40_arg0, f40_arg1)
								return 
							else
								f40_arg0:beginAnimation("keyframe", 149, false, false, CoD.TweenType.Linear)
								f40_arg0:setScale(1.2)
								f40_arg0:registerEventHandler("transition_complete_keyframe", f40_local0)
							end
						end

						if f39_arg1.interrupted then
							f39_local0(f39_arg0, f39_arg1)
							return 
						else
							f39_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
							f39_arg0:registerEventHandler("transition_complete_keyframe", f39_local0)
						end
					end

					if f38_arg1.interrupted then
						f38_local0(f38_arg0, f38_arg1)
						return 
					else
						f38_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
						f38_arg0:setScale(1)
						f38_arg0:registerEventHandler("transition_complete_keyframe", f38_local0)
					end
				end

				if f37_arg1.interrupted then
					f37_local0(f37_arg0, f37_arg1)
					return 
				else
					f37_arg0:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
					f37_arg0:setScale(0.8)
					f37_arg0:registerEventHandler("transition_complete_keyframe", f37_local0)
				end
			end

			if f36_arg1.interrupted then
				f36_local0(f36_arg0, f36_arg1)
				return 
			else
				f36_arg0:beginAnimation("keyframe", 189, false, false, CoD.TweenType.Linear)
				f36_arg0:setScale(1.2)
				f36_arg0:registerEventHandler("transition_complete_keyframe", f36_local0)
			end
		end

		f12_local0(f1_local8, {})
	end}, Inactive = {DefaultClip = function ()
		Widget:setupElementClipCounter(9)
		f1_local1:completeAnimation()
		Widget.AbilitySwirl:setAlpha(0)
		Widget.clipFinished(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.BBGumRingBacker:setAlpha(0.1)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.BBGumRing000:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing000:setAlpha(0)
		Widget.clipFinished(f1_local3, {})
		f1_local4:completeAnimation()
		Widget.BBGumRing00:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing00:setAlpha(0)
		Widget.clipFinished(f1_local4, {})
		f1_local5:completeAnimation()
		Widget.BBGumRing0:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing0:setAlpha(0)
		Widget.clipFinished(f1_local5, {})
		f1_local6:completeAnimation()
		Widget.BBGumRing:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing:setAlpha(0)
		Widget.clipFinished(f1_local6, {})
		f1_local7:completeAnimation()
		Widget.BBGumRingEdge:setRGB(1, 0.83, 0.08)
		Widget.BBGumRingEdge:setAlpha(0)
		Widget.clipFinished(f1_local7, {})
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setLeftRight(true, false, 8, 44)
		Widget.BBGumTexture:setTopBottom(true, false, 8, 44)
		Widget.BBGumTexture:setAlpha(1)
		Widget.clipFinished(f1_local8, {})
		f1_local9:beginAnimation("keyframe", 2000, false, false, CoD.TweenType.Linear)
		f1_local9:setAlpha(0)
		f1_local9:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
	end, Active = function ()
		Widget:setupElementClipCounter(9)
		f1_local1:completeAnimation()
		Widget.AbilitySwirl:setLeftRight(true, false, -4.99, 57.87)
		Widget.AbilitySwirl:setTopBottom(true, false, -4.93, 57.93)
		Widget.AbilitySwirl:setAlpha(0)
		Widget.AbilitySwirl:setZRot(0)
		Widget.AbilitySwirl:setScale(0.5)
		local f14_local0 = function (f45_arg0, f45_arg1)
			local f45_local0 = function (f54_arg0, f54_arg1)
				local f54_local0 = function (f55_arg0, f55_arg1)
					local f55_local0 = function (f56_arg0, f56_arg1)
						local f56_local0 = function (f57_arg0, f57_arg1)
							if not f57_arg1.interrupted then
								f57_arg0:beginAnimation("keyframe", 30, false, false, CoD.TweenType.Linear)
							end
							f57_arg0:setLeftRight(true, false, -4.99, 57.87)
							f57_arg0:setTopBottom(true, false, -4.93, 57.93)
							f57_arg0:setAlpha(0)
							f57_arg0:setZRot(631)
							f57_arg0:setScale(1.3)
							if f57_arg1.interrupted then
								Widget.clipFinished(f57_arg0, f57_arg1)
							else
								f57_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
							end
						end

						if f56_arg1.interrupted then
							f56_local0(f56_arg0, f56_arg1)
							return 
						else
							f56_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
							f56_arg0:setAlpha(0)
							f56_arg0:setZRot(592.29)
							f56_arg0:setScale(1.25)
							f56_arg0:registerEventHandler("transition_complete_keyframe", f56_local0)
						end
					end

					if f55_arg1.interrupted then
						f55_local0(f55_arg0, f55_arg1)
						return 
					else
						f55_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f55_arg0:setZRot(476.14)
						f55_arg0:setScale(1.11)
						f55_arg0:registerEventHandler("transition_complete_keyframe", f55_local0)
					end
				end

				if f54_arg1.interrupted then
					f54_local0(f54_arg0, f54_arg1)
					return 
				else
					f54_arg0:beginAnimation("keyframe", 89, false, false, CoD.TweenType.Linear)
					f54_arg0:setZRot(360)
					f54_arg0:setScale(0.96)
					f54_arg0:registerEventHandler("transition_complete_keyframe", f54_local0)
				end
			end

			if f45_arg1.interrupted then
				f45_local0(f45_arg0, f45_arg1)
				return 
			else
				f45_arg0:beginAnimation("keyframe", 200, false, false, CoD.TweenType.Linear)
				f45_arg0:setAlpha(0.9)
				f45_arg0:setZRot(248.28)
				f45_arg0:setScale(0.82)
				f45_arg0:registerEventHandler("transition_complete_keyframe", f45_local0)
			end
		end

		f14_local0(f1_local1, {})
		f1_local2:completeAnimation()
		Widget.BBGumRingBacker:setAlpha(0.1)
		local f14_local1 = function (f46_arg0, f46_arg1)
			if not f46_arg1.interrupted then
				f46_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
			end
			f46_arg0:setAlpha(0.1)
			if f46_arg1.interrupted then
				Widget.clipFinished(f46_arg0, f46_arg1)
			else
				f46_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f14_local1(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.BBGumRing000:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing000:setAlpha(0)
		local f14_local2 = function (f47_arg0, f47_arg1)
			if not f47_arg1.interrupted then
				f47_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
			end
			f47_arg0:setRGB(1, 0.85, 0)
			f47_arg0:setAlpha(0.5)
			if f47_arg1.interrupted then
				Widget.clipFinished(f47_arg0, f47_arg1)
			else
				f47_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f14_local2(f1_local3, {})
		f1_local4:completeAnimation()
		Widget.BBGumRing00:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing00:setAlpha(0)
		local f14_local3 = function (f48_arg0, f48_arg1)
			if not f48_arg1.interrupted then
				f48_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
			end
			f48_arg0:setRGB(1, 0.69, 0)
			f48_arg0:setAlpha(0.5)
			if f48_arg1.interrupted then
				Widget.clipFinished(f48_arg0, f48_arg1)
			else
				f48_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f14_local3(f1_local4, {})
		f1_local5:completeAnimation()
		Widget.BBGumRing0:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing0:setAlpha(0)
		local f14_local4 = function (f49_arg0, f49_arg1)
			if not f49_arg1.interrupted then
				f49_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
			end
			f49_arg0:setRGB(1, 0.78, 0)
			f49_arg0:setAlpha(0.5)
			if f49_arg1.interrupted then
				Widget.clipFinished(f49_arg0, f49_arg1)
			else
				f49_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f14_local4(f1_local5, {})
		f1_local6:completeAnimation()
		Widget.BBGumRing:setRGB(0.73, 0.73, 0.73)
		Widget.BBGumRing:setAlpha(0)
		local f14_local5 = function (f50_arg0, f50_arg1)
			if not f50_arg1.interrupted then
				f50_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
			end
			f50_arg0:setRGB(1, 0.96, 0.75)
			f50_arg0:setAlpha(0.7)
			if f50_arg1.interrupted then
				Widget.clipFinished(f50_arg0, f50_arg1)
			else
				f50_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f14_local5(f1_local6, {})
		f1_local7:completeAnimation()
		Widget.BBGumRingEdge:setAlpha(0)
		local f14_local6 = function (f51_arg0, f51_arg1)
			if not f51_arg1.interrupted then
				f51_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
			end
			f51_arg0:setAlpha(1)
			if f51_arg1.interrupted then
				Widget.clipFinished(f51_arg0, f51_arg1)
			else
				f51_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
			end
		end

		f14_local6(f1_local7, {})
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setAlpha(1)
		Widget.BBGumTexture:setScale(1)
		local f14_local7 = function (f52_arg0, f52_arg1)
			local f52_local0 = function (f58_arg0, f58_arg1)
				local f58_local0 = function (f59_arg0, f59_arg1)
					if not f59_arg1.interrupted then
						f59_arg0:beginAnimation("keyframe", 199, false, false, CoD.TweenType.Linear)
					end
					f59_arg0:setAlpha(1)
					f59_arg0:setScale(1)
					if f59_arg1.interrupted then
						Widget.clipFinished(f59_arg0, f59_arg1)
					else
						f59_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f58_arg1.interrupted then
					f58_local0(f58_arg0, f58_arg1)
					return 
				else
					f58_arg0:beginAnimation("keyframe", 150, false, false, CoD.TweenType.Linear)
					f58_arg0:setScale(1.2)
					f58_arg0:registerEventHandler("transition_complete_keyframe", f58_local0)
				end
			end

			if f52_arg1.interrupted then
				f52_local0(f52_arg0, f52_arg1)
				return 
			else
				f52_arg0:beginAnimation("keyframe", 150, false, false, CoD.TweenType.Linear)
				f52_arg0:setScale(0.8)
				f52_arg0:registerEventHandler("transition_complete_keyframe", f52_local0)
			end
		end

		f14_local7(f1_local8, {})
		f1_local9:completeAnimation()
		Widget.Glow1:setAlpha(0)
		local f14_local8 = function (f53_arg0, f53_arg1)
			local f53_local0 = function (f60_arg0, f60_arg1)
				local f60_local0 = function (f61_arg0, f61_arg1)
					if not f61_arg1.interrupted then
						f61_arg0:beginAnimation("keyframe", 199, false, false, CoD.TweenType.Linear)
					end
					f61_arg0:setAlpha(0)
					if f61_arg1.interrupted then
						Widget.clipFinished(f61_arg0, f61_arg1)
					else
						f61_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f60_arg1.interrupted then
					f60_local0(f60_arg0, f60_arg1)
					return 
				else
					f60_arg0:beginAnimation("keyframe", 150, false, false, CoD.TweenType.Linear)
					f60_arg0:registerEventHandler("transition_complete_keyframe", f60_local0)
				end
			end

			if f53_arg1.interrupted then
				f53_local0(f53_arg0, f53_arg1)
				return 
			else
				f53_arg0:beginAnimation("keyframe", 150, false, false, CoD.TweenType.Linear)
				f53_arg0:setAlpha(0.65)
				f53_arg0:registerEventHandler("transition_complete_keyframe", f53_local0)
			end
		end

		f14_local8(f1_local9, {})
	end}, InstantActivate = {DefaultClip = function ()
		Widget:setupElementClipCounter(0)
	end, DefaultState = function ()
		Widget:setupElementClipCounter(7)
		f1_local2:completeAnimation()
		Widget.BBGumRingBacker:setAlpha(0.1)
		Widget.clipFinished(f1_local2, {})
		f1_local3:completeAnimation()
		Widget.BBGumRing000:setRGB(1, 0.85, 0)
		Widget.BBGumRing000:setAlpha(0.5)
		Widget.clipFinished(f1_local3, {})
		f1_local4:completeAnimation()
		Widget.BBGumRing00:setRGB(1, 0.69, 0)
		Widget.BBGumRing00:setAlpha(0.5)
		Widget.clipFinished(f1_local4, {})
		f1_local5:completeAnimation()
		Widget.BBGumRing0:setRGB(1, 0.78, 0)
		Widget.BBGumRing0:setAlpha(0.5)
		Widget.clipFinished(f1_local5, {})
		f1_local6:completeAnimation()
		Widget.BBGumRing:setRGB(1, 0.96, 0.75)
		Widget.BBGumRing:setAlpha(0.7)
		Widget.clipFinished(f1_local6, {})
		f1_local7:completeAnimation()
		Widget.BBGumRingEdge:setRGB(1, 0.71, 0.12)
		Widget.BBGumRingEdge:setAlpha(1)
		Widget.clipFinished(f1_local7, {})
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setAlpha(1)
		Widget.BBGumTexture:setScale(0)
		local f16_local0 = function (f62_arg0, f62_arg1)
			local f62_local0 = function (f63_arg0, f63_arg1)
				local f63_local0 = function (f64_arg0, f64_arg1)
					local f64_local0 = function (f65_arg0, f65_arg1)
						local f65_local0 = function (f66_arg0, f66_arg1)
							local f66_local0 = function (f67_arg0, f67_arg1)
								local f67_local0 = function (f68_arg0, f68_arg1)
									local f68_local0 = function (f69_arg0, f69_arg1)
										local f69_local0 = function (f70_arg0, f70_arg1)
											if not f70_arg1.interrupted then
												f70_arg0:beginAnimation("keyframe", 200, false, false, CoD.TweenType.Linear)
											end
											f70_arg0:setAlpha(1)
											f70_arg0:setScale(0)
											if f70_arg1.interrupted then
												Widget.clipFinished(f70_arg0, f70_arg1)
											else
												f70_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
											end
										end

										if f69_arg1.interrupted then
											f69_local0(f69_arg0, f69_arg1)
											return 
										else
											f69_arg0:beginAnimation("keyframe", 309, false, false, CoD.TweenType.Linear)
											f69_arg0:registerEventHandler("transition_complete_keyframe", f69_local0)
										end
									end

									if f68_arg1.interrupted then
										f68_local0(f68_arg0, f68_arg1)
										return 
									else
										f68_arg0:beginAnimation("keyframe", 169, false, false, CoD.TweenType.Linear)
										f68_arg0:setScale(1)
										f68_arg0:registerEventHandler("transition_complete_keyframe", f68_local0)
									end
								end

								if f67_arg1.interrupted then
									f67_local0(f67_arg0, f67_arg1)
									return 
								else
									f67_arg0:beginAnimation("keyframe", 160, false, false, CoD.TweenType.Linear)
									f67_arg0:setScale(0.8)
									f67_arg0:registerEventHandler("transition_complete_keyframe", f67_local0)
								end
							end

							if f66_arg1.interrupted then
								f66_local0(f66_arg0, f66_arg1)
								return 
							else
								f66_arg0:beginAnimation("keyframe", 149, false, false, CoD.TweenType.Linear)
								f66_arg0:setScale(1.2)
								f66_arg0:registerEventHandler("transition_complete_keyframe", f66_local0)
							end
						end

						if f65_arg1.interrupted then
							f65_local0(f65_arg0, f65_arg1)
							return 
						else
							f65_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
							f65_arg0:registerEventHandler("transition_complete_keyframe", f65_local0)
						end
					end

					if f64_arg1.interrupted then
						f64_local0(f64_arg0, f64_arg1)
						return 
					else
						f64_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
						f64_arg0:setScale(1)
						f64_arg0:registerEventHandler("transition_complete_keyframe", f64_local0)
					end
				end

				if f63_arg1.interrupted then
					f63_local0(f63_arg0, f63_arg1)
					return 
				else
					f63_arg0:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
					f63_arg0:setScale(0.8)
					f63_arg0:registerEventHandler("transition_complete_keyframe", f63_local0)
				end
			end

			if f62_arg1.interrupted then
				f62_local0(f62_arg0, f62_arg1)
				return 
			else
				f62_arg0:beginAnimation("keyframe", 189, false, false, CoD.TweenType.Linear)
				f62_arg0:setScale(1.2)
				f62_arg0:registerEventHandler("transition_complete_keyframe", f62_local0)
			end
		end

		f16_local0(f1_local8, {})
	end, Active = function ()
		Widget:setupElementClipCounter(1)
		f1_local8:completeAnimation()
		Widget.BBGumTexture:setAlpha(1)
		Widget.BBGumTexture:setScale(0)
		local f17_local0 = function (f71_arg0, f71_arg1)
			local f71_local0 = function (f72_arg0, f72_arg1)
				local f72_local0 = function (f73_arg0, f73_arg1)
					local f73_local0 = function (f74_arg0, f74_arg1)
						local f74_local0 = function (f75_arg0, f75_arg1)
							local f75_local0 = function (f76_arg0, f76_arg1)
								local f76_local0 = function (f77_arg0, f77_arg1)
									local f77_local0 = function (f78_arg0, f78_arg1)
										local f78_local0 = function (f79_arg0, f79_arg1)
											if not f79_arg1.interrupted then
												f79_arg0:beginAnimation("keyframe", 200, false, false, CoD.TweenType.Linear)
											end
											f79_arg0:setAlpha(1)
											f79_arg0:setScale(1)
											if f79_arg1.interrupted then
												Widget.clipFinished(f79_arg0, f79_arg1)
											else
												f79_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
											end
										end

										if f78_arg1.interrupted then
											f78_local0(f78_arg0, f78_arg1)
											return 
										else
											f78_arg0:beginAnimation("keyframe", 309, false, false, CoD.TweenType.Linear)
											f78_arg0:registerEventHandler("transition_complete_keyframe", f78_local0)
										end
									end

									if f77_arg1.interrupted then
										f77_local0(f77_arg0, f77_arg1)
										return 
									else
										f77_arg0:beginAnimation("keyframe", 169, false, false, CoD.TweenType.Linear)
										f77_arg0:setScale(1)
										f77_arg0:registerEventHandler("transition_complete_keyframe", f77_local0)
									end
								end

								if f76_arg1.interrupted then
									f76_local0(f76_arg0, f76_arg1)
									return 
								else
									f76_arg0:beginAnimation("keyframe", 160, false, false, CoD.TweenType.Linear)
									f76_arg0:setScale(0.8)
									f76_arg0:registerEventHandler("transition_complete_keyframe", f76_local0)
								end
							end

							if f75_arg1.interrupted then
								f75_local0(f75_arg0, f75_arg1)
								return 
							else
								f75_arg0:beginAnimation("keyframe", 149, false, false, CoD.TweenType.Linear)
								f75_arg0:setScale(1.2)
								f75_arg0:registerEventHandler("transition_complete_keyframe", f75_local0)
							end
						end

						if f74_arg1.interrupted then
							f74_local0(f74_arg0, f74_arg1)
							return 
						else
							f74_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
							f74_arg0:registerEventHandler("transition_complete_keyframe", f74_local0)
						end
					end

					if f73_arg1.interrupted then
						f73_local0(f73_arg0, f73_arg1)
						return 
					else
						f73_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
						f73_arg0:setScale(1)
						f73_arg0:registerEventHandler("transition_complete_keyframe", f73_local0)
					end
				end

				if f72_arg1.interrupted then
					f72_local0(f72_arg0, f72_arg1)
					return 
				else
					f72_arg0:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
					f72_arg0:setScale(0.8)
					f72_arg0:registerEventHandler("transition_complete_keyframe", f72_local0)
				end
			end

			if f71_arg1.interrupted then
				f71_local0(f71_arg0, f71_arg1)
				return 
			else
				f71_arg0:beginAnimation("keyframe", 189, false, false, CoD.TweenType.Linear)
				f71_arg0:setScale(1.2)
				f71_arg0:registerEventHandler("transition_complete_keyframe", f71_local0)
			end
		end

		f17_local0(f1_local8, {})
	end}}
	Widget:mergeStateConditions({{stateName = "ActiveLow", condition = function (HudRef, ItemRef, UpdateTable)
		local f18_local0 = IsModelValueGreaterThan(InstanceRef, "bgb_timer", 0)
		if f18_local0 then
			f18_local0 = IsModelValueLessThan(InstanceRef, "bgb_timer", 0.25)
		end
		return f18_local0
	end}, {stateName = "Active", condition = function (HudRef, ItemRef, UpdateTable)
		return IsModelValueGreaterThan(InstanceRef, "bgb_timer", 0)
	end}, {stateName = "Inactive", condition = function (HudRef, ItemRef, UpdateTable)
		return IsModelValueEqualTo(InstanceRef, "bgb_display", 1)
	end}, {stateName = "InstantActivate", condition = function (HudRef, ItemRef, UpdateTable)
		return AlwaysFalse()
	end}})
	Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "bgb_timer"), function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "bgb_timer"})
	end)
	Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "bgb_display"), function (ModelRef)
		HudRef:updateElementState(Widget, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "bgb_display"})
	end)
	Widget:subscribeToGlobalModel(InstanceRef, "PerController", "deadSpectator.playerIndex", function (ModelRef)
		if IsModelValueEqualTo(InstanceRef, "deadSpectator.playerIndex", -1) then
			SetElementStateWithNoTransitionClip(Widget, Widget, InstanceRef, "DefaultState")
			PlayClip(Widget, "DefaultClip", InstanceRef)
		end
	end)
	Widget:subscribeToGlobalModel(InstanceRef, "PerController", "bgb_one_shot_use", function (ModelRef)
		local f25_local0 = Widget
		if IsModelValueGreaterThan(InstanceRef, "bgb_timer", 0) then
			SetElementState(Widget, f25_local0, InstanceRef, "InstantActivate")
			SetElementState(Widget, f25_local0, InstanceRef, "Active")
		elseif IsModelValueEqualTo(InstanceRef, "bgb_display", 1) then
			SetElementState(Widget, f25_local0, InstanceRef, "InstantActivate")
			SetElementState(Widget, f25_local0, InstanceRef, "DefaultState")
		end
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.BBGumRing000:close()
		Sender.BBGumRing00:close()
		Sender.BBGumRing0:close()
		Sender.BBGumRing:close()
		Sender.BBGumRingEdge:close()
		Sender.BBGumTexture:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

