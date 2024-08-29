EnableGlobals()

if not LilrifaUtils then
    LilrifaUtils = {}
end

if not LilrifaUtils.SubscribeToVisibilityBitAndUpdateElementState then
    LilrifaUtils.SubscribeToVisibilityBitAndUpdateElementState = function(InstanceRef, HudRef, Widget, VisiblityBitEnum)
        Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. VisiblityBitEnum), function(ModelRef)
            HudRef:updateElementState(Widget, {
                name = "model_validation",
                menu = HudRef,
                modelValue = Engine.GetModelValue(ModelRef),
                modelName = "UIVisibilityBit." .. VisiblityBitEnum
            })
        end)
    end
end

if not LilrifaUtils.SubscribeToModelAndUpdateState then
    LilrifaUtils.SubscribeToModelAndUpdateState = function(InstanceRef, HudRef, Widget, ModelName)
        Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), ModelName), function(ModelRef)
            HudRef:updateElementState(Widget, {
                name = "model_validation",
                menu = HudRef,
                modelValue = Engine.GetModelValue(ModelRef),
                modelName = ModelName
            })
        end)
    end
end

if not LilrifaUtils.LinkToElementModelAndUpdateState then
    LilrifaUtils.LinkToElementModelAndUpdateState = function(HudRef, Widget, ElementModelName, NeedsSubscription)
        Widget:linkToElementModel(Widget, ElementModelName, NeedsSubscription, function(ModelRef)
            HudRef:updateElementState(Widget, {
                name = "model_validation",
                menu = HudRef,
                modelValue = Engine.GetModelValue(ModelRef),
                modelName = ElementModelName
            })
        end)
    end
end

if not LilrifaUtils.SubscribeToModelByName then
    LilrifaUtils.SubscribeToModelByName = function(Widget, InstanceRef, ModelName, Callback)
        Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), ModelName), Callback)
    end
end