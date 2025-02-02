require("ui.uieditor.widgets.CPLevels.RamsesStation.WoundedSoldiers.woundedSoldier_Panel")
require("ui.uieditor.widgets.HUD.ZM_Notif.ZmNotif1_CursorHint")
require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZmNotif1Factory")
require("ui.uieditor.widgets.HUD.ZM_FX.ZmFx_Spark2")
require("ui.uieditor.widgets.HUD.ZM_AmmoWidgetFactory.ZmAmmo_ParticleFX")
require("ui.uieditor.widgets.ZMInventoryStalingrad.ZmNotif1_Notification_CursorHint")
require("ui.uieditor.widgets.ZMInventoryStalingrad.GameTimeWidget")
local f0_local0 = function (f1_arg0, f1_arg1)
	Engine.CreateModel(Engine.CreateModel(Engine.GetModelForController(f1_arg1), "hudItems.time"), "round_complete_time")
end

local f0_local1 = function (f2_arg0, f2_arg1)
	f2_arg0.notificationQueueEmptyModel = Engine.CreateModel(Engine.GetModelForController(f2_arg1), "NotificationQueueEmpty")
	f2_arg0.playNotification = function (f4_arg0, f4_arg1)
		f4_arg0.ZmNotif1CursorHint0.CursorHintText:setText(f4_arg1.description)
		f4_arg0.ZmNotifFactory.Label1:setText(f4_arg1.title)
		f4_arg0.ZmNotifFactory.Label2:setText(f4_arg1.title)
		if f4_arg1.clip == "TextandImageBGB" or f4_arg1.clip == "TextandImageBGBToken" or f4_arg1.clip == "TextandTimeAttack" then
			f4_arg0.bgbTexture:setImage(f4_arg1.bgbImage)
			local f4_local0 = f4_arg0.bgbTextureLabel
			local f4_local1 = f4_arg1.bgbImageText
			if not f4_local1 then
				f4_local1 = ""
			end
			f4_local0:setText(f4_local1)
			f4_local0 = f4_arg0.bgbTextureLabelBlur
			f4_local1 = f4_arg1.bgbImageText
			if not f4_local1 then
				f4_local1 = ""
			end
			f4_local0:setText(f4_local1)
			if f4_arg1.clip == "TextandTimeAttack" then
				f4_arg0.xpaward.Label1:setText(f4_arg1.xpAward)
				f4_arg0.xpaward.Label2:setText(f4_arg1.xpAward)
				f4_arg0.CursorHint.CursorHintText:setText(f4_arg1.rewardText)
			end
		end
		f4_arg0:playClip(f4_arg1.clip)
	end

	f2_arg0.appendNotification = function (f5_arg0, f5_arg1)
		if f5_arg0.notificationInProgress == true or Engine.GetModelValue(f5_arg0.notificationQueueEmptyModel) ~= true then
			local f5_local0 = f5_arg0.nextNotification
			if f5_local0 == nil then
				f5_arg0.nextNotification = LUI.ShallowCopy(f5_arg1)
			else
				while f5_local0 and f5_local0.next ~= nil do
					f5_local0 = f5_local0.next
				end
				f5_local0.next = LUI.ShallowCopy(f5_arg1)
			end
		else
			f5_arg0:playNotification(LUI.ShallowCopy(f5_arg1))
		end
	end

	f2_arg0.notificationInProgress = false
	f2_arg0.nextNotification = nil
	LUI.OverrideFunction_CallOriginalSecond(f2_arg0, "playClip", function (Sender)
		Sender.notificationInProgress = true
	end)
	f2_arg0:registerEventHandler("clip_over", function (Sender, Event)
		f2_arg0.notificationInProgress = false
		if f2_arg0.nextNotification ~= nil then
			f2_arg0:playNotification(f2_arg0.nextNotification)
			f2_arg0.nextNotification = f2_arg0.nextNotification.next
		end
	end)
	f2_arg0:subscribeToModel(f2_arg0.notificationQueueEmptyModel, function (ModelRef)
		if Engine.GetModelValue(ModelRef) == true then
			f2_arg0:processEvent({name = "clip_over"})
		end
	end)
	f2_arg0.Last5RoundTime.GameTimer:subscribeToModel(Engine.GetModel(Engine.CreateModel(Engine.GetModelForController(f2_arg1), "hudItems.time"), "round_complete_time"), function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f2_arg0.Last5RoundTime.GameTimer:setupServerTime(0 - ModelValue * 1000)
		end
	end)
end

