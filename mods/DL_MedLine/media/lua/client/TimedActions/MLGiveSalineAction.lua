require "TimedActions/ISBaseTimedAction";

MLGiveSalineAction = ISBaseTimedAction:derive("MLGiveSalineAction");

function MLGiveSalineAction:checkItems()

end

function MLGiveSalineAction:isValid()

    if not self.item then
        return false;
    end

    if ISHealthPanel.DidPatientMove(self.character, self.patient, self.patientX, self.patientY) then
        return false;
    end

    return true;
end

function MLGiveSalineAction:waitToStart()
    self.doctor:faceThisObject(self.patient);
    return self.doctor:shouldBeTurning();
end

function MLGiveSalineAction:update()
    self.doctor:faceThisObject(self.patient);

    self.doctor:setMetabolicTarget(Metabolics.LightDomestic);
end

function MLGiveSalineAction:start()
    if self.character == self.patient then
        self:setActionAnim(CharacterActionAnims.Bandage);
        self:setAnimVariable("LootPosition", "mid");
        self.character:reportEvent("EventBandage");
    else
        self:setActionAnim("Loot");
        self.character:SetVariable("LootPosition", "Mid");
        self.character:reportEvent("EventLootItem");
    end
	self:setOverrideHandModels(nil, nil);
end

function MLGiveSalineAction:stop()
    ISBaseTimedAction.stop(self);
end

function MLGiveSalineAction:perform()
    ISBaseTimedAction.perform(self);

    -- Get the blood bag, remove it.
    -- Give them a new one full
    -- Set the mod data to the blood type etc.

    -- Set the temp debuff
    self.item:getContainer():DoRemoveItem(self.item);

    -- Give empty bag of saline.
    local emptySaline = InventoryItemFactory.CreateItem("MedLine.BloodBag_Saline");
    self.doctor:getInventory():DoAddItem(emptySaline);

    sendClientCommand(self.doctor, "MedLine", "ReduceBloodLossDuration", { target = self.patient:getUsername(), efficiency = (SandboxVars.MedLine.BloodLoss_SalineEfficiency or 50) });
end

function MLGiveSalineAction:new(doctor, patient, bloodBag)
    local o = {};
	setmetatable(o, self);
	self.__index = self;
    o.character = doctor or getPlayer(); -- Required for an ISBaseTimedAction to work.
    o.stopOnWalk = true;
    o.stopOnRun = true;

	o.doctor = doctor;
    o.patient = patient;
    o.item = bloodBag;

    o.patientX = patient:getX();
    o.patientY = patient:getY();

    o.maxTime = 300;
	return o;
end

