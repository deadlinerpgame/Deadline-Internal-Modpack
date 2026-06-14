require("ISUI/ISScrollingListBox")

local Theme = require("ElyonLib/UI/Theme/Theme")
local TextUtils = require("ElyonLib/TextUtils/TextUtils")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")
local RulesData = require("DL_Dice2026/UI/DiceRulesData")

local T = Theme.colors

local DiceRules = DicePanelBase:derive("DiceRules")

function DiceRules:tocWidth()
	return self:S(150)
end

function DiceRules:createChildren()
	DicePanelBase.createChildren(self)

	local pad = self:S(6)
	local tocW = self:tocWidth()
	local btnH = math.max(self:S(18), self.fontHgt + self:S(4))
	local btnW = self:S(54)

	self.tocList = ISScrollingListBox:new(pad, self.headerH + pad, tocW, self.fullH - self.headerH - pad * 2)
	self.tocList:initialise()
	self.tocList:instantiate()
	self.tocList.itemheight = math.max(self:S(22), self.fontHgt + self:S(6))
	self.tocList.font = self.font
	self.tocList.drawBorder = true
	Theme.applyListStyle(self.tocList)
	self.tocList.doDrawItem = DiceRules.drawTocItem
	self.tocList.onMouseDown = DiceRules.onTocMouseDown
	self.tocList.rulesOwner = self
	for i = 1, #RulesData.sections do
		self.tocList:addItem(RulesData.sections[i].title, i)
	end
	self:addChild(self.tocList)
	self:registerControl(self.tocList)

	self.prevButton = ISButton:new(tocW + pad * 2, self.fullH - btnH - pad, btnW, btnH, "< Prev", self, DiceRules.onPrev)
	self.nextButton = ISButton:new(self.width - btnW - pad, self.fullH - btnH - pad, btnW, btnH, "Next >", self, DiceRules.onNext)
	local nav = { self.prevButton, self.nextButton }
	for i = 1, #nav do
		nav[i]:initialise()
		nav[i].font = self.font
		Theme.applyButtonStyle(nav[i], nil)
		self:addChild(nav[i])
		self:registerControl(nav[i])
	end

	self.sectionIndex = 1
	self.pageIndex = 1
	self.tocList.selected = 1
end

function DiceRules.drawTocItem(listSelf, y, item, alt)
	local owner = listSelf.rulesOwner
	local textA = owner and owner:textAlpha() or 1
	local font = listSelf.font or UIFont.Small
	local fontH = getTextManager():getFontHeight(font)
	local h = listSelf.itemheight
	if listSelf.selected == item.index then
		listSelf:drawRect(0, y, listSelf:getWidth(), h - 1, T.selected.a * Core.settings.opacity, T.selected.r, T.selected.g, T.selected.b)
	elseif listSelf.mouseoverselected == item.index then
		listSelf:drawRect(0, y, listSelf:getWidth(), h - 1, T.hovered.a * Core.settings.opacity, T.hovered.r, T.hovered.g, T.hovered.b)
	end
	local text = TextUtils.trimToWidth(font, item.text, listSelf:getWidth() - 12, "..") or ""
	listSelf:drawText(text, 6, y + math.floor((h - fontH) / 2), T.text.r, T.text.g, T.text.b, textA, font)
	return y + h
end

function DiceRules.onTocMouseDown(listSelf, x, y)
	local row = listSelf:rowAt(x, y)
	if row and row >= 1 and row <= #listSelf.items then
		listSelf.selected = row
		local owner = listSelf.rulesOwner
		if owner then
			owner.sectionIndex = listSelf.items[row].item
			owner.pageIndex = 1
		end
	end
	return true
end

function DiceRules:currentSection()
	return RulesData.sections[self.sectionIndex or 1]
end

function DiceRules:pageInfo(page)
	if type(page) == "table" then
		return page.text or "", page
	end
	return page or "", nil
end

function DiceRules:onPrev()
	if (self.pageIndex or 1) > 1 then
		self.pageIndex = self.pageIndex - 1
	end
end

