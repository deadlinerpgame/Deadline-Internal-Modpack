DeadlineDice = DeadlineDice or {}

ISDeadlineDiceUI = ISCollapsableWindow:derive("ISDeadlineDiceUI");
DeadlineDice.CombatActive = false
DeadlineDice.turnStartTime = nil
DeadlineDice.turnTimerActive = false
DeadlineDice.turnDuration = 90000
DeadlineDice.tileSteps = 15
DeadlineDice.tileStepsTaken = 0
DeadlineDice.lockedTiles = DeadlineDice.lockedTiles or {}
DeadlineDice.hpTracker = DeadlineDice.hpTracker or {}
DeadlineDice.cover = false
DeadlineDice.initBG = 0
DeadlineDice.option = 1
DeadlineDice.textoption = 1
DeadlineDice.optiontab = 1
DeadlineDice.textpage = 1
DeadlineDice.maxpages = 1
DeadlineDice.maxtabs = 6
DeadlineDice.OptionA = 1
DeadlineDice.OptionB = 2
DeadlineDice.OptionC = 3
DeadlineDice._pageTexCache = {}

DeadlineDice.pageIndexBySubject = DeadlineDice.pageIndexBySubject or {}

DeadlineDice.Subjects = {
  [1] = {
    name = "Introduction",
    pages = {
      "media/ui/tabs/tab01_introduction/p01.png",
    },
  },
  [2] = {
    name = "Actions",
    pages = {
      "media/ui/tabs/tab02_actions/p01.png",
    },
  },
  [3] = {
    name = "Initiating PVP",
    pages = {
      "media/ui/tabs/tab03_initiatingpvp/p01.png",
      "media/ui/tabs/tab03_initiatingpvp/p02.png",
    },
  },
  [4] = {
    name = "First Round",
    pages = {
      "media/ui/tabs/tab04_firstround/p01.png",
      "media/ui/tabs/tab04_firstround/p02.png",
    },
  },
  [5] = {
    name = "Following Rounds",
    pages = {
      "media/ui/tabs/tab05_followingrounds/p01.png",
    },
  },
  [6] = {
    name = "Damage and HP",
    pages = {
      "media/ui/tabs/tab06_damageandhp/p01.png",
      "media/ui/tabs/tab06_damageandhp/p02.png",
    },
  },
  [7] = {
    name = "Critical Hits and Fails",
    pages = {
      "media/ui/tabs/tab07_criticalhitsandfails/p01.png",
      "media/ui/tabs/tab07_criticalhitsandfails/p02.png",
    },
  },
  [8] = {
    name = "Surrendering",
    pages = {
      "media/ui/tabs/tab08_surrendering/p01.png",
      "media/ui/tabs/tab08_surrendering/p02.png",
      "media/ui/tabs/tab08_surrendering/p03.png",
      "media/ui/tabs/tab08_surrendering/p04.png",
      "media/ui/tabs/tab08_surrendering/p05.png",
      "media/ui/tabs/tab08_surrendering/p06.png",
      "media/ui/tabs/tab08_surrendering/p07.png",
      "media/ui/tabs/tab08_surrendering/p08.png",
    },
  },
  [9] = {
    name = "Escape",
    pages = {
      "media/ui/tabs/tab09_escape/p01.png",
      "media/ui/tabs/tab09_escape/p02.png",
      "media/ui/tabs/tab09_escape/p03.png",
      "media/ui/tabs/tab09_escape/p04.png",
      "media/ui/tabs/tab09_escape/p05.png",
      "media/ui/tabs/tab09_escape/p06.png",
    },
  },
  [10] = {
    name = "Movement",
    pages = {
      "media/ui/tabs/tab10_movement/p01.png",
    },
  },
  [11] = {
    name = "Grappling",
    pages = {
      "media/ui/tabs/tab11_grappling/p01.png",
      "media/ui/tabs/tab11_grappling/p02.png",
      "media/ui/tabs/tab11_grappling/p03.png",
      "media/ui/tabs/tab11_grappling/p04.png",
    },
  },
  [12] = {
    name = "Attack of Opportunity",
    pages = {
      "media/ui/tabs/tab12_attackofopportunity/p01.png",
      "media/ui/tabs/tab12_attackofopportunity/p02.png",
      "media/ui/tabs/tab12_attackofopportunity/p03.png",
      "media/ui/tabs/tab12_attackofopportunity/p04.png",
    },
  },
  [13] = {
    name = "Cover",
    pages = {
      "media/ui/tabs/tab13_cover/p01.png",
    },
  },
  [14] = {
    name = "Throwing",
    pages = {
      "media/ui/tabs/tab14_throwing/p01.png",
      "media/ui/tabs/tab14_throwing/p02.png",
      "media/ui/tabs/tab14_throwing/p03.png",
    },
  },
  [15] = {
    name = "Dice With Death",
    pages = {
      "media/ui/tabs/tab15_dicewithdeath/p01.png",
      "media/ui/tabs/tab15_dicewithdeath/p02.png",
      "media/ui/tabs/tab15_dicewithdeath/p03.png",
      "media/ui/tabs/tab15_dicewithdeath/p04.png",
    },
  },
  [16] = {
    name = "Scene Sanctity",
    pages = {
      "media/ui/tabs/tab16_scenesanctity/p01.png",
    },
  },
  [17] = {
    name = "Hostile RP with Cars",
    pages = {
      "media/ui/tabs/tab17_hostilerpwithcars/p01.png",
      "media/ui/tabs/tab17_hostilerpwithcars/p02.png",
      "media/ui/tabs/tab17_hostilerpwithcars/p03.png",
    },
  },
  [18] = {
    name = "Roadblocks",
    pages = {
      "media/ui/tabs/tab18_roadblocks/p01.png",
      "media/ui/tabs/tab18_roadblocks/p02.png",
      "media/ui/tabs/tab18_roadblocks/p03.png",
      "media/ui/tabs/tab18_roadblocks/p04.png",
      "media/ui/tabs/tab18_roadblocks/p05.png",
      "media/ui/tabs/tab18_roadblocks/p06.png",
    },
  },
}



--************************************************************************--
--** ISDeadlineDiceUI:initialise
--**
--************************************************************************--

local function applyImageStates(btn, texN, texH, texP)
    btn._texN, btn._texH, btn._texP = texN, (texH or texN), (texP or texH or texN)
    btn:setImage(texN)
    if btn._imgStatesHooked then return end
    btn._imgStatesHooked = true
    local baseRender = btn.render
    function btn:render()
        self.image = (not self.enable) and self._texN
                  or (self.pressed and self._texP)
                  or (self.mouseOver and self._texH)
                  or self._texN
        baseRender(self)
    end
end


function ISDeadlineDiceUI:createLabelWithButton(yPos, labelText)
    local label = ISLabel:new(25, yPos, 10, labelText, 1, 1, 1, 1, UIFont.NewMedium, true)

    self:addChild(label)

    local button = ISButton:new(label.x + 130, label.y - 10, 80, 35, "", self,
        function() self:getScore(labelText) end)
        
    button:initialise()
    button:instantiate()
    button:setImage(getTexture("media/ui/diceicon.png"))

    button.borderColor = { r = 1, g = 1, b = 1, a = 0 }
    button.tooltip = "Roll dice for: " .. labelText
    button.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
button.backgroundColorMouseOver = { r = 1, g = 1, b = 1, a = 0.1 } -- optional slight hover effect
button.borderColor = { r = 1, g = 1, b = 1, a = 0 } -- border fully invisible
    self:addChild(button)

    local pair = { label = label, button = button }
    table.insert(self.buttons, pair)

    return pair
end



function ISDeadlineDiceUI:getEditedLabel(labelText)
    local editedLabel = string.gsub(labelText, "%s", "")   -- Remove spaces
    editedLabel = string.gsub(editedLabel, "[()%(%)]", "") -- Remove parentheses
    editedLabel = string.gsub(editedLabel, "-", "")        -- Remove hyphens
    editedLabel = string.gsub(editedLabel, "/", "")        -- Remove slashes
    return editedLabel
end

function ISDeadlineDiceUI:createChildren()
    self.buttons = {}
    self.healthButtons = {}
    self.sayQueue = {}
    local y = 40
    local f = 0.8
    

    ISCollapsableWindow.createChildren(self)

    -- Add hit points bars and buttons and labels

    self.minusButton = ISButton:new(540, 8, 59, 28, "", self,
        function() self:decreaseHitPoints() end)
    self.minusButton:initialise()
    self.minusButton:instantiate()
    self.minusButton.tooltip = "Decrease Hit Points"
    self.minusButton:setImage(getTexture("media/ui/btnHPDown.png"))
    self.minusButton:setBackgroundRGBA(0, 0.5, 0, 0)             -- Green background
    self.minusButton:setBorderRGBA(0, 1, 0, 0)                   -- Green border
    self.minusButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0) -- Light green background on mouse-over
    self:addChild(self.minusButton)
    table.insert(self.healthButtons, self.minusButton)

    local btnNormal            = getTexture("media/ui/btnHPDown.png")
    local btnSelected          = getTexture("media/ui/btnHPDownSelected.png")
    local btnClicked          = getTexture("media/ui/btnHPDownClicked.png")
    applyImageStates(self.minusButton, btnNormal, btnSelected, btnClicked)


    self.plusButton = ISButton:new(470, 8, 61, 28, "", self,
        function() self:increaseHitPoints() end)
    self.plusButton:initialise()
    self.plusButton:instantiate()
    self.plusButton:setImage(getTexture("media/ui/btnHPUp.png"))
    self.plusButton.tooltip = "Increase Hit Points"
    self.plusButton:setBackgroundRGBA(0, 0.5, 0, 0)             -- Green background
    self.plusButton:setBorderRGBA(0, 1, 0, 0)                   -- Green border
    self.plusButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0) -- Light green background on mouse-over
    self:addChild(self.plusButton)
    table.insert(self.healthButtons, self.plusButton)

    local btnNormal            = getTexture("media/ui/btnHPUp.png")
    local btnSelected          = getTexture("media/ui/btnHPUpSelected.png")
    local btnClicked          = getTexture("media/ui/btnHPUpClicked.png")
    applyImageStates(self.plusButton, btnNormal, btnSelected, btnClicked)

    -- Create hit points label
    self.hitPointsLabel = ISLabel:new(175, 40, 10, "Hit point tracker: ",
        1, 1, 1, 0, UIFont.NewLarge, false)
    self:addChild(self.hitPointsLabel)

    self.resetButton = ISButton:new(610, 8, 64, 28, "", self,
        function() self:resetHitPoints() end)
    self.resetButton:initialise()
    self.resetButton:instantiate()
    self.resetButton.tooltip = "Reset Hit Points"
    self.resetButton:setImage(getTexture("media/ui/btnReset.png"))
    self.resetButton:setBackgroundRGBA(0, 0.5, 0, 0)             -- Green background
    self.resetButton:setBorderRGBA(0, 1, 0, 0)                   -- Green border
    self.resetButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0) -- Light green background on mouse-over
    self:addChild(self.resetButton)
    table.insert(self.healthButtons, self.resetButton)

    local btnNormal            = getTexture("media/ui/btnReset.png")
    local btnSelected          = getTexture("media/ui/btnResetSelected.png")
    local btnClicked          = getTexture("media/ui/btnResetClicked.png")
    applyImageStates(self.resetButton, btnNormal, btnSelected, btnClicked)
    

    self.DWDButton = ISButton:new(690, 8, 34, 28, "", self,
        function() self:getScore("Dice with Death") end)
    self.DWDButton:initialise()
    self.DWDButton:instantiate()
    self.DWDButton.tooltip = "Dice with Death"
    self.DWDButton:setImage(getTexture("media/ui/btnDWD.png"))
    self.DWDButton:setBackgroundRGBA(0, 0.5, 0, 0)             -- Green background
    self.DWDButton:setBorderRGBA(0, 1, 0, 0)                   -- Green border
    self.DWDButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0) -- Light green background on mouse-over
    self:addChild(self.DWDButton)
    table.insert(self.healthButtons, self.DWDButton)

    local btnNormal            = getTexture("media/ui/btnDWD.png")
    local btnSelected          = getTexture("media/ui/btnDWDSelected.png")
    local btnClicked          = getTexture("media/ui/btnDWDClicked.png")
    applyImageStates(self.DWDButton, btnNormal, btnSelected, btnClicked)


    -- Calculate position for hit points bars
    if getPlayer():HasTrait("Sturdy") then
        numBars = 14
        barWidth = 25
        barHeight = 25
        barSpacing = 5
    elseif getPlayer():HasTrait("Fragile") then
        numBars = 10
        barWidth = 35
        barHeight = 25
        barSpacing = 5
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") then
        numBars = 12
        barWidth = 30
        barHeight = 25
        barSpacing = 5
    end

    local totalWidth = numBars * (barWidth + barSpacing) - barSpacing
    local startX = (self.width - totalWidth) / 2 - 130
    local yPos = self.hitPointsLabel:getBottom() - 40

    self.hitPointsBars = {}

for i = 0, numBars do
    local x = startX + (i - 1) * (barWidth + barSpacing)
    local pip = ISButton:new(x, yPos, barWidth, barHeight, "", self, function()
        self:changeHitPoints(i)
        self:updateHitPointsBars()
    end)

    pip:initialise()
    pip:instantiate()
    pip:setVisible(true)
    pip:setAnchorLeft(true)
    pip:setAnchorRight(true)
    pip:setAnchorTop(true)
    pip:setAnchorBottom(true)
    pip.tooltip = "Set HP to " .. i
    pip.borderColor = { r = 0, g = 0, b = 0, a = 0 } -- Optional: hide border
    pip:setBackgroundRGBA(0, 0, 0, 0) -- Transparent background
    pip:setBackgroundColorMouseOverRGBA(1, 1, 1, 0) -- Light green background on mouse-over
    self:addChild(pip)
    table.insert(self.hitPointsBars, pip)
end

    y = yPos + barHeight + 20

    self.buttonGroups = {}
    local currentGroup = {}
    table.insert(self.buttonGroups, currentGroup)    
