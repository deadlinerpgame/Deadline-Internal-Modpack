require("ISUI/ISScrollingListBox")

local VirtualListBox = ISScrollingListBox:derive("KBWVirtualListBox")

function VirtualListBox:rowAt(x, y)
    if y < 0 then return -1 end
    local row = math.floor(y / self.itemheight) + 1
    return row >= 1 and row <= #self.items and row or -1
end

function VirtualListBox:topOfItem(index)
    if index < 1 or index > #self.items then return -1 end
    return (index - 1) * self.itemheight
end

function VirtualListBox:ensureVisible(index)
    if not index or index < 1 or index > #self.items then return end
    local y = self:topOfItem(index)
    if not self.smoothScrollTargetY then self.smoothScrollY = self:getYScroll() end
    if y <= -self:getYScroll() then
        self.smoothScrollTargetY = -y
    elseif y + self.itemheight > -self:getYScroll() + self.height then
        self.smoothScrollTargetY = -(y + self.itemheight - self.height)
    end
end

function VirtualListBox:clear()
    self.items = {}
    self.selected = 0
    self.itemheightoverride = {}
    self.count = 0
    self.smoothScrollTargetY = nil
    self.smoothScrollY = nil
    self:setScrollHeight(0)
    self:setYScroll(0)
end

function VirtualListBox:replaceItems(rows, textField, itemField)
    textField = textField or "name"
    itemField = itemField or "definition"
    local items = {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        items[rowIndex] = {
            text = row[textField],
            item = row[itemField],
            itemindex = rowIndex,
            index = rowIndex,
            height = self.itemheight
        }
    end
    self.items = items
    self.count = #items
    self.smoothScrollTargetY = nil
    self.smoothScrollY = nil
    self:setYScroll(0)
    self:setScrollHeight(self.count * self.itemheight)
end

function VirtualListBox:prerender()
    local count = #self.items
    if self.selected > count then self.selected = count end
    self.listHeight = count * self.itemheight

    self:drawRect(
        0, -self:getYScroll(), self.width, self.height,
        self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b
    )
    local inset = self.drawBorder and 1 or 0
    if self.drawBorder then
        self:drawRectBorder(
            0, -self:getYScroll(), self.width, self.height,
            self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b
        )
    end
    local stencilWidth = self.width - inset * 2
    if self:isVScrollBarVisible() then stencilWidth = self.vscroll.x + 3 - inset end
    self:setStencilRect(inset, inset, stencilWidth, self.height - inset * 2)

    if count > 0 then
        local visibleTop = math.max(0, -self:getYScroll())
        local first = math.max(1, math.floor(visibleTop / self.itemheight) + 1)
        local last = math.min(count, math.ceil((visibleTop + self.height) / self.itemheight) + 1)
        for rowIndex = first, last do
            local item = self.items[rowIndex]
            item.index = rowIndex
            item.height = self.itemheight
            self:doDrawItem((rowIndex - 1) * self.itemheight, item, rowIndex % 2 == 0)
        end
    end

    self:clearStencilRect()
    local mouseY = self:getMouseY()
    self:updateSmoothScrolling()
    if mouseY ~= self:getMouseY() and self:isMouseOver() then
        self:onMouseMove(0, self:getMouseY() - mouseY)
    end
    self:updateTooltip()
    if self.useStencilForChildren then self:setStencilRect(0, 0, self.width, self.height) end
end

return VirtualListBox