function DiceRules:onNext()
	local section = self:currentSection()
	if section and (self.pageIndex or 1) < #section.pages then
		self.pageIndex = self.pageIndex + 1
	end
end

function DiceRules:buildPageLines(text, maxW)
	local lines = {}
	local start = 1
	local len = string.len(text)
	while start <= len do
		local nl = string.find(text, "\n", start, true)
		local piece
		if nl then
			piece = string.sub(text, start, nl - 1)
			start = nl + 1
		else
			piece = string.sub(text, start)
			start = len + 1
		end
		if piece == "" then
			lines[#lines + 1] = ""
		else
			local wrapped = TextUtils.wrapLines(piece, self.font, maxW, 40)
			for j = 1, #wrapped do
				lines[#lines + 1] = wrapped[j]
			end
		end
	end
	return lines
end

function DiceRules:render()
	if self.collapsed then
		return
	end
	local textA = self:textAlpha()
	local pad = self:S(6)
	local tocW = self:tocWidth()
	local contentX = tocW + pad * 2
	local contentW = self.width - contentX - pad
	local section = self:currentSection()
	if not section then
		return
	end

	local titleFont = self.scale >= 2 and UIFont.Large or UIFont.Medium
	local titleH = getTextManager():getFontHeight(titleFont)

	local y = self.headerH + pad
	self:drawText(section.title, contentX, y, T.gold.r, T.gold.g, T.gold.b, textA, titleFont)
	y = y + titleH + self:S(4)

	local pageText, pageMeta = self:pageInfo(section.pages[self.pageIndex or 1])
	local lines = self:buildPageLines(pageText, contentW)
	local lineH = self.fontHgt + self:S(3)
	local maxY = self.fullH - math.max(self:S(28), self.fontHgt + self:S(12))
	for i = 1, #lines do
		if y + lineH > maxY then
			break
		end
		if lines[i] ~= "" then
			self:drawText(lines[i], contentX, y, T.text.r, T.text.g, T.text.b, textA, self.font)
			y = y + lineH
		else
			y = y + math.floor(lineH / 2)
		end
	end

	if pageMeta and pageMeta.image then
		if pageMeta.tex == nil then
			pageMeta.tex = getTexture(pageMeta.image) or false
		end
		local tex = pageMeta.tex
		local availH = maxY - y - self:S(6)
		if tex and availH > self:S(40) then
			local iw = pageMeta.imgW or 200
			local ih = pageMeta.imgH or 150
			local scale = math.min(contentW / iw, availH / ih, 1.5 * (self.scale or 1))
			local w = math.floor(iw * scale)
			local h = math.floor(ih * scale)
			local ix = contentX + math.floor((contentW - w) / 2)
			self:drawTextureScaled(tex, ix, y + self:S(4), w, h, textA, 1, 1, 1)
			self:drawRectBorder(ix - 1, y + self:S(4) - 1, w + 2, h + 2, T.borderDim.a * Core.settings.opacity, T.borderDim.r, T.borderDim.g, T.borderDim.b)
		end
	end

	local pageLabel = "Page " .. tostring(self.pageIndex or 1) .. " / " .. tostring(#section.pages)
	local labelW = TextUtils.measureWidth(self.font, pageLabel)
	self:drawText(pageLabel, contentX + math.floor((contentW - labelW) / 2), self.fullH - self.fontHgt - self:S(6), T.textMuted.r, T.textMuted.g, T.textMuted.b, textA, self.font)

	self.prevButton.enable = (self.pageIndex or 1) > 1
	self.nextButton.enable = (self.pageIndex or 1) < #section.pages
end

function DiceRules:onCoreEvent(event)
	if event == "opacity" then
		self:applyOpacity()
	end
end

function DiceRules:new()
	local s = Core.panelScale("rules")
	local width = Core.px(580 * (s >= 2 and 1.5 or 1))
	local height = Core.px(430 * (s >= 2 and 1.5 or 1))
	local o = DicePanelBase.new(self, "rules", "Combat rules", width, height, { xf = 0.32, yf = 0.18, visible = false })
	return o
end

return DiceRules