--[[
self.buttonGroups = {}
local currentGroup = {}
table.insert(self.buttonGroups, currentGroup)

local pair = self:createLabelWithButton(y, "Attack"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Defend (Close)"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Defend (Ranged)"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Escape / Stop Escape"); y = y + 40; table.insert(currentGroup, pair)

-- New group: Perception
currentGroup = {}
table.insert(self.buttonGroups, currentGroup)

pair = self:createLabelWithButton(y, "Sneak"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Notice"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Physical Endurance"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Mental Endurance"); y = y + 40; table.insert(currentGroup, pair)

-- New group: Skills
currentGroup = {}
table.insert(self.buttonGroups, currentGroup)

pair = self:createLabelWithButton(y, "Carpentry"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Cooking"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Electrical"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Farming"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "First Aid"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Mechanics"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Metalworking"); y = y + 40; table.insert(currentGroup, pair)
pair = self:createLabelWithButton(y, "Tailoring"); y = y + 40; table.insert(currentGroup, pair)

-- currentGroup = {}
-- table.insert(self.buttonGroups, currentGroup)
-- pair = self:createLabelWithButton(y, "Skill-less Roll"); y = y + 40; table.insert(currentGroup, pair)
]]
--[[
self.showBorderChk = ISTickBox:new(20, y, 180, 20, "", self, 
    function()
        DeadlineDice.cover = not DeadlineDice.cover
        print(DeadlineDice.cover)
    end)
self.showBorderChk:initialise()
self.showBorderChk:instantiate()
self.showBorderChk:addOption("In Cover?")         -- index 1
self.showBorderChk:setSelected(1, false)            -- start unchecked
self:addChild(self.showBorderChk)


    self.closeButton = ISButton:new(40 * f - 10, y + 25, 70 * f, 30, "Close", self,
        ISDeadlineDiceUI.close);
    self.closeButton.anchorTop = false
    self.closeButton.anchorBottom = true
    self.closeButton:initialise();
    self.closeButton:instantiate();
    self.closeButton.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self.closeButton:setBackgroundRGBA(0, 0, 0, 0)
    self:addChild(self.closeButton);
]]


local buttonWidth = 100
local buttonHeight = 60
local margin = 20


local x = self.width - buttonWidth - margin - 50



-----------

self.groupCombatButtonActive = ISButton:new(x - 600, 560, 159, 36, "", self,
    function()
        
    end)
self.groupCombatButtonActive:setImage(getTexture("media/ui/btnGroupCombatSelected.png"))
self.groupCombatButtonActive:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupCombatButtonActive:setBorderRGBA(0, 1, 0, 0)
self.groupCombatButtonActive:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupCombatButtonActive:setBackgroundRGBA(0, 0, 0, 0)
self.groupCombatButtonActive:initialise()
self.groupCombatButtonActive:setVisible(true)
self.groupCombatButtonActive:instantiate()
self.groupCombatButtonActive:setAnchorRight(true)
self.groupCombatButtonActive:setAnchorTop(true)
self:addChild(self.groupCombatButtonActive)

self.groupCombatButton = ISButton:new(x - 600, 560, 159, 36, "", self,
    function()
        self.groupCombatButton:setVisible(false)
        self.groupStealthButton:setVisible(true)
        self.groupEnduranceButton:setVisible(true)
        self.groupCraftingButton:setVisible(true)
        self.groupStealthButtonActive:setVisible(false)
        self.groupEnduranceButtonActive:setVisible(false)
        self.groupCraftingButtonActive:setVisible(false)
        self.groupCombatButtonActive:setVisible(true)

        self.RollAttack:setVisible(true)
        self.RollDefMelee:setVisible(true)
        self.RollDefRanged:setVisible(true)
        self.RollEscape:setVisible(true)
        self.RollFirstAid:setVisible(true)
        self.RollThrow:setVisible(true)

        self.RollSneak:setVisible(false)
        self.RollNotice:setVisible(false)

        self.RollPhys:setVisible(false)
        self.RollMent:setVisible(false)

        self.RollCarpentry:setVisible(false)
        self.RollMetalworking:setVisible(false)
        self.RollCooking:setVisible(false)
        self.RollFarming:setVisible(false)
        self.RollElectrical:setVisible(false)
        self.RollMechanics:setVisible(false)
        self.RollTailoring:setVisible(false)
        self.RollSkillless:setVisible(false)


        DeadlineDice.option = 1
        
    end)
self.groupCombatButton:setImage(getTexture("media/ui/btnGroupCombat.png"))
self.groupCombatButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupCombatButton:setBorderRGBA(0, 1, 0, 0)
self.groupCombatButton:setVisible(false)
self.groupCombatButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupCombatButton:setBackgroundRGBA(0, 0, 0, 0)
self.groupCombatButton:initialise()
self.groupCombatButton:instantiate()
self.groupCombatButton:setAnchorRight(true)
self.groupCombatButton:setAnchorTop(true)
self:addChild(self.groupCombatButton)

    local btnNormal            = getTexture("media/ui/btnGroupCombat.png")
    local btnSelected          = getTexture("media/ui/btnGroupCombatSelected.png")
    local btnClicked          = getTexture("media/ui/btnGroupCombatSelected.png")
    applyImageStates(self.groupCombatButton, btnNormal, btnSelected, btnClicked)
self.groupCombatButton:setVisible(false)





self.groupStealthButtonActive = ISButton:new(x - 460, 560, 159, 36, "", self,
    function()
        
    end)
self.groupStealthButtonActive:setImage(getTexture("media/ui/btnGroupStealthSelected.png"))
self.groupStealthButtonActive:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupStealthButtonActive:setBorderRGBA(0, 1, 0, 0)
self.groupStealthButtonActive:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupStealthButtonActive:setBackgroundRGBA(0, 0, 0, 0)
self.groupStealthButtonActive:initialise()
self.groupStealthButtonActive:setVisible(false)
self.groupStealthButtonActive:instantiate()
self.groupStealthButtonActive:setAnchorRight(true)
self.groupStealthButtonActive:setAnchorTop(true)
self:addChild(self.groupStealthButtonActive)

self.groupStealthButton = ISButton:new(x - 460, 560, 159, 36, "", self,
    function()
        self.groupCombatButton:setVisible(true)
        self.groupStealthButton:setVisible(false)
        self.groupEnduranceButton:setVisible(true)
        self.groupCraftingButton:setVisible(true)
        self.groupStealthButtonActive:setVisible(true)
        self.groupEnduranceButtonActive:setVisible(false)
        self.groupCraftingButtonActive:setVisible(false)
        self.groupCombatButtonActive:setVisible(false)

        self.RollAttack:setVisible(false)
        self.RollDefMelee:setVisible(false)
        self.RollDefRanged:setVisible(false)
        self.RollEscape:setVisible(false)
        self.RollFirstAid:setVisible(false)
        self.RollThrow:setVisible(false)

        self.RollSneak:setVisible(true)
        self.RollNotice:setVisible(true)

        self.RollPhys:setVisible(false)
        self.RollMent:setVisible(false)

        self.RollCarpentry:setVisible(false)
        self.RollMetalworking:setVisible(false)
        self.RollCooking:setVisible(false)
        self.RollFarming:setVisible(false)
        self.RollElectrical:setVisible(false)
        self.RollMechanics:setVisible(false)
        self.RollTailoring:setVisible(false)
        self.RollSkillless:setVisible(false)
        DeadlineDice.option = 2
        
    end)
self.groupStealthButton:setImage(getTexture("media/ui/btnGroupStealth.png"))
self.groupStealthButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupStealthButton:setBorderRGBA(0, 1, 0, 0)
self.groupStealthButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupStealthButton:setBackgroundRGBA(0, 0, 0, 0)
self.groupStealthButton:initialise()
self.groupStealthButton:instantiate()
self.groupStealthButton:setAnchorRight(true)
self.groupStealthButton:setAnchorTop(true)
self:addChild(self.groupStealthButton)

    local btnNormal            = getTexture("media/ui/btnGroupStealth.png")
    local btnSelected          = getTexture("media/ui/btnGroupStealthSelected.png")
    local btnClicked          = getTexture("media/ui/btnGroupStealthSelected.png")
    applyImageStates(self.groupStealthButton, btnNormal, btnSelected, btnClicked) 



self.groupEnduranceButtonActive = ISButton:new(x - 320, 560, 159, 36, "", self,
    function()
        
    end)
self.groupEnduranceButtonActive:setImage(getTexture("media/ui/btnGroupEnduranceSelected.png"))
self.groupEnduranceButtonActive:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupEnduranceButtonActive:setBorderRGBA(0, 1, 0, 0)
self.groupEnduranceButtonActive:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupEnduranceButtonActive:setBackgroundRGBA(0, 0, 0, 0)
self.groupEnduranceButtonActive:initialise()
self.groupEnduranceButtonActive:setVisible(false)
self.groupEnduranceButtonActive:instantiate()
self.groupEnduranceButtonActive:setAnchorRight(true)
self.groupEnduranceButtonActive:setAnchorTop(true)
self:addChild(self.groupEnduranceButtonActive)

self.groupEnduranceButton = ISButton:new(x - 320, 560, 159, 36, "", self,
    function()
        self.groupCombatButton:setVisible(true)
        self.groupStealthButton:setVisible(true)
        self.groupEnduranceButton:setVisible(false)
        self.groupCraftingButton:setVisible(true)
        self.groupStealthButtonActive:setVisible(false)
        self.groupEnduranceButtonActive:setVisible(true)
        self.groupCraftingButtonActive:setVisible(false)
        self.groupCombatButtonActive:setVisible(false)

        self.RollAttack:setVisible(false)
        self.RollDefMelee:setVisible(false)
        self.RollDefRanged:setVisible(false)
        self.RollEscape:setVisible(false)
        self.RollFirstAid:setVisible(false)
        self.RollThrow:setVisible(false)

        self.RollSneak:setVisible(false)
        self.RollNotice:setVisible(false)

        self.RollPhys:setVisible(true)
        self.RollMent:setVisible(true)

        self.RollCarpentry:setVisible(false)
        self.RollMetalworking:setVisible(false)
        self.RollCooking:setVisible(false)
        self.RollFarming:setVisible(false)
        self.RollElectrical:setVisible(false)
        self.RollMechanics:setVisible(false)
        self.RollTailoring:setVisible(false)
        self.RollSkillless:setVisible(false)

        DeadlineDice.option = 2
        
    end)
self.groupEnduranceButton:setImage(getTexture("media/ui/btnGroupEndurance.png"))
self.groupEnduranceButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupEnduranceButton:setBorderRGBA(0, 1, 0, 0)
self.groupEnduranceButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupEnduranceButton:setBackgroundRGBA(0, 0, 0, 0)
self.groupEnduranceButton:initialise()
self.groupEnduranceButton:instantiate()
self.groupEnduranceButton:setAnchorRight(true)
self.groupEnduranceButton:setAnchorTop(true)
self:addChild(self.groupEnduranceButton)

    local btnNormal            = getTexture("media/ui/btnGroupEndurance.png")
    local btnSelected          = getTexture("media/ui/btnGroupEnduranceSelected.png")
    local btnClicked          = getTexture("media/ui/btnGroupEnduranceSelected.png")
    applyImageStates(self.groupEnduranceButton, btnNormal, btnSelected, btnClicked) 



self.groupCraftingButtonActive = ISButton:new(x - 180, 560, 159, 36, "", self,
    function()
        
    end)
self.groupCraftingButtonActive:setImage(getTexture("media/ui/btnGroupCraftingSelected.png"))
self.groupCraftingButtonActive:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupCraftingButtonActive:setBorderRGBA(0, 1, 0, 0)
self.groupCraftingButtonActive:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupCraftingButtonActive:setBackgroundRGBA(0, 0, 0, 0)
self.groupCraftingButtonActive:initialise()
self.groupCraftingButtonActive:setVisible(false)
self.groupCraftingButtonActive:instantiate()
self.groupCraftingButtonActive:setAnchorRight(true)
self.groupCraftingButtonActive:setAnchorTop(true)
self:addChild(self.groupCraftingButtonActive)

self.groupCraftingButton = ISButton:new(x - 180, 560, 159, 36, "", self,
    function()
        self.groupCombatButton:setVisible(true)
        self.groupStealthButton:setVisible(true)
        self.groupEnduranceButton:setVisible(true)
        self.groupCraftingButton:setVisible(false)
        self.groupStealthButtonActive:setVisible(false)
        self.groupEnduranceButtonActive:setVisible(false)
        self.groupCraftingButtonActive:setVisible(true)
        self.groupCombatButtonActive:setVisible(false)

        self.RollAttack:setVisible(false)
        self.RollDefMelee:setVisible(false)
        self.RollDefRanged:setVisible(false)
        self.RollEscape:setVisible(false)
        self.RollFirstAid:setVisible(false)
        self.RollThrow:setVisible(false)

        self.RollSneak:setVisible(false)
        self.RollNotice:setVisible(false)

        self.RollPhys:setVisible(false)
        self.RollMent:setVisible(false)

        self.RollCarpentry:setVisible(true)
        self.RollMetalworking:setVisible(true)
        self.RollCooking:setVisible(true)
        self.RollFarming:setVisible(true)
        self.RollElectrical:setVisible(true)
        self.RollMechanics:setVisible(true)
        self.RollTailoring:setVisible(true)
        self.RollSkillless:setVisible(true)

        DeadlineDice.option = 3
        
    end)
self.groupCraftingButton:setImage(getTexture("media/ui/btnGroupCrafting.png"))
self.groupCraftingButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.groupCraftingButton:setBorderRGBA(0, 1, 0, 0)
self.groupCraftingButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.groupCraftingButton:setBackgroundRGBA(0, 0, 0, 0)
self.groupCraftingButton:initialise()
self.groupCraftingButton:instantiate()
self.groupCraftingButton:setAnchorRight(true)
self.groupCraftingButton:setAnchorTop(true)
self:addChild(self.groupCraftingButton)

    local btnNormal            = getTexture("media/ui/btnGroupCrafting.png")
    local btnSelected          = getTexture("media/ui/btnGroupCraftingSelected.png")
    local btnClicked          = getTexture("media/ui/btnGroupCraftingSelected.png")
    applyImageStates(self.groupCraftingButton, btnNormal, btnSelected, btnClicked) 

    
    --- ROLL BUTTONS ---


self.RollSneak = ISButton:new(x - 580, 605, 257, 42, "", self,
    function()
    self:getScore("Sneak") 
        
    end)
self.RollSneak:setImage(getTexture("media/ui/btnRollSneak.png"))
self.RollSneak:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollSneak:setBorderRGBA(0, 1, 0, 0)
self.RollSneak:setVisible(false)
self.RollSneak:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollSneak:setBackgroundRGBA(0, 0, 0, 0)
self.RollSneak:initialise()
self.RollSneak:instantiate()
self.RollSneak:setAnchorRight(true)
self.RollSneak:setAnchorTop(true)
self:addChild(self.RollSneak)
local btnNormal            = getTexture("media/ui/btnRollSneak.png")
local btnSelected          = getTexture("media/ui/btnRollSneakSelected.png")
local btnClicked          = getTexture("media/ui/btnRollSneakSelected.png")
applyImageStates(self.RollSneak, btnNormal, btnSelected, btnClicked) 

--

self.RollPhys = ISButton:new(x - 580, 605, 257, 42, "", self,
    function()
    self:getScore("Physical Endurance") 
        
    end)
self.RollPhys:setImage(getTexture("media/ui/btnRollPhys.png"))
self.RollPhys:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollPhys:setBorderRGBA(0, 1, 0, 0)
self.RollPhys:setVisible(false)
self.RollPhys:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollPhys:setBackgroundRGBA(0, 0, 0, 0)
self.RollPhys:initialise()
self.RollPhys:instantiate()
self.RollPhys:setAnchorRight(true)
self.RollPhys:setAnchorTop(true)
self:addChild(self.RollPhys)
local btnNormal            = getTexture("media/ui/btnRollPhys.png")
local btnSelected          = getTexture("media/ui/btnRollPhysSelected.png")
local btnClicked          = getTexture("media/ui/btnRollPhysSelected.png")
applyImageStates(self.RollPhys, btnNormal, btnSelected, btnClicked) 

--

self.RollCarpentry = ISButton:new(x - 580, 605, 257, 42, "", self,
    function()
    self:getScore("Carpentry") 
        
    end)
self.RollCarpentry:setImage(getTexture("media/ui/btnRollCarpentry.png"))
self.RollCarpentry:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollCarpentry:setBorderRGBA(0, 1, 0, 0)
self.RollCarpentry:setVisible(false)
self.RollCarpentry:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollCarpentry:setBackgroundRGBA(0, 0, 0, 0)
self.RollCarpentry:initialise()
self.RollCarpentry:instantiate()
self.RollCarpentry:setAnchorRight(true)
self.RollCarpentry:setAnchorTop(true)
self:addChild(self.RollCarpentry)
local btnNormal            = getTexture("media/ui/btnRollCarpentry.png")
local btnSelected          = getTexture("media/ui/btnRollCarpentrySelected.png")
local btnClicked          = getTexture("media/ui/btnRollCarpentrySelected.png")
applyImageStates(self.RollCarpentry, btnNormal, btnSelected, btnClicked) 

--

self.RollAttack = ISButton:new(x - 580, 605, 257, 42, "", self,
    function()
    self:getScore("Attack") 
    
        
    end)
self.RollAttack:setImage(getTexture("media/ui/btnRollAttack.png"))
self.RollAttack:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollAttack:setBorderRGBA(0, 1, 0, 0)
self.RollAttack:setVisible(true)
self.RollAttack:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollAttack:setBackgroundRGBA(0, 0, 0, 0)
self.RollAttack:initialise()
self.RollAttack:instantiate()
self.RollAttack:setAnchorRight(true)
self.RollAttack:setAnchorTop(true)
self:addChild(self.RollAttack)
local btnNormal            = getTexture("media/ui/btnRollAttack.png")
local btnSelected          = getTexture("media/ui/btnRollAttackSelected.png")
local btnClicked          = getTexture("media/ui/btnRollAttackSelected.png")
applyImageStates(self.RollAttack, btnNormal, btnSelected, btnClicked) 


---

self.RollNotice = ISButton:new(x - 580, 655, 257, 42, "", self,
    function()
    self:getScore("Notice") 
        
    end)
self.RollNotice:setImage(getTexture("media/ui/btnRollNotice.png"))
self.RollNotice:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollNotice:setBorderRGBA(0, 1, 0, 0)
self.RollNotice:setVisible(false)
self.RollNotice:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollNotice:setBackgroundRGBA(0, 0, 0, 0)
self.RollNotice:initialise()
self.RollNotice:instantiate()
self.RollNotice:setAnchorRight(true)
self.RollNotice:setAnchorTop(true)
self:addChild(self.RollNotice)
local btnNormal            = getTexture("media/ui/btnRollNotice.png")
local btnSelected          = getTexture("media/ui/btnRollNoticeSelected.png")
local btnClicked          = getTexture("media/ui/btnRollNoticeSelected.png")
applyImageStates(self.RollNotice, btnNormal, btnSelected, btnClicked) 

--

self.RollMent = ISButton:new(x - 580, 655, 257, 42, "", self,
    function()
    self:getScore("Mental Endurance") 
        
    end)
self.RollMent:setImage(getTexture("media/ui/btnRollMent.png"))
self.RollMent:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollMent:setBorderRGBA(0, 1, 0, 0)
self.RollMent:setVisible(false)
self.RollMent:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollMent:setBackgroundRGBA(0, 0, 0, 0)
self.RollMent:initialise()
self.RollMent:instantiate()
self.RollMent:setAnchorRight(true)
self.RollMent:setAnchorTop(true)
self:addChild(self.RollMent)
local btnNormal            = getTexture("media/ui/btnRollMent.png")
local btnSelected          = getTexture("media/ui/btnRollMentSelected.png")
local btnClicked          = getTexture("media/ui/btnRollMentSelected.png")
applyImageStates(self.RollMent, btnNormal, btnSelected, btnClicked) 

--

self.RollCooking = ISButton:new(x - 580, 655, 257, 42, "", self,
    function()
    self:getScore("Cooking") 
        
    end)
self.RollCooking:setImage(getTexture("media/ui/btnRollCooking.png"))
self.RollCooking:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollCooking:setBorderRGBA(0, 1, 0, 0)
self.RollCooking:setVisible(false)
self.RollCooking:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollCooking:setBackgroundRGBA(0, 0, 0, 0)
self.RollCooking:initialise()
self.RollCooking:instantiate()
self.RollCooking:setAnchorRight(true)
self.RollCooking:setAnchorTop(true)
self:addChild(self.RollCooking)
local btnNormal            = getTexture("media/ui/btnRollCooking.png")
local btnSelected          = getTexture("media/ui/btnRollCookingSelected.png")
local btnClicked          = getTexture("media/ui/btnRollCookingSelected.png")
applyImageStates(self.RollCooking, btnNormal, btnSelected, btnClicked) 

--

self.RollDefMelee = ISButton:new(x - 580, 655, 257, 42, "", self,
    function()
    self:getScore("Defend (Close)") 
        
    end)
self.RollDefMelee:setImage(getTexture("media/ui/btnRollDefMelee.png"))
self.RollDefMelee:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollDefMelee:setBorderRGBA(0, 1, 0, 0)
self.RollDefMelee:setVisible(false)
self.RollDefMelee:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollDefMelee:setBackgroundRGBA(0, 0, 0, 0)
self.RollDefMelee:initialise()
self.RollDefMelee:instantiate()
self.RollDefMelee:setAnchorRight(true)
self.RollDefMelee:setAnchorTop(true)
self:addChild(self.RollDefMelee)
local btnNormal            = getTexture("media/ui/btnRollDefMelee.png")
local btnSelected          = getTexture("media/ui/btnRollDefMeleeSelected.png")
local btnClicked          = getTexture("media/ui/btnRollDefMeleeSelected.png")
applyImageStates(self.RollDefMelee, btnNormal, btnSelected, btnClicked) 

---


self.RollElectrical = ISButton:new(x - 580, 705, 257, 42, "", self,
    function()
    self:getScore("Electrical") 
        
    end)

self.RollElectrical:setImage(getTexture("media/ui/btnRollElectrical.png"))
self.RollElectrical:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollElectrical:setBorderRGBA(0, 1, 0, 0)
self.RollElectrical:setVisible(false)
self.RollElectrical:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollElectrical:setBackgroundRGBA(0, 0, 0, 0)
self.RollElectrical:initialise()
self.RollElectrical:instantiate()
self.RollElectrical:setAnchorRight(true)
self.RollElectrical:setAnchorTop(true)
self:addChild(self.RollElectrical)
local btnNormal            = getTexture("media/ui/btnRollElectrical.png")
local btnSelected          = getTexture("media/ui/btnRollElectricalSelected.png")
local btnClicked          = getTexture("media/ui/btnRollElectricalSelected.png")
applyImageStates(self.RollElectrical, btnNormal, btnSelected, btnClicked) 


--
self.RollDefRanged = ISButton:new(x - 580, 705, 257, 42, "", self,
    function()
    self:getScore("Defend (Ranged)") 
        
    end)

self.RollDefRanged:setImage(getTexture("media/ui/btnRollDefRanged.png"))
self.RollDefRanged:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollDefRanged:setBorderRGBA(0, 1, 0, 0)
self.RollDefRanged:setVisible(false)
self.RollDefRanged:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollDefRanged:setBackgroundRGBA(0, 0, 0, 0)
self.RollDefRanged:initialise()
self.RollDefRanged:instantiate()
self.RollDefRanged:setAnchorRight(true)
self.RollDefRanged:setAnchorTop(true)
self:addChild(self.RollDefRanged)
local btnNormal            = getTexture("media/ui/btnRollDefRanged.png")
local btnSelected          = getTexture("media/ui/btnRollDefRangedSelected.png")
local btnClicked          = getTexture("media/ui/btnRollDefRangedSelected.png")
applyImageStates(self.RollDefRanged, btnNormal, btnSelected, btnClicked) 

---

self.RollMetalworking = ISButton:new(x - 300, 605, 257, 42, "", self,
    function()
    self:getScore("Metalworking") 
        
    end)
self.RollMetalworking:setImage(getTexture("media/ui/btnRollMetalworking.png"))
self.RollMetalworking:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollMetalworking:setBorderRGBA(0, 1, 0, 0)
self.RollMetalworking:setVisible(false)
self.RollMetalworking:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollMetalworking:setBackgroundRGBA(0, 0, 0, 0)
self.RollMetalworking:initialise()
self.RollMetalworking:instantiate()
self.RollMetalworking:setAnchorRight(true)
self.RollMetalworking:setAnchorTop(true)
self:addChild(self.RollMetalworking)
local btnNormal            = getTexture("media/ui/btnRollMetalworking.png")
local btnSelected          = getTexture("media/ui/btnRollMetalworkingSelected.png")
local btnClicked          = getTexture("media/ui/btnRollMetalworkingSelected.png")
applyImageStates(self.RollMetalworking, btnNormal, btnSelected, btnClicked) 

--

self.RollThrow = ISButton:new(x - 300, 605, 257, 42, "", self,
    function()
    self:getScore("Throwing") 
        
    end)
self.RollThrow:setImage(getTexture("media/ui/btnRollThrow.png"))
self.RollThrow:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollThrow:setBorderRGBA(0, 1, 0, 0)
self.RollThrow:setVisible(false)
self.RollThrow:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollThrow:setBackgroundRGBA(0, 0, 0, 0)
self.RollThrow:initialise()
self.RollThrow:instantiate()
self.RollThrow:setAnchorRight(true)
self.RollThrow:setAnchorTop(true)
self:addChild(self.RollThrow)
local btnNormal            = getTexture("media/ui/btnRollThrow.png")
local btnSelected          = getTexture("media/ui/btnRollThrowSelected.png")
local btnClicked          = getTexture("media/ui/btnRollThrowSelected.png")
applyImageStates(self.RollThrow, btnNormal, btnSelected, btnClicked) 

---

self.RollFarming = ISButton:new(x - 300, 655, 257, 42, "", self,
    function()
    self:getScore("Farming") 
        
    end)
self.RollFarming:setImage(getTexture("media/ui/btnRollFarming.png"))
self.RollFarming:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollFarming:setBorderRGBA(0, 1, 0, 0)
self.RollFarming:setVisible(false)
self.RollFarming:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollFarming:setBackgroundRGBA(0, 0, 0, 0)
self.RollFarming:initialise()
self.RollFarming:instantiate()
self.RollFarming:setAnchorRight(true)
self.RollFarming:setAnchorTop(true)
self:addChild(self.RollFarming)
local btnNormal            = getTexture("media/ui/btnRollFarming.png")
local btnSelected          = getTexture("media/ui/btnRollFarmingSelected.png")
local btnClicked          = getTexture("media/ui/btnRollFarmingSelected.png")
applyImageStates(self.RollFarming, btnNormal, btnSelected, btnClicked) 

--

self.RollEscape = ISButton:new(x - 300, 655, 257, 42, "", self,
    function()
    self:getScore("Escape") 
        
    end)
self.RollEscape:setImage(getTexture("media/ui/btnRollEscape.png"))
self.RollEscape:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollEscape:setBorderRGBA(0, 1, 0, 0)
self.RollEscape:setVisible(false)
self.RollEscape:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollEscape:setBackgroundRGBA(0, 0, 0, 0)
self.RollEscape:initialise()
self.RollEscape:instantiate()
self.RollEscape:setAnchorRight(true)
self.RollEscape:setAnchorTop(true)
self:addChild(self.RollEscape)
local btnNormal            = getTexture("media/ui/btnRollEscape.png")
local btnSelected          = getTexture("media/ui/btnRollEscapeSelected.png")
local btnClicked          = getTexture("media/ui/btnRollEscapeSelected.png")
applyImageStates(self.RollEscape, btnNormal, btnSelected, btnClicked) 

---

self.RollMechanics = ISButton:new(x - 300, 705, 257, 42, "", self,
    function()
    self:getScore("Mechanics") 
        
    end)
self.RollMechanics:setImage(getTexture("media/ui/btnRollMechanics.png"))
self.RollMechanics:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollMechanics:setBorderRGBA(0, 1, 0, 0)
self.RollMechanics:setVisible(false)
self.RollMechanics:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollMechanics:setBackgroundRGBA(0, 0, 0, 0)
self.RollMechanics:initialise()
self.RollMechanics:instantiate()
self.RollMechanics:setAnchorRight(true)
self.RollMechanics:setAnchorTop(true)
self:addChild(self.RollMechanics)
local btnNormal            = getTexture("media/ui/btnRollMechanics.png")
local btnSelected          = getTexture("media/ui/btnRollMechanicsSelected.png")
local btnClicked          = getTexture("media/ui/btnRollMechanicsSelected.png")
applyImageStates(self.RollMechanics, btnNormal, btnSelected, btnClicked) 

--

self.RollFirstAid = ISButton:new(x - 300, 705, 257, 42, "", self,
    function()
    self:getScore("First Aid") 
        
    end)
self.RollFirstAid:setImage(getTexture("media/ui/btnRollFirstAid.png"))
self.RollFirstAid:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollFirstAid:setBorderRGBA(0, 1, 0, 0)
self.RollFirstAid:setVisible(false)
self.RollFirstAid:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollFirstAid:setBackgroundRGBA(0, 0, 0, 0)
self.RollFirstAid:initialise()
self.RollFirstAid:instantiate()
self.RollFirstAid:setAnchorRight(true)
self.RollFirstAid:setAnchorTop(true)
self:addChild(self.RollFirstAid)
local btnNormal            = getTexture("media/ui/btnRollFirstAid.png")
local btnSelected          = getTexture("media/ui/btnRollFirstAidSelected.png")
local btnClicked          = getTexture("media/ui/btnRollFirstAidSelected.png")
applyImageStates(self.RollFirstAid, btnNormal, btnSelected, btnClicked) 

---

self.RollTailoring = ISButton:new(x - 580, 755, 257, 42, "", self,
    function()
    self:getScore("Tailoring") 
        
    end)

self.RollTailoring:setImage(getTexture("media/ui/btnRollTailoring.png"))
self.RollTailoring:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollTailoring:setBorderRGBA(0, 1, 0, 0)
self.RollTailoring:setVisible(false)
self.RollTailoring:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollTailoring:setBackgroundRGBA(0, 0, 0, 0)
self.RollTailoring:initialise()
self.RollTailoring:instantiate()
self.RollTailoring:setAnchorRight(true)
self.RollTailoring:setAnchorTop(true)
self:addChild(self.RollTailoring)
local btnNormal            = getTexture("media/ui/btnRollTailoring.png")
local btnSelected          = getTexture("media/ui/btnRollTailoringSelected.png")
local btnClicked          = getTexture("media/ui/btnRollTailoringSelected.png")
applyImageStates(self.RollTailoring, btnNormal, btnSelected, btnClicked) 

---

self.RollSkillless = ISButton:new(x - 300, 755, 257, 42, "", self,
    function()
    self:getScore("Other") 
        
    end)
self.RollSkillless:setImage(getTexture("media/ui/btnRollSkillless.png"))
self.RollSkillless:setBackgroundRGBA(0, 0.5, 0, 0)
self.RollSkillless:setBorderRGBA(0, 1, 0, 0)
self.RollSkillless:setVisible(false)
self.RollSkillless:setBackgroundColorMouseOverRGBA(0, 0, 0, 0)
self.RollSkillless:setBackgroundRGBA(0, 0, 0, 0)
self.RollSkillless:initialise()
self.RollSkillless:instantiate()
self.RollSkillless:setAnchorRight(true)
self.RollSkillless:setAnchorTop(true)
self:addChild(self.RollSkillless)
local btnNormal            = getTexture("media/ui/btnRollSkillless.png")
local btnSelected          = getTexture("media/ui/btnRollSkilllessSelected.png")
local btnClicked          = getTexture("media/ui/btnRollSkilllessSelected.png")
applyImageStates(self.RollSkillless, btnNormal, btnSelected, btnClicked) 


--------------------------


self.rangeButton = ISButton:new(x - 10, 610, 159, 36, "", self,
    function()
        DeadlineDice.GunRangeMode = not DeadlineDice.GunRangeMode
        DeadlineDice.MovementRangeMode = false
    end)
self.rangeButton:setImage(getTexture("media/ui/btnGunRange.png"))
self.rangeButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.rangeButton:setBorderRGBA(0, 1, 0, 0)
self.rangeButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.rangeButton:setBackgroundRGBA(0, 0, 0, 0)
self.rangeButton:initialise()
self.rangeButton:instantiate()
self.rangeButton:setAnchorRight(true)
self.rangeButton:setAnchorTop(true)
self:addChild(self.rangeButton)
    local btnNormal            = getTexture("media/ui/btnGunRange.png")
    local btnSelected          = getTexture("media/ui/btnGunRangeSelected.png")
    local btnClicked          = getTexture("media/ui/btnGunRangeClicked.png")
    applyImageStates(self.rangeButton, btnNormal, btnSelected, btnClicked)
x = x - 140
self.movementButton = ISButton:new(x + 130, 560, 159, 36, "", self,
    function()
        DeadlineDice.MovementRangeMode = not DeadlineDice.MovementRangeMode
        DeadlineDice.GunRangeMode = false
    end)
self.movementButton:setImage(getTexture("media/ui/btnMovementRange.png"))
self.movementButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.movementButton:setBorderRGBA(0, 1, 0, 0)
self.movementButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.movementButton:initialise()
self.movementButton:instantiate()
self.movementButton:setAnchorRight(true)
self.movementButton:setAnchorTop(true)
self:addChild(self.movementButton)
    local btnNormal            = getTexture("media/ui/btnMovementRange.png")
    local btnSelected          = getTexture("media/ui/btnMovementRangeSelected.png")
    local btnClicked          = getTexture("media/ui/btnMovementRangeClicked.png")
    applyImageStates(self.movementButton, btnNormal, btnSelected, btnClicked)


self.announceButton = ISButton:new(x + 130, 660, 159, 36, "", self,
    function()
        table.insert(self.sayQueue, "PvP scene has now been initiated. Please refrain from moving..")
    end)
self.announceButton:setImage(getTexture("media/ui/btnAnnounce.png"))
self.announceButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.announceButton:setBorderRGBA(0, 1, 0, 0)
self.announceButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.announceButton:initialise()
self.announceButton:instantiate()
self.announceButton:setAnchorRight(true)
self.announceButton:setAnchorTop(true)
self:addChild(self.announceButton)
    local btnNormal            = getTexture("media/ui/btnAnnounce.png")
    local btnSelected          = getTexture("media/ui/btnAnnounceSelected.png")
    local btnClicked          = getTexture("media/ui/btnAnnounceClicked.png")
    applyImageStates(self.announceButton, btnNormal, btnSelected, btnClicked)


self.coverButtonOn = ISButton:new(x + 130, 710, 159, 36, "", self,
    function()
        DeadlineDice.cover = false
        self.coverButtonOff:setVisible(true)
        self.coverButtonOn:setVisible(false)
    end)
self.coverButtonOn:setImage(getTexture("media/ui/btnCoverOn.png"))
self.coverButtonOn:setBackgroundRGBA(0, 0.5, 0, 0)
self.coverButtonOn:setBorderRGBA(0, 1, 0, 0)
self.coverButtonOn:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.coverButtonOn:initialise()
self.coverButtonOn:instantiate()
self.coverButtonOn:setAnchorRight(true)
self.coverButtonOn:setAnchorTop(true)
self:addChild(self.coverButtonOn)
    local btnNormal            = getTexture("media/ui/btnCoverOn.png")
    local btnSelected          = getTexture("media/ui/btnCoverOnSelected.png")
    local btnClicked          = getTexture("media/ui/btnCoverOnClicked.png")
    applyImageStates(self.coverButtonOn, btnNormal, btnSelected, btnClicked)


self.coverButtonOff = ISButton:new(x + 130, 710, 159, 36, "", self,
    function()
        DeadlineDice.cover = true
        self.coverButtonOff:setVisible(false)
        self.coverButtonOn:setVisible(true)
    end)
self.coverButtonOff:setImage(getTexture("media/ui/btnCoverOff.png"))
self.coverButtonOff:setBackgroundRGBA(0, 0.5, 0, 0)
self.coverButtonOff:setBorderRGBA(0, 1, 0, 0)
self.coverButtonOff:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.coverButtonOff:initialise()
self.coverButtonOff:instantiate()
self.coverButtonOff:setAnchorRight(true)
self.coverButtonOff:setAnchorTop(true)
self:addChild(self.coverButtonOff)
    local btnNormal            = getTexture("media/ui/btnCoverOff.png")
    local btnSelected          = getTexture("media/ui/btnCoverOffSelected.png")
    local btnClicked          = getTexture("media/ui/btnCoverOffClicked.png")
    applyImageStates(self.coverButtonOff, btnNormal, btnSelected, btnClicked)

    x = x - 110
    --[[
    x = x - 130

self.meleeButton = ISButton:new(x, 830, buttonWidth, buttonHeight, "Show Melee Range", self,
    function()
        self:toggleRadiusMarker()
        

    end)
self.meleeButton:setBackgroundRGBA(0, 0, 0, 0)
self.meleeButton:initialise()
self.meleeButton:instantiate()
self.meleeButton:setAnchorRight(true)
self.meleeButton:setAnchorTop(true)
self:addChild(self.meleeButton)
--]]
x = x + 50


    -- Calculate the height of the initiative tracker border based on the number of items
    local numInitiativeItems = 20                 -- Total number of initiative items
    local rows = math.ceil(numInitiativeItems / 2)
    local initiativeBorderHeight = 430

    -- Initiative tracker border
    self.initiativeBorder = { x = 10, y = yPos + barHeight + 50, width = 355, height = initiativeBorderHeight }
--[[
    -- Create loud mode button
    self.loudModeButton = ISButton:new((self:getWidth() / 2) - 100 + 10, 445, 60, 25,
        "Loud", self, ISDeadlineDiceUI.onOptionMouseDown)
    self.loudModeButton.internal = "LOUD_MODE"
    self.loudModeButton:initialise()
    self.loudModeButton:instantiate()
    self.loudModeButton.tooltip = "Loud mode. Has a range of 30"
    self.loudModeButton:setBackgroundRGBA(0.0, 0.5, 0.0, 1)
    self.loudModeButton:setBackgroundColorMouseOverRGBA(0.0, 0.5, 0.0, 0.5)
    self.loudModeButton:setBorderRGBA(1, 1, 1, 1)
    self:addChild(self.loudModeButton)

    -- Create quiet mode button
    self.quietModeButton = ISButton:new((self:getWidth() / 2) + 100 - 70, 445, 60, 25,
        "Quiet", self, ISDeadlineDiceUI.onOptionMouseDown)
    self.quietModeButton.internal = "QUIET_MODE"
    self.quietModeButton:initialise()
    self.quietModeButton:instantiate()
    self.quietModeButton.tooltip = "Quiet mode. Has a range of 10"
    self.quietModeButton:setBackgroundRGBA(0.3, 0.3, 0.3, 1)
    self.quietModeButton:setBackgroundColorMouseOverRGBA(0.3, 0.3, 0.3, 0.5)
    self.quietModeButton:setBorderRGBA(1, 1, 1, 1)
    self:addChild(self.quietModeButton)
y = y + 30;
--]]

self.rollInitiative = ISButton:new(x + 20, 430, 103, 36, "", self,
    function()
        self:getScore("Initiative") 
        --self.rollInitiative:setEnable(false)
    end)
self.rollInitiative:initialise()
self.rollInitiative:instantiate()
self.rollInitiative:setImage(getTexture("media/ui/btnRollInitiative.png"))
self.rollInitiative:setAnchorRight(true)
self.rollInitiative:setAnchorTop(true)
self.rollInitiative:setBackgroundRGBA(0, 0.5, 0, 0)
self.rollInitiative:setBorderRGBA(0, 1, 0, 0)
self.rollInitiative:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self:addChild(self.rollInitiative)

local btnNormal            = getTexture("media/ui/btnRollInitiative.png")
local btnSelected          = getTexture("media/ui/btnRollInitiativeSelected.png")
local btnClicked          = getTexture("media/ui/btnRollInitiativeClicked.png")
applyImageStates(self.rollInitiative, btnNormal, btnSelected, btnClicked)

self.resetInitiative = ISButton:new(x + 20, 480, 103, 36, "", self,
    function()
        self:resetInitiativeTracker()
    end)
self.resetInitiative:initialise()
self.resetInitiative:instantiate()
self.resetInitiative:setImage(getTexture("media/ui/btnResetInitiative.png"))
self.resetInitiative:setAnchorRight(true)
self.resetInitiative:setAnchorTop(true)
self.resetInitiative:setBackgroundRGBA(0, 0.5, 0, 0)
self.resetInitiative:setBorderRGBA(0, 1, 0, 0)
self.resetInitiative:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self:addChild(self.resetInitiative)

local btnNormal            = getTexture("media/ui/btnResetInitiative.png")
local btnSelected          = getTexture("media/ui/btnResetInitiativeSelected.png")
local btnClicked          = getTexture("media/ui/btnResetInitiativeClicked.png")
applyImageStates(self.resetInitiative, btnNormal, btnSelected, btnClicked)


x = x - 130
self.startCombat = ISButton:new(x + 260, 430, 104, 36, "", self,
    function()
   -- self:toggleCircleMarker()
    DeadlineDice.CombatActive = true
            table.sort(DeadlineDice.orderTracker, function(a, b)
            return (DeadlineDice.initiativeTracker[a] or 0) > (DeadlineDice.initiativeTracker[b] or 0)
        end)
    DeadlineDice.turnStartTime = getTimestampMs()
    DeadlineDice.turnTimerActive = true
    local playerName = self.character:getDescriptor():getForename()
    resultString = playerName .. " started the combat encounter."
    localtext = playerName .. " started the combat encounter."
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    table.insert(self.sayQueue, resultString)
    sendClientCommand("DeadlineDice", "DisableStartCombat", {
        sourcePlayerID = getPlayer():getOnlineID(),
        coords = {
            x = getPlayer():getX(),
            y = getPlayer():getY(),
            z = getPlayer():getZ()
        },
        range = 30,
        order = DeadlineDice.orderTracker

    })

    --[[
for _, username in ipairs(DeadlineDice.orderTracker) do
    local player = getPlayerByUsername(username)
    if player then
        sendServerCommand("DeadlineDice", "LockPlayerPosition", {
        sourcePlayerID = getPlayer():getOnlineID(),
        coords = {
            x = getPlayer():getX(),
            y = getPlayer():getY(),
            z = getPlayer():getZ()
        },
        range = 30,
        order = DeadlineDice.orderTracker,
            username = username,
            x = math.floor(player:getX()),
            y = math.floor(player:getY()),
            z = player:getZ()
        })
    end
end
]]
    self.startCombat:setEnable(false)
    DeadlineDice.broadcastFullInitiative()
    end)
local player = getPlayer()
DeadlineDice.lockedTiles = DeadlineDice.lockedTiles or {}
DeadlineDice.lockedTiles[player:getUsername()] = {
    x = math.floor(player:getX()),
    y = math.floor(player:getY()),
    z = player:getZ()
}
self.startCombat:initialise()
self.startCombat:instantiate()
self.startCombat:setImage(getTexture("media/ui/btnStartCombat.png"))
self.startCombat:setBackgroundRGBA(0, 0.5, 0, 0)
self.startCombat:setBorderRGBA(0, 1, 0, 0)
self.startCombat:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.startCombat:setAnchorRight(true)
self.startCombat:setAnchorTop(true)
self:addChild(self.startCombat)

local btnNormal            = getTexture("media/ui/btnStartCombat.png")
local btnSelected          = getTexture("media/ui/btnStartCombatSelected.png")
local btnClicked          = getTexture("media/ui/btnStartCombatClicked.png")
applyImageStates(self.startCombat, btnNormal, btnSelected, btnClicked)



self.turnDurationEntry = ISTextEntryBox:new("90", x + 370, 485, 35, 25)
self.turnDurationEntry:initialise()
self.turnDurationEntry:instantiate()
self.turnDurationEntry:setOnlyNumbers(true)

self:addChild(self.turnDurationEntry)

self.setTurnDurationButton = ISButton:new(x + 410, 480, 63, 36, "", self, function()
    local text = self.turnDurationEntry:getText()
    local durationSec = tonumber(text) or 90

    if durationSec and durationSec > 0 then
        DeadlineDice.turnDuration = durationSec * 1000
        print(DeadlineDice.turnDuration)
    local playerName = self.character:getDescriptor():getForename()
    resultString = playerName .. " set the turn duration to " .. durationSec .. " seconds."
    localtext = playerName .. " set the turn duration to " .. durationSec .. " seconds."
    table.insert(self.sayQueue, resultString)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
        sendClientCommand("DeadlineDice", "SyncTurnDuration", {
        sourcePlayerID = getPlayer():getOnlineID(),
        coords = {
            x = getPlayer():getX(),
            y = getPlayer():getY(),
            z = getPlayer():getZ()
        },
        range = 30,
            duration = tonumber(DeadlineDice.turnDuration)
        })
    end
end)
self.setTurnDurationButton:setImage(getTexture("media/ui/btnSet.png"))
self.setTurnDurationButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.setTurnDurationButton:setBorderRGBA(0, 1, 0, 0)
self.setTurnDurationButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.setTurnDurationButton:initialise()
self.setTurnDurationButton:instantiate()

self:addChild(self.setTurnDurationButton)
local btnNormal            = getTexture("media/ui/btnSet.png")
local btnSelected          = getTexture("media/ui/btnSetSelected.png")
local btnClicked          = getTexture("media/ui/btnSetClicked.png")
applyImageStates(self.setTurnDurationButton, btnNormal, btnSelected, btnClicked)


self.finishTurn = ISButton:new(x + 370, 430, 103, 36, "", self,
    function()
    local top = table.remove(DeadlineDice.orderTracker, 1)
    table.insert(DeadlineDice.orderTracker, top)

    local playerName = self.character:getDescriptor():getForename()
    local newTop = DeadlineDice.orderTracker[1]
    local newTopForename = getForenameByUsername(newTop)
    local resultString = playerName .. " has finished their turn. It is now " .. newTopForename .. "'s turn."

    if playerName == newTopForename then
        print ("ITS ME")
        DeadlineDice.tileSteps = 15
        DeadlineDice.tileStepsTaken = 0
    end

    table.insert(self.sayQueue, resultString)

    local localtext = playerName .. " has finished their turn. It is now " .. newTopForename .. "'s turn."
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {
        loggerName = "Dice",
        logText = localtext
    })

    -- Optionally update the UI right away
    self:updateInitiativeDisplay()

    -- Broadcast the new order to others
    sendClientCommand("DeadlineDice", "SyncTurnOrder", {
        sourcePlayerID = getPlayer():getOnlineID(),
        coords = {
            x = getPlayer():getX(),
            y = getPlayer():getY(),
            z = getPlayer():getZ()
        },
        range = 30,
        order = DeadlineDice.orderTracker
    })
    DeadlineDice.turnStartTime = getTimestampMs()
    DeadlineDice.turnTimerActive = true
    self.finishTurn:setEnable(false)
    DeadlineDice.broadcastFullInitiative()
    end)
self.finishTurn:setImage(getTexture("media/ui/btnFinishTurn.png"))
self.finishTurn:setBackgroundRGBA(0, 0.5, 0, 0)
self.finishTurn:setBorderRGBA(0, 1, 0, 0)
self.finishTurn:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.finishTurn:initialise()
self.finishTurn:instantiate()
self.finishTurn:setAnchorRight(true)
self.finishTurn:setAnchorTop(true)
self:addChild(self.finishTurn)
local btnNormal            = getTexture("media/ui/btnFinishTurn.png")
local btnSelected          = getTexture("media/ui/btnFinishTurnSelected.png")
local btnClicked          = getTexture("media/ui/btnFinishTurnClicked.png")
applyImageStates(self.finishTurn, btnNormal, btnSelected, btnClicked)

self.finishCombat = ISButton:new(x + 260, 480, 104, 36, "", self,
    function()
        local playerName = self.character:getUsername()
        


        -- Notify other clients
        sendClientCommand("DeadlineDice", "FinishCombat", {
            sourcePlayerID = getPlayer():getOnlineID(),
            coords = {
                x = getPlayer():getX(),
                y = getPlayer():getY(),
                z = getPlayer():getZ()
            },
            range = 30,
            name = playerName
        })
        self.startCombat:setEnable(true)
        self.turnDurationEntry:setEditable(true)
        self.setTurnDurationButton:setEnable(true)
        DeadlineDice.CombatActive = false
        table.insert(self.sayQueue, self.character:getDescriptor():getForename() .. " has exited the combat.")
        DeadlineDice.lockedTiles = nil

        -- Remove locally
        DeadlineDice.initiativeTracker[playerName] = nil
        for i, name in ipairs(DeadlineDice.orderTracker) do
            if name == playerName then
                table.remove(DeadlineDice.orderTracker, i)
                break
            end
        end

        self:updateInitiativeDisplay()
    end)
self.finishCombat:setBackgroundRGBA(0, 0, 0, 0)
self.finishCombat:initialise()
self.finishCombat:instantiate()
self.finishCombat:setImage(getTexture("media/ui/btnLeaveCombat.png"))
self.finishCombat:setBackgroundRGBA(0, 0.5, 0, 0)
self.finishCombat:setBorderRGBA(0, 1, 0, 0)
self.finishCombat:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.finishCombat:setAnchorRight(true)
self.finishCombat:setAnchorTop(true)
self:addChild(self.finishCombat)
local btnNormal            = getTexture("media/ui/btnLeaveCombat.png")
local btnSelected          = getTexture("media/ui/btnLeaveCombatSelected.png")
local btnClicked          = getTexture("media/ui/btnLeaveCombatClicked.png")
applyImageStates(self.finishCombat, btnNormal, btnSelected, btnClicked)



--------------

self.btnTextbookPrevTab = ISButton:new(395, 62, 20, 22, "", self,
    function()
        DeadlineDice.optiontab = DeadlineDice.optiontab - 1
        DeadlineDice.OptionC = DeadlineDice.OptionC - 3
        DeadlineDice.OptionB = DeadlineDice.OptionB - 3
        DeadlineDice.OptionA = DeadlineDice.OptionA - 3
        local n = DeadlineDice.OptionA
        local m = DeadlineDice.OptionB
        local o = DeadlineDice.OptionC
        if n and n >= 1 and n <= 18 then
            local base = string.format("media/ui/tabs/btntab%02d", n)
            local tex      = getTexture(base .. ".png")
            local texSel   = getTexture(base .. "selected.png")
            local texClick = getTexture(base .. "clicked.png")
            local baseb = string.format("media/ui/tabs/btntab%02d", m)
            local texb      = getTexture(baseb .. ".png")
            local texSelb   = getTexture(baseb .. "selected.png")
            local texClickb = getTexture(baseb .. "clicked.png")
            local basec = string.format("media/ui/tabs/btntab%02d", o)
            local texc      = getTexture(basec .. ".png")
            local texSelc   = getTexture(basec .. "selected.png")
            local texClickc = getTexture(basec .. "clicked.png")
                applyImageStates(self.DamageTxtButton, tex, texSel, texClick)
                applyImageStates(self.DWDTxtButton, texb, texSelb, texClickb)
                applyImageStates(self.TurnTxtButton, texc, texSelc, texClickc)
            end

        if DeadlineDice.optiontab <= 1 then
            self.btnTextbookPrevTab:setVisible(false)

        else
            self.btnTextbookNextTab:setVisible(true)
        end
    end)
self.btnTextbookPrevTab:setImage(getTexture("media/ui/btnTxtDamage.png"))
self.btnTextbookPrevTab:setBackgroundRGBA(0, 0.5, 0, 0)
self.btnTextbookPrevTab:setBorderRGBA(0, 1, 0, 0)
self.btnTextbookPrevTab:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.btnTextbookPrevTab:initialise()
self.btnTextbookPrevTab:instantiate()
self.btnTextbookPrevTab:setAnchorRight(true)
self.btnTextbookPrevTab:setAnchorTop(true)
self:addChild(self.btnTextbookPrevTab)
    local btnNormal            = getTexture("media/ui/btnPreviousTabTop.png")
    local btnSelected          = getTexture("media/ui/btnPreviousTabTopSelected.png")
    local btnClicked          = getTexture("media/ui/btnPreviousTabTopClicked.png")
    applyImageStates(self.btnTextbookPrevTab, btnNormal, btnSelected, btnClicked)


self.btnTextbookNextTab = ISButton:new(745, 62, 20, 22, "", self,
    function()
        DeadlineDice.optiontab = DeadlineDice.optiontab + 1
        DeadlineDice.OptionC = DeadlineDice.OptionC + 3
        DeadlineDice.OptionB = DeadlineDice.OptionB + 3
        DeadlineDice.OptionA = DeadlineDice.OptionA + 3
        local n = DeadlineDice.OptionA
        local m = DeadlineDice.OptionB
        local o = DeadlineDice.OptionC
        if n and n >= 1 and n <= 18 then
            local base = string.format("media/ui/tabs/btntab%02d", n)
            local tex      = getTexture(base .. ".png")
            local texSel   = getTexture(base .. "selected.png")
            local texClick = getTexture(base .. "clicked.png")
            local baseb = string.format("media/ui/tabs/btntab%02d", m)
            local texb      = getTexture(baseb .. ".png")
            local texSelb   = getTexture(baseb .. "selected.png")
            local texClickb = getTexture(baseb .. "clicked.png")
            local basec = string.format("media/ui/tabs/btntab%02d", o)
            local texc      = getTexture(basec .. ".png")
            local texSelc   = getTexture(basec .. "selected.png")
            local texClickc = getTexture(basec .. "clicked.png")
                applyImageStates(self.DamageTxtButton, tex, texSel, texClick)
                applyImageStates(self.DWDTxtButton, texb, texSelb, texClickb)
                applyImageStates(self.TurnTxtButton, texc, texSelc, texClickc)
            end
            
        if DeadlineDice.optiontab >= DeadlineDice.maxtabs then
            self.btnTextbookNextTab:setVisible(false)
        else
            self.btnTextbookPrevTab:setVisible(true)
        end
    end)
self.btnTextbookNextTab:setImage(getTexture("media/ui/btnTxtDamage.png"))
self.btnTextbookNextTab:setBackgroundRGBA(0, 0.5, 0, 0)
self.btnTextbookNextTab:setBorderRGBA(0, 1, 0, 0)
self.btnTextbookNextTab:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.btnTextbookNextTab:initialise()
self.btnTextbookNextTab:instantiate()
self.btnTextbookNextTab:setAnchorRight(true)
self.btnTextbookNextTab:setAnchorTop(true)
self:addChild(self.btnTextbookNextTab)
    local btnNormal            = getTexture("media/ui/btnNextTabTop.png")
    local btnSelected          = getTexture("media/ui/btnNextTabTopSelected.png")
    local btnClicked          = getTexture("media/ui/btnNextTabTopClicked.png")
    applyImageStates(self.btnTextbookNextTab, btnNormal, btnSelected, btnClicked)

--------------

self.btnTextbookPrevPage = ISButton:new(395, 197, 20, 150, "", self,
    function()
        self:setCurrentPageIndex(self:getCurrentPageIndex() - 1)
        self:updatePageNav()
    end)
self.btnTextbookPrevPage:setImage(getTexture("media/ui/btnTxtDamage.png"))
self.btnTextbookPrevPage:setBackgroundRGBA(0, 0.5, 0, 0)
self.btnTextbookPrevPage:setBorderRGBA(0, 1, 0, 0)
self.btnTextbookPrevPage:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.btnTextbookPrevPage:initialise()
self.btnTextbookPrevPage:instantiate()
self.btnTextbookPrevPage:setAnchorRight(true)
self.btnTextbookPrevPage:setAnchorTop(true)
self:addChild(self.btnTextbookPrevPage)
    local btnNormal            = getTexture("media/ui/btnPrevTab.png")
    local btnSelected          = getTexture("media/ui/btnPrevTabSelected.png")
    local btnClicked          = getTexture("media/ui/btnPrevTabClicked.png")
    applyImageStates(self.btnTextbookPrevPage, btnNormal, btnSelected, btnClicked)


self.btnTextbookNextPage = ISButton:new(745, 197, 20, 150, "", self,
    function()
        self:setCurrentPageIndex(self:getCurrentPageIndex() + 1)
        self:updatePageNav()
    end)
self.btnTextbookNextPage:setImage(getTexture("media/ui/btnTxtDamage.png"))
self.btnTextbookNextPage:setBackgroundRGBA(0, 0.5, 0, 0)
self.btnTextbookNextPage:setBorderRGBA(0, 1, 0, 0)
self.btnTextbookNextPage:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.btnTextbookNextPage:initialise()
self.btnTextbookNextPage:instantiate()
self.btnTextbookNextPage:setAnchorRight(true)
self.btnTextbookNextPage:setAnchorTop(true)
self:addChild(self.btnTextbookNextPage)
    local btnNormal            = getTexture("media/ui/btnNextTab.png")
    local btnSelected          = getTexture("media/ui/btnNextTabSelected.png")
    local btnClicked          = getTexture("media/ui/btnNextTabClicked.png")
    applyImageStates(self.btnTextbookNextPage, btnNormal, btnSelected, btnClicked)


-------------

self.DamageTxtButton = ISButton:new(420, 62, 100, 22, "", self,
    function()
    DeadlineDice.textoption = DeadlineDice.OptionA
        self:setCurrentPageIndex(0)
        self:updatePageNav()
        self:updatePageUI()
    end)
self.DamageTxtButton:setImage(getTexture("media/ui/tabs/btntab01.png"))
self.DamageTxtButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.DamageTxtButton:setBorderRGBA(0, 1, 0, 0)
self.DamageTxtButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.DamageTxtButton:initialise()
self.DamageTxtButton:instantiate()
self.DamageTxtButton:setAnchorRight(true)
self.DamageTxtButton:setAnchorTop(true)
btnA = getTexture("media/ui/tabs/btntab01.png")
btnAClicked = getTexture("media/ui/tabs/btntab01selected.png")
btnASelected = getTexture("media/ui/tabs/btntab01clicked.png")
self:addChild(self.DamageTxtButton)


self.DWDTxtButton = ISButton:new(530, 62, 100, 22, "", self,
    function()
    DeadlineDice.textoption = DeadlineDice.OptionB
        self:setCurrentPageIndex(0)
        self:updatePageNav()
        self:updatePageUI()
    end)
self.DWDTxtButton:setImage(getTexture("media/ui/tabs/btntab02.png"))
self.DWDTxtButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.DWDTxtButton:setBorderRGBA(0, 1, 0, 0)
self.DWDTxtButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.DWDTxtButton:initialise()
self.DWDTxtButton:instantiate()
self.DWDTxtButton:setAnchorRight(true)
self.DWDTxtButton:setAnchorTop(true)
self:addChild(self.DWDTxtButton)


self.TurnTxtButton = ISButton:new(640, 62, 100, 22, "", self,
    function()
        DeadlineDice.textoption = DeadlineDice.OptionC
        self:setCurrentPageIndex(0)
        self:updatePageNav()
        self:updatePageUI()
    end)
self.TurnTxtButton:setImage(getTexture("media/ui/tabs/btntab03.png"))
self.TurnTxtButton:setBackgroundRGBA(0, 0.5, 0, 0)
self.TurnTxtButton:setBorderRGBA(0, 1, 0, 0)
self.TurnTxtButton:setBackgroundColorMouseOverRGBA(1, 1, 1, 0)
self.TurnTxtButton:initialise()
self.TurnTxtButton:instantiate()
self.TurnTxtButton:setAnchorRight(true)
self.TurnTxtButton:setAnchorTop(true)
self:addChild(self.TurnTxtButton)




end

function ISDeadlineDiceUI:updateInitiativeDisplay()
    for _, obj in ipairs(self.initiativeLabels or {}) do
        self:removeChild(obj.label)
    end

    self.initiativeLabels = {}

    for i, name in ipairs(DeadlineDice.orderTracker) do
        local value = DeadlineDice.initiativeTracker[name]
        local y = 500 + i * 20 -- or wherever you want to draw
        local label = ISLabel:new(600, y, 20, name .. ": " .. tostring(value), 1, 1, 1, 1, UIFont.Small, true)
        self:addChild(label)
        table.insert(self.initiativeLabels, {name = name, label = label})
    end
end

function ISDeadlineDiceUI:toggleRadiusMarker()
    DeadlineDice.meleeMarkerActive = not DeadlineDice.meleeMarkerActive

    local player = getSpecificPlayer(0)
    local args = {
        x = math.floor(player:getX()),
        y = math.floor(player:getY()),
        z = player:getZ(),
        radius = 4.9,
        active = DeadlineDice.meleeMarkerActive
    }

    if DeadlineDice.meleeMarkerActive then
        local markerDuration = 20 * 60
        DeadlineDice.markerTimer = markerDuration
    end
    sendClientCommand("DeadlineDice", "ToggleMeleeMarker", args)
end


function ISDeadlineDiceUI:toggleCircleMarker()


    local player = getSpecificPlayer(0)
    local args = {
        x = math.floor(player:getX()),
        y = math.floor(player:getY()),
        z = player:getZ(),
        radius = 30,
        active = true
    }


   -- sendClientCommand("DeadlineDice", "EnableCircleMarker", args)
end


function ISDeadlineDiceUI:onOptionMouseDown(button, x, y)
    if button.internal == "LOUD_MODE" then
        if self.selectedMode ~= "loud" then
            self.loudModeButton.backgroundColor = { r = 0.0, g = 0.5, b = 0.0, a = 1 }
            self.loudModeButton.backgroundColorMouseOver = { r = 0.0, g = 0.5, b = 0.0, a = 0.5 }

            self.quietModeButton.backgroundColor = { r = 0.3, g = 0.3, b = 0.3, a = 1 }
            self.quietModeButton.backgroundColorMouseOver = { r = 0.3, g = 0.3, b = 0.3, a = 0.5 }
            self.selectedMode = "loud"
        end
    elseif button.internal == "QUIET_MODE" then
        if self.selectedMode ~= "quiet" then
            self.quietModeButton.backgroundColor = { r = 0.0, g = 0.5, b = 0.0, a = 1 }
            self.quietModeButton.backgroundColorMouseOver = { r = 0.0, g = 0.5, b = 0.0, a = 0.5 }

            self.loudModeButton.backgroundColor = { r = 0.3, g = 0.3, b = 0.3, a = 1 }
            self.loudModeButton.backgroundColorMouseOver = { r = 0.3, g = 0.3, b = 0.3, a = 0.5 }
            self.selectedMode = "quiet"
        end
    end
end

function ISDeadlineDiceUI:getTopInitiativeEntry()
    return DeadlineDice.orderTracker[1]
end

function ISDeadlineDiceUI:updateInitiativeLabels()
    -- Remove old labels if they exist
    if self.initiativeLabels then
        for _, entry in ipairs(self.initiativeLabels) do
            self:removeChild(entry.label)
        end
    end

    self.initiativeLabels = {}

    local x = 200  -- adjust x/y based on your layout
    local y = 100
    for i, name in ipairs(DeadlineDice.orderTracker) do
        local value = DeadlineDice.initiativeTracker[name]
       -- local label = ISLabel:new(x, y + i * 20, 20, name .. ": " .. tostring(value), 1, 1, 1, 1, UIFont.Small, true)
       -- self:addChild(label)
        table.insert(self.initiativeLabels, {name = name, label = label})
    end
end

function getForenameByUsername(username)
    for i = 0, getOnlinePlayers():size() - 1 do
        local player = getOnlinePlayers():get(i)
        if player:getUsername() == username then
            return player:getDescriptor():getForename()
        end
    end
    return username
end

function getTraitFromUsername(username, traitname)
    for i = 0, getOnlinePlayers():size() - 1 do
        local player = getOnlinePlayers():get(i)
        if player:getUsername() == username then
            return player:HasTrait(traitname)
        end
    end
    return username
end

function getPlayerByUsername(username)
    for i = 0, getOnlinePlayers():size() - 1 do
        local player = getOnlinePlayers():get(i)
        if player:getUsername() == username then
            return player
        end
    end
    return nil
end

function ISDeadlineDiceUI:addOrUpdateInitiative(name, value)
    -- Check if the name is already in the initiativeTracker
    if DeadlineDice.initiativeTracker[name] then
        -- Update the value if the name exists
        DeadlineDice.initiativeTracker[name] = value
    else
        -- If the number of entries is 20 or more, remove the oldest entry
        if #DeadlineDice.orderTracker >= 20 then
            local oldestName = table.remove(DeadlineDice.orderTracker, 1)
            DeadlineDice.initiativeTracker[oldestName] = nil
        end
        -- Add the new name and value
        DeadlineDice.initiativeTracker[name] = value
        table.insert(DeadlineDice.orderTracker, name)
    end
    self:updateInitiativeLabels()
end

function ISDeadlineDiceUI:tableKeys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

function ISDeadlineDiceUI:getLowestInitiative()
    local lowestName, lowestValue
    for name, value in pairs(DeadlineDice.initiativeTracker) do
        if not lowestValue or value < lowestValue then
            lowestName, lowestValue = name, value
        end
    end
    return lowestName, lowestValue
end

function ISDeadlineDiceUI:adjustHitPointsLabelPosition()

end

function ISDeadlineDiceUI:initialise()
    ISPanel.initialise(self);
    DeadlineDice.cover = false
    DeadlineDice.option = 1
    DeadlineDice.lastRoll = 0
    DeadlineDice.lastHealthClick = 0
    DeadlineDice.textoption = 1
    DeadlineDice.optiontab = 1
    DeadlineDice.textpage = 1
    DeadlineDice.maxpages = 1
    DeadlineDice.OptionA = 1
    DeadlineDice.OptionB = 2
    DeadlineDice.OptionC = 3
    self.RollTailoring:setVisible(false)
    self.RollSkillless:setVisible(false)
    self.btnTextbookPrevTab:setVisible(false)
    self:updatePageNav()
    if getPlayer():HasTrait("Sturdy") then
        DeadlineDice.hitPoints = 14
    elseif getPlayer():HasTrait("Fragile") then
        DeadlineDice.hitPoints = 10
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") then
        DeadlineDice.hitPoints = 12
    end

    if getPlayer():getModData().MedLine and getPlayer():getModData().MedLine.BloodData then
        local bloodData = getPlayer():getModData().MedLine.BloodData;
        if bloodData.bloodLossTimeoutUnix and bloodData.bloodLossTimeoutUnix > getTimestamp() then
            DeadlineDice.hitPoints = DeadlineDice.hitPoints - (SandboxVars.MedLine.BloodLoss_DiceHPDisadvantage or 2);
            print("DeadlineDice - MedLine blood loss integration.");
        end
    end

end

function ISDeadlineDiceUI:update()

local playerName = getPlayer():getUsername()
local topPlayer = DeadlineDice.orderTracker and DeadlineDice.orderTracker[1]

if DeadlineDice.CombatActive and DeadlineDice.turnTimerActive and playerName == topPlayer then
    local elapsed = getTimestampMs() - (DeadlineDice.turnStartTime or 0)
    if elapsed >= tonumber(DeadlineDice.turnDuration) then
        -- Only THIS player handles the timeout
        DeadlineDice.turnTimerActive = false
--[[
    local top = table.remove(DeadlineDice.orderTracker, 1)
    table.insert(DeadlineDice.orderTracker, top)

    local playerName = self.character:getDescriptor():getForename()
    local newTop = DeadlineDice.orderTracker[1]
    local newTopForename = getForenameByUsername(newTop)]]
  --  local resultString = playerName .. " skipped their turn due to inactivity. It is now " .. newTopForename .. "'s turn."
    local resultString = getPlayer():getDescriptor():getForename() .. "'s turn has run out of time, finish quickly!"
    table.insert(self.sayQueue, resultString)

  -- local localtext = playerName .. " skipped their turn due to inactivity. It is now " .. newTopForename .. "'s turn."
    local localtext = playerName .. "'s turn has run out of time, finish quickly!"
    sendClientCommand(getPlayer():getDescriptor():getForename(), 'ISLogSystem', 'writeLog', {
        loggerName = "Dice",
        logText = localtext
    })
--[[
        sendClientCommand("DeadlineDice", "SyncTurnOrder", {
            sourcePlayerID = getPlayer():getOnlineID(),
            coords = {
                x = getPlayer():getX(),
                y = getPlayer():getY(),
                z = getPlayer():getZ()
            },
            range = 30,
            order = DeadlineDice.orderTracker,
            autoSkipped = true,
            previousPlayer = top,
            nextPlayer = DeadlineDice.orderTracker[1]
        })

        -- Reset timer for next turn
        DeadlineDice.turnStartTime = getTimestampMs()
        DeadlineDice.turnTimerActive = true
    ]]
    end
end

    if #self.sayQueue > 0 then
        if not self.lastTimestamp then
            self.lastTimestamp = getTimestamp()
            -- Handle the first item in the queue immediately
            self:handleNextSay()
        else
            local currentTime = getTimestamp()
            local elapsedTime = currentTime - self.lastTimestamp

            -- Check if 3 seconds have passed since the last Say() call
            if elapsedTime >= self.delay then
                self.lastTimestamp = currentTime
                self:handleNextSay()
            end
        end
    end
end

function ISDeadlineDiceUI:handleNextSay()
    if #self.sayQueue > 0 then
        local message = table.remove(self.sayQueue, 1)

        self.character:addLineChatElement(message, 1, 1, 1, UIFont.Dialogue, 10, "default",
            true, true, true, true, true, true)

        local playerName = self.character:getDescriptor():getForename()
        DeadlineDice.addLineInChat(playerName .. ": " .. message)

        local args =
        {
            sourcePlayerID = self.character:getOnlineID(),
            message = message,
            coords =
            {
                x = self.character:getX(),
                y = self.character:getY(),
                z = self.character:getZ()
            },
            mode = self.selectedMode
        }
        sendClientCommand('DeadlineDice', 'requestSendMessage', args)

        self.lastTimestamp = getTimestamp() -- Update lastTimestamp after the first message
    else
        self:close()
    end
end



function ISDeadlineDiceUI:prerender()
    ISCollapsableWindow.prerender(self);

        if DeadlineDice.initBG == 0 then
            self.bgTexture = getTexture("media/ui/dicebgnew.png")
            DeadlineDice.initBG = 1
        elseif DeadlineDice.initBG == 1 then
            self.bgTexture = getTexture("media/ui/dicebgnewb.png")
            DeadlineDice.initBG = 2
        elseif DeadlineDice.initBG == 2 then
            self.bgTexture = getTexture("media/ui/dicebgnewc.png")
            DeadlineDice.initBG = 3
        end
        local tex = self:getCurrentPageTexture()
        if tex then self.bgTextTexture = tex end
        --[[
        if DeadlineDice.textoption == 1 then
            self.bgTextTexture = getTexture("media/ui/tab1page1.png")
        elseif DeadlineDice.textoption == 2 then
            self.bgTextTexture = getTexture("media/ui/textb.png")
        else
            self.bgTextTexture = getTexture("media/ui/textc.png")
        end
        ]]
        if DeadlineDice.option < 3 then
            self.bgTexture = getTexture("media/ui/dicebgnew.png")
        else
            self.bgTexture = getTexture("media/ui/dicebgnewc.png")
        end

        self:drawTextureScaled(self.bgTexture, 0, 0, self.width, self.height, 1.0, 1, 1, 1)
        self:drawTextureScaled(self.bgTextTexture, 390, 60, 378, 478, 1.0, 1, 1, 1)
end


function ISDeadlineDiceUI:render()


if DeadlineDice.CombatActive and DeadlineDice.turnStartTime then
    local now = getTimestampMs()
    
    local elapsed = now - DeadlineDice.turnStartTime
    local remaining = math.max(0, DeadlineDice.turnDuration - elapsed)
    local seconds = math.ceil(remaining / 1000)
    self.turnDurationEntry:setEditable(false)
    self.setTurnDurationButton:setEnable(false)

    local timerText = "" .. tostring(seconds) .. " seconds remain..."
    self:drawText(timerText, 120, self.initiativeBorder.y - 20, 1, 1, 1, 1, UIFont.Medium)
else
    local timerText = ""
    self:drawText(timerText, 120, self.initiativeBorder.y - 20, 1, 1, 1, 1, UIFont.Medium)
end

local topName = self:getTopInitiativeEntry()
local playerName = self.character:getUsername()
if topName and playerName then
   -- print(topName .. " - " .. playerName)
end
if DeadlineDice.CombatActive and topName == playerName then
    self.finishTurn:setEnable(true)
    --self.movementButton:setEnable(true)
    for _, group in ipairs(self.buttonGroups) do
        for _, pair in ipairs(group) do
            if pair.label.name == "Attack" then
                pair.button:setEnable(true)
            end
        end
    end
elseif DeadlineDice.CombatActive == false then
    for _, group in ipairs(self.buttonGroups) do
        for _, pair in ipairs(group) do
            if pair.label.name == "Attack" then
                pair.button:setEnable(true)
            end
        end
    end

else
    self.finishTurn:setEnable(false)
    --self.movementButton:setEnable(false)
    for _, group in ipairs(self.buttonGroups) do
        for _, pair in ipairs(group) do
            if pair.label.name == "Attack" then
                pair.button:setEnable(false)
            end
        end
    end
end

    if DeadlineDice.CombatActive and self.initiativeLabels then
        local topName = self:getTopInitiativeEntry()
        for _, entry in ipairs(self.initiativeLabels) do
            if entry.name == topName then
                local lbl = entry.label

            end
        end
    end

for i, group in ipairs(self.buttonGroups or {}) do

    if #group > 0 then
        local first = group[1]
        local last = group[#group]

        if first and last and first.label and last.button then
            local padding = 5
            local x = first.label.x - padding
            local y = first.label.y - 10
            local width = (last.button.x + last.button.width) - x + padding
            local height = (last.button.y + last.button.height) - y

            self:drawRectBorder(x, y, width, height, 1, 1, 1, 1)
        else

        end
    end
end



    -- Update hit points bars
    self:updateHitPointsBars()

    for _, pair in ipairs(self.buttons) do
        if pair.label:getName() ~= "Initiative" then
            local label = pair.label
            local button = pair.button
            if label then
                -- Calculate the combined width and height for the border
                local width = button:getRight() - label:getX() + 10
                local height = math.max(label.height, button.height) + 10

                -- Draw the border
                --self:drawRectBorder(label.x - 5, label.y - 15, width, height - 4, 1, 0.5, 0.5, 0.5)
            end
        end
    end



    -- Draw initiative tracker border
    local borderX = self.initiativeBorder.x
    local borderY = self.initiativeBorder.y
    local borderWidth = self.initiativeBorder.width
    local borderHeight = self.initiativeBorder.height
    local borderColor = { r = 1, g = 1, b = 1, a = 0 }
    self:drawRectBorder(borderX, borderY, borderWidth, borderHeight, borderColor.a, borderColor.r, borderColor.g,
        borderColor.b)

    -- Draw border for initiative button
    -- self:drawRectBorder(10, borderY, self.initiativeButton.width + 10, borderHeight, borderColor.a, borderColor.r,
    -- borderColor.g, borderColor.b)

    -- Sort initiative tracker by value in descending order
-- Utility function to truncate text
local function truncateText(text, maxLength)
    if string.len(text) > maxLength then
        return string.sub(text, 1, maxLength - 2) .. "..."
    else
        return text
    end
end

local textX = 30
local textY = borderY + 5
local namesPerColumn = 20
local maxNameLength = 50
local columnCount = 0

if DeadlineDice.CombatActive then
    -- During combat: use fixed orderTracker
    local columnWidth = 300
    for index, name in ipairs(DeadlineDice.orderTracker) do
        
        local value = DeadlineDice.initiativeTracker[name]
        local displayName = (name == self.character:getUsername()) and "You" or getForenameByUsername(name)
        local truncatedName = truncateText(displayName, maxNameLength)
        local hp = DeadlineDice.hpTracker[name] or "?"
        if index == 1 then
        self.bgTexture = getTexture("media/ui/playerlisttop.png")
        else
        self.bgTexture = getTexture("media/ui/playerlist.png")      
        end
        self:drawTextureScaled(self.bgTexture , textX - 10, textY, 340, 25, 1.0, 1, 1, 1)
        self:drawText(truncatedName, textX, textY + 2, 1, 1, 1, 1, UIFont.Medium)
        self:drawText(tostring(value), textX + 245, textY + 2, 1, 1, 1, 1, UIFont.Medium)
        


        self:drawText(tostring(hp), textX + 167, textY + 2, 1, 1, 1, 1, UIFont.Medium)

        if(getTraitFromUsername(name, "PowerStriker")) then
        self:drawTextureScaled(self.buffPowerStriker , textX + 135, textY + 4, 22, 17, 1.0, 1, 1, 1)    

        elseif(getTraitFromUsername(name, "PrecisionStriker")) then
        self:drawTextureScaled(self.buffPrecisionStriker , textX + 135, textY + 4, 19, 16, 1.0, 1, 1, 1)           
        
        elseif(getTraitFromUsername(name, "SharpShooter")) then
        self:drawTextureScaled(self.buffSharpShooter , textX + 130, textY + 4, 26, 17, 1.0, 1, 1, 1)               
        
        end
        textY = textY + 30

        if (index % namesPerColumn) == 0 then
            columnCount = columnCount + 1
            textX = 270 + columnCount * columnWidth
            textY = borderY + 30
        end
    end
else
    -- Before combat: show auto-sorted order
    local sortedInitiative = {}
    for name, value in pairs(DeadlineDice.initiativeTracker) do
        table.insert(sortedInitiative, { name = name, value = value })
    end
    table.sort(sortedInitiative, function(a, b) return a.value > b.value end)
    local columnWidth = (borderWidth) / math.ceil(#sortedInitiative / namesPerColumn)

    for index, pair in ipairs(sortedInitiative) do
        local displayName = (pair.name == self.character:getUsername()) and "You" or getForenameByUsername(pair.name)


        local truncatedName = truncateText(displayName, maxNameLength)
        self.bgTexture = getTexture("media/ui/playerlist.png")
        self.buffPrecisionStriker = getTexture("media/ui/buffPrecisionStriker.png")
        self.buffPowerStriker = getTexture("media/ui/buffPowerStriker.png")
        self.buffSharpShooter = getTexture("media/ui/buffSharpshooter.png")
        self:drawTextureScaled(self.bgTexture , textX - 10, textY, 340, 25, 1.0, 1, 1, 1)
        self:drawText(truncatedName, textX, textY + 2, 1, 1, 1, 1, UIFont.Medium)
        self:drawText(tostring(pair.value), textX + 245, textY + 2, 1, 1, 1, 1, UIFont.Medium)
        if(getTraitFromUsername(pair.name, "PowerStriker")) then
        self:drawTextureScaled(self.buffPowerStriker , textX + 135, textY + 4, 22, 17, 1.0, 1, 1, 1)    

        elseif(getTraitFromUsername(pair.name, "PrecisionStriker")) then
        self:drawTextureScaled(self.buffPrecisionStriker , textX + 135, textY + 4, 19, 16, 1.0, 1, 1, 1)           
        
        elseif(getTraitFromUsername(pair.name, "SharpShooter")) then
        self:drawTextureScaled(self.buffSharpShooter , textX + 130, textY + 4, 26, 17, 1.0, 1, 1, 1)               
        
        end
        textY = textY + 30
        if (index % namesPerColumn) == 0 then
            columnCount = columnCount + 1
            textX = 270 + columnCount * columnWidth
            textY = borderY + 30
        end
    end

end

    ISCollapsableWindow.render(self);
end

function ISDeadlineDiceUI:getScore(labelText)
    DeadlineDice.lastRoll = getTimestamp()
    local editedLabel = self:getEditedLabel(labelText)
    local playerName = self.character:getUsername()           -- Get the player's username
    local diceScore = DeadlineDice.getDiceRoll()
    local diceScore6 = ZombRand(1, 7)
    local modifiers = DeadlineDice.getModifiers(editedLabel, diceScore)
    local totalScore = diceScore
    local currentItem = self.character:getPrimaryHandItem() or self.character:getSecondaryHandItem()
    if editedLabel == "Attack" and DeadlineDice.CombatActive then
        --[[
        if not currentItem or not currentItem:isRanged() then
            if isOtherPlayerNearby(5) then
                print("Another player is within 5 tiles!")
            else

            table.insert(self.sayQueue, "Can't attack melee, no players within 5 tiles!")
            localtext = playerName .. " can't attack melee, no players within 5 tiles!"
            sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
                return
            end
        end]]
    end

    table.insert(self.sayQueue, "Rolling for: " .. labelText)
    localtext = playerName .. " rolls for: " .. labelText
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    if editedLabel == "DicewithDeath" then
    resultString = "Rolled " .. tostring(diceScore6)
    else
    resultString = "Rolled " .. tostring(diceScore)
    end

    -- Construct the modifiers string
    local modifierString = ""
    for modifier, value in pairs(modifiers) do
        modifierString = modifierString ..
            (value >= 0 and " + " or " - ") .. tostring(math.abs(value)) .. " (" .. modifier .. ")"
        -- Add modifier value to total score
        totalScore = totalScore + value
    end

    localtext = playerName .. " rolls for: " .. resultString
    -- Combine the strings
    if diceScore == 19 and (editedLabel == "Attack" or editedLabel == "AttackRanged" or editedLabel == "Throwing" or editedLabel == "DefendRanged" or editedLabel == "DefendClose") and getPlayer():HasTrait("Lucky") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " LUCKY CRITICAL HIT!"
    elseif diceScore == 2 and (editedLabel == "Attack" or editedLabel == "AttackRanged" or editedLabel == "Throwing" or editedLabel == "DefendRanged" or editedLabel == "DefendClose") and getPlayer():HasTrait("Unlucky") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " UNLUCKY CRITICAL FAILURE!"
    elseif diceScore == 20 and (editedLabel == "Attack" or editedLabel == "AttackRanged" or editedLabel == "Throwing") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " CRITICAL HIT!"
    elseif diceScore == 1 and (editedLabel == "Attack" or editedLabel == "AttackRanged" or editedLabel == "Throwing") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " CRITICAL FAILURE!"
    elseif DeadlineDice.cover == true and (editedLabel == "DefendRanged") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. " + 2 (In Cover) = " .. tostring(totalScore + 2) 
    elseif diceScore < 11 and (editedLabel == "Escape") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. ""
    elseif diceScore > 10 and (editedLabel == "Escape") then
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore) .. ""
    elseif editedLabel == "DicewithDeath" then
        resultString = resultString .. modifierString .. " = " .. tostring(diceScore6)
        localtext = playerName .. " rolls for: " .. diceScore6
    else
        resultString = resultString .. modifierString .. " = " .. tostring(totalScore)
    end
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
        -- Combine the strings


    -- Insert the result into the sayQueue
    table.insert(self.sayQueue, resultString)

    if editedLabel == "Initiative" then
        --DeadlineDice.hitPoints = self.character:getPerkLevel(Perks.Fitness)
        table.insert(self.sayQueue, "Current Hit Points: " .. tostring(DeadlineDice.hitPoints))

        local args =
        {
            sourcePlayerID = self.character:getOnlineID(),
            name = self.character:getUsername(),
            value = totalScore,
            coords =
            {
                x = self.character:getX(),
                y = self.character:getY(),
                z = self.character:getZ()
            },
            mode = self.selectedMode
        }
        sendClientCommand('DeadlineDice', 'requestSendInitiativeData', args)
    end
end

function ISDeadlineDiceUI:openInitiativePopup(username)
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()

    local uiWidth = 250
    local uiHeight = 100
    local uiX = (screenWidth - uiWidth) / 2
    local uiY = (screenHeight - uiHeight) / 2

    local ui = ISPanel:new(uiX, uiY, uiWidth, uiHeight)
    ui:initialise()
    ui:instantiate()
    ui:addToUIManager()


    local textBox = ISTextEntryBox:new("0", 10, 20, 230, 30)
    textBox:initialise()
    ui:addChild(textBox)


    local submitButton = ISButton:new(10, 50, 100, 25, "Submit", ui, function()
        local args =
        {
            sourcePlayerID = self.character:getOnlineID(),
            name = self.character:getUsername(),
            value = tonumber(textBox:getText()),
            coords =
            {
                x = self.character:getX(),
                y = self.character:getY(),
                z = self.character:getZ()
            },
            mode = self.selectedMode
        }
        sendClientCommand('DeadlineDice', 'requestSendInitiativeData', args)
    ui:removeFromUIManager()    
    end)
    submitButton:initialise()
    ui:addChild(submitButton)

    -- Cancel Button
    local cancelButton = ISButton:new(120, 50, 100, 25, "Cancel", ui, function()
        print("UI Cancelled")
        ui:removeFromUIManager()
    end)
    cancelButton:initialise()
    ui:addChild(cancelButton)
    local titleLabel = ISLabel:new(240, 0, 25, "Input your new Initiative value:", 1, 1, 1, 1, UIFont.Small)
    titleLabel:initialise()
    ui:addChild(titleLabel)
end

function ISDeadlineDiceUI:close()
    ISDeadlineDiceUI.instance = nil
    self:setVisible(false);
    self:removeFromUIManager();
end

function ISDeadlineDiceUI:updateHitPointsBars()
    local hitPoints = DeadlineDice.hitPoints or 0

    for idx, pip in ipairs(self.hitPointsBars) do
        local pipHP = idx - 1
        if pipHP <= hitPoints then
            pip:setImage(getTexture("media/ui/fullnew.png"))
        else
            pip:setImage(getTexture("media/ui/emptynew.png"))
        end
    end
    self.hitPointsLabel.name = "Hit Point Tracker: " .. tostring(hitPoints)
end

function ISDeadlineDiceUI:increaseHitPoints()
        if getPlayer():HasTrait("Sturdy") then
        maxHitPoints = 14
    elseif getPlayer():HasTrait("Fragile") then
       maxHitPoints = 10
    elseif not getPlayer():HasTrait("Sturdy") and not getPlayer():HasTrait("Fragile") then
        maxHitPoints = 12
    end

    if getPlayer():getModData().MedLine and getPlayer():getModData().MedLine.BloodData then
        local bloodData = getPlayer():getModData().MedLine.BloodData;
        if bloodData.bloodLossTimeoutUnix and bloodData.bloodLossTimeoutUnix > getTimestamp() then
            maxHitPoints = maxHitPoints - (SandboxVars.MedLine.BloodLoss_DiceHPDisadvantage or 2);
            print("DeadlineDice - MedLine blood loss integration.");
        end
    end
    
    DeadlineDice.hitPoints = math.min(DeadlineDice.hitPoints + 1, maxHitPoints)

    local playerName = self.character:getDescriptor():getForename()
    table.insert(self.sayQueue, "Current Hit Points set at: " .. tostring(DeadlineDice.hitPoints))
    localtext = self.character:getUsername() .. " set Hit Points at: " .. tostring(DeadlineDice.hitPoints)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    DeadlineDice.lastHealthClick = getTimestamp()

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:changeHitPoints(newValue)
    local oldHP = DeadlineDice.hitPoints or 0
    newValue = math.max(0, newValue)

    if getPlayer():HasTrait("Sturdy") then
        newValue = math.min(newValue, 14)
    elseif getPlayer():HasTrait("Fragile") then
        newValue = math.min(newValue, 10)
    else
        newValue = math.min(newValue, 12)
    end



    DeadlineDice.hitPoints = newValue
    DeadlineDice.hpTracker = DeadlineDice.hpTracker or {}
DeadlineDice.hpTracker[self.character:getUsername()] = newValue
    sendClientCommand("DeadlineDice", "SyncHP", {
        sourcePlayerID = getPlayer():getOnlineID(),
        coords = {
            x = getPlayer():getX(),
            y = getPlayer():getY(),
            z = getPlayer():getZ()
        },
        username = self.character:getUsername(),
        hp = newValue

    })
    local playerName = self.character:getDescriptor():getForename()
    local verb = (newValue < oldHP) and "took damage. Hitpoints lowered from" or "healed damage. Hitpoints increased from"
    if newValue == oldHP then 
        verb = "states their HP is" 
    local message = string.format("%s %s %d", playerName, verb, oldHP, newValue)    
    table.insert(self.sayQueue, message)
    local logText = self.character:getUsername() .. " " .. verb .. " " .. oldHP
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = logText})

    DeadlineDice.lastHealthClick = getTimestamp()
    return
    end
    local message = string.format("%s %s %d to %d", playerName, verb, oldHP, newValue)

    table.insert(self.sayQueue, message)

    local entry = {
        player = playerName,
        hp = tostring(newValue),
        oldHp = tostring(oldHP)
    }
    sendClientCommand("DiceLogging", "ChangeHP", entry)

    local logText = self.character:getUsername() .. " " .. verb .. " " .. oldHP .. " to " .. newValue
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = logText})

    DeadlineDice.lastHealthClick = getTimestamp()

    local diceBloodLossThreshold = SandboxVars.MedLine.BloodLoss_DiceHPThreshold or 3;
    if DeadlineDice.hitPoints <= diceBloodLossThreshold then
        table.insert(self.sayQueue, playerName .. " has dropped to critical HP and has been given the blood loss popup dialog.");
        sendClientCommand(getPlayer(), "MedLine", "DICE_ShowCriticalHealthPopup", { hp = diceBloodLossThreshold });
    end

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:decreaseHitPoints()
    DeadlineDice.hitPoints = math.max(DeadlineDice.hitPoints - 1, 0)

    local playerName = self.character:getDescriptor():getForename()
    table.insert(self.sayQueue, playerName .. " took damage. Current hit points: " .. tostring(DeadlineDice.hitPoints))
    local entry = {
        player = playerName,
        hp = tostring(DeadlineDice.hitPoints)
    }
    sendClientCommand("DiceLogging", "DecreaseHP", entry)
    localtext = self.character:getUsername() .. " took damage. Current hit points: " .. tostring(DeadlineDice.hitPoints)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})
    DeadlineDice.lastHealthClick = getTimestamp()

    local diceBloodLossThreshold = SandboxVars.MedLine.BloodLoss_DiceHPThreshold or 3;
    if DeadlineDice.hitPoints <= diceBloodLossThreshold then
        table.insert(self.sayQueue, playerName .. " has dropped to critical HP and has been given the blood loss popup dialog.");
        sendClientCommand(getPlayer(), "MedLine", "DICE_ShowCriticalHealthPopup", { hp = diceBloodLossThreshold });
    end

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:resetHitPoints()
    if getPlayer():HasTrait("Sturdy") then
    DeadlineDice.hitPoints = 14
    elseif getPlayer():HasTrait("Fragile") then
    DeadlineDice.hitPoints = 10
    else
    DeadlineDice.hitPoints = 12
    end

    if getPlayer():getModData().MedLine and getPlayer():getModData().MedLine.BloodData then
        local bloodData = getPlayer():getModData().MedLine.BloodData;
        if bloodData.bloodLossTimeoutUnix and bloodData.bloodLossTimeoutUnix > getTimestamp() then
            DeadlineDice.hitPoints = DeadlineDice.hitPoints - (SandboxVars.MedLine.BloodLoss_DiceHPDisadvantage or 2);
            print("DeadlineDice - MedLine blood loss integration.");
        end
    end

    local playerName = self.character:getDescriptor():getForename()
    table.insert(self.sayQueue, playerName .. " has reset their hit points to: " .. tostring(DeadlineDice.hitPoints))
    localtext = self.character:getUsername() .. " has reset their Hit Points to: " .. tostring(DeadlineDice.hitPoints)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Dice", logText = localtext})

    DeadlineDice.lastHealthClick = getTimestamp()

    self:updateHitPointsBars()
