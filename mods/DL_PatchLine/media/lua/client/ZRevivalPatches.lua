

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

local original_ApplyMechanics = JaxeRevival.Incapacitation.apply;
local original_ReviveAction = JaxeRevival.TimedAction.perform;

--[[JaxeRevival.UI.applyEffectiveHealth = function(value)
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
end--]]

function JaxeRevival.TimedAction:perform()
    original_ReviveAction(self);

    self.target:setInvincible(false);
    self.target:clearVariable("ExerciseStarted");
    self.target:clearVariable("ExerciseEnded");
    self.target:setOnFloor(false);
    self.target:setX(self.target:getX());
    self.target:setY(self.target:getY());
    self.target:setZ(self.target:getZ());
    --self.target:setShootable(true);
end

JaxeRevival.Incapacitation.apply = function(player, value, serverInitiated)
    if not player then return end;

    --player:setInvincible(value or false);
    --sendPlayerExtraInfo(player);
    --player:setShootable(true);
    original_ApplyMechanics(player, value, serverInitiated);
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
