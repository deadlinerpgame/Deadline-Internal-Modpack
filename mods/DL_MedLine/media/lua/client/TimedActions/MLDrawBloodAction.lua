require "TimedActions/ISBaseTimedAction";

MLDrawBloodAction = ISBaseTimedAction:derive("MLDrawBloodAction");

function MLDrawBloodAction:checkItems()

end

function MLDrawBloodAction:isValid()

    if ISHealthPanel.DidPatientMove(self.character, self.patient, self.patientX, self.patientY) then
        return false;
    end

    -- Make sure still have the items.
    if not MedLine_Client.hasItemsForBloodDraw(self.character) then 
        return false;
    end

    return true;
end

function MLDrawBloodAction:waitToStart()
    self.doctor:faceThisObject(self.patient);
    return self.doctor:shouldBeTurning();
end

function MLDrawBloodAction:update()
    self.doctor:faceThisObject(self.patient);

    self.doctor:setMetabolicTarget(Metabolics.LightDomestic);
end

function MLDrawBloodAction:start()
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

function MLDrawBloodAction:stop()
    ISBaseTimedAction.stop(self);
end

function MLDrawBloodAction:perform()
    ISBaseTimedAction.perform(self);

    -- Get the blood bag, remove it.
    -- Give them a new one full
    -- Set the mod data to the blood type etc.

    -- Set the temp debuff.

    local bloodBag = self.doctor:getInventory():getFirstTypeRecurse("MedLine.BloodBag_Empty");
    if not bloodBag then
        self:stop();
        return;
    end

    bloodBag:getContainer():DoRemoveItem(bloodBag);

    local filledBag = InventoryItemFactory.CreateItem("MedLine.BloodBag_Full");
    self.doctor:getInventory():DoAddItem(filledBag);
    ISWorldObjectContextMenu.equip(self.doctor, self.doctor:getPrimaryHandItem(), filledBag, false, false);

    MedLine_Client.setBloodBagData(filledBag, self.patient);
end

function MLDrawBloodAction:new(doctor, patient)
    local o = {};
	setmetatable(o, self);
	self.__index = self;
    o.character = doctor or getPlayer(); -- Required for an ISBaseTimedAction to work.
    o.stopOnWalk = true;
    o.stopOnRun = true;

	o.doctor = doctor;
    o.patient = patient;

    o.patientX = patient:getX();
    o.patientY = patient:getY();

    o.maxTime = 300;
	return o;
end

