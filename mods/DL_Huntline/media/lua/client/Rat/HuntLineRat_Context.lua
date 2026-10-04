HuntLineRat = HuntLineRat or {}


function HuntLineRat.Context(player, context, worldobjects)
	local pl = getSpecificPlayer(player)
	if not pl then return end
	local inv = pl:getInventory()
	local sq = clickedSquare
	local zed
	local worldSquare = nil
	if sq then
		zed = sq:getZombie()

		if (getCore():getDebug() or isAdmin()) then

			local Main = context:addOptionOnTop(getText('ContextMenu_AnimalDebug'))

			local opt = ISContextMenu:getNew(context)
			context:addSubMenu(Main, opt)








			-----------------------            ---------------------------

			if sq and zed then
				local fit = HuntLineRat.getOutfitName(zed)
				if fit then
					opt:addOption('set stats: '..tostring(fit), worldobjects, function()
						HuntLineRat.setStats(zed)
						print(HuntLineRat.getOutfitName(zed))
					end);
				end
				local isCrawler = HuntLineRat.isCrawler(zed)
				if isCrawler then
					local crawlType = zed:getCrawlerType()

					if crawlType then
						opt:addOption('CrawlerType '..tostring(crawlType), worldobjects, function()
							if crawlType ~= 2 then
								zed:setCrawlerType(2)
							elseif crawlType == 2 then
								zed:setCrawlerType(1)
							end
						end);
					end
				else
					opt:addOption("setCrawler", worldobjects, function()
						HuntLineRat.setCrawler(zed)
					end);
				end
				local speedData = zed:getVariableString('AnimSpeed')

				if speedData then
					opt:addOption("AnimSpeed: "..tostring(speedData), worldobjects, function()
						HuntLineRat.setAnimSpeed(zed)
					end);
				end

			end
			if sq then



			end

		end

	end
end
Events.OnFillWorldObjectContextMenu.Remove(HuntLineRat.Context)
Events.OnFillWorldObjectContextMenu.Add(HuntLineRat.Context)
