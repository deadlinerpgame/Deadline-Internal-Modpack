HuntLineRabbit = HuntLineRabbit or {}


function HuntLineRabbit.Context(player, context, worldobjects)
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


			local ri = opt:addOptionOnTop(getText('ContextMenu_HuntLineRabbit_Reward'))
			local spwnRewardOpt = ISContextMenu:getNew(opt)
			opt:addSubMenu(ri, spwnRewardOpt)




			spwnRewardOpt:addOption("x3", worldobjects, function()
				HuntLineRabbit.SpawnRewards(sq)
				HuntLineRabbit.SpawnRewards(sq)
				HuntLineRabbit.SpawnRewards(sq)
			end);

			spwnRewardOpt:addOption("x1", worldobjects, function()
				HuntLineRabbit.SpawnRewards(sq)
			end);




			local sb = opt:addOptionOnTop(getText('ContextMenu_HuntLineRabbit_Population'))
			local spwn = ISContextMenu:getNew(opt)
			opt:addSubMenu(sb, spwn)

			-----------------------            ---------------------------

			if sq and zed then
				local fit = HuntLineRabbit.getOutfitName(zed)
				if fit then
					opt:addOption('set stats: '..tostring(fit), worldobjects, function()
						HuntLineRabbit.setStats(zed)
						print(HuntLineRabbit.getOutfitName(zed))
					end);
				end
				local isCrawler = HuntLineRabbit.isCrawler(zed)
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
						HuntLineRabbit.setCrawler(zed)
					end);
				end
				local speedData = zed:getVariableString('AnimSpeed')

				if speedData then
					opt:addOption("AnimSpeed: "..tostring(speedData), worldobjects, function()
						HuntLineRabbit.setAnimSpeed(zed)
					end);
				end

			end
			if sq then

				local sIco = spwn:addOption(getText('ContextMenu_Rabbit_Spawn'), worldobjects, function()
					HuntLineRabbit.doSpawn(sq, false, HuntLineRabbit.outfit0)
				end);

			end

		end

	end
end
Events.OnFillWorldObjectContextMenu.Remove(HuntLineRabbit.Context)
Events.OnFillWorldObjectContextMenu.Add(HuntLineRabbit.Context)