end

function ISDeadlineDiceUI:resetInitiativeTracker()
    -- Clear the initiative tracker and order tracker
    DeadlineDice.initiativeTracker = {}
    DeadlineDice.orderTracker = {}
    self.rollInitiative:setEnable(true)
    -- Add a message to the sayQueue to notify players
    local playerName = self.character:getDescriptor():getForename()
    table.insert(self.sayQueue, playerName .. " has reset the initiative tracker.")
    DeadlineDice.lastHealthClick = getTimestamp()
end

--]]

--************************************************************************--
--** ISDeadlineDiceUI:new
--**
--************************************************************************--
function ISDeadlineDiceUI:new(x, y, character)
    
    local width = 770
    local height = 815
    local o = ISCollapsableWindow.new(self, x, y, width, height);
    o.playerNum = character:getPlayerNum()
    if y == 0 then
        o.y = getPlayerScreenTop(o.playerNum) + (getPlayerScreenHeight(o.playerNum) - height) / 2
        o:setY(o.y)
    end

    --Right positioning
    if x == 0 then
        local screenWidth = getPlayerScreenWidth(o.playerNum)
        local width = o:getWidth()
        local offset = 100
        o.x = getPlayerScreenLeft(o.playerNum) + screenWidth - width - offset
        o:setX(o.x)
    end

    --Center Positioning
    -- if x == 0 then
    --     o.x = getPlayerScreenLeft(o.playerNum) + (getPlayerScreenWidth(o.playerNum) - width) / 2
    --     o:setX(o.x)
    -- end
    o.width = width;
    o.height = height;
    o.character = character;
    o.moveWithMouse = true;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;
    o.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    o.delay = 2
    o.cooldown = 10
    
    o.healthCooldown = 2
    o.selectedMode = "loud"
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 };
    o:setResizable(false)
    ISDeadlineDiceUI.instance = o;
    return o;
