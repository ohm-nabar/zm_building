-- Trial dialogue per gargoyle (outer: 1=Aramis, 2=Porthos, 3=Dart, 4=Athos).
-- Inner: 1=initial, 2-5=after each trial completion benchmark.
-- Mirrors GSC gargoyle_dialogue[garg_num][step] (step 0-4).
local GargoyleTrialDialogue = {
    {  -- Aramis
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS0",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS1",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS2",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS3",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS4",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS10",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS15",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS25"
    },
    {  -- Porthos
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS0",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS1",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS2",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS3",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS4",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS10",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS15",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS25"
    },
    {  -- Dart
        "ZM_ABBEY_TRIAL_DIALOGUE_DART0",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART1",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART2",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART3",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART4",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART10",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART15",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART25"
    },
    {  -- Athos
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS0",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS1",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS2",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS3",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS4",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS10",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS15",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS25"
    }
}

-- Bribe dialogue per gargoyle (outer: 1=Aramis, 2=Porthos, 3=Dart, 4=Athos).
-- Inner: 1-4 matching BRIBE1-BRIBE4.
-- Mirrors GSC gargoyle_dialogue_bribe[garg_num][bribe_index] (bribe_index 0-3).
local GargoyleBribeDialogue = {
    {  -- Aramis
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE1",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE2",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE3",
        "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE4"
    },
    {  -- Porthos
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE1",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE2",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE3",
        "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE4"
    },
    {  -- Dart
        "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE1",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE2",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE3",
        "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE4"
    },
    {  -- Athos
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE1",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE2",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE3",
        "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE4"
    }
}

-- Display color per gobblegum, keyed by GSC scriptname.
-- Mirrors the color keys used in GSC gg_hintstrings: "purple", "blue", "orange", "green".
-- Derived from the #precache triggerstring color-variant lines in custom_gg_machine.gsc.
local GumColors = {
    ["zm_bgb_stock_option"]           = "green",
    ["zm_bgb_sword_flay"]             = "green",
    ["zm_bgb_temporal_gift"]          = "blue",
    ["zm_bgb_in_plain_sight"]         = "purple",
    ["zm_bgb_im_feelin_lucky"]        = "purple",
    ["zm_bgb_immolation_liquidation"] = "purple",
    ["zm_bgb_head_drama"]             = "blue",
    ["zm_bgb_phoenix_up"]             = "purple",
    ["zm_bgb_pop_shocks"]             = "orange",
    ["zm_bgb_on_the_house"]           = "purple",
    ["zm_bgb_extra_credit"]           = "purple",
    ["zm_bgb_profit_sharing"]         = "green",
    ["zm_bgb_flavor_hexed"]           = "orange",
    ["zm_bgb_unquenchable"]           = "orange",
    ["zm_bgb_alchemical_antithesis"]  = "purple",
    ["zm_bgb_crate_power"]            = "orange",
    ["zm_bgb_aftertaste_blood"]       = "blue",
    ["zm_bgb_challenge_rejected"]     = "purple",
    ["zm_bgb_perkaholic"]             = "orange"
}

-- Mirrors GSC level.gg_names (scriptname → localized display name key).
local GumNames = {
    ["zm_bgb_stock_option"]           = "ZMUI_BGB_STOCK_OPTION",
    ["zm_bgb_sword_flay"]             = "ZMUI_BGB_SWORD_FLAY",
    ["zm_bgb_temporal_gift"]          = "ZMUI_BGB_TEMPORAL_GIFT",
    ["zm_bgb_in_plain_sight"]         = "ZMUI_BGB_IN_PLAIN_SIGHT",
    ["zm_bgb_im_feelin_lucky"]        = "ZMUI_BGB_IM_FEELIN_LUCKY",
    ["zm_bgb_immolation_liquidation"] = "ZMUI_BGB_IMMOLATION_LIQUIDATION",
    ["zm_bgb_phoenix_up"]             = "ZMUI_BGB_PHOENIX_UP",
    ["zm_bgb_pop_shocks"]             = "ZMUI_BGB_POP_SHOCKS",
    ["zm_bgb_challenge_rejected"]     = "ZMUI_BGB_CHALLENGE_REJECTED",
    ["zm_bgb_on_the_house"]           = "ZMUI_BGB_ON_THE_HOUSE",
    ["zm_bgb_profit_sharing"]         = "ZMUI_BGB_PROFIT_SHARING",
    ["zm_bgb_flavor_hexed"]           = "ZMUI_BGB_FLAVOR_HEXED",
    ["zm_bgb_crate_power"]            = "ZMUI_BGB_CRATE_POWER",
    ["zm_bgb_unquenchable"]           = "ZMUI_BGB_UNQUENCHABLE",
    ["zm_bgb_alchemical_antithesis"]  = "ZMUI_BGB_ALCHEMICAL_ANTITHESIS",
    ["zm_bgb_extra_credit"]           = "ZMUI_BGB_EXTRA_CREDIT",
    ["zm_bgb_head_drama"]             = "ZMUI_BGB_HEAD_DRAMA",
    ["zm_bgb_aftertaste_blood"]       = "ZMUI_BGB_AFTERTASTE_BLOOD",
    ["zm_bgb_perkaholic"]             = "ZMUI_BGB_PERKAHOLIC"
}

