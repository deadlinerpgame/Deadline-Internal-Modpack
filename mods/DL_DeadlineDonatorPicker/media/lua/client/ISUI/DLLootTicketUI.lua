

--[[function DLLootTicketUI:initialise()
    ISPanelJoypad.initialise(self);
end

function DLLootTicketUI:new(x, y, width, height, state)
    local o = {};
    o = ISPanelJoypad:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.width = width;
    o.height = height;
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=1};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.anchorTop = true;
    o.moveWithMouse = true;
    o.drawFrame = true;
    o.showBackground = true;
    o.showBorder = false;
    return o;
end--]]