end

function simpleHash(data)
    local hash = 0
    for i = 1, #data do
        local byte = string.byte(data, i)
        hash = (hash * 31 + byte) % 2^32  -- Simple rolling hash
    end
    return hash
end

function hashFunctionContents(func)
    local info = debug.getinfo()  -- Get function source info
end

Events.OnTick.Add(function()
    if DeadlineDice.meleeMarkerActive and DeadlineDice.markerTimer then
        DeadlineDice.markerTimer = DeadlineDice.markerTimer - 1
        if DeadlineDice.markerTimer <= 0 then
            local player = getSpecificPlayer(0)
            local args = {
                x = math.floor(player:getX()),
                y = math.floor(player:getY()),
                z = player:getZ(),
                radius = 4.9,
                active = false
            }
            sendClientCommand("DeadlineDice", "ToggleMeleeMarker", args)

            DeadlineDice.meleeMarkerActive = false
            DeadlineDice.markerTimer = nil
        end
    end
end)


DeadlineDice.prevHighlightedSquares = DeadlineDice.prevHighlightedSquares or {}

Events.OnRenderTick.Add(function()
    if not DeadlineDice.CombatActive then return end

    -- Clear previous highlights
    for _, square in ipairs(DeadlineDice.prevHighlightedSquares) do
        if square and square:getFloor() then
            square:getFloor():setHighlighted(false)
        end
    end
    DeadlineDice.prevHighlightedSquares = {}

    -- Highlight current player tiles
    for _, username in ipairs(DeadlineDice.orderTracker) do
        local player = getPlayerByUsername(username)
        if player then
            local square = getCell():getGridSquare(
                math.floor(player:getX()),
                math.floor(player:getY()),
                player:getZ()
            )
            if square and square:getFloor() then
       --         square:getFloor():setHighlightColor(1, 0, 1, 0.5)
       --         square:getFloor():setHighlighted(true)
                table.insert(DeadlineDice.prevHighlightedSquares, square)
            end
        end
    end
end)