-- Mirrors GSC level.gg_hintstrings (gum available, color → localized string key).
local GumHintstrings = {
    ["purple"] = "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE",
    ["blue"]   = "ZM_ABBEY_TRIAL_HINTSTRING_BLUE",
    ["orange"] = "ZM_ABBEY_TRIAL_HINTSTRING_ORANGE",
    ["green"]  = "ZM_ABBEY_TRIAL_HINTSTRING_GREEN"
}

-- Mirrors GSC level.gg_hintstrings_unavailable (gum locked, color → localized string key).
local GumHintstringsUnavailable = {
    ["purple"] = "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE",
    ["blue"]   = "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_BLUE",
    ["orange"] = "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_ORANGE",
    ["green"]  = "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_GREEN"
}

-- Mirrors GSC level.gg_hintstrings_bribe (bribe purchase, color → localized string key).
local GumHintStringsBribe = {
    ["purple"] = "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE",
    ["blue"]   = "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_BLUE",
    ["orange"] = "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_ORANGE",
    ["green"]  = "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_GREEN"
}

-- Gum scriptnames per tier, ordered to match trial_control.lua's Tier*GumLookup.
-- Mirrors: Tier1GumLookup, Tier2GumLookup, Tier3GumLookup (but as scriptnames).
local TierScriptLookup = {
    {  -- Tier 1 (5 gums)
        "zm_bgb_stock_option", "zm_bgb_sword_flay", "zm_bgb_temporal_gift",
        "zm_bgb_in_plain_sight", "zm_bgb_im_feelin_lucky"
    },
    {  -- Tier 2 (7 gums)
        "zm_bgb_immolation_liquidation", "zm_bgb_pop_shocks", "zm_bgb_challenge_rejected",
        "zm_bgb_flavor_hexed", "zm_bgb_crate_power", "zm_bgb_aftertaste_blood",
        "zm_bgb_extra_credit"
    },
    {  -- Tier 3 (4 gums)
        "zm_bgb_on_the_house", "zm_bgb_unquenchable", "zm_bgb_head_drama",
        "zm_bgb_alchemical_antithesis"
    }
}

-- Maps each tier position to {gargoyle_index, slot_index}.
-- Derived from trial_control.lua's Tier1Gum/Tier2Gum/Tier3Gum = {GumTable[g][s], ...}.
local TierSlots = {
    {  -- Tier 1 positions 1-5
        {1,1}, {1,2}, {1,3}, {2,1}, {3,1}
    },
    {  -- Tier 2 positions 1-7
        {1,4}, {2,2}, {2,3}, {3,2}, {3,3}, {4,1}, {4,2}
    },
    {  -- Tier 3 positions 1-4
        {2,4}, {3,4}, {4,3}, {4,4}
    }
}

-- Bribe cost per gum equals its tier number. Derived from TierScriptLookup.
local GumBribeCosts = {}
for Tier = 1, 3 do
    for _, Scriptname in ipairs(TierScriptLookup[Tier]) do
        GumBribeCosts[Scriptname] = Tier
    end
end

CoD.GargoyleDialogue = InheritFrom(LUI.UIElement)

