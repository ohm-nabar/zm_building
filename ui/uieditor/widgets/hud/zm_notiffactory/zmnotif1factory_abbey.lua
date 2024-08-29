require("ui.uieditor.widgets.HUD.ZM_Notif.ZmNotif1_BckScl")
CoD.ZmNotif1Factory = InheritFrom(LUI.UIElement)
CoD.ZmNotif1Factory.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.ZmNotif1Factory)
	Widget.id = "ZmNotif1Factory"
	Widget.soundSet = "HUD"
	Widget:setLeftRight(true, false, 0, 224)
	Widget:setTopBottom(true, false, 0, 55)
	local f1_local1 = LUI.UIImage.new()
	f1_local1:setLeftRight(true, true, -55, 41)
	f1_local1:setTopBottom(false, false, -45, 45)
	f1_local1:setRGB(0.63, 0.63, 0.63)
	f1_local1:setImage(RegisterImage("uie_t7_core_hud_mapwidget_panelglow"))
	f1_local1:setMaterial(LUI.UIImage.GetCachedMaterial("ui_multiply"))
	Widget:addElement(f1_local1)
	Widget.GLowMultiply = f1_local1
	
	local f1_local2 = LUI.UITightText.new()
	f1_local2:setLeftRight(false, false, -20, 21)
	f1_local2:setTopBottom(true, false, 7.63, 45.63)
	f1_local2:setRGB(0, 0.58, 1)
	f1_local2:setAlpha(0.2)
	f1_local2:setText(Engine.Localize("MENU_NEW"))
	f1_local2:setTTF("fonts/WEARETRIPPINShort.ttf")
	f1_local2:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	f1_local2:setShaderVector(0, 0.21, 0, 0, 0)
	f1_local2:setShaderVector(1, 0, 0, 0, 0)
	f1_local2:setShaderVector(2, 1, 0, 0, 0)
	f1_local2:setLetterSpacing(0.2)
	Widget:addElement(f1_local2)
	Widget.Label2 = f1_local2
	
	local f1_local3 = LUI.UITightText.new()
	f1_local3:setLeftRight(false, false, -20, 21)
	f1_local3:setTopBottom(true, false, 7.63, 45.63)
	f1_local3:setRGB(0.62, 0.96, 0.99)
	f1_local3:setText(Engine.Localize("MENU_NEW"))
	f1_local3:setTTF("fonts/WEARETRIPPINShort.ttf")
	LUI.OverrideFunction_CallOriginalFirst(f1_local3, "setText", function (f2_arg0, f2_arg1)
		ScaleWidgetToLabelCentered(Widget, f2_arg0, 3)
	end)
	Widget:addElement(f1_local3)
	Widget.Label1 = f1_local3
	
	local f1_local4 = LUI.UIImage.new()
	f1_local4:setLeftRight(true, true, 8, -13)
	f1_local4:setTopBottom(false, false, -27.38, 21.63)
	f1_local4:setRGB(0.4, 0.055, 0.078)
	f1_local4:setAlpha(0.5)
	f1_local4:setImage(RegisterImage("uie_t7_zm_hud_notif_txtbacking"))
	f1_local4:setMaterial(LUI.UIImage.GetCachedMaterial("uie_tile_scroll"))
	f1_local4:setShaderVector(0, 1.71, 1, 0, 0)
	f1_local4:setShaderVector(1, 0, 100, 0, 0)
	Widget:addElement(f1_local4)
	Widget.Flckr = f1_local4
	
	local f1_local5 = CoD.ZmNotif1_BckScl.new(HudRef, InstanceRef)
	f1_local5:setLeftRight(true, true, 0, 0)
	f1_local5:setTopBottom(false, false, -26.38, 22.63)
	f1_local5:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f1_local5)
	Widget.BckScl = f1_local5
	
	local f1_local6 = LUI.UIImage.new()
	f1_local6:setLeftRight(true, true, -36.17, 33.17)
	f1_local6:setTopBottom(false, false, -33.75, 32)
	f1_local6:setRGB(0.4, 0.055, 0.078)
	f1_local6:setAlpha(0.43)
	f1_local6:setImage(RegisterImage("uie_t7_core_hud_mapwidget_panelglow"))
	f1_local6:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Widget:addElement(f1_local6)
	Widget.Glow = f1_local6
	
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.BckScl:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

