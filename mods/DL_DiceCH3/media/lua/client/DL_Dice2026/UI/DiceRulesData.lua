local DiceRulesData = {}

local IMG = "media/ui/DL_Dice2026/rules/"

DiceRulesData.sections = {
	{
		title = "Introduction",
		pages = {
			"! You must read the full rules on the Discord.\n! It is recommended to video record every PvP scene.\n! Deadline Dice is the default system for PvP.\n\n- Players may still choose to engage in mechanical combat, but only if all parties consent.\n- Staff will not untangle disputes arising from mechanical combat.\n- This rulebook is divided into tabs, each containing summarized information from the full rules found on Discord. It is still important that everyone reads the full rules on the Discord.",
			"! To speed up dice combat, we highly recommend that players prepare their dice moves in advance. When it's their turn, they can quickly paste their prepared text into the chatbox. To do this:\n\n- Select the prepared text using Ctrl + A (to select all).\n- Copy it with Ctrl + C.\n- Paste it into the chatbox with Ctrl + V.",
		},
	},
	{
		title = "Actions",
		pages = {
			"OVERVIEW\n\nWhen in dice combat, we speak of 'Actions'. Each turn a player may move 7 tiles and perform one action from the list below:\n\n- Dashing\n- Escaping\n- Surrendering\n- Grappling\n- Disengaging\n- Attacking\n- Reloading\n- Changing weapons",
		},
	},
	{
		title = "Initiating PVP",
		pages = {
			"- Do not click 'Start Combat' during this round. You click this button at the start of the second round.\n- The attacker needs a valid RP reason to start a PvP scene.\n- Initiation requires a hostile demand that includes a threat of violence.\n- The initiator types /meloud and describes how they intend to use violence. Then the initiator presses the 'Announce PvP' button.\n- As soon as PvP has been announced, everyone at the scene must freeze in place.\n- This includes players who are not planning to participate.\n- Players who were not in shout-range (and therefore did not hear the announcement), may not join the PvP. See our 'Scene sanctity' rules on the discord.",
			"SURRENDER OR PARTICIPATE IN COMBAT\n\n- If the initiator is attacking multiple people, he must select one player (ooc chat) to become the Primary Defender.\n- The Primary Defender now has two options:\n- Surrenders immediately by typing their surrender with a /meloud and complies with the hostile demands of the attacker (see surrendering rules).\n- Participates in the PvP by describing their intent (!) to fight or escape with a /meloud.\n- Example: \"/meloud pulls out his own weapon and aims it at the attacker\" or \"Attempts to run towards the door\"\n\nPVP INVOLVING VEHICLES\n\nRemember you cannot initiate PvP inside a vehicle.",
		},
	},
	{
		title = "First Round",
		pages = {
			"Dice combat in the first round is limited to two players maximum:\n\n- Primary Attacker\n- Primary Defender\n\nNobody rolls for initiative at this stage. All other players simply observe the first round and remain frozen in place.\n\nTURN ORDER\n\n1. Defender may choose to surrender\n2. Attacker's turn, the attacker may have his first turn.\n3. Defender's turn, the defender may then have their turn (attack, attempt to escape).\n\nTIES\n\n- If the attacker's roll is equal to the defender's roll, the attack is considered successful.",
			"SECOND ROUND\n\nOnce both attacker and defender have had their turn, and combat has not ended with a surrender. Then the second round begins.\n\nAt the start of this second round. Everyone who participates must roll for initiative.\n\nSee the 'Following Rounds' tab for more information\n\nTIES\n\nIf the attacker's roll is equal to the defender's roll, the attack is considered successful.",
		},
	},
	{
		title = "Following Rounds",
		pages = {
			"STARTING SECOND ROUND\n\nOnce both attacker and defender have had their turn and combat has not ended with a surrender. Then the second round begins.\n\nAt the start of the second round, every player who wants to join the PvP combat, rolls for initiative.\n\nOnce everyone rolled for initiative, one person clicks the 'Start Combat' button.\n\nActions are taken in initiative order from highest to lowest.\n\nThe initiative order remains the same for all following rounds.\n\nNo one may join the combat if they were not present (within shout range) at the start of the first initiation. (Unless all parties already present, agree).",
		},
	},
	{
		title = "Damage and HP",
		pages = {
			"MELEE DAMAGE\n\n- Unarmed melee combat: 1 HP\n- Improvised melee weapon: 2 HP\n- One handed melee weapon: 2 HP\n- Two handed melee weapon: 3 HP\n\nRANGED\n\n- Pistols 3 HP (max 15 range)\n- Shotgun 4 HP (max 15 range)\n- Rifles: 4 HP (max 20 range)\n- Crossbow: 4 HP (max 20 range, 1 turn reload)\n- Throwing a weapon: 2 HP (max 10 range)\n\nAll scrap/junk ranged weapons do -1 HP less damage.\n\nEXPLOSIVES\n\n- Fire Bomb/Molotov: 1 HP for 3 turns (3x3 area, max 10 range)\n- Aerosol- and Pipebomb: 4 HP (4x4 area, max 10 range)",
			"CHANGING WEAPONS\n\n- Switching from a melee weapon to a ranged weapon, or vice versa, counts as an action. If you change weapons on your turn, you cannot perform any other actions that turn.\n- If you begin combat unarmed, you may equip a weapon without it counting as an action\n\nRELOADING\n\n- Reloading a crossbow counts as an action.\n- Reloading a rifle, pistol or gun does not count as an action.\n\nTIES\n\n- If the attacker's roll is equal to the defender's roll, the attack is considered successful.\n\nDUAL WIELDING\n\n! You may have one weapon equipped maximum. Wielding more than one weapon is not allowed.",
		},
	},
	{
		title = "Critical Hits and Fails",
		pages = {
			"CRITICAL HITS!\n\nWhen rolling the attack dice, you have a chance to land a critical hit. This can either be a critical success or a critical failure.\n\nCRITICAL SUCCESS (NATURAL 20)\n\nIf you roll a natural 20 on your attack and your opponent's defense roll is lower, you get a critical hit. You then get to roll for extra damage to your opponent's HP by typing: /roll 1d4.\n\nThe result of this roll is added to the normal damage dealt by your weapon as bonus damage to your opponent's HP.\n\nNote! A critical hit does not automatically guarantee victory. The opponent might roll a 19 and, with traits that give a defence bonus, reach a total of 21, beating the natural 20.",
			"LUCKY & UNLUCKY\n\nIf you have the 'Lucky' trait; then a roll of 19 will count as a critical success.\n\nIf you have the 'Unlucky' trait; then a roll of 2 will count as a critical failure.\n\nCRITICAL FAILURE (NATURAL 1)\n\nRolling a natural 1 on an attack = automatic miss.\n\nOpponent does not roll to defend.\n\nThe text will display 'Critical Failure' next to the roll.",
			"BAD CRITICAL FAILURE EXAMPLES\n\nThe player who rolled the dice is the player who describes the outcome of the critical failure.\n\nA critical failure's impact may only affect your own character. You cannot accidentally hit, injure, or otherwise negatively impact other players or their characters.\n\nWHEN DESCRIBING A CRITICAL FAILURE, YOU MUST:\n\nStay realistic in detailing the failed action.\n\nIf you choose to describe an injury, it must be reasonable and appropriate for the situation.\n\nEXAMPLES OF ROLEPLAY THAT SHOULD NOT OCCUR:\n\nHitting or injuring another character because of the failed roll.\n\nAny outcome that removes another player's agency or forces them to react in a specific way.",
			"THROWING EXPLOSIVES\n\nIf you critically fail when throwing any explosive:\n\n- The explosive does not detonate and does not cause damage.\n- It should be roleplayed as poorly functioning or defective (faulty fuse, failed ignition, not enough fuel)",
		},
	},
	{
		title = "Surrendering",
		pages = {
			"By surrendering, a player places themselves at the mercy of the opposing party and agree to comply with any realistic demands.\n\nSURRENDERING AT THE START OF COMBAT\n\nA player may surrender when PvP is initiated. In this case, the surrender must be accepted by the opponent.",
			"A player may also choose to surrender during one of the later combat rounds. In this situation:\n\n- The opponent is not required to accept the surrender.\n- If the opponent does accept, then they must confirm it in character.\n- Once confirmed, the surrender is OOC binding and cannot be undone.\n- In PvP scenes with multiple players, all members of the opposing team must agree to the surrender for it to be valid.\n- Attempting to surrender is considered an action, but only if it is accepted. If the surrender is declined, you may still perform another action.\n\nNote: If all involved combatants on one side have surrendered, the PvP scene ends and proceeds with roleplay.",
			"A surrendered party:\n\n- Must drop any weapon they are holding on the ground.\n- Cannot join or rejoin the PvP fight if one continues.\n- Cannot attempt to flee during the combat scene or when it has finished.\n- Becomes the prisoner of the attacker (if they win the dice combat scene), and will not resist being restrained or kidnapped.\n- Cannot contact other parties by radio.\n- Is not a valid target for attacks.\n- Can roleplay/emote appropriate self-preservation and compliance such as ducking and cowering in a gunfight or following commands of an attacker. They may not use self-preservation to gain an IC advantage, escape, or provide assistance.",
			"SURRENDERING FAIL INVITES CONSEQUENCES\n\nA surrendered character can still roleplay, move, and speak. However, if they resist, threaten, or fail to obey realistic demands, the opponent may attack them on their turn and drop them to 0 HP immediately without an attack roll.\n\nThe surrendered player must then roll \"Dice with Death.\" By default, the character who failed to surrender properly becomes unconscious for the rest of the PvP scene; the dice roll decides whether they ultimately survive or die.",
			"WHAT HAPPENS AFTER COMBAT?\n\n- You may search the surrendered character (cannot be done during combat).\n- You may steal items from the surrendered character (see our Robbery rules).\n- You may also choose to kidnap them and make them your prisoner (see our Prison rules).\n- You can also simply leave them alone.\n- You can make a reasonable demand.\n- If the character who surrendered is the target of your approved murder ticket, you may also murder them (with roleplay).",
			"SEARCHING A SURRENDERED CHARACTER\n\nIt is the responsibility of the searcher to emote a thorough search for what they're looking for.\n\n/meloud pats him down for weapons and radios.\n\n- The defender must then drop his weapons and radio. This includes tools like a screwdriver, a saw, etc.\n- We have a mod that allows a player to search another player for weapons. If the mod does not recognize a weapon, inform the player OOC that your character has a weapon.",
			"- If the captors are not roleplaying the searching, you may keep realistic items on your character. Hiding a wood axe or shotgun under a jacket is not allowed.\n- Using stealth rolls to hide a weapon is not allowed by default. The captor may decline OOC proposals.\n- Attempting to hide a weapon means you are no longer surrendering and become a valid target again.\n\nREASONABLE & REALISTIC DEMANDS\n\n- In-Character: made by a character during play, not as an OOC instruction.\n- Possible: something a person could actually comply with in the moment.\n- Scene-bound: apply only to the current scene.\n- Allowed by the rules: cannot break OOC robbery limits, consent requirements, or game mechanics.",
			"NOT REASONABLE & REALISTIC\n\nExamples: demanding more than OOC robbery rules permit; forcing OOC consent to graphic content; demands that are impossible or would cause lethal harm.\n\n[OK] \"Drop your weapon and step back.\"\n[OK] \"Walk ten paces away while we leave.\"\n[X] \"Bring me supplies tomorrow or you've failed surrender.\"\n[X] \"Sit there while I cut your ear off with these rusty scissors and....\"",
		},
	},
	{
		title = "Escape",
		pages = {
			"ESCAPE REQUIREMENTS\n\nEscaping requires that you:\n\n- Be physically capable of fleeing. You cannot escape if you are bound, severely injured in a movement-affecting manner, or grappled.\n- Are in an environment where escape is realistically possible.\n\nEXAMPLES WHERE ESCAPE IS POSSIBLE\n\n- A street\n- An open field\n- A room with an unblocked door\n\nEXAMPLES WHERE ESCAPE IS NOT POSSIBLE\n\n- Locked in a room\n- Cornered in an alleyway with the exit blocked\n- Trapped in a vehicle at a roadblock with no path forward",
			"ESCAPING BEFORE COMBAT STARTS\n\nIf a player meets all escape requirements, they may attempt to flee before PvP combat is initiated.\n\n- The player must type a /meloud that clearly describes how they are attempting to flee (running away, driving off, escaping through a window, and so on).\n- They then click the 'Announce PvP' button. Everyone at the scene freezes in place.\n- The potential attacker, must then decide to either respond with a PvP initiation, or let the player escape.\n- If combat is initiated, the First Round of PvP begins (see the First Round rules). The attacker gets the first turn.",
			{
				text = "DISTANCE\n\nThis only applies when both players are close enough for normal conversation (within range of messages typed with /say). If a player spots their enemy from a distance outside of say-range, they may leave mechanically without needing to emote their escape.",
				image = IMG .. "escape_distance.png",
				imgW = 299,
				imgH = 171,
			},
			"ESCAPING DURING COMBAT\n\nRequirements for attempting an escape during combat:\n\n- The escapee must meet all escape requirements.\n- The escapee has not done any other actions this turn.\n- The escapee cannot be grappled by another player.\n- The escapee must have a clear, unobstructed path out of the scene. If the only possible route requires moving directly past an attacker, the escape is not possible.\n- The escape attempt may only be done on the escapee's turn.\n- Important: The escape action can not be combined with any movement. If you want to use the escape action, you lose your default movement for this round.",
			"ESCAPE ROLL\n\n- Before rolling, count the number of tiles (diagonal or straight) between the escapee and their closest opponent. Only empty tiles are counted; do not include tiles occupied by players.\n- Begin with the number 20, then subtract 2 for each empty tile counted.\n- The escapee rolls the escape dice.\n- To succeed, the result must be equal to or higher than the modified number.\n\nOUTCOME\n\n- Success: The escape is successful, and the escapee must leave the scene. (They may not stick around to watch OOC.)\n- Failure: The attempt fails, and the escapee remains in combat. They may now use their 7 tiles of movement.",
			"RULES FOR ESCAPED CHARACTERS\n\n- You may not return to the scene under any circumstances while it is still active.\n- You are not allowed to take actions related to the scene until combat is resolved. This includes gathering allies, planning retaliation, or preparing a follow-up attack.\n- If you are unsure whether combat has ended, create an Open Communication thread in Discord and tag the involved players so they can confirm.\n- You may not use radios to call about the scene until it has been confirmed out of character that the scene has ended.\n- You must leave the area entirely. Staying nearby to observe is not allowed.",
		},
	},
	{
		title = "Movement",
		pages = {
			{
				text = "On your turn, you can move up to 7 tiles. You can move in any direction, horizontal, vertical, or diagonal. By default, every player may move 7 tiles each turn.\n\nDASH\n\nYou may use the Dash action to gain an additional 7 movement on your turn.\n\n- This counts as an action, you can only do one action each turn.\n- You cannot use the Dash action two turns in a row.",
				image = IMG .. "movement_dash.png",
				imgW = 211,
				imgH = 124,
			},
		},
	},
	{
		title = "Grappling",
		pages = {
			{
				text = "GRAPPLING\n\nA grappled character cannot move freely. Their movement is locked as long as the grapple is maintained. Grappling is not to be confused with restraining, which is not part of our PvP rules.",
				image = IMG .. "grappling.png",
				imgW = 285,
				imgH = 183,
			},
			"HOW TO GRAPPLE\n\nGrappling is an action.\n\n- You may grapple if your target is in melee range.\n- You need to have one free hand to grapple someone.\n\nTO GRAPPLE\n\n1. Describe your attempt.\n2. Roll Attack (unarmed).\n3. Opponent rolls Defend (close).\n4. If your roll is higher or equal to the opponent's roll, the grapple succeeds.\n\nGrappling does no damage by itself.",
			"THE GRAPPLER\n\n- Must keep one hand free to maintain the hold.\n- May still attack anyone if in range (melee/ranged), but only with one-handed weapons.\n- May not move unless the grapple is released.\n- May release the grapple during their turn (free action).\n\nTHE GRAPPLED\n\n- May still attack anyone if in range (melee/ranged).\n- May not move unless the grapple is broken.\n- May attempt to break free (action).\n- Cannot move tiles freely.",
			"BREAKING A GRAPPLE\n\nBreaking free from a grapple is considered an action and can only be taken on your turn.\n\nTO BREAK FREE\n\n1. Roll Attack (unarmed or any weapon).\n2. Opponent rolls Defend (close).\n3. If your roll is higher or equal you escape the grapple.\n\nOTHER INFO\n\n- A player can only be grappled by one person at the same time.\n- Restraining or handcuffing someone during combat is not allowed.",
		},
	},
	{
		title = "Attack of Opportunity",
		pages = {
			"An Attack of Opportunity (AoO) is a special reaction that lets a player make a free attack during another player's turn.\n\nWHEN DOES AN AOO TAKE PLACE?\n\nAn Attack of Opportunity is triggered when:\n\n- A player leaves the melee range (1 tile) of their opponent and wants to move away without using the Disengage action.\n- A player moves directly past (1 tile) an opponent within that opponent's melee range.\n- The opponent must be in a melee stance (unarmed or equipped with a melee weapon) to make an AoO.",
			"HOW DOES IT WORK?\n\n- When the AoO is triggered, the moving player must stop.\n- The opponent makes an attack roll (melee only).\n- The moving player makes a Defend (Close) roll.\n- Resolve like a normal attack. If the attack succeeds, apply damage. The mover may still complete their movement.",
			"DISENGAGING\n\n- Instead of moving normally and risking an AoO, a player may use the Disengage action.\n- No dice roll is involved. Describe with a /meloud how you disengage.\n- If a player chooses Disengage, they may not take any other actions this turn.\n- If a player is standing next to more than one opponent, they can still use the disengage action. This counts as one action.",
			{
				text = "AOO MELEE RANGE",
				image = IMG .. "aoo_melee_range.png",
				imgW = 321,
				imgH = 197,
			},
		},
	},
	{
		title = "Cover",
		pages = {
			"Cover is no longer a whole action and instead a status condition. Cover does not make you immune to damage. It provides a small defensive bonus because you are harder to target with a ranged weapon.\n\n- While in cover, you gain +2 Defense when positioned behind reasonably sized objects that partially obstruct an opponent's line of sight.\n- Valid cover: tables, cars, sofas, doors, dumpsters, rubble, corpses, or the corner of a wall.\n- Invalid cover: other characters, a small plant, a wooden chair, a mailbox, anything you drop from your inventory.",
		},
	},
	{
		title = "Throwing",
		pages = {
			"- You can throw any weapon from a distance of maximum 10 tiles.\n- Throwing is considered an action.\n\nTO THROW A WEAPON\n\n1. Describe your attempt.\n2. Roll Throwing.\n3. Opponent rolls Defend (ranged).\n\nRESOLUTION\n\n- If your roll is higher or equal to the opponent's roll, the throwing attack succeeds. Damage is 2 HP.\n- Once the weapon has been thrown (successful or not), you must OOC move to the opponent's tile and drop the weapon, then return to your tile.",
			"EXPLOSIVES (GENERAL)\n\n- Explosives cannot be used in the first round of combat.\n- Explosives can be thrown up to 10 tiles.\n- You cannot strap explosives to your body.\n- On a critical failure, the explosive detonates in the attacker's hands, damaging them and anyone adjacent.\n- Explosives affect all combatants, including allies.\n- When rolling Throwing, the explosive must be equipped in the primary hand; the game deletes the item once rolled.\n- Explosives require two hands. After throwing, your hands are empty; next turn you must use Change Weapon to equip again.",
			"MOLOTOV & FIRE BOMBS\n\n- Damage: 1 HP per turn for 3 turns, starting immediately.\n- Radius: 3x3 tiles (centered on the target).\n\nPIPEBOMBS, GRENADES, AEROSOL BOMBS\n\n- Damage: flat 4 HP.\n- Radius: 4x4 tiles (centered on the target).",
		},
	},
	{
		title = "Dice with Death",
		pages = {
			"Dicing with death is the ultimate consequence. When you have died in PvP, you will be required to Dice with Death. You can always choose to allow the death to be permanent or come to an arrangement with the other players involved about other consequences.\n\nNote: Deaths from PvE (Zombies, falls, glitches) are not permanent unless you choose. If your character died in PvP by accident or while complying, they will always be considered to have rolled a 5/6 on the Dice and you do not need to make a ticket.\n\nThe default when losing in PvP is Dicing with Death. However you may OOC come to an alternative agreement with your attackers. But only if all of them agree.",
			"In the top right of the Dice Menu, there is a 'Dice with Death' button. When you click the button, the dice will roll and decide your character's fate.\n\nDICE WITH DEATH ROLL\n\n- 1-2: Your character died of their wounds in the scene. You have no actions after the death unless specifically approved by staff or with approval from your opponents. This might be something like last words telling someone where you hid their prized hamster or cursing your killer as you crash through a glass coffee table. Generally, something dramatic but will not affect the results of the scene or inform others of your attacker.",
			"- 3-4: Your character will only survive if treated by someone highly skilled in First Aid (6+) within the next 60 (IRL) minutes. (Time starts after the entire PvP scene has concluded). The medic would roll Medical and results below 15 would result in severe ongoing injuries (such as a permanent negative trait or scar). 15 and above would result in severe temporary injuries you are expected to play for at least 2 IRL weeks. You can do this by applying injuries mechanically to yourself, but in general, you should be doing med rp, avoiding very physical activities and showing painful but progressive recovery. Involved characters should not be actively preventing rescue.",
			"- 5-6: Your character is unconscious and/or incapable of fighting. You cannot perform any actions as long as your enemy is present. When they leave, you should roleplay appropriate injuries.",
		},
	},
	{
		title = "Scene Sanctity",
		pages = {
			"After the PvP initiation emote has taken place, then everyone at the scene freezes in place. Even if you suspect you will not be involved, you must remain in place. No one can join the scene later. No one can rejoin the scene after leaving.\n\nCombat takes place in the blink of an eye, but when you're using dice, it can be quite a bit longer. We want to avoid people joining the scene later who wouldn't have had the time to get there. It also helps to keep the flow of the scene.\n\nFor story purposes, all parties can agree to lift the ban but it must be universal to all parties joining. This prevents someone only wanting their allies to show up but not the other person's.",
		},
	},
	{
		title = "Hostile RP with Cars",
		pages = {
			"There is a communication bug where those inside of the car can not be heard from outside of the vehicle, which would not allow participants in a hostile scene to realize that PvP has been initiated.\n\nAt the moment, vehicles can't be used in PvP.",
			"- If someone hits your character with a car, then they must exit the vehicle and state their intent that it was a hostile act (OOC or IC). The hostile scene will start when the driver exits the vehicle. Any passengers must also exit the vehicle promptly to participate in the hostile scene. A player who has been hit can respond with their emote to initiate PvP, roleplay or try to de-escalate the hostility.\n- Drive-by shootings require a management ticket. They can be done with mech PvP, but purely for flavor and roleplay purposes. A moderator will be online to oversee the scene.\n- Vehicles do give a cover bonus. See the Cover rules.",
			"CAR CHASES\n\nYou cannot use a vehicle chase scene to run someone off the road without the consent of both parties involved. Work with each other to come up with a solution before you're arguing on the roadside. We have this rule because car chases rarely go well because of vehicle desync. What you see on your screen might not necessarily be happening on the screen of the other player.",
		},
	},
	{
		title = "Roadblocks",
		pages = {
			"Players are allowed to build roadblocks and barricades around their base and on the map. But it cannot obstruct player movement along the road/pathway unless it is manned.",
			"If players would like to build larger and more persistent blockades they should open a ticket and discuss with staff for approval.\n\nAvoid creating a situation that is extremely burdensome for your fellow players. Be prepared to discuss how your construction will create good roleplay for everyone, does not create an unreasonably long detour, and does not contain a large amount of loot. Consider concerns other players may have with your blockade and how you can help prevent issues.",
			{
				text = "EXAMPLES OF ROADBLOCKS - NOT ALLOWED\n\nWhat's wrong with this one? Tiles and Vehicles make it impossible to completely remove all the obstacles. The road is fully blocked off. No way for the other player to drive through it without having to spend a lot of time clearing the road.",
				image = IMG .. "roadblock_bad.png",
				imgW = 274,
				imgH = 212,
			},
			{
				text = "ALLOWED\n\nIf players are present at the blockade to man it, you are allowed to block the road using tiles and vehicles. The other player has to be able to interact with the roadblock if he wants to get through. There should also be the option to avoid the barricade through side roads or detours.",
				image = IMG .. "roadblock_good.png",
				imgW = 275,
				imgH = 212,
			},
			"ROADBLOCKS AND PVP\n\nWhen using a roadblock in PvP, it must effectively prevent vehicles from bypassing it. If a vehicle can still drive past or around the roadblock without stopping, it is considered ineffective. In that case, the driver is not required to stop and may continue in their original direction.\n\nThe driver must stop the car and get out OOC so that their typing can be visible. (There's a bug in PZ that sometimes people's words inside a vehicle don't get transmitted outside the vehicle / words outside don't get inside). Stand by the vehicle, but your character remains in the vehicle IC.",
			"AFTER THE VEHICLE STOPS\n\nOnce the vehicle has successfully stopped at a roadblock, roleplay begins. The default combat and escape rules apply: If the person managing the roadblock wishes to rob, attack, or otherwise engage the players, they must initiate PvP and clearly announce combat (see Initiating PVP).\n\nVehicles can not be used in PvP, they do give a Cover bonus.\n\nAvoid repeat attacks on the same players/roadblockers unless it's part of a planned story. Use Open Communication to discuss concerns, share locations, offer alternatives, and make sure everyone enjoys the interaction.",
		},
	},
}

return DiceRulesData