Events.OnPlayerUpdate.Add(function(player)
    --[[
    if not DeadlineDice.CombatActive then return end
    local player = getSpecificPlayer(0)
    local username = player:getUsername()
    local locked = DeadlineDice.lockedTiles and DeadlineDice.lockedTiles[username]
    if not locked then return end

    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = player:getZ()

    if px ~= locked.x or py ~= locked.y or pz ~= locked.z then
        -- Move player back to locked tile
        player:setX(locked.x + 0.5)
        player:setY(locked.y + 0.5)
        player:setZ(locked.z)

        if not player:isLocalPlayer() then return end
        if not DeadlineDice.lastWarnTime or (getTimestampMs() - DeadlineDice.lastWarnTime > 3000) then
            player:Say("You can't move during combat!")
            DeadlineDice.lastWarnTime = getTimestampMs()
        end
    end
    ]]
end)


function isOtherPlayerNearby(range)
    local localPlayer = getSpecificPlayer(0)
    if not localPlayer then return false end

    local lx, ly, lz = math.floor(localPlayer:getX()), math.floor(localPlayer:getY()), localPlayer:getZ()

    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer ~= localPlayer then
            local ox, oy, oz = math.floor(otherPlayer:getX()), math.floor(otherPlayer:getY()), otherPlayer:getZ()

            if oz == lz then
                local dx = math.abs(ox - lx)
                local dy = math.abs(oy - ly)

                if dx <= range and dy <= range then
                    return true
                end
            end
        end
    end

    return false
