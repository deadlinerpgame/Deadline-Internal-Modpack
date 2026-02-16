

JaxeRevival = JaxeRevival or {};
JaxeRevival.Panel = JaxeRevival.Panel or {};
JaxeRevival.Health = JaxeRevival.Health or {};
JaxeRevival.Incapacitation = JaxeRevival.Incapacitation or {};
JaxeRevival.TimedAction = JaxeRevival.TimedAction or {};

local original_OnGiveUp = JaxeRevival.Panel.onGiveUp;

ScreenWidth = getCore():getScreenWidth();
ScreenHeight = getCore():getScreenHeight();

ModalX = (ScreenWidth / 2) - 380;
ModalY = (ScreenHeight / 2) - 120;

local original_ApplyMechanics = JaxeRevival.Incapacitation.applyMechanics;
local original_SyncApplyEffects = JaxeRevival.Sync.applyEffects;
local original_ReviveAction = JaxeRevival.TimedAction.perform;

JaxeRevival.UI.applyEffectiveHealth = function(value)
  if value then playersHealth = {} end

  local players = isClient() and getOnlinePlayers() or IsoPlayer.getPlayers()
  if not players then return end

  for i = 0, players:size() - 1 do
    local player = players:get(i)
    if player then
      local body = player:isLocalPlayer() and player:getBodyDamage() or player:getBodyDamageRemote()

      if value then
        playersHealth[i] = body:getHealth()
        if JaxeRevival.Incapacitation.isActive(player) then
          body:setOverallBodyHealth(SandboxVars.JaxeRevival.IncapacitatedHealth or 25);
        elseif not player:isDead() then
          body:setOverallBodyHealth(JaxeRevival.UI.getEffectiveHealth(playersHealth[i]))
        end
      else
        body:setOverallBodyHealth(playersHealth[i])
      end
    end
  end
end

function JaxeRevival.TimedAction:perform()
    original_ReviveAction(self);

    self.target:setInvincible(false);
    self.target:clearVariable("ExerciseStarted");
    self.target:clearVariable("ExerciseEnded");
    self.target:setOnFloor(false);
    self.target:setX(self.target:getX());
    self.target:setY(self.target:getY());
    self.target:setZ(self.target:getZ());
    player:setShootable(true);
end

JaxeRevival.Sync.applyEffects = function(player, value)
    --player:setInvincible(value or false);
    sendPlayerExtraInfo(player);

    if value then player:setShootable(false); end;

    original_SyncApplyEffects(player, value);
    --JaxeRevival.Sync.sendClient(player, JaxeRevival.Sync.REVIVE, JaxeRevival.Sync.getArgsFromTarget(player));
end



JaxeRevival.Incapacitation.applyMechanics = function(player, value)
    if not player then return end;

    --player:setInvincible(value or false);
    sendPlayerExtraInfo(player);
    player:setShootable(true); 
    original_ApplyMechanics(player, value);
    --JaxeRevival.Sync.sendClient(player, JaxeRevival.Sync.REVIVE, JaxeRevival.Sync.getArgsFromTarget(player));
end

JaxeRevival.Panel.onGiveUp = function(self)
    -- Get all nearby players, and check if any are within 50 tiles.
    local allPlayers = getOnlinePlayers();
    local numNearby = 0;

    if allPlayers then
        
        for i = 0, allPlayers:size() - 1 do
            
            local distanceSq = 50*50;
            local iteratedPlayer = allPlayers:get(i);

            if getPlayer() ~= iteratedPlayer and getPlayer():getDistanceSq(iteratedPlayer) <= distanceSq then
                numNearby = numNearby + 1;
            end
        end
    end

    if numNearby > 0 then
        local modal = ISModalDialog:new(ModalX, ModalY, 380, 120, "There are other people nearby, you can't give up.", false, self, ISModalDialog.onClick, nil);
        modal:initialise();
        modal:addToUIManager();
        modal:bringToTop();
        return;
    end

    original_OnGiveUp(self);
end

local function OnPlayerUpdate_Revival(player)
    if player ~= getPlayer() then return end;

    if not JaxeRevival then return end;

    local threshold = SandboxVars.JaxeRevival.IncapacitatedHealth;
    if player:getBodyDamage():getOverallBodyHealth() <= threshold then
        player:getBodyDamage():setOverallBodyHealth(threshold);
        if player:isShootable() then
            player:setShootable(false);
        end
    end
end

local function OnWeaponHitCharacter(attacker, target, weapon, damage)
    print("On Weapon Hit Character");
    print("Attacker: " .. attacker:getUsername() .. " | target: " .. target:getUsername() .. " damage: " .. tostring(damage));
    local victimHealth = target:getBodyDamage():getOverallBodyHealth();
    print("Victim health is " .. tostring(victimHealth));
    local threshold = SandboxVars.JaxeRevival.IncapacitatedHealth;
    print("Threshold is " .. tostring(threshold));
    if victimHealth < threshold or victimHealth < (threshold + damage) then
        print("Would go below, setting overall body health and avoiding dmg");
        target:getBodyDamage():setOverallBodyHealth(threshold);
        target:setAvoidDamage(true);
    end

end

Events.OnPlayerUpdate.Add(OnPlayerUpdate_Revival);
Events.OnWeaponHitCharacter.Add(OnWeaponHitCharacter);

--[[local function OnWeaponHitCharacter(attacker, target, weapon, damage)
    if instanceof(attacker, "IsoPlayer") and instanceof(target, "IsoPlayer") then
        if damage > 0 then
            print("damage is " .. tostring(damage));
        end
    end
end



Events.OnWeaponHitCharacter.Add(OnWeaponHitCharacter);--]]