require "TimedActions/ISBaseTimedAction";

MLGiveBloodAction = ISBaseTimedAction:derive("MLGiveBloodAction");

function MLGiveBloodAction:checkItems()

end

function MLGiveBloodAction:isValid()

    if not self.item then
        return false;
    end

    if ISHealthPanel.DidPatientMove(self.character, self.patient, self.patientX, self.patientY) then
        return false;
    end

    return true;
end

function MLGiveBloodAction:waitToStart()
    self.doctor:faceThisObject(self.patient);
    return self.doctor:shouldBeTurning();
end

function MLGiveBloodAction:update()
    self.doctor:faceThisObject(self.patient);

    self.doctor:setMetabolicTarget(Metabolics.LightDomestic);
end

function MLGiveBloodAction:start()
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

function MLGiveBloodAction:stop()
    ISBaseTimedAction.stop(self);
end

function MLGiveBloodAction:perform()
    ISBaseTimedAction.perform(self);

    -- Get the blood bag, remove it.
    -- Give them a new one full
    -- Set the mod data to the blood type etc.

    -- Set the temp debuff
    self.item:getContainer():DoRemoveItem(self.item);
    sendClientCommand(self.doctor, "MedLine", "ReduceBloodLossDuration", { target = self.patient:getUsername(), efficiency = 100 });
end

function MLGiveBloodAction:new(doctor, patient, bloodBag)
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