function CoD.GargoyleDialogue.new(HudRef, InstanceRef)
    local GargoyleDialogue = LUI.UIElement.new()
    GargoyleDialogue:setClass(CoD.GargoyleDialogue)
    GargoyleDialogue.id = "GargoyleDialogue"
    GargoyleDialogue.soundSet = "default"

    GargoyleDialogue:setLeftRight(true, true)
    GargoyleDialogue:setTopBottom(true, true)

    local RefreshHintstring -- forward declaration; defined after UI elements are created below

    -- Current bribe count for the local player. Mirrors item_inventory.lua's bribeCount subscription.
    local CurrentBribeCount = 0
    local function UpdateBribeCount(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            CurrentBribeCount = NotifyData
            if RefreshHintstring then RefreshHintstring() end
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "bribeCount"), UpdateBribeCount)

    -- GargoyleGums[gargoyle_index][slot_index] = scriptname string.
    -- Populated by SetTierGums when tier model values arrive.
    -- Matches the GSC gargoyle_gums[garg_num][judge_index] layout (1-indexed here).
    local GargoyleGums = {{}, {}, {}, {}}

    -- Tracks the {gargoyle, slot} position of extra_credit and head_drama so
    -- OnPlayerCountChange can swap them in/out for multiplayer.
    local ExtraCreditGargSlot = nil
    local HeadDramaGargSlot   = nil

    -- Mirrors trial_control.lua's SetGum: decodes a factoradic integer into a permutation
    -- and writes the resulting scriptnames into GargoyleGums.
    local function SetTierGums(Factoradic, Tier)
        local PermTable = {}
        local N = #TierScriptLookup[Tier]
        local Quotient = Factoradic

        for i=1,N do
            local TableIndex = (N - i) + 1
            PermTable[TableIndex] = Quotient % i
            Quotient = math.floor(Quotient / i)
        end

        for i=1,(N-1) do
            local TableIndex = N - i
            for j=(TableIndex+1),N do
                if PermTable[j] >= PermTable[TableIndex] then
                    PermTable[j] = PermTable[j] + 1
                end
            end
        end

        for i=1,N do
            local TableVal = PermTable[i] + 1
            if Tier == 2 and TableVal == 7 then
                ExtraCreditGargSlot = TierSlots[Tier][i]
            elseif Tier == 3 and TableVal == 3 then
                HeadDramaGargSlot = TierSlots[Tier][i]
            end
            local Slot = TierSlots[Tier][i]
            GargoyleGums[Slot[1]][Slot[2]] = TierScriptLookup[Tier][TableVal]
        end
    end

    local function SetTier1Gum(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 0 then
            SetTierGums(NotifyData, 1)
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.tier1"), SetTier1Gum)

    local function SetTier2Gum(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 0 then
            SetTierGums(NotifyData, 2)
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.tier2"), SetTier2Gum)

    local function SetTier3Gum(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData and NotifyData >= 0 then
            SetTierGums(NotifyData, 3)
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.tier3"), SetTier3Gum)

    local HintstringBackground = LUI.UIImage.new()
    HintstringBackground:setRGB(0, 0, 0)
    HintstringBackground:setLeftRight(false, false, -143, 143)
    HintstringBackground:setTopBottom(true, false, 508, 538)
    HintstringBackground:setAlpha(0)
    GargoyleDialogue:addElement(HintstringBackground)

    local HintstringText = LUI.UIText.new()
    HintstringText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    HintstringText:setLeftRight(true, false, 0, 1280)
    HintstringText:setTopBottom(true, false, 512, 533)
    HintstringText:setAlpha(0)
    GargoyleDialogue:addElement(HintstringText)

    local DialogueBackground = LUI.UIImage.new()
    DialogueBackground:setRGB(0, 0, 0)
    DialogueBackground:setLeftRight(false, false, -143, 143)
    DialogueBackground:setTopBottom(true, false, 543, 573)
    DialogueBackground:setAlpha(0)
    GargoyleDialogue:addElement(DialogueBackground)

    local DialogueText = LUI.UIText.new()
    DialogueText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
    DialogueText:setLeftRight(true, false, 0, 1280)
    DialogueText:setTopBottom(true, false, 548, 569)
    DialogueText:setAlpha(0)
    GargoyleDialogue:addElement(DialogueText)

    -- Per-gargoyle state. All gums start unavailable; availability arrives via *Random CFs.
    local CurrentGargoyleStatus = 0
    local GumAvailable = {
        {false, false, false, false},
        {false, false, false, false},
        {false, false, false, false},
        {false, false, false, false}
    }
    -- Current dialogue key per gargoyle. Starts at the initial (index 1) entry.
    local CurrentDialogue = {
        GargoyleTrialDialogue[1][1],
        GargoyleTrialDialogue[2][1],
        GargoyleTrialDialogue[3][1],
        GargoyleTrialDialogue[4][1]
    }
    local TrialCounts     = {0, 0, 0, 0}
    local GargBribeCounts = {0, 0, 0, 0}
    -- Mirrors trial_control.lua's CurrentIndices: tracks which slot a trial completion unlocks next.
    -- Slots 1-4 are real gum slots; at 5 we're in the post-goal stage (handled by *Random CFs).
    local CurrentIndices  = {1, 1, 1, 1}

    local function CountNewlines(String)
        local _, Count = String:gsub("\n", "")
        return Count
    end

    -- Returns 1-based index into GargoyleTrialDialogue[garg] for a given cumulative trial count.
    -- Benchmarks: 1-4 → indices 2-5; 5-9 → stay at 5; 10-14 → 6; 15-24 → 7; 25+ → 8.
    local function GetDialogueIndex(TrialCount)
        if TrialCount >= 25 then return 8
        elseif TrialCount >= 15 then return 7
        elseif TrialCount >= 10 then return 6
        else return math.min(TrialCount + 1, 5)
        end
    end

    RefreshHintstring = function()
        if CurrentGargoyleStatus == 0 then
            HintstringBackground:setAlpha(0)
            HintstringText:setAlpha(0)
            DialogueBackground:setAlpha(0)
            DialogueText:setAlpha(0)
            return
        end

        local GargNum   = math.floor((CurrentGargoyleStatus - 1) / 4) + 1
        local SlotIndex = ((CurrentGargoyleStatus - 1) % 4) + 1
        local Gum = GargoyleGums[GargNum][SlotIndex]

        local HintString
        if Gum then
            local Color     = GumColors[Gum]
            local GumName   = Engine.Localize(GumNames[Gum])
            local BribeCost = GumBribeCosts[Gum]
            if GumAvailable[GargNum][SlotIndex] then
                HintString = Engine.Localize(GumHintstrings[Color], GumName)
            elseif BribeCost and CurrentBribeCount >= BribeCost then
                HintString = Engine.Localize(GumHintStringsBribe[Color], GumName, tostring(BribeCost))
            else
                HintString = Engine.Localize(GumHintstringsUnavailable[Color], GumName)
            end
        else
            HintString = ""
        end

        local DialogueString = Engine.Localize(CurrentDialogue[GargNum])

        -- Hintstring element
        local HintHeight = 29 + (20.75 * CountNewlines(HintString))
        HintstringText:setText(HintString)
        local HintBgX = (HintstringText:getTextWidth() + 10) / 2
        HintstringBackground:setLeftRight(false, false, -HintBgX, HintBgX)
        HintstringBackground:setTopBottom(true, false, 508, 508 + HintHeight)
        HintstringBackground:setAlpha(HintString ~= "" and 0.5 or 0)
        HintstringText:setAlpha(HintString ~= "" and 1 or 0)

        -- Dialogue element (slightly below hintstring)
        local DialogueTop    = 508 + HintHeight + 4
        local DialogueHeight = 29 + (20.75 * CountNewlines(DialogueString))
        DialogueText:setText(DialogueString)
        local DialogueBgX = (DialogueText:getTextWidth() + 10) / 2
        DialogueBackground:setLeftRight(false, false, -DialogueBgX, DialogueBgX)
        DialogueBackground:setTopBottom(true, false, DialogueTop, DialogueTop + DialogueHeight)
        DialogueText:setTopBottom(true, false, DialogueTop + 4, DialogueTop + 25)
        DialogueBackground:setAlpha(0.5)
        DialogueText:setAlpha(1)
    end

    local function UpdateGargoyleStatus(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            CurrentGargoyleStatus = NotifyData
            RefreshHintstring()
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "gargoyleStatus"), UpdateGargoyleStatus)

    -- Update gum availability when *Random CFs pulse.
    -- Values 1-4 = gum at slot became available; 5-8 = slot (val-4) became unavailable.
    local GargoyleRandomCFNames = {"trials.aramisRandom", "trials.porthosRandom", "trials.dartRandom", "trials.athosRandom"}
    for GargIdx = 1, 4 do
        local GI = GargIdx
        local function OnRandomCF(ModelRef)
            local NotifyData = Engine.GetModelValue(ModelRef)
            if NotifyData and NotifyData ~= 0 then
                if NotifyData >= 1 and NotifyData <= 4 then
                    GumAvailable[GI][NotifyData] = true
                elseif NotifyData >= 5 and NotifyData <= 8 then
                    GumAvailable[GI][NotifyData - 4] = false
                end
                RefreshHintstring()
            end
        end
        GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), GargoyleRandomCFNames[GargIdx]), OnRandomCF)
    end

    -- Track slot availability via trials.aramis/porthos/dart/athos progress CFs.
    -- Value == 1 means a trial just completed: mark the current slot available and advance.
    -- Value == -1 means reset (e.g. fast restart handled separately).
    -- Post-goal completions skip this path and come through *Random CFs instead.
    local GargoyleTrialCFNames = {"trials.aramis", "trials.porthos", "trials.dart", "trials.athos"}
    for GargIdx = 1, 4 do
        local GI = GargIdx
        local function OnTrialProgress(ModelRef)
            local NotifyData = Engine.GetModelValue(ModelRef)
            if NotifyData == 1 then
                local Idx = CurrentIndices[GI]
                if Idx <= 4 then
                    GumAvailable[GI][Idx] = true
                    CurrentIndices[GI] = CurrentIndices[GI] + 1
                    RefreshHintstring()
                end
            elseif NotifyData == -1 then
                CurrentIndices[GI] = 1
            end
        end
        GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), GargoyleTrialCFNames[GargIdx]), OnTrialProgress)
    end

    -- Advance dialogue when *Dialogue CFs pulse (1 = trial completed, 2 = bribe given).
    local GargoyleDialogueCFNames = {"aramisDialogue", "porthosDialogue", "dartDialogue", "athosDialogue"}
    for GargIdx = 1, 4 do
        local GI = GargIdx
        local function OnDialogueCF(ModelRef)
            local NotifyData = Engine.GetModelValue(ModelRef)
            if NotifyData and NotifyData ~= 0 then
                if NotifyData == 1 then
                    TrialCounts[GI] = TrialCounts[GI] + 1
                    CurrentDialogue[GI] = GargoyleTrialDialogue[GI][GetDialogueIndex(TrialCounts[GI])]
                elseif NotifyData == 2 then
                    GargBribeCounts[GI] = GargBribeCounts[GI] + 1
                    CurrentDialogue[GI] = GargoyleBribeDialogue[GI][math.min(GargBribeCounts[GI], 4)]
                end
                RefreshHintstring()
            end
        end
        GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), GargoyleDialogueCFNames[GargIdx]), OnDialogueCF)
    end

    -- Swap extra_credit/head_drama �" profit_sharing/phoenix_up when player count changes.
    local function OnPlayerCountChange(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                if ExtraCreditGargSlot then GargoyleGums[ExtraCreditGargSlot[1]][ExtraCreditGargSlot[2]] = "zm_bgb_extra_credit"   end
                if HeadDramaGargSlot   then GargoyleGums[HeadDramaGargSlot[1]][HeadDramaGargSlot[2]]     = "zm_bgb_head_drama"     end
            else
                if ExtraCreditGargSlot then GargoyleGums[ExtraCreditGargSlot[1]][ExtraCreditGargSlot[2]] = "zm_bgb_profit_sharing" end
                if HeadDramaGargSlot   then GargoyleGums[HeadDramaGargSlot[1]][HeadDramaGargSlot[2]]     = "zm_bgb_phoenix_up"     end
            end
            RefreshHintstring()
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "trials.playerCountChange"), OnPlayerCountChange)

    local function FastRestartCheck(ModelRef)
        for i = 1, 4 do
            TrialCounts[i] = 0
            GargBribeCounts[i] = 0
            CurrentIndices[i] = 1
            CurrentDialogue[i] = GargoyleTrialDialogue[i][1]
            GumAvailable[i] = {false, false, false, false}
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.CreateModel(Engine.GetGlobalModel(), "fastRestart"), FastRestartCheck, false)

    local function UpdateVisibility(ModelRef)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) then
			if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) or Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) then
				GargoyleDialogue:hide()
			else
				GargoyleDialogue:show()
			end
		else
			GargoyleDialogue:hide()
		end
    end

	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), UpdateVisibility)
	GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE), UpdateVisibility)
	
	local function JournalVisibility(ModelRef)
        local NotifyData = Engine.GetModelValue(ModelRef)
        if NotifyData then
            if NotifyData == 0 then
                UpdateVisibility(ModelRef)
            else
                GargoyleDialogue:hide()
            end
        end
    end
    GargoyleDialogue:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "inventoryVisible"), JournalVisibility)
	
    return GargoyleDialogue
end