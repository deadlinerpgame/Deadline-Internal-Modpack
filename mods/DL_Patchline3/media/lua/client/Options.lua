local K_FORCE_VALUES = { 0.5, 0.75, 1.0, 1.25, 1.5, 2.0 }
local SPEED_VALUES = { 20.0, 30.0, 40.0, 50.0, 60.0, 169.0 }
local OPTIONS = {
    CruiseControlSupport = false,
    DisableForSundayDriver = false,
    KForceIndex = 3,        -- 1.0
    TriggerSpeedIndex = 2,  -- 30 km/h
}

drivestraight = drivestraight or {}
drivestraight.K_FORCE_VALUES = K_FORCE_VALUES
drivestraight.SPEED_VALUES = SPEED_VALUES
drivestraight.CruiseControlSupport = OPTIONS.CruiseControlSupport
drivestraight.DisableForSundayDriver = OPTIONS.DisableForSundayDriver
drivestraight.KForceIndex = OPTIONS.KForceIndex
drivestraight.TriggerSpeedIndex = OPTIONS.TriggerSpeedIndex

local function syncToGlobal()
    drivestraight.CruiseControlSupport = OPTIONS.CruiseControlSupport
    drivestraight.DisableForSundayDriver = OPTIONS.DisableForSundayDriver
    drivestraight.KForceIndex = OPTIONS.KForceIndex
    drivestraight.TriggerSpeedIndex = OPTIONS.TriggerSpeedIndex
end

if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(OPTIONS, "drivestraight", "No more wiggly vehicle")

    settings.options_data.CruiseControlSupport.name = "Enable in Cruise Control"
    settings.options_data.DisableForSundayDriver.name = "Disable for Sunday Driver trait"
    settings.options_data.KForceIndex.name = "Alignment force strength"
    settings.options_data.TriggerSpeedIndex.name = "Minimum activation speed"

    local cruiseData = settings:getData("CruiseControlSupport")
    if cruiseData then
        cruiseData.tooltip = "If checked, auto-align works even when you take your hands off the W key during cruise control."
    end
    local sundayData = settings:getData("DisableForSundayDriver")
    if sundayData then
        sundayData.tooltip = "If checked, this mod will not activate for characters with the Sunday Driver trait."
    end

    local kForceData = settings:getData("KForceIndex")
    if kForceData then
        for i, v in ipairs(K_FORCE_VALUES) do
            kForceData[i] = string.format("x%.2f", v)
        end
        kForceData.tooltip = "Strength of the alignment force. Higher = snappier, lower = gentler."
    end

    local speedData = settings:getData("TriggerSpeedIndex")
    if speedData then
        for i, v in ipairs(SPEED_VALUES) do
            speedData[i] = string.format("%d km/h", v)
        end
        speedData.tooltip = "Minimum speed at which auto-align activates."
    end
end

Events.OnGameStart.Add(syncToGlobal)
Events.OnMainMenuEnter.Add(syncToGlobal)