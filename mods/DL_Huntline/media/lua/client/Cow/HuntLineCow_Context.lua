HuntLineCow = HuntLineCow or {}


function HuntLineCow.Context(player, context, worldobjects)
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


			local ri = opt:addOptionOnTop(getText('ContextMenu_HuntLineCow_Reward'))
			local spwnRewardOpt = ISContextMenu:getNew(opt)
			opt:addSubMenu(ri, spwnRewardOpt)




			spwnRewardOpt:addOption("x3", worldobjects, function()
				HuntLineCow.SpawnRewards(sq)
				HuntLineCow.SpawnRewards(sq)
				HuntLineCow.SpawnRewards(sq)
			end);

			spwnRewardOpt:addOption("x1", worldobjects, function()
				HuntLineCow.SpawnRewards(sq)
			end);




			local sb = opt:addOptionOnTop(getText('ContextMenu_HuntLineCow_Population'))
			local spwn = ISContextMenu:getNew(opt)
			opt:addSubMenu(sb, spwn)

			-----------------------            ---------------------------

			if sq and zed then
				local fit = HuntLineCow.getOutfitName(zed)
				if fit then
					opt:addOption('set stats: '..tostring(fit), worldobjects, function()
						HuntLineCow.setStats(zed)
						print(HuntLineCow.getOutfitName(zed))
					end);
				end
				local isCrawler = HuntLineCow.isCrawler(zed)
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
						HuntLineCow.setCrawler(zed)
					end);
				end
				local speedData = zed:getVariableString('AnimSpeed')

				if speedData then
					opt:addOption("AnimSpeed: "..tostring(speedData), worldobjects, function()
						HuntLineCow.setAnimSpeed(zed)
					end);
				end

			end
			if sq then

				local sIco = spwn:addOption(getText('ContextMenu_Bull_Spawn'), worldobjects, function()
					HuntLineCow.doSpawn(sq, false, HuntLineCow.outfit0)
				end);

			end

		end

	end
end
Events.OnFillWorldObjectContextMenu.Remove(HuntLineCow.Context)
Events.OnFillWorldObjectContextMenu.Add(HuntLineCow.Context)
