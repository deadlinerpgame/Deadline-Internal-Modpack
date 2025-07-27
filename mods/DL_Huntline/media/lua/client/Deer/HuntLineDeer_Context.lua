HuntLineDeer = HuntLineDeer or {}


function HuntLineDeer.Context(player, context, worldobjects)
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


			local ri = opt:addOptionOnTop(getText('ContextMenu_HuntLineDeer_Reward'))
			local spwnRewardOpt = ISContextMenu:getNew(opt)
			opt:addSubMenu(ri, spwnRewardOpt)




			spwnRewardOpt:addOption("x3", worldobjects, function()
				HuntLineDeer.SpawnRewards(sq)
				HuntLineDeer.SpawnRewards(sq)
				HuntLineDeer.SpawnRewards(sq)
			end);

			spwnRewardOpt:addOption("x1", worldobjects, function()
				HuntLineDeer.SpawnRewards(sq)
			end);




			local sb = opt:addOptionOnTop(getText('ContextMenu_HuntLineDeer_Population'))
			local spwn = ISContextMenu:getNew(opt)
			opt:addSubMenu(sb, spwn)

			-----------------------            ---------------------------

			if sq and zed then
				local fit = HuntLineDeer.getOutfitName(zed)
				if fit then
					opt:addOption('set stats: '..tostring(fit), worldobjects, function()
						HuntLineDeer.setStats(zed)
						print(HuntLineDeer.getOutfitName(zed))
					end);
				end
				local isCrawler = HuntLineDeer.isCrawler(zed)
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
						HuntLineDeer.setCrawler(zed)
					end);
				end
				local speedData = zed:getVariableString('AnimSpeed')

				if speedData then
					opt:addOption("AnimSpeed: "..tostring(speedData), worldobjects, function()
						HuntLineDeer.setAnimSpeed(zed)
					end);
				end

			end
			if sq then

				local sIco = spwn:addOption(getText('ContextMenu_Deer_Spawn'), worldobjects, function()
					HuntLineDeer.doSpawn(sq, false, HuntLineDeer.outfit0)
				end);

			end

		end

	end
end
Events.OnFillWorldObjectContextMenu.Remove(HuntLineDeer.Context)
Events.OnFillWorldObjectContextMenu.Add(HuntLineDeer.Context)