CoD.ZmNotifBGB_ContainerFactory = InheritFrom(LUI.UIElement)
CoD.ZmNotifBGB_ContainerFactory.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if f0_local0 then
		f0_local0(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ZmNotifBGB_ContainerFactory)
	Widget.id = "ZmNotifBGB_ContainerFactory"
	Widget.soundSet = "HUD"
	Widget:setLeftRight(true, false, 0, 312)
	Widget:setTopBottom(true, false, 0, 32)
	Widget.anyChildUsesUpdateState = true

	local function InventoryControlVisibility(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                Widget:show()
            else
                Widget:hide()
            end
        end
    end
    Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), InventoryControlVisibility)

	local f3_local1 = CoD.woundedSoldier_Panel.new(HudRef, InstanceRef)
	f3_local1:setLeftRight(false, false, -156, 156)
	f3_local1:setTopBottom(true, false, 3.67, 254.33)
	f3_local1:setRGB(0.84, 0.78, 0.72)
	f3_local1:setAlpha(0)
	f3_local1:setRFTMaterial(LUI.UIImage.GetCachedMaterial("uie_scene_blur_pass_2"))
	f3_local1:setShaderVector(0, 30, 0, 0, 0)
	f3_local1.Image1:setShaderVector(0, 10, 10, 0, 0)
	Widget:addElement(f3_local1)
	Widget.Panel = f3_local1
	
	local f3_local2 = LUI.UIImage.new()
	f3_local2:setLeftRight(false, false, -124, 124)
	f3_local2:setTopBottom(true, false, 5, 253)
	f3_local2:setAlpha(0)
	f3_local2:setImage(RegisterImage("abbey_backdesign"))
	Widget:addElement(f3_local2)
	Widget.basicImageBacking = f3_local2
	
	local f3_local3 = LUI.UIImage.new()
	f3_local3:setLeftRight(true, false, 370, 498)
	f3_local3:setTopBottom(true, false, 92.5, 220.5)
	f3_local3:setAlpha(0)
	f3_local3:setImage(RegisterImage("uie_t7_icon_dlc3_time_attack"))
	Widget:addElement(f3_local3)
	Widget.TimeAttack = f3_local3
	
	local f3_local4 = LUI.UIImage.new()
	f3_local4:setLeftRight(false, false, -123, 125)
	f3_local4:setTopBottom(true, false, 13, 221)
	f3_local4:setAlpha(0)
	f3_local4:setImage(RegisterImage("abbey_notif"))
	Widget:addElement(f3_local4)
	Widget.basicImage = f3_local4
	
	local f3_local5 = LUI.UIImage.new()
	f3_local5:setLeftRight(false, false, -103.18, 103.34)
	f3_local5:setTopBottom(false, false, -183.84, 124.17)
	f3_local5:setRGB(0.4, 0.055, 0.078)
	f3_local5:setAlpha(0)
	f3_local5:setZRot(90)
	f3_local5:setImage(RegisterImage("uie_t7_core_hud_mapwidget_panelglow"))
	f3_local5:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f3_local5)
	Widget.bgbGlowOrangeOver = f3_local5
	
	local f3_local6 = LUI.UIImage.new()
	f3_local6:setLeftRight(false, false, -89.33, 90.67)
	f3_local6:setTopBottom(true, false, -3.5, 176.5)
	f3_local6:setAlpha(0)
	f3_local6:setScale(1.1)
	f3_local6:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgumtexture"))
	Widget:addElement(f3_local6)
	Widget.bgbTexture = f3_local6
	
	local f3_local7 = LUI.UIText.new()
	f3_local7:setLeftRight(false, false, -46.88, 40.22)
	f3_local7:setTopBottom(true, false, 63.5, 149.5)
	f3_local7:setRGB(0.24, 0.11, 0.01)
	f3_local7:setAlpha(0)
	f3_local7:setScale(0.7)
	f3_local7:setText(Engine.Localize("MP_X2"))
	f3_local7:setTTF("fonts/FoundryGridnik-Bold.ttf")
	f3_local7:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	f3_local7:setShaderVector(0, 0.11, 0, 0, 0)
	f3_local7:setShaderVector(1, 0.94, 0, 0, 0)
	f3_local7:setShaderVector(2, 0, 0, 0, 0)
	f3_local7:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	f3_local7:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f3_local7)
	Widget.bgbTextureLabelBlur = f3_local7
	
	local f3_local8 = LUI.UIText.new()
	f3_local8:setLeftRight(false, false, -46.88, 40.22)
	f3_local8:setTopBottom(true, false, 63.5, 149.5)
	f3_local8:setRGB( 0.851, 0.78, 0.263 )
	f3_local8:setAlpha(0)
	f3_local8:setScale(0.7)
	f3_local8:setText(Engine.Localize("MP_X2"))
	f3_local8:setTTF("fonts/FoundryGridnik-Bold.ttf")
	f3_local8:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	f3_local8:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f3_local8)
	Widget.bgbTextureLabel = f3_local8
	
	local f3_local9 = LUI.UIImage.new()
	f3_local9:setLeftRight(false, false, -63.43, 75.43)
	f3_local9:setTopBottom(true, false, 19.64, 156.5)
	f3_local9:setRGB(0.4, 0.055, 0.078)
	f3_local9:setAlpha(0)
	f3_local9:setImage(RegisterImage("uie_t7_core_hud_ammowidget_abilityswirl"))
	f3_local9:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f3_local9)
	Widget.bgbAbilitySwirl = f3_local9
	
	local f3_local10 = CoD.ZmNotif1_CursorHint.new(HudRef, InstanceRef)
	f3_local10:setLeftRight(false, false, -256, 256)
	f3_local10:setTopBottom(true, false, 197.5, 217.5)
	f3_local10:setAlpha(0)
	f3_local10:setScale(1.4)
	f3_local10.FEButtonPanel0:setAlpha(0.27)
	f3_local10.CursorHintText:setText(Engine.Localize("MENU_NEW"))
	Widget:addElement(f3_local10)
	Widget.ZmNotif1CursorHint0 = f3_local10
	
	local f3_local11 = CoD.ZmNotif1Factory.new(HudRef, InstanceRef)
	f3_local11:setLeftRight(false, false, -112, 112)
	f3_local11:setTopBottom(true, false, 138.5, 193.5)
	f3_local11:setAlpha(0)
	f3_local11.Label2:setText(Engine.Localize("MENU_NEW"))
    f3_local11.Label2:setRGB(0.4, 0.055, 0.078)
	f3_local11.Label1:setText(Engine.Localize("MENU_NEW"))
    f3_local11.Label1:setRGB(0.64, 0.03, 0.05)
	Widget:addElement(f3_local11)
	Widget.ZmNotifFactory = f3_local11
	
	local f3_local12 = LUI.UIImage.new()
	f3_local12:setLeftRight(false, false, -205, 205)
	f3_local12:setTopBottom(true, false, 18.5, 258.5)
	f3_local12:setAlpha(0)
	f3_local12:setImage(RegisterImage("uie_t7_zm_hud_notif_glowfilm"))
	f3_local12:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f3_local12)
	Widget.Glow = f3_local12
	
	local f3_local13 = CoD.ZmFx_Spark2.new(HudRef, InstanceRef)
	f3_local13:setLeftRight(false, false, -102, 101.34)
	f3_local13:setTopBottom(true, false, 73.5, 225.5)
	f3_local13:setRGB(0, 0, 0)
	f3_local13:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local13.Image0:setShaderVector(1, 0, 0.4, 0, 0)
	f3_local13.Image00:setShaderVector(1, 0, -0.2, 0, 0)
	Widget:addElement(f3_local13)
	Widget.ZmFxSpark20 = f3_local13
	
	local f3_local14 = LUI.UIImage.new()
	f3_local14:setLeftRight(false, false, -219.65, 219.34)
	f3_local14:setTopBottom(true, false, 146.25, 180.75)
	f3_local14:setRGB(0.73, 0.35, 0)
	f3_local14:setAlpha(0)
	f3_local14:setImage(RegisterImage("uie_t7_zm_hud_notif_txtstreak"))
	f3_local14:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f3_local14)
	Widget.Flsh = f3_local14
	
	local f3_local15 = CoD.ZmAmmo_ParticleFX.new(HudRef, InstanceRef)
	f3_local15:setLeftRight(true, false, -17.74, 125.74)
	f3_local15:setTopBottom(true, false, 132.89, 207.5)
	f3_local15:setAlpha(0)
	f3_local15:setXRot(1)
	f3_local15:setYRot(1)
	f3_local15:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local15.p2:setAlpha(0)
	f3_local15.p3:setAlpha(0)
	Widget:addElement(f3_local15)
	Widget.ZmAmmoParticleFX1left = f3_local15
	
	local f3_local16 = CoD.ZmAmmo_ParticleFX.new(HudRef, InstanceRef)
	f3_local16:setLeftRight(true, false, -17.74, 125.74)
	f3_local16:setTopBottom(true, false, 130.5, 205.11)
	f3_local16:setAlpha(0)
	f3_local16:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local16.p1:setAlpha(0)
	f3_local16.p3:setAlpha(0)
	Widget:addElement(f3_local16)
	Widget.ZmAmmoParticleFX2left = f3_local16
	
	local f3_local17 = CoD.ZmAmmo_ParticleFX.new(HudRef, InstanceRef)
	f3_local17:setLeftRight(true, false, -17.74, 125.74)
	f3_local17:setTopBottom(true, false, 131.5, 206.11)
	f3_local17:setAlpha(0)
	f3_local17:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local17.p1:setAlpha(0)
	f3_local17.p2:setAlpha(0)
	Widget:addElement(f3_local17)
	Widget.ZmAmmoParticleFX3left = f3_local17
	
	local f3_local18 = CoD.ZmAmmo_ParticleFX.new(HudRef, InstanceRef)
	f3_local18:setLeftRight(true, false, 204.52, 348)
	f3_local18:setTopBottom(true, false, 129, 203.6)
	f3_local18:setAlpha(0)
	f3_local18:setXRot(1)
	f3_local18:setYRot(1)
	f3_local18:setZRot(180)
	f3_local18:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local18.p2:setAlpha(0)
	f3_local18.p3:setAlpha(0)
	Widget:addElement(f3_local18)
	Widget.ZmAmmoParticleFX1right = f3_local18
	
	local f3_local19 = CoD.ZmAmmo_ParticleFX.new(HudRef, InstanceRef)
	f3_local19:setLeftRight(true, false, 204.52, 348)
	f3_local19:setTopBottom(true, false, 126.6, 201.21)
	f3_local19:setAlpha(0)
	f3_local19:setZRot(180)
	f3_local19:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local19.p1:setAlpha(0)
	f3_local19.p3:setAlpha(0)
	Widget:addElement(f3_local19)
	Widget.ZmAmmoParticleFX2right = f3_local19
	
	local f3_local20 = CoD.ZmAmmo_ParticleFX.new(HudRef, InstanceRef)
	f3_local20:setLeftRight(true, false, 204.52, 348)
	f3_local20:setTopBottom(true, false, 127.6, 202.21)
	f3_local20:setAlpha(0)
	f3_local20:setZRot(180)
	f3_local20:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	f3_local20.p1:setAlpha(0)
	f3_local20.p2:setAlpha(0)
	Widget:addElement(f3_local20)
	Widget.ZmAmmoParticleFX3right = f3_local20
	
	local f3_local21 = LUI.UIImage.new()
	f3_local21:setLeftRight(true, false, 102, 192)
	f3_local21:setTopBottom(true, false, 33.21, 201.21)
	f3_local21:setAlpha(0)
	f3_local21:setImage(RegisterImage("uie_t7_zm_derriese_hud_notification_anim"))
	f3_local21:setMaterial(LUI.UIImage.GetCachedMaterial("uie_flipbook"))
	f3_local21:setShaderVector(0, 28, 0, 0, 0)
	f3_local21:setShaderVector(1, 30, 0, 0, 0)
	Widget:addElement(f3_local21)
	Widget.Lightning = f3_local21
	
	local f3_local22 = LUI.UIImage.new()
	f3_local22:setLeftRight(true, false, 102, 192)
	f3_local22:setTopBottom(true, false, 33.21, 201.21)
	f3_local22:setAlpha(0)
	f3_local22:setImage(RegisterImage("uie_t7_zm_derriese_hud_notification_anim"))
	f3_local22:setMaterial(LUI.UIImage.GetCachedMaterial("uie_flipbook"))
	f3_local22:setShaderVector(0, 28, 0, 0, 0)
	f3_local22:setShaderVector(1, 30, 0, 0, 0)
	Widget:addElement(f3_local22)
	Widget.Lightning2 = f3_local22
	
	local f3_local23 = LUI.UIImage.new()
	f3_local23:setLeftRight(true, false, 102, 192)
	f3_local23:setTopBottom(true, false, 33.21, 201.21)
	f3_local23:setAlpha(0)
	f3_local23:setImage(RegisterImage("uie_t7_zm_derriese_hud_notification_anim"))
	f3_local23:setMaterial(LUI.UIImage.GetCachedMaterial("uie_flipbook"))
	f3_local23:setShaderVector(0, 28, 0, 0, 0)
	f3_local23:setShaderVector(1, 30, 0, 0, 0)
	Widget:addElement(f3_local23)
	Widget.Lightning3 = f3_local23
	
	local f3_local24 = LUI.UIText.new()
	f3_local24:setLeftRight(false, false, -46.88, 40.22)
	f3_local24:setTopBottom(true, false, 63.5, 149.5)
	f3_local24:setRGB(0.24, 0.11, 0.01)
	f3_local24:setAlpha(0)
	f3_local24:setScale(0.7)
	f3_local24:setText(Engine.Localize("MP_X2"))
	f3_local24:setTTF("fonts/FoundryGridnik-Bold.ttf")
	f3_local24:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	f3_local24:setShaderVector(0, 0.11, 0, 0, 0)
	f3_local24:setShaderVector(1, 0.94, 0, 0, 0)
	f3_local24:setShaderVector(2, 0, 0, 0, 0)
	f3_local24:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	f3_local24:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f3_local24)
	Widget.bgbTextureLabelBlur0 = f3_local24
	
	local f3_local25 = LUI.UIText.new()
	f3_local25:setLeftRight(false, false, -46.88, 40.22)
	f3_local25:setTopBottom(true, false, 63.5, 149.5)
	f3_local25:setRGB( 0.851, 0.78, 0.263 )
	f3_local25:setAlpha(0)
	f3_local25:setScale(0.7)
	f3_local25:setText(Engine.Localize("MP_X2"))
	f3_local25:setTTF("fonts/FoundryGridnik-Bold.ttf")
	f3_local25:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	f3_local25:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget:addElement(f3_local25)
	Widget.bgbTextureLabel0 = f3_local25
	
	local f3_local26 = CoD.ZmNotif1Factory.new(HudRef, InstanceRef)
	f3_local26:setLeftRight(false, false, -112, 112)
	f3_local26:setTopBottom(true, false, 328.5, 383.5)
	f3_local26:setAlpha(0)
	f3_local26.Label2:setText(Engine.Localize("GROUPS_SEARCH_SIZE_RANGE_4"))
	f3_local26.Label1:setText(Engine.Localize("GROUPS_SEARCH_SIZE_RANGE_4"))
	Widget:addElement(f3_local26)
	Widget.xpaward = f3_local26
	
	local f3_local27 = CoD.ZmNotif1_Notification_CursorHint.new(HudRef, InstanceRef)
	f3_local27:setLeftRight(true, false, -99, 413)
	f3_local27:setTopBottom(true, false, 340, 372)
	f3_local27:setAlpha(0)
	f3_local27.CursorHintText:setText("")
	Widget:addElement(f3_local27)
	Widget.CursorHint = f3_local27
	
	local f3_local28 = CoD.GameTimeWidget.new(HudRef, InstanceRef)
	f3_local28:setLeftRight(true, false, 752, 880)
	f3_local28:setTopBottom(true, false, 0, 96)
	f3_local28:setAlpha(0)
	f3_local28.TimeElasped:setText(Engine.Localize("DLC3_TIME_CURRENT"))
	f3_local28:mergeStateConditions({{stateName = "Visible", condition = function (HudRef, ItemRef, UpdateTable)
		local f10_local0 = IsZombies()
		if f10_local0 then
			f10_local0 = not IsModelValueEqualTo(InstanceRef, "hudItems.time.round_complete_time", 0)
		end
		return f10_local0
	end}})
	f3_local28:subscribeToModel(Engine.GetModel(Engine.GetGlobalModel(), "lobbyRoot.lobbyNav"), function (ModelRef)
		HudRef:updateElementState(f3_local28, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "lobbyRoot.lobbyNav"})
	end)
	f3_local28:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "hudItems.time.round_complete_time"), function (ModelRef)
		HudRef:updateElementState(f3_local28, {name = "model_validation", menu = HudRef, modelValue = Engine.GetModelValue(ModelRef), modelName = "hudItems.time.round_complete_time"})
	end)
	Widget:addElement(f3_local28)
	Widget.Last5RoundTime = f3_local28
	
	Widget.clipsPerState = {DefaultState = {DefaultClip = function ()
		Widget:setupElementClipCounter(13)
		f3_local1:completeAnimation()
		Widget.Panel:setAlpha(0)
		Widget.clipFinished(f3_local1, {})
		f3_local2:beginAnimation("keyframe", 4369, false, false, CoD.TweenType.Linear)
		f3_local2:setAlpha(0)
		f3_local2:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local4:beginAnimation("keyframe", 4369, false, false, CoD.TweenType.Linear)
		f3_local4:setAlpha(0)
		f3_local4:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local5:completeAnimation()
		Widget.bgbGlowOrangeOver:setAlpha(0)
		Widget.clipFinished(f3_local5, {})
		f3_local6:completeAnimation()
		Widget.bgbTexture:setAlpha(0)
		Widget.clipFinished(f3_local6, {})
		f3_local9:completeAnimation()
		Widget.bgbAbilitySwirl:setAlpha(0)
		Widget.clipFinished(f3_local9, {})
		f3_local10:completeAnimation()
		Widget.ZmNotif1CursorHint0:setAlpha(0)
		Widget.clipFinished(f3_local10, {})
		f3_local11:completeAnimation()
		Widget.ZmNotifFactory:setAlpha(0)
		Widget.clipFinished(f3_local11, {})
		f3_local12:completeAnimation()
		Widget.Glow:setAlpha(0)
		Widget.clipFinished(f3_local12, {})
		f3_local13:completeAnimation()
		Widget.ZmFxSpark20:setRGB(0, 0, 0)
		Widget.ZmFxSpark20:setAlpha(1)
		Widget.clipFinished(f3_local13, {})
		f3_local14:completeAnimation()
		Widget.Flsh:setRGB(0.62, 0.22, 0)
		Widget.Flsh:setAlpha(0)
		Widget.clipFinished(f3_local14, {})
		f3_local27:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
		f3_local27:setAlpha(0)
		f3_local27:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local28:beginAnimation("keyframe", 6780, false, false, CoD.TweenType.Linear)
		f3_local28:setAlpha(0)
		f3_local28:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
	end, TextandImageBGB = function ()
		Widget:setupElementClipCounter(22)
		f3_local1:completeAnimation()
		Widget.Panel:setAlpha(0)
		local f14_local0 = function (f19_arg0, f19_arg1)
			local f19_local0 = function (f34_arg0, f34_arg1)
				local f34_local0 = function (f35_arg0, f35_arg1)
					if not f35_arg1.interrupted then
						f35_arg0:beginAnimation("keyframe", 680, false, false, CoD.TweenType.Linear)
					end
					f35_arg0:setAlpha(0)
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
					f34_arg0:beginAnimation("keyframe", 2850, false, false, CoD.TweenType.Linear)
					f34_arg0:registerEventHandler("transition_complete_keyframe", f34_local0)
				end
			end

			if f19_arg1.interrupted then
				f19_local0(f19_arg0, f19_arg1)
				return 
			else
				f19_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
				f19_arg0:setAlpha(1)
				f19_arg0:registerEventHandler("transition_complete_keyframe", f19_local0)
			end
		end

		f14_local0(f3_local1, {})
		f3_local2:completeAnimation()
		Widget.basicImageBacking:setAlpha(0)
		Widget.clipFinished(f3_local2, {})
		f3_local4:completeAnimation()
		Widget.basicImage:setAlpha(0)
		Widget.clipFinished(f3_local4, {})
		f3_local5:completeAnimation()
		Widget.bgbGlowOrangeOver:setAlpha(0)
		local f14_local1 = function (f20_arg0, f20_arg1)
			local f20_local0 = function (f36_arg0, f36_arg1)
				local f36_local0 = function (f37_arg0, f37_arg1)
					local f37_local0 = function (f38_arg0, f38_arg1)
						local f38_local0 = function (f39_arg0, f39_arg1)
							local f39_local0 = function (f40_arg0, f40_arg1)
								local f40_local0 = function (f41_arg0, f41_arg1)
									local f41_local0 = function (f42_arg0, f42_arg1)
										local f42_local0 = function (f43_arg0, f43_arg1)
											local f43_local0 = function (f44_arg0, f44_arg1)
												local f44_local0 = function (f45_arg0, f45_arg1)
													local f45_local0 = function (f46_arg0, f46_arg1)
														local f46_local0 = function (f47_arg0, f47_arg1)
															if not f47_arg1.interrupted then
																f47_arg0:beginAnimation("keyframe", 720, true, false, CoD.TweenType.Bounce)
															end
															f47_arg0:setAlpha(0)
															if f47_arg1.interrupted then
																Widget.clipFinished(f47_arg0, f47_arg1)
															else
																f47_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
															end
														end

														if f46_arg1.interrupted then
															f46_local0(f46_arg0, f46_arg1)
															return 
														else
															f46_arg0:beginAnimation("keyframe", 109, false, false, CoD.TweenType.Linear)
															f46_arg0:setAlpha(0.75)
															f46_arg0:registerEventHandler("transition_complete_keyframe", f46_local0)
														end
													end

													if f45_arg1.interrupted then
														f45_local0(f45_arg0, f45_arg1)
														return 
													else
														f45_arg0:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
														f45_arg0:setAlpha(1)
														f45_arg0:registerEventHandler("transition_complete_keyframe", f45_local0)
													end
												end

												if f44_arg1.interrupted then
													f44_local0(f44_arg0, f44_arg1)
													return 
												else
													f44_arg0:beginAnimation("keyframe", 539, false, false, CoD.TweenType.Linear)
													f44_arg0:setAlpha(0.8)
													f44_arg0:registerEventHandler("transition_complete_keyframe", f44_local0)
												end
											end

											if f43_arg1.interrupted then
												f43_local0(f43_arg0, f43_arg1)
												return 
											else
												f43_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
												f43_arg0:setAlpha(0.36)
												f43_arg0:registerEventHandler("transition_complete_keyframe", f43_local0)
											end
										end

										if f42_arg1.interrupted then
											f42_local0(f42_arg0, f42_arg1)
											return 
										else
											f42_arg0:beginAnimation("keyframe", 519, false, false, CoD.TweenType.Linear)
											f42_arg0:setAlpha(0.8)
											f42_arg0:registerEventHandler("transition_complete_keyframe", f42_local0)
										end
									end

									if f41_arg1.interrupted then
										f41_local0(f41_arg0, f41_arg1)
										return 
									else
										f41_arg0:beginAnimation("keyframe", 579, false, false, CoD.TweenType.Linear)
										f41_arg0:setAlpha(0.36)
										f41_arg0:registerEventHandler("transition_complete_keyframe", f41_local0)
									end
								end

								if f40_arg1.interrupted then
									f40_local0(f40_arg0, f40_arg1)
									return 
								else
									f40_arg0:beginAnimation("keyframe", 480, false, false, CoD.TweenType.Linear)
									f40_arg0:setAlpha(0.8)
									f40_arg0:registerEventHandler("transition_complete_keyframe", f40_local0)
								end
							end

							if f39_arg1.interrupted then
								f39_local0(f39_arg0, f39_arg1)
								return 
							else
								f39_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
								f39_arg0:setAlpha(0.33)
								f39_arg0:registerEventHandler("transition_complete_keyframe", f39_local0)
							end
						end

						if f38_arg1.interrupted then
							f38_local0(f38_arg0, f38_arg1)
							return 
						else
							f38_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
							f38_arg0:setAlpha(0.75)
							f38_arg0:registerEventHandler("transition_complete_keyframe", f38_local0)
						end
					end

					if f37_arg1.interrupted then
						f37_local0(f37_arg0, f37_arg1)
						return 
					else
						f37_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
						f37_arg0:setAlpha(1)
						f37_arg0:registerEventHandler("transition_complete_keyframe", f37_local0)
					end
				end

				if f36_arg1.interrupted then
					f36_local0(f36_arg0, f36_arg1)
					return 
				else
					f36_arg0:beginAnimation("keyframe", 159, true, false, CoD.TweenType.Bounce)
					f36_arg0:setAlpha(0.75)
					f36_arg0:registerEventHandler("transition_complete_keyframe", f36_local0)
				end
			end

			if f20_arg1.interrupted then
				f20_local0(f20_arg0, f20_arg1)
				return 
			else
				f20_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f20_arg0:registerEventHandler("transition_complete_keyframe", f20_local0)
			end
		end

		f14_local1(f3_local5, {})
		f3_local6:completeAnimation()
		Widget.bgbTexture:setAlpha(0)
		Widget.bgbTexture:setScale(0.5)
		local f14_local2 = function (f21_arg0, f21_arg1)
			local f21_local0 = function (f48_arg0, f48_arg1)
				local f48_local0 = function (f49_arg0, f49_arg1)
					local f49_local0 = function (f50_arg0, f50_arg1)
						local f50_local0 = function (f51_arg0, f51_arg1)
							local f51_local0 = function (f52_arg0, f52_arg1)
								local f52_local0 = function (f53_arg0, f53_arg1)
									local f53_local0 = function (f54_arg0, f54_arg1)
										if not f54_arg1.interrupted then
											f54_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
										end
										f54_arg0:setAlpha(0)
										f54_arg0:setScale(0.5)
										if f54_arg1.interrupted then
											Widget.clipFinished(f54_arg0, f54_arg1)
										else
											f54_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
										end
									end

									if f53_arg1.interrupted then
										f53_local0(f53_arg0, f53_arg1)
										return 
									else
										f53_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
										f53_arg0:setAlpha(0)
										f53_arg0:setScale(0.57)
										f53_arg0:registerEventHandler("transition_complete_keyframe", f53_local0)
									end
								end

								if f52_arg1.interrupted then
									f52_local0(f52_arg0, f52_arg1)
									return 
								else
									f52_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
									f52_arg0:setAlpha(0.77)
									f52_arg0:setScale(1.2)
									f52_arg0:registerEventHandler("transition_complete_keyframe", f52_local0)
								end
							end

							if f51_arg1.interrupted then
								f51_local0(f51_arg0, f51_arg1)
								return 
							else
								f51_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
								f51_arg0:setScale(0.82)
								f51_arg0:registerEventHandler("transition_complete_keyframe", f51_local0)
							end
						end

						if f50_arg1.interrupted then
							f50_local0(f50_arg0, f50_arg1)
							return 
						else
							f50_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
							f50_arg0:registerEventHandler("transition_complete_keyframe", f50_local0)
						end
					end

					if f49_arg1.interrupted then
						f49_local0(f49_arg0, f49_arg1)
						return 
					else
						f49_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
						f49_arg0:setScale(0.7)
						f49_arg0:registerEventHandler("transition_complete_keyframe", f49_local0)
					end
				end

				if f48_arg1.interrupted then
					f48_local0(f48_arg0, f48_arg1)
					return 
				else
					f48_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
					f48_arg0:setAlpha(1)
					f48_arg0:setScale(1.2)
					f48_arg0:registerEventHandler("transition_complete_keyframe", f48_local0)
				end
			end

			if f21_arg1.interrupted then
				f21_local0(f21_arg0, f21_arg1)
				return 
			else
				f21_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f21_arg0:registerEventHandler("transition_complete_keyframe", f21_local0)
			end
		end

		f14_local2(f3_local6, {})
		f3_local9:completeAnimation()
		Widget.bgbAbilitySwirl:setAlpha(0)
		Widget.bgbAbilitySwirl:setZRot(0)
		Widget.bgbAbilitySwirl:setScale(1)
		local f14_local3 = function (f22_arg0, f22_arg1)
			local f22_local0 = function (f55_arg0, f55_arg1)
				if not f55_arg1.interrupted then
					f55_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
				end
				f55_arg0:setAlpha(0)
				f55_arg0:setZRot(360)
				f55_arg0:setScale(1.7)
				if f55_arg1.interrupted then
					Widget.clipFinished(f55_arg0, f55_arg1)
				else
					f55_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f22_arg1.interrupted then
				f22_local0(f22_arg0, f22_arg1)
				return 
			else
				f22_arg0:beginAnimation("keyframe", 280, false, false, CoD.TweenType.Linear)
				f22_arg0:setAlpha(0.8)
				f22_arg0:setZRot(240)
				f22_arg0:setScale(1.7)
				f22_arg0:registerEventHandler("transition_complete_keyframe", f22_local0)
			end
		end

		f14_local3(f3_local9, {})
		f3_local10:completeAnimation()
		Widget.ZmNotif1CursorHint0:setAlpha(0)
		local f14_local4 = function (f23_arg0, f23_arg1)
			local f23_local0 = function (f56_arg0, f56_arg1)
				local f56_local0 = function (f57_arg0, f57_arg1)
					local f57_local0 = function (f58_arg0, f58_arg1)
						if not f58_arg1.interrupted then
							f58_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
						end
						f58_arg0:setAlpha(0)
						if f58_arg1.interrupted then
							Widget.clipFinished(f58_arg0, f58_arg1)
						else
							f58_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f57_arg1.interrupted then
						f57_local0(f57_arg0, f57_arg1)
						return 
					else
						f57_arg0:beginAnimation("keyframe", 2849, false, false, CoD.TweenType.Linear)
						f57_arg0:registerEventHandler("transition_complete_keyframe", f57_local0)
					end
				end

				if f56_arg1.interrupted then
					f56_local0(f56_arg0, f56_arg1)
					return 
				else
					f56_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
					f56_arg0:setAlpha(1)
					f56_arg0:registerEventHandler("transition_complete_keyframe", f56_local0)
				end
			end

			if f23_arg1.interrupted then
				f23_local0(f23_arg0, f23_arg1)
				return 
			else
				f23_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
				f23_arg0:registerEventHandler("transition_complete_keyframe", f23_local0)
			end
		end

		f14_local4(f3_local10, {})
		f3_local11:completeAnimation()
		Widget.ZmNotifFactory:setAlpha(0)
		local f14_local5 = function (f24_arg0, f24_arg1)
			local f24_local0 = function (f59_arg0, f59_arg1)
				local f59_local0 = function (f60_arg0, f60_arg1)
					if not f60_arg1.interrupted then
						f60_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
					end
					f60_arg0:setAlpha(0)
					if f60_arg1.interrupted then
						Widget.clipFinished(f60_arg0, f60_arg1)
					else
						f60_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f59_arg1.interrupted then
					f59_local0(f59_arg0, f59_arg1)
					return 
				else
					f59_arg0:beginAnimation("keyframe", 3240, false, false, CoD.TweenType.Linear)
					f59_arg0:registerEventHandler("transition_complete_keyframe", f59_local0)
				end
			end

			if f24_arg1.interrupted then
				f24_local0(f24_arg0, f24_arg1)
				return 
			else
				f24_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
				f24_arg0:setAlpha(1)
				f24_arg0:registerEventHandler("transition_complete_keyframe", f24_local0)
			end
		end

		f14_local5(f3_local11, {})
		f3_local12:completeAnimation()
		Widget.Glow:setRGB(0.4, 0.055, 0.078)
		Widget.Glow:setAlpha(0)
		local f14_local6 = function (f25_arg0, f25_arg1)
			local f25_local0 = function (f61_arg0, f61_arg1)
				local f61_local0 = function (f62_arg0, f62_arg1)
					if not f62_arg1.interrupted then
						f62_arg0:beginAnimation("keyframe", 800, false, false, CoD.TweenType.Linear)
					end
					f62_arg0:setRGB(0.4, 0.055, 0.078)
					f62_arg0:setAlpha(0)
					if f62_arg1.interrupted then
						Widget.clipFinished(f62_arg0, f62_arg1)
					else
						f62_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f61_arg1.interrupted then
					f61_local0(f61_arg0, f61_arg1)
					return 
				else
					f61_arg0:beginAnimation("keyframe", 3359, false, false, CoD.TweenType.Linear)
					f61_arg0:registerEventHandler("transition_complete_keyframe", f61_local0)
				end
			end

			if f25_arg1.interrupted then
				f25_local0(f25_arg0, f25_arg1)
				return 
			else
				f25_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
				f25_arg0:setAlpha(1)
				f25_arg0:registerEventHandler("transition_complete_keyframe", f25_local0)
			end
		end

		f14_local6(f3_local12, {})
		f3_local13:completeAnimation()
		Widget.ZmFxSpark20:setAlpha(0)
		Widget.clipFinished(f3_local13, {})
		f3_local14:completeAnimation()
		Widget.Flsh:setLeftRight(false, false, -219.65, 219.34)
		Widget.Flsh:setTopBottom(true, false, 146.25, 180.75)
		Widget.Flsh:setRGB(0.4, 0.055, 0.078)
		Widget.Flsh:setAlpha(0.36)
		local f14_local7 = function (f26_arg0, f26_arg1)
			local f26_local0 = function (f63_arg0, f63_arg1)
				if not f63_arg1.interrupted then
					f63_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
				end
				f63_arg0:setLeftRight(false, false, -219.65, 219.34)
				f63_arg0:setTopBottom(true, false, 146.25, 180.75)
				f63_arg0:setRGB(0.4, 0.055, 0.078)
				f63_arg0:setAlpha(0)
				if f63_arg1.interrupted then
					Widget.clipFinished(f63_arg0, f63_arg1)
				else
					f63_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f26_arg1.interrupted then
				f26_local0(f26_arg0, f26_arg1)
				return 
			else
				f26_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
				f26_arg0:setRGB(0.4, 0.055, 0.078)
				f26_arg0:setAlpha(1)
				f26_arg0:registerEventHandler("transition_complete_keyframe", f26_local0)
			end
		end

		f14_local7(f3_local14, {})
		f3_local15:completeAnimation()
		Widget.ZmAmmoParticleFX1left:setAlpha(0)
		local f14_local8 = function (f27_arg0, f27_arg1)
			local f27_local0 = function (f64_arg0, f64_arg1)
				local f64_local0 = function (f65_arg0, f65_arg1)
					if not f65_arg1.interrupted then
						f65_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f65_arg0:setAlpha(0)
					if f65_arg1.interrupted then
						Widget.clipFinished(f65_arg0, f65_arg1)
					else
						f65_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f64_arg1.interrupted then
					f64_local0(f64_arg0, f64_arg1)
					return 
				else
					f64_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f64_arg0:registerEventHandler("transition_complete_keyframe", f64_local0)
				end
			end

			if f27_arg1.interrupted then
				f27_local0(f27_arg0, f27_arg1)
				return 
			else
				f27_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f27_arg0:setAlpha(1)
				f27_arg0:registerEventHandler("transition_complete_keyframe", f27_local0)
			end
		end

		f14_local8(f3_local15, {})
		f3_local16:completeAnimation()
		Widget.ZmAmmoParticleFX2left:setAlpha(0)
		local f14_local9 = function (f28_arg0, f28_arg1)
			local f28_local0 = function (f66_arg0, f66_arg1)
				local f66_local0 = function (f67_arg0, f67_arg1)
					if not f67_arg1.interrupted then
						f67_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f67_arg0:setAlpha(0)
					if f67_arg1.interrupted then
						Widget.clipFinished(f67_arg0, f67_arg1)
					else
						f67_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f66_arg1.interrupted then
					f66_local0(f66_arg0, f66_arg1)
					return 
				else
					f66_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f66_arg0:registerEventHandler("transition_complete_keyframe", f66_local0)
				end
			end

			if f28_arg1.interrupted then
				f28_local0(f28_arg0, f28_arg1)
				return 
			else
				f28_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f28_arg0:setAlpha(1)
				f28_arg0:registerEventHandler("transition_complete_keyframe", f28_local0)
			end
		end

		f14_local9(f3_local16, {})
		f3_local17:completeAnimation()
		Widget.ZmAmmoParticleFX3left:setAlpha(0)
		local f14_local10 = function (f29_arg0, f29_arg1)
			local f29_local0 = function (f68_arg0, f68_arg1)
				local f68_local0 = function (f69_arg0, f69_arg1)
					if not f69_arg1.interrupted then
						f69_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f69_arg0:setAlpha(0)
					if f69_arg1.interrupted then
						Widget.clipFinished(f69_arg0, f69_arg1)
					else
						f69_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f68_arg1.interrupted then
					f68_local0(f68_arg0, f68_arg1)
					return 
				else
					f68_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f68_arg0:registerEventHandler("transition_complete_keyframe", f68_local0)
				end
			end

			if f29_arg1.interrupted then
				f29_local0(f29_arg0, f29_arg1)
				return 
			else
				f29_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f29_arg0:setAlpha(1)
				f29_arg0:registerEventHandler("transition_complete_keyframe", f29_local0)
			end
		end

		f14_local10(f3_local17, {})
		f3_local18:completeAnimation()
		Widget.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
		Widget.ZmAmmoParticleFX1right:setAlpha(0)
		Widget.ZmAmmoParticleFX1right:setZRot(180)
		local f14_local11 = function (f30_arg0, f30_arg1)
			local f30_local0 = function (f70_arg0, f70_arg1)
				local f70_local0 = function (f71_arg0, f71_arg1)
					if not f71_arg1.interrupted then
						f71_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f71_arg0:setLeftRight(true, false, 204.52, 348)
					f71_arg0:setTopBottom(true, false, 129, 203.6)
					f71_arg0:setAlpha(0)
					f71_arg0:setZRot(180)
					if f71_arg1.interrupted then
						Widget.clipFinished(f71_arg0, f71_arg1)
					else
						f71_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f70_arg1.interrupted then
					f70_local0(f70_arg0, f70_arg1)
					return 
				else
					f70_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f70_arg0:registerEventHandler("transition_complete_keyframe", f70_local0)
				end
			end

			if f30_arg1.interrupted then
				f30_local0(f30_arg0, f30_arg1)
				return 
			else
				f30_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f30_arg0:setAlpha(1)
				f30_arg0:registerEventHandler("transition_complete_keyframe", f30_local0)
			end
		end

		f14_local11(f3_local18, {})
		f3_local19:completeAnimation()
		Widget.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
		Widget.ZmAmmoParticleFX2right:setAlpha(0)
		Widget.ZmAmmoParticleFX2right:setZRot(180)
		local f14_local12 = function (f31_arg0, f31_arg1)
			local f31_local0 = function (f72_arg0, f72_arg1)
				local f72_local0 = function (f73_arg0, f73_arg1)
					if not f73_arg1.interrupted then
						f73_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f73_arg0:setLeftRight(true, false, 204.52, 348)
					f73_arg0:setTopBottom(true, false, 126.6, 201.21)
					f73_arg0:setAlpha(0)
					f73_arg0:setZRot(180)
					if f73_arg1.interrupted then
						Widget.clipFinished(f73_arg0, f73_arg1)
					else
						f73_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f72_arg1.interrupted then
					f72_local0(f72_arg0, f72_arg1)
					return 
				else
					f72_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f72_arg0:registerEventHandler("transition_complete_keyframe", f72_local0)
				end
			end

			if f31_arg1.interrupted then
				f31_local0(f31_arg0, f31_arg1)
				return 
			else
				f31_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f31_arg0:setAlpha(1)
				f31_arg0:registerEventHandler("transition_complete_keyframe", f31_local0)
			end
		end

		f14_local12(f3_local19, {})
		f3_local20:completeAnimation()
		Widget.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
		Widget.ZmAmmoParticleFX3right:setAlpha(1)
		Widget.ZmAmmoParticleFX3right:setZRot(180)
		local f14_local13 = function (f32_arg0, f32_arg1)
			local f32_local0 = function (f74_arg0, f74_arg1)
				local f74_local0 = function (f75_arg0, f75_arg1)
					if not f75_arg1.interrupted then
						f75_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f75_arg0:setLeftRight(true, false, 204.52, 348)
					f75_arg0:setTopBottom(true, false, 127.6, 202.21)
					f75_arg0:setAlpha(0)
					f75_arg0:setZRot(180)
					if f75_arg1.interrupted then
						Widget.clipFinished(f75_arg0, f75_arg1)
					else
						f75_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f74_arg1.interrupted then
					f74_local0(f74_arg0, f74_arg1)
					return 
				else
					f74_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f74_arg0:setAlpha(0)
					f74_arg0:registerEventHandler("transition_complete_keyframe", f74_local0)
				end
			end

			if f32_arg1.interrupted then
				f32_local0(f32_arg0, f32_arg1)
				return 
			else
				f32_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f32_arg0:registerEventHandler("transition_complete_keyframe", f32_local0)
			end
		end

		f14_local13(f3_local20, {})
		f3_local21:completeAnimation()
		Widget.Lightning:setLeftRight(true, false, 38.67, 280)
		Widget.Lightning:setTopBottom(true, false, -22.5, 193.5)
		Widget.Lightning:setAlpha(0)
		local f14_local14 = function (f33_arg0, f33_arg1)
			local f33_local0 = function (f76_arg0, f76_arg1)
				local f76_local0 = function (f77_arg0, f77_arg1)
					local f77_local0 = function (f78_arg0, f78_arg1)
						if not f78_arg1.interrupted then
							f78_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
						end
						f78_arg0:setLeftRight(true, false, 38.67, 280)
						f78_arg0:setTopBottom(true, false, -22.5, 193.5)
						f78_arg0:setAlpha(0)
						if f78_arg1.interrupted then
							Widget.clipFinished(f78_arg0, f78_arg1)
						else
							f78_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f77_arg1.interrupted then
						f77_local0(f77_arg0, f77_arg1)
						return 
					else
						f77_arg0:beginAnimation("keyframe", 150, false, false, CoD.TweenType.Linear)
						f77_arg0:registerEventHandler("transition_complete_keyframe", f77_local0)
					end
				end

				if f76_arg1.interrupted then
					f76_local0(f76_arg0, f76_arg1)
					return 
				else
					f76_arg0:beginAnimation("keyframe", 109, false, false, CoD.TweenType.Linear)
					f76_arg0:setAlpha(1)
					f76_arg0:registerEventHandler("transition_complete_keyframe", f76_local0)
				end
			end

			if f33_arg1.interrupted then
				f33_local0(f33_arg0, f33_arg1)
				return 
			else
				f33_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f33_arg0:registerEventHandler("transition_complete_keyframe", f33_local0)
			end
		end

		f14_local14(f3_local21, {})
		f3_local22:completeAnimation()
		Widget.Lightning2:setAlpha(0)
		Widget.clipFinished(f3_local22, {})
		f3_local23:completeAnimation()
		Widget.Lightning3:setAlpha(0)
		Widget.clipFinished(f3_local23, {})
		f3_local27:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
		f3_local27:setAlpha(0)
		f3_local27:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local28:completeAnimation()
		Widget.Last5RoundTime:setAlpha(0)
		Widget.clipFinished(f3_local28, {})
	end, TextandImageBGBToken = function ()
		Widget:setupElementClipCounter(24)
		f3_local1:completeAnimation()
		Widget.Panel:setAlpha(0)
		local f15_local0 = function (f79_arg0, f79_arg1)
			local f79_local0 = function (f96_arg0, f96_arg1)
				local f96_local0 = function (f97_arg0, f97_arg1)
					if not f97_arg1.interrupted then
						f97_arg0:beginAnimation("keyframe", 680, false, false, CoD.TweenType.Linear)
					end
					f97_arg0:setAlpha(0)
					if f97_arg1.interrupted then
						Widget.clipFinished(f97_arg0, f97_arg1)
					else
						f97_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f96_arg1.interrupted then
					f96_local0(f96_arg0, f96_arg1)
					return 
				else
					f96_arg0:beginAnimation("keyframe", 2850, false, false, CoD.TweenType.Linear)
					f96_arg0:registerEventHandler("transition_complete_keyframe", f96_local0)
				end
			end

			if f79_arg1.interrupted then
				f79_local0(f79_arg0, f79_arg1)
				return 
			else
				f79_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
				f79_arg0:setAlpha(1)
				f79_arg0:registerEventHandler("transition_complete_keyframe", f79_local0)
			end
		end

		f15_local0(f3_local1, {})
		f3_local2:completeAnimation()
		Widget.basicImageBacking:setAlpha(0)
		Widget.clipFinished(f3_local2, {})
		f3_local4:completeAnimation()
		Widget.basicImage:setAlpha(0)
		Widget.clipFinished(f3_local4, {})
		f3_local5:completeAnimation()
		Widget.bgbGlowOrangeOver:setAlpha(0)
		local f15_local1 = function (f80_arg0, f80_arg1)
			local f80_local0 = function (f98_arg0, f98_arg1)
				local f98_local0 = function (f99_arg0, f99_arg1)
					local f99_local0 = function (f100_arg0, f100_arg1)
						local f100_local0 = function (f101_arg0, f101_arg1)
							local f101_local0 = function (f102_arg0, f102_arg1)
								local f102_local0 = function (f103_arg0, f103_arg1)
									local f103_local0 = function (f104_arg0, f104_arg1)
										local f104_local0 = function (f105_arg0, f105_arg1)
											local f105_local0 = function (f106_arg0, f106_arg1)
												local f106_local0 = function (f107_arg0, f107_arg1)
													local f107_local0 = function (f108_arg0, f108_arg1)
														local f108_local0 = function (f109_arg0, f109_arg1)
															if not f109_arg1.interrupted then
																f109_arg0:beginAnimation("keyframe", 720, true, false, CoD.TweenType.Bounce)
															end
															f109_arg0:setAlpha(0)
															if f109_arg1.interrupted then
																Widget.clipFinished(f109_arg0, f109_arg1)
															else
																f109_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
															end
														end

														if f108_arg1.interrupted then
															f108_local0(f108_arg0, f108_arg1)
															return 
														else
															f108_arg0:beginAnimation("keyframe", 109, false, false, CoD.TweenType.Linear)
															f108_arg0:setAlpha(0.75)
															f108_arg0:registerEventHandler("transition_complete_keyframe", f108_local0)
														end
													end

													if f107_arg1.interrupted then
														f107_local0(f107_arg0, f107_arg1)
														return 
													else
														f107_arg0:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
														f107_arg0:setAlpha(1)
														f107_arg0:registerEventHandler("transition_complete_keyframe", f107_local0)
													end
												end

												if f106_arg1.interrupted then
													f106_local0(f106_arg0, f106_arg1)
													return 
												else
													f106_arg0:beginAnimation("keyframe", 539, false, false, CoD.TweenType.Linear)
													f106_arg0:setAlpha(0.8)
													f106_arg0:registerEventHandler("transition_complete_keyframe", f106_local0)
												end
											end

											if f105_arg1.interrupted then
												f105_local0(f105_arg0, f105_arg1)
												return 
											else
												f105_arg0:beginAnimation("keyframe", 500, false, false, CoD.TweenType.Linear)
												f105_arg0:setAlpha(0.36)
												f105_arg0:registerEventHandler("transition_complete_keyframe", f105_local0)
											end
										end

										if f104_arg1.interrupted then
											f104_local0(f104_arg0, f104_arg1)
											return 
										else
											f104_arg0:beginAnimation("keyframe", 519, false, false, CoD.TweenType.Linear)
											f104_arg0:setAlpha(0.8)
											f104_arg0:registerEventHandler("transition_complete_keyframe", f104_local0)
										end
									end

									if f103_arg1.interrupted then
										f103_local0(f103_arg0, f103_arg1)
										return 
									else
										f103_arg0:beginAnimation("keyframe", 579, false, false, CoD.TweenType.Linear)
										f103_arg0:setAlpha(0.36)
										f103_arg0:registerEventHandler("transition_complete_keyframe", f103_local0)
									end
								end

								if f102_arg1.interrupted then
									f102_local0(f102_arg0, f102_arg1)
									return 
								else
									f102_arg0:beginAnimation("keyframe", 480, false, false, CoD.TweenType.Linear)
									f102_arg0:setAlpha(0.8)
									f102_arg0:registerEventHandler("transition_complete_keyframe", f102_local0)
								end
							end

							if f101_arg1.interrupted then
								f101_local0(f101_arg0, f101_arg1)
								return 
							else
								f101_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
								f101_arg0:setAlpha(0.33)
								f101_arg0:registerEventHandler("transition_complete_keyframe", f101_local0)
							end
						end

						if f100_arg1.interrupted then
							f100_local0(f100_arg0, f100_arg1)
							return 
						else
							f100_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
							f100_arg0:setAlpha(0.75)
							f100_arg0:registerEventHandler("transition_complete_keyframe", f100_local0)
						end
					end

					if f99_arg1.interrupted then
						f99_local0(f99_arg0, f99_arg1)
						return 
					else
						f99_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
						f99_arg0:setAlpha(1)
						f99_arg0:registerEventHandler("transition_complete_keyframe", f99_local0)
					end
				end

				if f98_arg1.interrupted then
					f98_local0(f98_arg0, f98_arg1)
					return 
				else
					f98_arg0:beginAnimation("keyframe", 159, true, false, CoD.TweenType.Bounce)
					f98_arg0:setAlpha(0.75)
					f98_arg0:registerEventHandler("transition_complete_keyframe", f98_local0)
				end
			end

			if f80_arg1.interrupted then
				f80_local0(f80_arg0, f80_arg1)
				return 
			else
				f80_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f80_arg0:registerEventHandler("transition_complete_keyframe", f80_local0)
			end
		end

		f15_local1(f3_local5, {})
		f3_local6:completeAnimation()
		Widget.bgbTexture:setAlpha(0)
		Widget.bgbTexture:setScale(0.5)
		local f15_local2 = function (f81_arg0, f81_arg1)
			local f81_local0 = function (f110_arg0, f110_arg1)
				local f110_local0 = function (f111_arg0, f111_arg1)
					local f111_local0 = function (f112_arg0, f112_arg1)
						local f112_local0 = function (f113_arg0, f113_arg1)
							local f113_local0 = function (f114_arg0, f114_arg1)
								local f114_local0 = function (f115_arg0, f115_arg1)
									local f115_local0 = function (f116_arg0, f116_arg1)
										if not f116_arg1.interrupted then
											f116_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
										end
										f116_arg0:setAlpha(0)
										f116_arg0:setScale(0.5)
										if f116_arg1.interrupted then
											Widget.clipFinished(f116_arg0, f116_arg1)
										else
											f116_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
										end
									end

									if f115_arg1.interrupted then
										f115_local0(f115_arg0, f115_arg1)
										return 
									else
										f115_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
										f115_arg0:setAlpha(0)
										f115_arg0:setScale(0.57)
										f115_arg0:registerEventHandler("transition_complete_keyframe", f115_local0)
									end
								end

								if f114_arg1.interrupted then
									f114_local0(f114_arg0, f114_arg1)
									return 
								else
									f114_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
									f114_arg0:setAlpha(0.77)
									f114_arg0:setScale(1.2)
									f114_arg0:registerEventHandler("transition_complete_keyframe", f114_local0)
								end
							end

							if f113_arg1.interrupted then
								f113_local0(f113_arg0, f113_arg1)
								return 
							else
								f113_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
								f113_arg0:setScale(0.82)
								f113_arg0:registerEventHandler("transition_complete_keyframe", f113_local0)
							end
						end

						if f112_arg1.interrupted then
							f112_local0(f112_arg0, f112_arg1)
							return 
						else
							f112_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
							f112_arg0:registerEventHandler("transition_complete_keyframe", f112_local0)
						end
					end

					if f111_arg1.interrupted then
						f111_local0(f111_arg0, f111_arg1)
						return 
					else
						f111_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
						f111_arg0:setScale(0.7)
						f111_arg0:registerEventHandler("transition_complete_keyframe", f111_local0)
					end
				end

				if f110_arg1.interrupted then
					f110_local0(f110_arg0, f110_arg1)
					return 
				else
					f110_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
					f110_arg0:setAlpha(1)
					f110_arg0:setScale(1.2)
					f110_arg0:registerEventHandler("transition_complete_keyframe", f110_local0)
				end
			end

			if f81_arg1.interrupted then
				f81_local0(f81_arg0, f81_arg1)
				return 
			else
				f81_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f81_arg0:registerEventHandler("transition_complete_keyframe", f81_local0)
			end
		end

		f15_local2(f3_local6, {})
		f3_local7:completeAnimation()
		Widget.bgbTextureLabelBlur:setAlpha(0)
		Widget.bgbTextureLabelBlur:setScale(0.5)
		local f15_local3 = function (f82_arg0, f82_arg1)
			local f82_local0 = function (f117_arg0, f117_arg1)
				local f117_local0 = function (f118_arg0, f118_arg1)
					local f118_local0 = function (f119_arg0, f119_arg1)
						local f119_local0 = function (f120_arg0, f120_arg1)
							local f120_local0 = function (f121_arg0, f121_arg1)
								local f121_local0 = function (f122_arg0, f122_arg1)
									local f122_local0 = function (f123_arg0, f123_arg1)
										if not f123_arg1.interrupted then
											f123_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
										end
										f123_arg0:setAlpha(0)
										f123_arg0:setScale(0.5)
										if f123_arg1.interrupted then
											Widget.clipFinished(f123_arg0, f123_arg1)
										else
											f123_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
										end
									end

									if f122_arg1.interrupted then
										f122_local0(f122_arg0, f122_arg1)
										return 
									else
										f122_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
										f122_arg0:setAlpha(0)
										f122_arg0:setScale(0.57)
										f122_arg0:registerEventHandler("transition_complete_keyframe", f122_local0)
									end
								end

								if f121_arg1.interrupted then
									f121_local0(f121_arg0, f121_arg1)
									return 
								else
									f121_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
									f121_arg0:setAlpha(0.77)
									f121_arg0:setScale(1.2)
									f121_arg0:registerEventHandler("transition_complete_keyframe", f121_local0)
								end
							end

							if f120_arg1.interrupted then
								f120_local0(f120_arg0, f120_arg1)
								return 
							else
								f120_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
								f120_arg0:setScale(0.82)
								f120_arg0:registerEventHandler("transition_complete_keyframe", f120_local0)
							end
						end

						if f119_arg1.interrupted then
							f119_local0(f119_arg0, f119_arg1)
							return 
						else
							f119_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
							f119_arg0:registerEventHandler("transition_complete_keyframe", f119_local0)
						end
					end

					if f118_arg1.interrupted then
						f118_local0(f118_arg0, f118_arg1)
						return 
					else
						f118_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
						f118_arg0:setScale(0.7)
						f118_arg0:registerEventHandler("transition_complete_keyframe", f118_local0)
					end
				end

				if f117_arg1.interrupted then
					f117_local0(f117_arg0, f117_arg1)
					return 
				else
					f117_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
					f117_arg0:setAlpha(1)
					f117_arg0:setScale(1.2)
					f117_arg0:registerEventHandler("transition_complete_keyframe", f117_local0)
				end
			end

			if f82_arg1.interrupted then
				f82_local0(f82_arg0, f82_arg1)
				return 
			else
				f82_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f82_arg0:registerEventHandler("transition_complete_keyframe", f82_local0)
			end
		end

		f15_local3(f3_local7, {})
		f3_local8:completeAnimation()
		Widget.bgbTextureLabel:setAlpha(0)
		Widget.bgbTextureLabel:setScale(0.5)
		local f15_local4 = function (f83_arg0, f83_arg1)
			local f83_local0 = function (f124_arg0, f124_arg1)
				local f124_local0 = function (f125_arg0, f125_arg1)
					local f125_local0 = function (f126_arg0, f126_arg1)
						local f126_local0 = function (f127_arg0, f127_arg1)
							local f127_local0 = function (f128_arg0, f128_arg1)
								local f128_local0 = function (f129_arg0, f129_arg1)
									local f129_local0 = function (f130_arg0, f130_arg1)
										if not f130_arg1.interrupted then
											f130_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
										end
										f130_arg0:setAlpha(0)
										f130_arg0:setScale(0.5)
										if f130_arg1.interrupted then
											Widget.clipFinished(f130_arg0, f130_arg1)
										else
											f130_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
										end
									end

									if f129_arg1.interrupted then
										f129_local0(f129_arg0, f129_arg1)
										return 
									else
										f129_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
										f129_arg0:setAlpha(0)
										f129_arg0:setScale(0.57)
										f129_arg0:registerEventHandler("transition_complete_keyframe", f129_local0)
									end
								end

								if f128_arg1.interrupted then
									f128_local0(f128_arg0, f128_arg1)
									return 
								else
									f128_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
									f128_arg0:setAlpha(0.77)
									f128_arg0:setScale(1.2)
									f128_arg0:registerEventHandler("transition_complete_keyframe", f128_local0)
								end
							end

							if f127_arg1.interrupted then
								f127_local0(f127_arg0, f127_arg1)
								return 
							else
								f127_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
								f127_arg0:setScale(0.82)
								f127_arg0:registerEventHandler("transition_complete_keyframe", f127_local0)
							end
						end

						if f126_arg1.interrupted then
							f126_local0(f126_arg0, f126_arg1)
							return 
						else
							f126_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
							f126_arg0:registerEventHandler("transition_complete_keyframe", f126_local0)
						end
					end

					if f125_arg1.interrupted then
						f125_local0(f125_arg0, f125_arg1)
						return 
					else
						f125_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
						f125_arg0:setScale(0.7)
						f125_arg0:registerEventHandler("transition_complete_keyframe", f125_local0)
					end
				end

				if f124_arg1.interrupted then
					f124_local0(f124_arg0, f124_arg1)
					return 
				else
					f124_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
					f124_arg0:setAlpha(1)
					f124_arg0:setScale(1.2)
					f124_arg0:registerEventHandler("transition_complete_keyframe", f124_local0)
				end
			end

			if f83_arg1.interrupted then
				f83_local0(f83_arg0, f83_arg1)
				return 
			else
				f83_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f83_arg0:registerEventHandler("transition_complete_keyframe", f83_local0)
			end
		end

		f15_local4(f3_local8, {})
		f3_local9:completeAnimation()
		Widget.bgbAbilitySwirl:setAlpha(0)
		Widget.bgbAbilitySwirl:setZRot(0)
		Widget.bgbAbilitySwirl:setScale(1)
		local f15_local5 = function (f84_arg0, f84_arg1)
			local f84_local0 = function (f131_arg0, f131_arg1)
				if not f131_arg1.interrupted then
					f131_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
				end
				f131_arg0:setAlpha(0)
				f131_arg0:setZRot(360)
				f131_arg0:setScale(1.7)
				if f131_arg1.interrupted then
					Widget.clipFinished(f131_arg0, f131_arg1)
				else
					f131_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f84_arg1.interrupted then
				f84_local0(f84_arg0, f84_arg1)
				return 
			else
				f84_arg0:beginAnimation("keyframe", 280, false, false, CoD.TweenType.Linear)
				f84_arg0:setAlpha(0.8)
				f84_arg0:setZRot(240)
				f84_arg0:setScale(1.7)
				f84_arg0:registerEventHandler("transition_complete_keyframe", f84_local0)
			end
		end

		f15_local5(f3_local9, {})
		f3_local10:completeAnimation()
		Widget.ZmNotif1CursorHint0:setAlpha(0)
		local f15_local6 = function (f85_arg0, f85_arg1)
			local f85_local0 = function (f132_arg0, f132_arg1)
				local f132_local0 = function (f133_arg0, f133_arg1)
					local f133_local0 = function (f134_arg0, f134_arg1)
						if not f134_arg1.interrupted then
							f134_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
						end
						f134_arg0:setAlpha(0)
						if f134_arg1.interrupted then
							Widget.clipFinished(f134_arg0, f134_arg1)
						else
							f134_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f133_arg1.interrupted then
						f133_local0(f133_arg0, f133_arg1)
						return 
					else
						f133_arg0:beginAnimation("keyframe", 2849, false, false, CoD.TweenType.Linear)
						f133_arg0:registerEventHandler("transition_complete_keyframe", f133_local0)
					end
				end

				if f132_arg1.interrupted then
					f132_local0(f132_arg0, f132_arg1)
					return 
				else
					f132_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
					f132_arg0:setAlpha(1)
					f132_arg0:registerEventHandler("transition_complete_keyframe", f132_local0)
				end
			end

			if f85_arg1.interrupted then
				f85_local0(f85_arg0, f85_arg1)
				return 
			else
				f85_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
				f85_arg0:registerEventHandler("transition_complete_keyframe", f85_local0)
			end
		end

		f15_local6(f3_local10, {})
		f3_local11:completeAnimation()
		Widget.ZmNotifFactory:setAlpha(0)
		local f15_local7 = function (f86_arg0, f86_arg1)
			local f86_local0 = function (f135_arg0, f135_arg1)
				local f135_local0 = function (f136_arg0, f136_arg1)
					if not f136_arg1.interrupted then
						f136_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
					end
					f136_arg0:setAlpha(0)
					if f136_arg1.interrupted then
						Widget.clipFinished(f136_arg0, f136_arg1)
					else
						f136_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f135_arg1.interrupted then
					f135_local0(f135_arg0, f135_arg1)
					return 
				else
					f135_arg0:beginAnimation("keyframe", 3240, false, false, CoD.TweenType.Linear)
					f135_arg0:registerEventHandler("transition_complete_keyframe", f135_local0)
				end
			end

			if f86_arg1.interrupted then
				f86_local0(f86_arg0, f86_arg1)
				return 
			else
				f86_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
				f86_arg0:setAlpha(1)
				f86_arg0:registerEventHandler("transition_complete_keyframe", f86_local0)
			end
		end

		f15_local7(f3_local11, {})
		f3_local12:completeAnimation()
		Widget.Glow:setRGB(0.4, 0.055, 0.078)
		Widget.Glow:setAlpha(0)
		local f15_local8 = function (f87_arg0, f87_arg1)
			local f87_local0 = function (f137_arg0, f137_arg1)
				local f137_local0 = function (f138_arg0, f138_arg1)
					if not f138_arg1.interrupted then
						f138_arg0:beginAnimation("keyframe", 800, false, false, CoD.TweenType.Linear)
					end
					f138_arg0:setRGB(0.4, 0.055, 0.078)
					f138_arg0:setAlpha(0)
					if f138_arg1.interrupted then
						Widget.clipFinished(f138_arg0, f138_arg1)
					else
						f138_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f137_arg1.interrupted then
					f137_local0(f137_arg0, f137_arg1)
					return 
				else
					f137_arg0:beginAnimation("keyframe", 3359, false, false, CoD.TweenType.Linear)
					f137_arg0:registerEventHandler("transition_complete_keyframe", f137_local0)
				end
			end

			if f87_arg1.interrupted then
				f87_local0(f87_arg0, f87_arg1)
				return 
			else
				f87_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
				f87_arg0:setAlpha(1)
				f87_arg0:registerEventHandler("transition_complete_keyframe", f87_local0)
			end
		end

		f15_local8(f3_local12, {})
		f3_local13:completeAnimation()
		Widget.ZmFxSpark20:setAlpha(0)
		Widget.clipFinished(f3_local13, {})
		f3_local14:completeAnimation()
		Widget.Flsh:setLeftRight(false, false, -219.65, 219.34)
		Widget.Flsh:setTopBottom(true, false, 146.25, 180.75)
		Widget.Flsh:setRGB(0.4, 0.055, 0.078)
		Widget.Flsh:setAlpha(0.36)
		local f15_local9 = function (f88_arg0, f88_arg1)
			local f88_local0 = function (f139_arg0, f139_arg1)
				if not f139_arg1.interrupted then
					f139_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
				end
				f139_arg0:setLeftRight(false, false, -219.65, 219.34)
				f139_arg0:setTopBottom(true, false, 146.25, 180.75)
				f139_arg0:setRGB(0.4, 0.055, 0.078)
				f139_arg0:setAlpha(0)
				if f139_arg1.interrupted then
					Widget.clipFinished(f139_arg0, f139_arg1)
				else
					f139_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f88_arg1.interrupted then
				f88_local0(f88_arg0, f88_arg1)
				return 
			else
				f88_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
				f88_arg0:setRGB(0.4, 0.055, 0.078)
				f88_arg0:setAlpha(1)
				f88_arg0:registerEventHandler("transition_complete_keyframe", f88_local0)
			end
		end

		f15_local9(f3_local14, {})
		f3_local15:completeAnimation()
		Widget.ZmAmmoParticleFX1left:setAlpha(0)
		local f15_local10 = function (f89_arg0, f89_arg1)
			local f89_local0 = function (f140_arg0, f140_arg1)
				local f140_local0 = function (f141_arg0, f141_arg1)
					if not f141_arg1.interrupted then
						f141_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f141_arg0:setAlpha(0)
					if f141_arg1.interrupted then
						Widget.clipFinished(f141_arg0, f141_arg1)
					else
						f141_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f140_arg1.interrupted then
					f140_local0(f140_arg0, f140_arg1)
					return 
				else
					f140_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f140_arg0:registerEventHandler("transition_complete_keyframe", f140_local0)
				end
			end

			if f89_arg1.interrupted then
				f89_local0(f89_arg0, f89_arg1)
				return 
			else
				f89_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f89_arg0:setAlpha(1)
				f89_arg0:registerEventHandler("transition_complete_keyframe", f89_local0)
			end
		end

		f15_local10(f3_local15, {})
		f3_local16:completeAnimation()
		Widget.ZmAmmoParticleFX2left:setAlpha(0)
		local f15_local11 = function (f90_arg0, f90_arg1)
			local f90_local0 = function (f142_arg0, f142_arg1)
				local f142_local0 = function (f143_arg0, f143_arg1)
					if not f143_arg1.interrupted then
						f143_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f143_arg0:setAlpha(0)
					if f143_arg1.interrupted then
						Widget.clipFinished(f143_arg0, f143_arg1)
					else
						f143_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f142_arg1.interrupted then
					f142_local0(f142_arg0, f142_arg1)
					return 
				else
					f142_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f142_arg0:registerEventHandler("transition_complete_keyframe", f142_local0)
				end
			end

			if f90_arg1.interrupted then
				f90_local0(f90_arg0, f90_arg1)
				return 
			else
				f90_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f90_arg0:setAlpha(1)
				f90_arg0:registerEventHandler("transition_complete_keyframe", f90_local0)
			end
		end

		f15_local11(f3_local16, {})
		f3_local17:completeAnimation()
		Widget.ZmAmmoParticleFX3left:setAlpha(0)
		local f15_local12 = function (f91_arg0, f91_arg1)
			local f91_local0 = function (f144_arg0, f144_arg1)
				local f144_local0 = function (f145_arg0, f145_arg1)
					if not f145_arg1.interrupted then
						f145_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f145_arg0:setAlpha(0)
					if f145_arg1.interrupted then
						Widget.clipFinished(f145_arg0, f145_arg1)
					else
						f145_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f144_arg1.interrupted then
					f144_local0(f144_arg0, f144_arg1)
					return 
				else
					f144_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f144_arg0:registerEventHandler("transition_complete_keyframe", f144_local0)
				end
			end

			if f91_arg1.interrupted then
				f91_local0(f91_arg0, f91_arg1)
				return 
			else
				f91_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f91_arg0:setAlpha(1)
				f91_arg0:registerEventHandler("transition_complete_keyframe", f91_local0)
			end
		end

		f15_local12(f3_local17, {})
		f3_local18:completeAnimation()
		Widget.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
		Widget.ZmAmmoParticleFX1right:setAlpha(0)
		Widget.ZmAmmoParticleFX1right:setZRot(180)
		local f15_local13 = function (f92_arg0, f92_arg1)
			local f92_local0 = function (f146_arg0, f146_arg1)
				local f146_local0 = function (f147_arg0, f147_arg1)
					if not f147_arg1.interrupted then
						f147_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f147_arg0:setLeftRight(true, false, 204.52, 348)
					f147_arg0:setTopBottom(true, false, 129, 203.6)
					f147_arg0:setAlpha(0)
					f147_arg0:setZRot(180)
					if f147_arg1.interrupted then
						Widget.clipFinished(f147_arg0, f147_arg1)
					else
						f147_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f146_arg1.interrupted then
					f146_local0(f146_arg0, f146_arg1)
					return 
				else
					f146_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f146_arg0:registerEventHandler("transition_complete_keyframe", f146_local0)
				end
			end

			if f92_arg1.interrupted then
				f92_local0(f92_arg0, f92_arg1)
				return 
			else
				f92_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f92_arg0:setAlpha(1)
				f92_arg0:registerEventHandler("transition_complete_keyframe", f92_local0)
			end
		end

		f15_local13(f3_local18, {})
		f3_local19:completeAnimation()
		Widget.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
		Widget.ZmAmmoParticleFX2right:setAlpha(0)
		Widget.ZmAmmoParticleFX2right:setZRot(180)
		local f15_local14 = function (f93_arg0, f93_arg1)
			local f93_local0 = function (f148_arg0, f148_arg1)
				local f148_local0 = function (f149_arg0, f149_arg1)
					if not f149_arg1.interrupted then
						f149_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f149_arg0:setLeftRight(true, false, 204.52, 348)
					f149_arg0:setTopBottom(true, false, 126.6, 201.21)
					f149_arg0:setAlpha(0)
					f149_arg0:setZRot(180)
					if f149_arg1.interrupted then
						Widget.clipFinished(f149_arg0, f149_arg1)
					else
						f149_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f148_arg1.interrupted then
					f148_local0(f148_arg0, f148_arg1)
					return 
				else
					f148_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f148_arg0:registerEventHandler("transition_complete_keyframe", f148_local0)
				end
			end

			if f93_arg1.interrupted then
				f93_local0(f93_arg0, f93_arg1)
				return 
			else
				f93_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f93_arg0:setAlpha(1)
				f93_arg0:registerEventHandler("transition_complete_keyframe", f93_local0)
			end
		end

		f15_local14(f3_local19, {})
		f3_local20:completeAnimation()
		Widget.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
		Widget.ZmAmmoParticleFX3right:setAlpha(0)
		Widget.ZmAmmoParticleFX3right:setZRot(180)
		local f15_local15 = function (f94_arg0, f94_arg1)
			local f94_local0 = function (f150_arg0, f150_arg1)
				local f150_local0 = function (f151_arg0, f151_arg1)
					if not f151_arg1.interrupted then
						f151_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
					end
					f151_arg0:setLeftRight(true, false, 204.52, 348)
					f151_arg0:setTopBottom(true, false, 127.6, 202.21)
					f151_arg0:setAlpha(0)
					f151_arg0:setZRot(180)
					if f151_arg1.interrupted then
						Widget.clipFinished(f151_arg0, f151_arg1)
					else
						f151_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f150_arg1.interrupted then
					f150_local0(f150_arg0, f150_arg1)
					return 
				else
					f150_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
					f150_arg0:setAlpha(0)
					f150_arg0:registerEventHandler("transition_complete_keyframe", f150_local0)
				end
			end

			if f94_arg1.interrupted then
				f94_local0(f94_arg0, f94_arg1)
				return 
			else
				f94_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
				f94_arg0:setAlpha(1)
				f94_arg0:registerEventHandler("transition_complete_keyframe", f94_local0)
			end
		end

		f15_local15(f3_local20, {})
		f3_local21:completeAnimation()
		Widget.Lightning:setLeftRight(true, false, 38.67, 280)
		Widget.Lightning:setTopBottom(true, false, -22.5, 193.5)
		Widget.Lightning:setAlpha(0)
		local f15_local16 = function (f95_arg0, f95_arg1)
			local f95_local0 = function (f152_arg0, f152_arg1)
				local f152_local0 = function (f153_arg0, f153_arg1)
					if not f153_arg1.interrupted then
						f153_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
					end
					f153_arg0:setLeftRight(true, false, 38.67, 280)
					f153_arg0:setTopBottom(true, false, -22.5, 193.5)
					f153_arg0:setAlpha(0)
					if f153_arg1.interrupted then
						Widget.clipFinished(f153_arg0, f153_arg1)
					else
						f153_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f152_arg1.interrupted then
					f152_local0(f152_arg0, f152_arg1)
					return 
				else
					f152_arg0:beginAnimation("keyframe", 260, false, false, CoD.TweenType.Linear)
					f152_arg0:setAlpha(1)
					f152_arg0:registerEventHandler("transition_complete_keyframe", f152_local0)
				end
			end

			if f95_arg1.interrupted then
				f95_local0(f95_arg0, f95_arg1)
				return 
			else
				f95_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f95_arg0:registerEventHandler("transition_complete_keyframe", f95_local0)
			end
		end

		f15_local16(f3_local21, {})
		f3_local22:completeAnimation()
		Widget.Lightning2:setAlpha(0)
		Widget.clipFinished(f3_local22, {})
		f3_local23:completeAnimation()
		Widget.Lightning3:setAlpha(0)
		Widget.clipFinished(f3_local23, {})
		f3_local27:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
		f3_local27:setAlpha(0)
		f3_local27:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local28:completeAnimation()
		Widget.Last5RoundTime:setAlpha(0)
		Widget.clipFinished(f3_local28, {})
	end, TextandImageBasic = function ()
		Widget:setupElementClipCounter(23)
		f3_local1:completeAnimation()
		Widget.Panel:setRGB(0.4, 0.055, 0.078)
		Widget.Panel:setAlpha(0)
		local f16_local0 = function (f154_arg0, f154_arg1)
			local f154_local0 = function (f170_arg0, f170_arg1)
				local f170_local0 = function (f171_arg0, f171_arg1)
					local f171_local0 = function (f172_arg0, f172_arg1)
						if not f172_arg1.interrupted then
							f172_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
						end
						f172_arg0:setRGB(0.4, 0.055, 0.078)
						f172_arg0:setAlpha(0)
						if f172_arg1.interrupted then
							Widget.clipFinished(f172_arg0, f172_arg1)
						else
							f172_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f171_arg1.interrupted then
						f171_local0(f171_arg0, f171_arg1)
						return 
					else
						f171_arg0:beginAnimation("keyframe", 1850, false, false, CoD.TweenType.Linear)
						f171_arg0:registerEventHandler("transition_complete_keyframe", f171_local0)
					end
				end

				if f170_arg1.interrupted then
					f170_local0(f170_arg0, f170_arg1)
					return 
				else
					f170_arg0:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
					f170_arg0:setAlpha(1)
					f170_arg0:registerEventHandler("transition_complete_keyframe", f170_local0)
				end
			end

			if f154_arg1.interrupted then
				f154_local0(f154_arg0, f154_arg1)
				return 
			else
				f154_arg0:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
				f154_arg0:setAlpha(0.8)
				f154_arg0:registerEventHandler("transition_complete_keyframe", f154_local0)
			end
		end

		f16_local0(f3_local1, {})
		f3_local2:completeAnimation()
		Widget.basicImageBacking:setAlpha(0)
		Widget.basicImageBacking:setZRot(-10)
		local f16_local1 = function (f155_arg0, f155_arg1)
			local f155_local0 = function (f173_arg0, f173_arg1)
				local f173_local0 = function (f174_arg0, f174_arg1)
					local f174_local0 = function (f175_arg0, f175_arg1)
						if not f175_arg1.interrupted then
							f175_arg0:beginAnimation("keyframe", 600, false, false, CoD.TweenType.Linear)
						end
						f175_arg0:setAlpha(0)
						f175_arg0:setZRot(10)
						if f175_arg1.interrupted then
							Widget.clipFinished(f175_arg0, f175_arg1)
						else
							f175_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f174_arg1.interrupted then
						f174_local0(f174_arg0, f174_arg1)
						return 
					else
						f174_arg0:beginAnimation("keyframe", 1879, false, false, CoD.TweenType.Linear)
						f174_arg0:setZRot(5.7)
						f174_arg0:registerEventHandler("transition_complete_keyframe", f174_local0)
					end
				end

				if f173_arg1.interrupted then
					f173_local0(f173_arg0, f173_arg1)
					return 
				else
					f173_arg0:beginAnimation("keyframe", 310, false, false, CoD.TweenType.Linear)
					f173_arg0:setAlpha(1)
					f173_arg0:setZRot(-7.78)
					f173_arg0:registerEventHandler("transition_complete_keyframe", f173_local0)
				end
			end

			if f155_arg1.interrupted then
				f155_local0(f155_arg0, f155_arg1)
				return 
			else
				f155_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f155_arg0:registerEventHandler("transition_complete_keyframe", f155_local0)
			end
		end

		f16_local1(f3_local2, {})
		f3_local3:beginAnimation("keyframe", 540, false, false, CoD.TweenType.Linear)
		f3_local3:setAlpha(0)
		f3_local3:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local4:completeAnimation()
		Widget.basicImage:setAlpha(0)
		local f16_local2 = function (f156_arg0, f156_arg1)
			local f156_local0 = function (f176_arg0, f176_arg1)
				local f176_local0 = function (f177_arg0, f177_arg1)
					local f177_local0 = function (f178_arg0, f178_arg1)
						if not f178_arg1.interrupted then
							f178_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
						end
						f178_arg0:setAlpha(0)
						if f178_arg1.interrupted then
							Widget.clipFinished(f178_arg0, f178_arg1)
						else
							f178_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f177_arg1.interrupted then
						f177_local0(f177_arg0, f177_arg1)
						return 
					else
						f177_arg0:beginAnimation("keyframe", 1970, false, false, CoD.TweenType.Linear)
						f177_arg0:registerEventHandler("transition_complete_keyframe", f177_local0)
					end
				end

				if f176_arg1.interrupted then
					f176_local0(f176_arg0, f176_arg1)
					return 
				else
					f176_arg0:beginAnimation("keyframe", 290, false, false, CoD.TweenType.Linear)
					f176_arg0:setAlpha(1)
					f176_arg0:registerEventHandler("transition_complete_keyframe", f176_local0)
				end
			end

			if f156_arg1.interrupted then
				f156_local0(f156_arg0, f156_arg1)
				return 
			else
				f156_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Linear)
				f156_arg0:registerEventHandler("transition_complete_keyframe", f156_local0)
			end
		end

		f16_local2(f3_local4, {})
		f3_local5:completeAnimation()
		Widget.bgbGlowOrangeOver:setAlpha(0)
		Widget.clipFinished(f3_local5, {})
		f3_local6:completeAnimation()
		Widget.bgbTexture:setAlpha(0)
		Widget.clipFinished(f3_local6, {})
		f3_local9:completeAnimation()
		Widget.bgbAbilitySwirl:setAlpha(0)
		Widget.bgbAbilitySwirl:setZRot(0)
		Widget.bgbAbilitySwirl:setScale(1)
		Widget.clipFinished(f3_local9, {})
		f3_local10:completeAnimation()
		Widget.ZmNotif1CursorHint0:setAlpha(0)
		local f16_local3 = function (f157_arg0, f157_arg1)
			local f157_local0 = function (f179_arg0, f179_arg1)
				local f179_local0 = function (f180_arg0, f180_arg1)
					local f180_local0 = function (f181_arg0, f181_arg1)
						if not f181_arg1.interrupted then
							f181_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
						end
						f181_arg0:setAlpha(0)
						if f181_arg1.interrupted then
							Widget.clipFinished(f181_arg0, f181_arg1)
						else
							f181_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f180_arg1.interrupted then
						f180_local0(f180_arg0, f180_arg1)
						return 
					else
						f180_arg0:beginAnimation("keyframe", 1849, false, false, CoD.TweenType.Linear)
						f180_arg0:registerEventHandler("transition_complete_keyframe", f180_local0)
					end
				end

				if f179_arg1.interrupted then
					f179_local0(f179_arg0, f179_arg1)
					return 
				else
					f179_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
					f179_arg0:setAlpha(1)
					f179_arg0:registerEventHandler("transition_complete_keyframe", f179_local0)
				end
			end

			if f157_arg1.interrupted then
				f157_local0(f157_arg0, f157_arg1)
				return 
			else
				f157_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
				f157_arg0:registerEventHandler("transition_complete_keyframe", f157_local0)
			end
		end

		f16_local3(f3_local10, {})
		f3_local11:completeAnimation()
		Widget.ZmNotifFactory:setRGB(1, 1, 1)
		Widget.ZmNotifFactory:setAlpha(0)
		local f16_local4 = function (f158_arg0, f158_arg1)
			local f158_local0 = function (f182_arg0, f182_arg1)
				local f182_local0 = function (f183_arg0, f183_arg1)
					if not f183_arg1.interrupted then
						f183_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
					end
					f183_arg0:setRGB(1, 1, 1)
					f183_arg0:setAlpha(0)
					if f183_arg1.interrupted then
						Widget.clipFinished(f183_arg0, f183_arg1)
					else
						f183_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f182_arg1.interrupted then
					f182_local0(f182_arg0, f182_arg1)
					return 
				else
					f182_arg0:beginAnimation("keyframe", 2240, false, false, CoD.TweenType.Linear)
					f182_arg0:registerEventHandler("transition_complete_keyframe", f182_local0)
				end
			end

			if f158_arg1.interrupted then
				f158_local0(f158_arg0, f158_arg1)
				return 
			else
				f158_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
				f158_arg0:setAlpha(1)
				f158_arg0:registerEventHandler("transition_complete_keyframe", f158_local0)
			end
		end

		f16_local4(f3_local11, {})
		f3_local12:completeAnimation()
		Widget.Glow:setRGB(0.4, 0.055, 0.078)
		Widget.Glow:setAlpha(0)
		local f16_local5 = function (f159_arg0, f159_arg1)
			local f159_local0 = function (f184_arg0, f184_arg1)
				local f184_local0 = function (f185_arg0, f185_arg1)
					local f185_local0 = function (f186_arg0, f186_arg1)
						if not f186_arg1.interrupted then
							f186_arg0:beginAnimation("keyframe", 799, false, false, CoD.TweenType.Linear)
						end
						f186_arg0:setRGB(0.4, 0.055, 0.078)
						f186_arg0:setAlpha(0)
						if f186_arg1.interrupted then
							Widget.clipFinished(f186_arg0, f186_arg1)
						else
							f186_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f185_arg1.interrupted then
						f185_local0(f185_arg0, f185_arg1)
						return 
					else
						f185_arg0:beginAnimation("keyframe", 2049, false, false, CoD.TweenType.Linear)
						f185_arg0:registerEventHandler("transition_complete_keyframe", f185_local0)
					end
				end

				if f184_arg1.interrupted then
					f184_local0(f184_arg0, f184_arg1)
					return 
				else
					f184_arg0:beginAnimation("keyframe", 310, false, false, CoD.TweenType.Linear)
					f184_arg0:registerEventHandler("transition_complete_keyframe", f184_local0)
				end
			end

			if f159_arg1.interrupted then
				f159_local0(f159_arg0, f159_arg1)
				return 
			else
				f159_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
				f159_arg0:setAlpha(1)
				f159_arg0:registerEventHandler("transition_complete_keyframe", f159_local0)
			end
		end

		f16_local5(f3_local12, {})
		f3_local13:completeAnimation()
		Widget.ZmFxSpark20:setAlpha(0)
		Widget.clipFinished(f3_local13, {})
		f3_local14:completeAnimation()
		Widget.Flsh:setLeftRight(false, false, -219.65, 219.34)
		Widget.Flsh:setTopBottom(true, false, 146.25, 180.75)
		Widget.Flsh:setRGB(0.4, 0.055, 0.078)
		Widget.Flsh:setAlpha(0.36)
		local f16_local6 = function (f160_arg0, f160_arg1)
			local f160_local0 = function (f187_arg0, f187_arg1)
				if not f187_arg1.interrupted then
					f187_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
				end
				f187_arg0:setLeftRight(false, false, -219.65, 219.34)
				f187_arg0:setTopBottom(true, false, 146.25, 180.75)
				f187_arg0:setRGB(0.4, 0.055, 0.078)
				f187_arg0:setAlpha(0)
				if f187_arg1.interrupted then
					Widget.clipFinished(f187_arg0, f187_arg1)
				else
					f187_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f160_arg1.interrupted then
				f160_local0(f160_arg0, f160_arg1)
				return 
			else
				f160_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
				f160_arg0:setRGB(0.4, 0.055, 0.078)
				f160_arg0:setAlpha(1)
				f160_arg0:registerEventHandler("transition_complete_keyframe", f160_local0)
			end
		end

		f16_local6(f3_local14, {})
		f3_local15:completeAnimation()
		Widget.ZmAmmoParticleFX1left:setAlpha(1)
		local f16_local7 = function (f161_arg0, f161_arg1)
			local f161_local0 = function (f188_arg0, f188_arg1)
				if not f188_arg1.interrupted then
					f188_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f188_arg0:setAlpha(0)
				if f188_arg1.interrupted then
					Widget.clipFinished(f188_arg0, f188_arg1)
				else
					f188_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f161_arg1.interrupted then
				f161_local0(f161_arg0, f161_arg1)
				return 
			else
				f161_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f161_arg0:registerEventHandler("transition_complete_keyframe", f161_local0)
			end
		end

		f16_local7(f3_local15, {})
		f3_local16:completeAnimation()
		Widget.ZmAmmoParticleFX2left:setAlpha(1)
		local f16_local8 = function (f162_arg0, f162_arg1)
			local f162_local0 = function (f189_arg0, f189_arg1)
				if not f189_arg1.interrupted then
					f189_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f189_arg0:setAlpha(0)
				if f189_arg1.interrupted then
					Widget.clipFinished(f189_arg0, f189_arg1)
				else
					f189_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f162_arg1.interrupted then
				f162_local0(f162_arg0, f162_arg1)
				return 
			else
				f162_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f162_arg0:registerEventHandler("transition_complete_keyframe", f162_local0)
			end
		end

		f16_local8(f3_local16, {})
		f3_local17:completeAnimation()
		Widget.ZmAmmoParticleFX3left:setAlpha(1)
		local f16_local9 = function (f163_arg0, f163_arg1)
			local f163_local0 = function (f190_arg0, f190_arg1)
				if not f190_arg1.interrupted then
					f190_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f190_arg0:setAlpha(0)
				if f190_arg1.interrupted then
					Widget.clipFinished(f190_arg0, f190_arg1)
				else
					f190_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f163_arg1.interrupted then
				f163_local0(f163_arg0, f163_arg1)
				return 
			else
				f163_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f163_arg0:registerEventHandler("transition_complete_keyframe", f163_local0)
			end
		end

		f16_local9(f3_local17, {})
		f3_local18:completeAnimation()
		Widget.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
		Widget.ZmAmmoParticleFX1right:setAlpha(1)
		Widget.ZmAmmoParticleFX1right:setZRot(180)
		local f16_local10 = function (f164_arg0, f164_arg1)
			local f164_local0 = function (f191_arg0, f191_arg1)
				if not f191_arg1.interrupted then
					f191_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f191_arg0:setLeftRight(true, false, 204.52, 348)
				f191_arg0:setTopBottom(true, false, 129, 203.6)
				f191_arg0:setAlpha(0)
				f191_arg0:setZRot(180)
				if f191_arg1.interrupted then
					Widget.clipFinished(f191_arg0, f191_arg1)
				else
					f191_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f164_arg1.interrupted then
				f164_local0(f164_arg0, f164_arg1)
				return 
			else
				f164_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f164_arg0:registerEventHandler("transition_complete_keyframe", f164_local0)
			end
		end

		f16_local10(f3_local18, {})
		f3_local19:completeAnimation()
		Widget.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
		Widget.ZmAmmoParticleFX2right:setAlpha(1)
		Widget.ZmAmmoParticleFX2right:setZRot(180)
		local f16_local11 = function (f165_arg0, f165_arg1)
			local f165_local0 = function (f192_arg0, f192_arg1)
				if not f192_arg1.interrupted then
					f192_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f192_arg0:setLeftRight(true, false, 204.52, 348)
				f192_arg0:setTopBottom(true, false, 126.6, 201.21)
				f192_arg0:setAlpha(0)
				f192_arg0:setZRot(180)
				if f192_arg1.interrupted then
					Widget.clipFinished(f192_arg0, f192_arg1)
				else
					f192_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f165_arg1.interrupted then
				f165_local0(f165_arg0, f165_arg1)
				return 
			else
				f165_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f165_arg0:registerEventHandler("transition_complete_keyframe", f165_local0)
			end
		end

		f16_local11(f3_local19, {})
		f3_local20:completeAnimation()
		Widget.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
		Widget.ZmAmmoParticleFX3right:setAlpha(0)
		Widget.ZmAmmoParticleFX3right:setZRot(180)
		local f16_local12 = function (f166_arg0, f166_arg1)
			local f166_local0 = function (f193_arg0, f193_arg1)
				if not f193_arg1.interrupted then
					f193_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f193_arg0:setLeftRight(true, false, 204.52, 348)
				f193_arg0:setTopBottom(true, false, 127.6, 202.21)
				f193_arg0:setAlpha(0)
				f193_arg0:setZRot(180)
				if f193_arg1.interrupted then
					Widget.clipFinished(f193_arg0, f193_arg1)
				else
					f193_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f166_arg1.interrupted then
				f166_local0(f166_arg0, f166_arg1)
				return 
			else
				f166_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f166_arg0:registerEventHandler("transition_complete_keyframe", f166_local0)
			end
		end

		f16_local12(f3_local20, {})
		f3_local21:completeAnimation()
		Widget.Lightning:setLeftRight(true, false, 110.67, 200.67)
		Widget.Lightning:setTopBottom(true, false, 8.5, 176.5)
		Widget.Lightning:setAlpha(0)
		local f16_local13 = function (f167_arg0, f167_arg1)
			local f167_local0 = function (f194_arg0, f194_arg1)
				local f194_local0 = function (f195_arg0, f195_arg1)
					if not f195_arg1.interrupted then
						f195_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					end
					f195_arg0:setLeftRight(true, false, 110.67, 200.67)
					f195_arg0:setTopBottom(true, false, 8.5, 176.5)
					f195_arg0:setAlpha(0)
					if f195_arg1.interrupted then
						Widget.clipFinished(f195_arg0, f195_arg1)
					else
						f195_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f194_arg1.interrupted then
					f194_local0(f194_arg0, f194_arg1)
					return 
				else
					f194_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
					f194_arg0:registerEventHandler("transition_complete_keyframe", f194_local0)
				end
			end

			if f167_arg1.interrupted then
				f167_local0(f167_arg0, f167_arg1)
				return 
			else
				f167_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f167_arg0:setAlpha(1)
				f167_arg0:registerEventHandler("transition_complete_keyframe", f167_local0)
			end
		end

		f16_local13(f3_local21, {})
		f3_local22:completeAnimation()
		Widget.Lightning2:setLeftRight(true, false, 35.74, 125.74)
		Widget.Lightning2:setTopBottom(true, false, 62.25, 230.25)
		Widget.Lightning2:setAlpha(0)
		Widget.Lightning2:setZRot(40)
		Widget.Lightning2:setScale(0.7)
		local f16_local14 = function (f168_arg0, f168_arg1)
			local f168_local0 = function (f196_arg0, f196_arg1)
				local f196_local0 = function (f197_arg0, f197_arg1)
					if not f197_arg1.interrupted then
						f197_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					end
					f197_arg0:setLeftRight(true, false, 35.74, 125.74)
					f197_arg0:setTopBottom(true, false, 62.25, 230.25)
					f197_arg0:setAlpha(0)
					f197_arg0:setZRot(40)
					f197_arg0:setScale(0.7)
					if f197_arg1.interrupted then
						Widget.clipFinished(f197_arg0, f197_arg1)
					else
						f197_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f196_arg1.interrupted then
					f196_local0(f196_arg0, f196_arg1)
					return 
				else
					f196_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
					f196_arg0:registerEventHandler("transition_complete_keyframe", f196_local0)
				end
			end

			if f168_arg1.interrupted then
				f168_local0(f168_arg0, f168_arg1)
				return 
			else
				f168_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f168_arg0:setAlpha(1)
				f168_arg0:registerEventHandler("transition_complete_keyframe", f168_local0)
			end
		end

		f16_local14(f3_local22, {})
		f3_local23:completeAnimation()
		Widget.Lightning3:setLeftRight(true, false, 186, 276)
		Widget.Lightning3:setTopBottom(true, false, 60.5, 228.5)
		Widget.Lightning3:setAlpha(0)
		Widget.Lightning3:setZRot(-40)
		Widget.Lightning3:setScale(0.7)
		local f16_local15 = function (f169_arg0, f169_arg1)
			local f169_local0 = function (f198_arg0, f198_arg1)
				local f198_local0 = function (f199_arg0, f199_arg1)
					if not f199_arg1.interrupted then
						f199_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					end
					f199_arg0:setLeftRight(true, false, 186, 276)
					f199_arg0:setTopBottom(true, false, 60.5, 228.5)
					f199_arg0:setAlpha(0)
					f199_arg0:setZRot(-40)
					f199_arg0:setScale(0.7)
					if f199_arg1.interrupted then
						Widget.clipFinished(f199_arg0, f199_arg1)
					else
						f199_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f198_arg1.interrupted then
					f198_local0(f198_arg0, f198_arg1)
					return 
				else
					f198_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
					f198_arg0:registerEventHandler("transition_complete_keyframe", f198_local0)
				end
			end

			if f169_arg1.interrupted then
				f169_local0(f169_arg0, f169_arg1)
				return 
			else
				f169_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f169_arg0:setAlpha(1)
				f169_arg0:registerEventHandler("transition_complete_keyframe", f169_local0)
			end
		end

		f16_local15(f3_local23, {})
		f3_local27:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
		f3_local27:setAlpha(0)
		f3_local27:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
		f3_local28:completeAnimation()
		Widget.Last5RoundTime:setAlpha(0)
		Widget.clipFinished(f3_local28, {})
	end, TextandTimeAttack = function ()
		Widget:setupElementClipCounter(24)
		f3_local1:completeAnimation()
		Widget.Panel:setRGB(0.4, 0.055, 0.078)
		Widget.Panel:setAlpha(0)
		local f17_local0 = function (f200_arg0, f200_arg1)
			local f200_local0 = function (f220_arg0, f220_arg1)
				local f220_local0 = function (f221_arg0, f221_arg1)
					local f221_local0 = function (f222_arg0, f222_arg1)
						if not f222_arg1.interrupted then
							f222_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
						end
						f222_arg0:setRGB(0.4, 0.055, 0.078)
						f222_arg0:setAlpha(0)
						if f222_arg1.interrupted then
							Widget.clipFinished(f222_arg0, f222_arg1)
						else
							f222_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f221_arg1.interrupted then
						f221_local0(f221_arg0, f221_arg1)
						return 
					else
						f221_arg0:beginAnimation("keyframe", 1850, false, false, CoD.TweenType.Linear)
						f221_arg0:registerEventHandler("transition_complete_keyframe", f221_local0)
					end
				end

				if f220_arg1.interrupted then
					f220_local0(f220_arg0, f220_arg1)
					return 
				else
					f220_arg0:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
					f220_arg0:setAlpha(1)
					f220_arg0:registerEventHandler("transition_complete_keyframe", f220_local0)
				end
			end

			if f200_arg1.interrupted then
				f200_local0(f200_arg0, f200_arg1)
				return 
			else
				f200_arg0:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
				f200_arg0:setAlpha(0.8)
				f200_arg0:registerEventHandler("transition_complete_keyframe", f200_local0)
			end
		end

		f17_local0(f3_local1, {})
		f3_local2:completeAnimation()
		Widget.basicImageBacking:setAlpha(0)
		Widget.basicImageBacking:setZRot(-10)
		local f17_local1 = function (f201_arg0, f201_arg1)
			local f201_local0 = function (f223_arg0, f223_arg1)
				local f223_local0 = function (f224_arg0, f224_arg1)
					local f224_local0 = function (f225_arg0, f225_arg1)
						if not f225_arg1.interrupted then
							f225_arg0:beginAnimation("keyframe", 600, false, false, CoD.TweenType.Linear)
						end
						f225_arg0:setAlpha(0)
						f225_arg0:setZRot(10)
						if f225_arg1.interrupted then
							Widget.clipFinished(f225_arg0, f225_arg1)
						else
							f225_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f224_arg1.interrupted then
						f224_local0(f224_arg0, f224_arg1)
						return 
					else
						f224_arg0:beginAnimation("keyframe", 1879, false, false, CoD.TweenType.Linear)
						f224_arg0:setZRot(5.7)
						f224_arg0:registerEventHandler("transition_complete_keyframe", f224_local0)
					end
				end

				if f223_arg1.interrupted then
					f223_local0(f223_arg0, f223_arg1)
					return 
				else
					f223_arg0:beginAnimation("keyframe", 310, false, false, CoD.TweenType.Linear)
					f223_arg0:setAlpha(1)
					f223_arg0:setZRot(-7.78)
					f223_arg0:registerEventHandler("transition_complete_keyframe", f223_local0)
				end
			end

			if f201_arg1.interrupted then
				f201_local0(f201_arg0, f201_arg1)
				return 
			else
				f201_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
				f201_arg0:registerEventHandler("transition_complete_keyframe", f201_local0)
			end
		end

		f17_local1(f3_local2, {})
		f3_local3:completeAnimation()
		Widget.TimeAttack:setLeftRight(true, false, 75.67, 237.67)
		Widget.TimeAttack:setTopBottom(true, false, 44, 206)
		Widget.TimeAttack:setAlpha(0)
		Widget.TimeAttack:setScale(0.8)
		local f17_local2 = function (f202_arg0, f202_arg1)
			local f202_local0 = function (f226_arg0, f226_arg1)
				local f226_local0 = function (f227_arg0, f227_arg1)
					local f227_local0 = function (f228_arg0, f228_arg1)
						if not f228_arg1.interrupted then
							f228_arg0:beginAnimation("keyframe", 559, false, false, CoD.TweenType.Linear)
						end
						f228_arg0:setLeftRight(true, false, 75.67, 237.67)
						f228_arg0:setTopBottom(true, false, 44, 206)
						f228_arg0:setAlpha(0)
						f228_arg0:setScale(0.8)
						if f228_arg1.interrupted then
							Widget.clipFinished(f228_arg0, f228_arg1)
						else
							f228_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f227_arg1.interrupted then
						f227_local0(f227_arg0, f227_arg1)
						return 
					else
						f227_arg0:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
						f227_arg0:setAlpha(1)
						f227_arg0:registerEventHandler("transition_complete_keyframe", f227_local0)
					end
				end

				if f226_arg1.interrupted then
					f226_local0(f226_arg0, f226_arg1)
					return 
				else
					f226_arg0:beginAnimation("keyframe", 1839, false, false, CoD.TweenType.Linear)
					f226_arg0:registerEventHandler("transition_complete_keyframe", f226_local0)
				end
			end

			if f202_arg1.interrupted then
				f202_local0(f202_arg0, f202_arg1)
				return 
			else
				f202_arg0:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
				f202_arg0:setAlpha(0.95)
				f202_arg0:registerEventHandler("transition_complete_keyframe", f202_local0)
			end
		end

		f17_local2(f3_local3, {})
		f3_local4:completeAnimation()
		Widget.basicImage:setAlpha(0)
		local f17_local3 = function (f203_arg0, f203_arg1)
			local f203_local0 = function (f229_arg0, f229_arg1)
				local f229_local0 = function (f230_arg0, f230_arg1)
					local f230_local0 = function (f231_arg0, f231_arg1)
						local f231_local0 = function (f232_arg0, f232_arg1)
							if not f232_arg1.interrupted then
								f232_arg0:beginAnimation("keyframe", 679, false, true, CoD.TweenType.Linear)
							end
							f232_arg0:setAlpha(0)
							if f232_arg1.interrupted then
								Widget.clipFinished(f232_arg0, f232_arg1)
							else
								f232_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
							end
						end

						if f231_arg1.interrupted then
							f231_local0(f231_arg0, f231_arg1)
							return 
						else
							f231_arg0:beginAnimation("keyframe", 1630, false, false, CoD.TweenType.Linear)
							f231_arg0:registerEventHandler("transition_complete_keyframe", f231_local0)
						end
					end

					if f230_arg1.interrupted then
						f230_local0(f230_arg0, f230_arg1)
						return 
					else
						f230_arg0:beginAnimation("keyframe", 339, false, false, CoD.TweenType.Linear)
						f230_arg0:registerEventHandler("transition_complete_keyframe", f230_local0)
					end
				end

				if f229_arg1.interrupted then
					f229_local0(f229_arg0, f229_arg1)
					return 
				else
					f229_arg0:beginAnimation("keyframe", 290, false, false, CoD.TweenType.Linear)
					f229_arg0:registerEventHandler("transition_complete_keyframe", f229_local0)
				end
			end

			if f203_arg1.interrupted then
				f203_local0(f203_arg0, f203_arg1)
				return 
			else
				f203_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Linear)
				f203_arg0:registerEventHandler("transition_complete_keyframe", f203_local0)
			end
		end

		f17_local3(f3_local4, {})
		f3_local5:completeAnimation()
		Widget.bgbGlowOrangeOver:setAlpha(0)
		Widget.clipFinished(f3_local5, {})
		f3_local6:completeAnimation()
		Widget.bgbTexture:setAlpha(0)
		Widget.clipFinished(f3_local6, {})
		f3_local9:completeAnimation()
		Widget.bgbAbilitySwirl:setAlpha(0)
		Widget.bgbAbilitySwirl:setZRot(0)
		Widget.bgbAbilitySwirl:setScale(1)
		Widget.clipFinished(f3_local9, {})
		f3_local10:completeAnimation()
		Widget.ZmNotif1CursorHint0:setAlpha(0)
		local f17_local4 = function (f204_arg0, f204_arg1)
			local f204_local0 = function (f233_arg0, f233_arg1)
				local f233_local0 = function (f234_arg0, f234_arg1)
					local f234_local0 = function (f235_arg0, f235_arg1)
						if not f235_arg1.interrupted then
							f235_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
						end
						f235_arg0:setAlpha(0)
						if f235_arg1.interrupted then
							Widget.clipFinished(f235_arg0, f235_arg1)
						else
							f235_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f234_arg1.interrupted then
						f234_local0(f234_arg0, f234_arg1)
						return 
					else
						f234_arg0:beginAnimation("keyframe", 1849, false, false, CoD.TweenType.Linear)
						f234_arg0:registerEventHandler("transition_complete_keyframe", f234_local0)
					end
				end

				if f233_arg1.interrupted then
					f233_local0(f233_arg0, f233_arg1)
					return 
				else
					f233_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
					f233_arg0:setAlpha(1)
					f233_arg0:registerEventHandler("transition_complete_keyframe", f233_local0)
				end
			end

			if f204_arg1.interrupted then
				f204_local0(f204_arg0, f204_arg1)
				return 
			else
				f204_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
				f204_arg0:registerEventHandler("transition_complete_keyframe", f204_local0)
			end
		end

		f17_local4(f3_local10, {})
		f3_local11:completeAnimation()
		Widget.ZmNotifFactory:setRGB(1, 1, 1)
		Widget.ZmNotifFactory:setAlpha(0)
		local f17_local5 = function (f205_arg0, f205_arg1)
			local f205_local0 = function (f236_arg0, f236_arg1)
				local f236_local0 = function (f237_arg0, f237_arg1)
					if not f237_arg1.interrupted then
						f237_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
					end
					f237_arg0:setRGB(1, 1, 1)
					f237_arg0:setAlpha(0)
					if f237_arg1.interrupted then
						Widget.clipFinished(f237_arg0, f237_arg1)
					else
						f237_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f236_arg1.interrupted then
					f236_local0(f236_arg0, f236_arg1)
					return 
				else
					f236_arg0:beginAnimation("keyframe", 2240, false, false, CoD.TweenType.Linear)
					f236_arg0:registerEventHandler("transition_complete_keyframe", f236_local0)
				end
			end

			if f205_arg1.interrupted then
				f205_local0(f205_arg0, f205_arg1)
				return 
			else
				f205_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
				f205_arg0:setAlpha(1)
				f205_arg0:registerEventHandler("transition_complete_keyframe", f205_local0)
			end
		end

		f17_local5(f3_local11, {})
		f3_local12:completeAnimation()
		Widget.Glow:setRGB(0.4, 0.055, 0.078)
		Widget.Glow:setAlpha(0)
		local f17_local6 = function (f206_arg0, f206_arg1)
			local f206_local0 = function (f238_arg0, f238_arg1)
				local f238_local0 = function (f239_arg0, f239_arg1)
					local f239_local0 = function (f240_arg0, f240_arg1)
						if not f240_arg1.interrupted then
							f240_arg0:beginAnimation("keyframe", 799, false, false, CoD.TweenType.Linear)
						end
						f240_arg0:setRGB(0.4, 0.055, 0.078)
						f240_arg0:setAlpha(0)
						if f240_arg1.interrupted then
							Widget.clipFinished(f240_arg0, f240_arg1)
						else
							f240_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f239_arg1.interrupted then
						f239_local0(f239_arg0, f239_arg1)
						return 
					else
						f239_arg0:beginAnimation("keyframe", 2049, false, false, CoD.TweenType.Linear)
						f239_arg0:registerEventHandler("transition_complete_keyframe", f239_local0)
					end
				end

				if f238_arg1.interrupted then
					f238_local0(f238_arg0, f238_arg1)
					return 
				else
					f238_arg0:beginAnimation("keyframe", 310, false, false, CoD.TweenType.Linear)
					f238_arg0:registerEventHandler("transition_complete_keyframe", f238_local0)
				end
			end

			if f206_arg1.interrupted then
				f206_local0(f206_arg0, f206_arg1)
				return 
			else
				f206_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
				f206_arg0:setAlpha(1)
				f206_arg0:registerEventHandler("transition_complete_keyframe", f206_local0)
			end
		end

		f17_local6(f3_local12, {})
		f3_local13:completeAnimation()
		Widget.ZmFxSpark20:setAlpha(0)
		Widget.clipFinished(f3_local13, {})
		f3_local14:completeAnimation()
		Widget.Flsh:setLeftRight(false, false, -219.65, 219.34)
		Widget.Flsh:setTopBottom(true, false, 146.25, 180.75)
		Widget.Flsh:setRGB(0.4, 0.055, 0.078)
		Widget.Flsh:setAlpha(0.36)
		local f17_local7 = function (f207_arg0, f207_arg1)
			local f207_local0 = function (f241_arg0, f241_arg1)
				if not f241_arg1.interrupted then
					f241_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
				end
				f241_arg0:setLeftRight(false, false, -219.65, 219.34)
				f241_arg0:setTopBottom(true, false, 146.25, 180.75)
				f241_arg0:setRGB(0.4, 0.055, 0.078)
				f241_arg0:setAlpha(0)
				if f241_arg1.interrupted then
					Widget.clipFinished(f241_arg0, f241_arg1)
				else
					f241_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f207_arg1.interrupted then
				f207_local0(f207_arg0, f207_arg1)
				return 
			else
				f207_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
				f207_arg0:setRGB(0.4, 0.055, 0.078)
				f207_arg0:setAlpha(1)
				f207_arg0:registerEventHandler("transition_complete_keyframe", f207_local0)
			end
		end

		f17_local7(f3_local14, {})
		f3_local15:completeAnimation()
		Widget.ZmAmmoParticleFX1left:setAlpha(1)
		local f17_local8 = function (f208_arg0, f208_arg1)
			local f208_local0 = function (f242_arg0, f242_arg1)
				if not f242_arg1.interrupted then
					f242_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f242_arg0:setAlpha(0)
				if f242_arg1.interrupted then
					Widget.clipFinished(f242_arg0, f242_arg1)
				else
					f242_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f208_arg1.interrupted then
				f208_local0(f208_arg0, f208_arg1)
				return 
			else
				f208_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f208_arg0:registerEventHandler("transition_complete_keyframe", f208_local0)
			end
		end

		f17_local8(f3_local15, {})
		f3_local16:completeAnimation()
		Widget.ZmAmmoParticleFX2left:setAlpha(1)
		local f17_local9 = function (f209_arg0, f209_arg1)
			local f209_local0 = function (f243_arg0, f243_arg1)
				if not f243_arg1.interrupted then
					f243_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f243_arg0:setAlpha(0)
				if f243_arg1.interrupted then
					Widget.clipFinished(f243_arg0, f243_arg1)
				else
					f243_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f209_arg1.interrupted then
				f209_local0(f209_arg0, f209_arg1)
				return 
			else
				f209_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f209_arg0:registerEventHandler("transition_complete_keyframe", f209_local0)
			end
		end

		f17_local9(f3_local16, {})
		f3_local17:completeAnimation()
		Widget.ZmAmmoParticleFX3left:setAlpha(1)
		local f17_local10 = function (f210_arg0, f210_arg1)
			local f210_local0 = function (f244_arg0, f244_arg1)
				if not f244_arg1.interrupted then
					f244_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f244_arg0:setAlpha(0)
				if f244_arg1.interrupted then
					Widget.clipFinished(f244_arg0, f244_arg1)
				else
					f244_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f210_arg1.interrupted then
				f210_local0(f210_arg0, f210_arg1)
				return 
			else
				f210_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f210_arg0:registerEventHandler("transition_complete_keyframe", f210_local0)
			end
		end

		f17_local10(f3_local17, {})
		f3_local18:completeAnimation()
		Widget.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
		Widget.ZmAmmoParticleFX1right:setAlpha(1)
		Widget.ZmAmmoParticleFX1right:setZRot(180)
		local f17_local11 = function (f211_arg0, f211_arg1)
			local f211_local0 = function (f245_arg0, f245_arg1)
				if not f245_arg1.interrupted then
					f245_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f245_arg0:setLeftRight(true, false, 204.52, 348)
				f245_arg0:setTopBottom(true, false, 129, 203.6)
				f245_arg0:setAlpha(0)
				f245_arg0:setZRot(180)
				if f245_arg1.interrupted then
					Widget.clipFinished(f245_arg0, f245_arg1)
				else
					f245_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f211_arg1.interrupted then
				f211_local0(f211_arg0, f211_arg1)
				return 
			else
				f211_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f211_arg0:registerEventHandler("transition_complete_keyframe", f211_local0)
			end
		end

		f17_local11(f3_local18, {})
		f3_local19:completeAnimation()
		Widget.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
		Widget.ZmAmmoParticleFX2right:setAlpha(1)
		Widget.ZmAmmoParticleFX2right:setZRot(180)
		local f17_local12 = function (f212_arg0, f212_arg1)
			local f212_local0 = function (f246_arg0, f246_arg1)
				if not f246_arg1.interrupted then
					f246_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f246_arg0:setLeftRight(true, false, 204.52, 348)
				f246_arg0:setTopBottom(true, false, 126.6, 201.21)
				f246_arg0:setAlpha(0)
				f246_arg0:setZRot(180)
				if f246_arg1.interrupted then
					Widget.clipFinished(f246_arg0, f246_arg1)
				else
					f246_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f212_arg1.interrupted then
				f212_local0(f212_arg0, f212_arg1)
				return 
			else
				f212_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f212_arg0:registerEventHandler("transition_complete_keyframe", f212_local0)
			end
		end

		f17_local12(f3_local19, {})
		f3_local20:completeAnimation()
		Widget.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
		Widget.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
		Widget.ZmAmmoParticleFX3right:setAlpha(0)
		Widget.ZmAmmoParticleFX3right:setZRot(180)
		local f17_local13 = function (f213_arg0, f213_arg1)
			local f213_local0 = function (f247_arg0, f247_arg1)
				if not f247_arg1.interrupted then
					f247_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
				end
				f247_arg0:setLeftRight(true, false, 204.52, 348)
				f247_arg0:setTopBottom(true, false, 127.6, 202.21)
				f247_arg0:setAlpha(0)
				f247_arg0:setZRot(180)
				if f247_arg1.interrupted then
					Widget.clipFinished(f247_arg0, f247_arg1)
				else
					f247_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
				end
			end

			if f213_arg1.interrupted then
				f213_local0(f213_arg0, f213_arg1)
				return 
			else
				f213_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
				f213_arg0:registerEventHandler("transition_complete_keyframe", f213_local0)
			end
		end

		f17_local13(f3_local20, {})
		f3_local21:completeAnimation()
		Widget.Lightning:setLeftRight(true, false, 110.67, 200.67)
		Widget.Lightning:setTopBottom(true, false, 8.5, 176.5)
		Widget.Lightning:setAlpha(0)
		local f17_local14 = function (f214_arg0, f214_arg1)
			local f214_local0 = function (f248_arg0, f248_arg1)
				local f248_local0 = function (f249_arg0, f249_arg1)
					if not f249_arg1.interrupted then
						f249_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					end
					f249_arg0:setLeftRight(true, false, 110.67, 200.67)
					f249_arg0:setTopBottom(true, false, 8.5, 176.5)
					f249_arg0:setAlpha(0)
					if f249_arg1.interrupted then
						Widget.clipFinished(f249_arg0, f249_arg1)
					else
						f249_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f248_arg1.interrupted then
					f248_local0(f248_arg0, f248_arg1)
					return 
				else
					f248_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
					f248_arg0:registerEventHandler("transition_complete_keyframe", f248_local0)
				end
			end

			if f214_arg1.interrupted then
				f214_local0(f214_arg0, f214_arg1)
				return 
			else
				f214_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f214_arg0:registerEventHandler("transition_complete_keyframe", f214_local0)
			end
		end

		f17_local14(f3_local21, {})
		f3_local22:completeAnimation()
		Widget.Lightning2:setLeftRight(true, false, 35.74, 125.74)
		Widget.Lightning2:setTopBottom(true, false, 62.25, 230.25)
		Widget.Lightning2:setAlpha(0)
		Widget.Lightning2:setZRot(40)
		Widget.Lightning2:setScale(0.7)
		local f17_local15 = function (f215_arg0, f215_arg1)
			local f215_local0 = function (f250_arg0, f250_arg1)
				local f250_local0 = function (f251_arg0, f251_arg1)
					if not f251_arg1.interrupted then
						f251_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					end
					f251_arg0:setLeftRight(true, false, 35.74, 125.74)
					f251_arg0:setTopBottom(true, false, 62.25, 230.25)
					f251_arg0:setAlpha(0)
					f251_arg0:setZRot(40)
					f251_arg0:setScale(0.7)
					if f251_arg1.interrupted then
						Widget.clipFinished(f251_arg0, f251_arg1)
					else
						f251_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f250_arg1.interrupted then
					f250_local0(f250_arg0, f250_arg1)
					return 
				else
					f250_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
					f250_arg0:registerEventHandler("transition_complete_keyframe", f250_local0)
				end
			end

			if f215_arg1.interrupted then
				f215_local0(f215_arg0, f215_arg1)
				return 
			else
				f215_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f215_arg0:setAlpha(1)
				f215_arg0:registerEventHandler("transition_complete_keyframe", f215_local0)
			end
		end

		f17_local15(f3_local22, {})
		f3_local23:completeAnimation()
		Widget.Lightning3:setLeftRight(true, false, 186, 276)
		Widget.Lightning3:setTopBottom(true, false, 60.5, 228.5)
		Widget.Lightning3:setAlpha(0)
		Widget.Lightning3:setZRot(-40)
		Widget.Lightning3:setScale(0.7)
		local f17_local16 = function (f216_arg0, f216_arg1)
			local f216_local0 = function (f252_arg0, f252_arg1)
				local f252_local0 = function (f253_arg0, f253_arg1)
					if not f253_arg1.interrupted then
						f253_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					end
					f253_arg0:setLeftRight(true, false, 186, 276)
					f253_arg0:setTopBottom(true, false, 60.5, 228.5)
					f253_arg0:setAlpha(0)
					f253_arg0:setZRot(-40)
					f253_arg0:setScale(0.7)
					if f253_arg1.interrupted then
						Widget.clipFinished(f253_arg0, f253_arg1)
					else
						f253_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f252_arg1.interrupted then
					f252_local0(f252_arg0, f252_arg1)
					return 
				else
					f252_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
					f252_arg0:registerEventHandler("transition_complete_keyframe", f252_local0)
				end
			end

			if f216_arg1.interrupted then
				f216_local0(f216_arg0, f216_arg1)
				return 
			else
				f216_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f216_arg0:setAlpha(1)
				f216_arg0:registerEventHandler("transition_complete_keyframe", f216_local0)
			end
		end

		f17_local16(f3_local23, {})
		f3_local26:completeAnimation()
		Widget.xpaward:setLeftRight(false, false, -112, 112)
		Widget.xpaward:setTopBottom(true, false, 328.5, 383.5)
		Widget.xpaward:setAlpha(0)
		local f17_local17 = function (f217_arg0, f217_arg1)
			local f217_local0 = function (f254_arg0, f254_arg1)
				local f254_local0 = function (f255_arg0, f255_arg1)
					local f255_local0 = function (f256_arg0, f256_arg1)
						if not f256_arg1.interrupted then
							f256_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f256_arg0:setLeftRight(false, false, -112, 112)
						f256_arg0:setTopBottom(true, false, 328.5, 383.5)
						f256_arg0:setAlpha(0)
						if f256_arg1.interrupted then
							Widget.clipFinished(f256_arg0, f256_arg1)
						else
							f256_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f255_arg1.interrupted then
						f255_local0(f255_arg0, f255_arg1)
						return 
					else
						f255_arg0:beginAnimation("keyframe", 1590, false, false, CoD.TweenType.Linear)
						f255_arg0:registerEventHandler("transition_complete_keyframe", f255_local0)
					end
				end

				if f254_arg1.interrupted then
					f254_local0(f254_arg0, f254_arg1)
					return 
				else
					f254_arg0:beginAnimation("keyframe", 770, false, false, CoD.TweenType.Linear)
					f254_arg0:registerEventHandler("transition_complete_keyframe", f254_local0)
				end
			end

			if f217_arg1.interrupted then
				f217_local0(f217_arg0, f217_arg1)
				return 
			else
				f217_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f217_arg0:setAlpha(1)
				f217_arg0:registerEventHandler("transition_complete_keyframe", f217_local0)
			end
		end

		f17_local17(f3_local26, {})
		f3_local27:completeAnimation()
		Widget.CursorHint:setAlpha(0)
		local f17_local18 = function (f218_arg0, f218_arg1)
			local f218_local0 = function (f257_arg0, f257_arg1)
				local f257_local0 = function (f258_arg0, f258_arg1)
					local f258_local0 = function (f259_arg0, f259_arg1)
						if not f259_arg1.interrupted then
							f259_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
						end
						f259_arg0:setAlpha(0)
						if f259_arg1.interrupted then
							Widget.clipFinished(f259_arg0, f259_arg1)
						else
							f259_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
						end
					end

					if f258_arg1.interrupted then
						f258_local0(f258_arg0, f258_arg1)
						return 
					else
						f258_arg0:beginAnimation("keyframe", 3349, false, false, CoD.TweenType.Linear)
						f258_arg0:registerEventHandler("transition_complete_keyframe", f258_local0)
					end
				end

				if f257_arg1.interrupted then
					f257_local0(f257_arg0, f257_arg1)
					return 
				else
					f257_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
					f257_arg0:setAlpha(1)
					f257_arg0:registerEventHandler("transition_complete_keyframe", f257_local0)
				end
			end

			if f218_arg1.interrupted then
				f218_local0(f218_arg0, f218_arg1)
				return 
			else
				f218_arg0:beginAnimation("keyframe", 2660, false, false, CoD.TweenType.Linear)
				f218_arg0:registerEventHandler("transition_complete_keyframe", f218_local0)
			end
		end

		f17_local18(f3_local27, {})
		f3_local28:completeAnimation()
		Widget.Last5RoundTime:setAlpha(0)
		local f17_local19 = function (f219_arg0, f219_arg1)
			local f219_local0 = function (f260_arg0, f260_arg1)
				local f260_local0 = function (f261_arg0, f261_arg1)
					if not f261_arg1.interrupted then
						f261_arg0:beginAnimation("keyframe", 330, false, false, CoD.TweenType.Linear)
					end
					f261_arg0:setAlpha(0)
					if f261_arg1.interrupted then
						Widget.clipFinished(f261_arg0, f261_arg1)
					else
						f261_arg0:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
					end
				end

				if f260_arg1.interrupted then
					f260_local0(f260_arg0, f260_arg1)
					return 
				else
					f260_arg0:beginAnimation("keyframe", 6149, false, false, CoD.TweenType.Linear)
					f260_arg0:registerEventHandler("transition_complete_keyframe", f260_local0)
				end
			end

			if f219_arg1.interrupted then
				f219_local0(f219_arg0, f219_arg1)
				return 
			else
				f219_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
				f219_arg0:setAlpha(1)
				f219_arg0:registerEventHandler("transition_complete_keyframe", f219_local0)
			end
		end

		f17_local19(f3_local28, {})
	end}}
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.Panel:close()
		Sender.ZmNotif1CursorHint0:close()
		Sender.ZmNotifFactory:close()
		Sender.ZmFxSpark20:close()
		Sender.ZmAmmoParticleFX1left:close()
		Sender.ZmAmmoParticleFX2left:close()
		Sender.ZmAmmoParticleFX3left:close()
		Sender.ZmAmmoParticleFX1right:close()
		Sender.ZmAmmoParticleFX2right:close()
		Sender.ZmAmmoParticleFX3right:close()
		Sender.xpaward:close()
		Sender.CursorHint:close()
		Sender.Last5RoundTime:close()
	end)
	if f0_local1 then
		f0_local1(Widget, InstanceRef, HudRef)
	end
	return Widget
end