end



function clamp(n, lo, hi) if n < lo then return lo elseif n > hi then return hi else return n end end

function ISDeadlineDiceUI:getCurrentSubject()
    return DeadlineDice.Subjects[DeadlineDice.textoption]
end

function ISDeadlineDiceUI:getCurrentPageIndex()
    local s = self:getCurrentSubject(); if not s then return 1 end
    local idx = DeadlineDice.pageIndexBySubject[DeadlineDice.textoption] or 1
    idx = clamp(idx, 1, #s.pages)
    DeadlineDice.pageIndexBySubject[DeadlineDice.textoption] = idx
    return idx
end

function ISDeadlineDiceUI:setCurrentPageIndex(idx)
    local s = self:getCurrentSubject(); if not s then return end
    idx = clamp(idx, 1, #s.pages)
    DeadlineDice.pageIndexBySubject[DeadlineDice.textoption] = idx
    self:updatePageUI()
end

function ISDeadlineDiceUI:getCurrentPageTexture()
    local s = self:getCurrentSubject(); if not s then return nil end
    local idx = self:getCurrentPageIndex()
    local path = s.pages[idx]
    if not DeadlineDice._pageTexCache[path] then
        DeadlineDice._pageTexCache[path] = getTexture(path)
    end
    return DeadlineDice._pageTexCache[path]
end

function ISDeadlineDiceUI:updatePageUI()
    local s = self:getCurrentSubject(); if not s then return end
    local idx = self:getCurrentPageIndex()
    local count = #s.pages
    if self.btnPagePrev  then self.btnPagePrev:setVisible(count > 1 and idx > 1) end
    if self.btnPageNext  then self.btnPageNext:setVisible(count > 1 and idx < count) end
end

function ISDeadlineDiceUI:updatePageNav()
    local s = DeadlineDice.Subjects and DeadlineDice.Subjects[DeadlineDice.textoption]
    local count = (s and s.pages and #s.pages) or 0

    local idx = self:getCurrentPageIndex() or 1
    if idx < 1 then idx = 1 end
    if count > 0 and idx > count then idx = count end

    local showPrev = (count > 1) and (idx > 1)
    local showNext = (count > 1) and (idx < count)

    if self.btnTextbookPrevPage then
        self.btnTextbookPrevPage:setVisible(showPrev)
        self.btnTextbookPrevPage:setEnable(showPrev)
    end
    if self.btnTextbookNextPage then
        self.btnTextbookNextPage:setVisible(showNext)
        self.btnTextbookNextPage:setEnable(showNext)
    end
end

function DeadlineDice.broadcastFullInitiative(rangeOverride)

    local me = getPlayer(); if not me then return end

    local args = {
        sourcePlayerID = me:getOnlineID(),
        coords = { x = me:getX(), y = me:getY(), z = me:getZ() },
        range = rangeOverride or 30,
        mode  = "loud",
        order = DeadlineDice.orderTracker or {},
        tracker = DeadlineDice.initiativeTracker or {},
        hptracker = DeadlineDice.hpTracker or {},
    }

    sendClientCommand("DeadlineDice", "SyncFullInitiative", args)
end