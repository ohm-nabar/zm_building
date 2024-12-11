EnableGlobals()
-- Rayjiun UIModels Utils
if not UIModelUtils then
    UIModelUtils = {}
end

-- A cleaner way to just register your UI Model with a default value that also handles fast_restart
if not UIModelUtils.RegisterUIModel then
    UIModelUtils.RegisterUIModel = function(controller, model, value)
        if not UIModels then
            UIModels = {}
        end

        if not UIModels[model] then
            UIModels[model] = value
            Engine.SetModelValue(Engine.CreateModel(Engine.GetModelForController(controller), model), value) -- Set an initial value, otherwise the game will fill it as Userdata
        end
    end
end

if not UIModelUtils.SetupUIModels then
    UIModelUtils.SetupUIModels = function(self, controller) 
        if not UIModels then
            return
        end

        -- To support fast_restart
        self:subscribeToModel(Engine.CreateModel(Engine.GetGlobalModel(), "fastRestart"), function(model)
            for key, value in pairs(UIModels) do
                Engine.SetModelValue(Engine.CreateModel(Engine.GetModelForController(controller), key), value)
            end
        end, false)
    end
end
DisableGlobals()