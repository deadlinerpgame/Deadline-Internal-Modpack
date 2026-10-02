local DiceRulesData = {}

local IMG = "media/ui/DL_Dice2026/rules/"

DiceRulesData.sections = {
	{
		title = "PvP Combat",
		pages = {
			"We use our own dice mod, Deadline Dice, which is the default for all Player versus Player (PvP) actions this Chapter. Players can choose to engage in ranged mechanical combat (meaning with guns in game) only with the consent of all parties, but staff will not untangle it if something goes wrong.\n\nAll melee combat is handled with dice. Staff, or the players involved by consent, may make exceptions to these rules, especially for large-scale combat scenes involving many players. We encourage everyone to be open to interesting ideas in all scenes, including combat.",
			"Just like any roleplay scene, PvP scenes require good faith from players. Don't search for loopholes. Be fair to each other and don't focus on winning OOC. Focus on creating a good story together; sometimes taking a loss benefits the overall story.\n\nIt is highly recommended that attackers and defenders video record the gameplay as soon as they OOC think a PvP scene might happen. Alternatively, take a lot of screenshots.",
		},
	},
	{
		title = "How Dice Work",
		pages = {
			"When combat is initiated, the attacker and the attacked have the first interaction and rolls during the first round. After that, all actions follow initiative order from top to bottom, and the order stays the same every round. See Following Rounds.\n\nReminder: if someone wasn't present in the first round of combat, they can't join the battle unless all parties already present agree.",
			"- For every combat action, you emote and then make a dice roll. If it's an attack against another person, the system rolls their defence for them automatically.\n- Every roll is a d20 plus modifiers. The only exceptions are Dice with Death (d6) and the automatic side rolls: 1d4 critical damage, 1d3 ammo and explosive drift.\n- All modifiers are applied by the system: your traits, the weapon in your hand, your status effects and your advantage toggle. Every modifier is shown in the combat log next to the roll it changed.",
			"- Modifiers stack. Every trait that applies is added together, both positive and negative, and there is no cap.\n- Distances are counted in tiles, and diagonals count as 1 tile. 3 tiles east and 3 tiles north is 3 tiles away. That is why all range rings and blast areas are squares.\n\nTIES\n\nIf the attacker's roll equals the defender's roll, the attack succeeds. The same applies to throws, grapples and breaking free.",
			"ADVANTAGE AND DISADVANTAGE\n\nThese buttons apply to your next roll only, then reset. With advantage you roll 2d20 and keep the higher; with disadvantage you keep the lower. That next roll can be one the system makes for you, such as a defence roll. Only use it when a rule, a trait or staff grants it.\n\nIN CASE OF DICE ROLL BUGS\n\nIf a roll isn't what you were trying to do, use the d20 it gave you and explain the missing modifier in OOC. Make a bug report afterwards.",
		},
	},
	{
		title = "Actions",
		pages = {
			"When engaging in dice combat, we speak of actions. Each turn a player may move 5 tiles and perform one action from the list below.\n\nMOVEMENT ACTIONS\n- Dashing: move 5 additional tiles.\n\nHOSTILE ACTIONS\n- Attacking: attempting to harm your opponent.\n- Throwing weapons or explosives at your opponent.\n- Reloading a crossbow. Reloading a pistol, rifle or other gun does not take an action.\n- Changing weapons: switching from one weapon to another.\n- Grappling: stopping someone from moving, but not from taking other actions.",
			"SELF-PRESERVATION ACTIONS\n- Disengaging: moving away from an enemy without triggering an attack.\n- Escaping: fleeing combat.\n- Surrendering: ending combat and placing yourself at the mercy of your opponent.\n- First aid: treating burning or poison on yourself or someone next to you.\n\nMOVE FIRST, THEN ACT\n\nPressing Attack, Throw, Grapple, Break free, First aid, Surrender, or failing an Escape, ends your turn immediately. Every other action (Dash, Reload, Change weapons, Disengage) is followed by pressing Finish turn.",
		},
	},
	{
		title = "Hit Points",
		pages = {
			"- Everyone starts with 12 Hit Points.\n- At 0 HP you are knocked out (KO). You skip your turns, cannot roll, and cannot be targeted by attacks.\n- Your HP panel has -1 / +1, Reset (back to full) and KO buttons. Use them for any damage the system doesn't track itself, such as damage from the first round or a broken surrender.\n- First aid does not restore HP during dice combat. It can remove burning or poison (see First Aid).\n- If you are knocked out, you may have to roll Dice with Death.",
		},
	},
	{
		title = "Status Effects",
		pages = {
			"Status effects appear as icons in the turn order. Hover over one to see what it does.\n\n- In cover: +2 Defend (ranged). Set with the In cover button, until you turn it off.\n- Poisoned: -2 to every roll. Comes from events. Lasts 3 of your turns, counted at the end of each of your turns, or until treated with first aid.\n- Burning: 1 HP at the start of each of your turns. Comes from a Molotov hit or events. After a Molotov hit it lasts 2 turns after the first 1 HP, or until treated with first aid.",
			"- Grappled: cannot move or use Escape, and does not trigger attacks of opportunity. Comes from a successful grapple on you, until you break free or are released.\n- Grappling: you are holding someone and cannot move. Comes from your successful grapple, until you release them or they break free.\n- Escape-preventing wounds: cannot use Escape. Comes from events, until removed.",
			"- Threatened: a Spearwall fighter gets a free attack if you step out of their reach. Automatic, while in their reach.\n- Covering: you get a free attack on anyone stepping out of your reach. Automatic with Spearwall and a two-handed melee weapon.",
			"- Knocked out: skips turns, cannot make combat rolls, cannot be targeted. From 0 HP or the KO button, until revived or reset.\n- Surrendered: skips turns, cannot make combat rolls, cannot be targeted. From the Surrender button, until withdrawn.\n- Suppressed and Blinded: no mechanical effect. Come from events, until removed.\n- Armored: no mechanical effect. Set with the Armored button.\n\nLucky shortens poison and burning by 1 turn (never below 1). Unlucky lengthens them by 1 turn.",
		},
	},
	{
		title = "Traits",
		pages = {
			"The system reads your character's traits and applies them by itself.\n\n- Weapon traits only count while you hold that kind of weapon.\n- Gun traits count with every gun, crossbows included, plus a bonus when the gun is in the right group (see Weapon Damage).\n- Melee means unarmed, one-handed and two-handed melee.\n- Ranged means guns, thrown weapons and explosives.",
			"INITIATIVE\n- Dextrous: +1 Initiative\n- All Thumbs: -1 Initiative\n- Quickdraw: +3 Initiative if you roll initiative holding a pistol-class gun. The bonus is taken away as soon as the system sees you holding anything else (when you attack or swap weapons).\n\nGENERAL ATTACK\n- Timid: -2 Attack, melee and ranged\n- Meek: -4 Attack, melee and ranged\n- Heavyweight: +1 melee Attack, -1 movement tile\n- Featherweight: -1 melee Attack, +1 movement tile",
			"- Lunger: +2 melee Attack after moving 3 or more tiles in a straight line this turn\n- Spearwall: -2 on every attack, but you get attacks of opportunity while holding a two-handed melee weapon\n- Strong Arm: can throw short blades and short blunt weapons, +1 thrown damage, +3 throw range, -1 on every attack that is not a throw",
			"MELEE WEAPONS\nThese don't apply when the weapon is thrown.\n- Hewer / Limbsplitter: +2 / +4 Attack with axes\n- Cudgeller / Bonebreaker: +2 / +4 Attack with long blunt weapons\n- Thumper / Skullcracker: +2 / +4 Attack with short blunt weapons\n- Slasher / Cleaver: +2 / +4 Attack with long blades\n- Cutter / Redhand: +2 / +4 Attack with short blades\n- Sticker / Longreach: +2 / +4 Attack with spears\n- Scrapper: +1 Attack unarmed and with improvised weapons",
			"GUNS\n- Snapshooter: +1 with any gun, +2 total with Close group guns\n- Gunslinger: +2 with any gun, +4 total with Close group guns\n- Rifleman: +1 with any gun, +2 total with Medium group guns\n- Dead-Eye: +2 with any gun, +4 total with Medium group guns\n- Spotter: +1 with any gun, +2 total with Long group guns\n- Longshot: +2 with any gun, +4 total with Long group guns",
			"DEFENCE\n- Spry: +1 Defend (close)\n- Furtive: +2 Defend (close)\n- Glass Jaw: -4 Defend (close)\n- Longstrider: +1 Defend (ranged)\n- Roadburner: +2 Defend (ranged)\n- Bullet Magnet: -4 Defend (ranged)\n- Evasive: +1 Defend (ranged), -1 Defend (close)\n- Sturdy: +1 Defend (close), -1 Defend (ranged)",
			"GRAPPLE, ESCAPE, CRITICALS AND STATUS EFFECTS\n- Wrestler: +2 Grapple (grappling and breaking free)\n- Slippery: +2 Escape\n- Wildcard: critical success on 19-20, critical failure on 1-2 (attack and defence)\n- Even Keel: no critical successes and no critical failures at all\n- Lucky: poison and burning end 1 turn sooner (never below 1). Does not change criticals.\n- Unlucky: poison and burning last 1 turn longer. Does not change criticals.",
			"UTILITY ROLLS\n- Notice: Cat's Eyes +1, Eagle Eyes +1, Keen Hearing +1, Daydreamer -1, Hard of Hearing -2, Poor Eyesight -2, Oblivious -2\n- Hide (Sneak): Graceful +1, Inconspicuous +1, Softstep +1, Prowler +1, Deadly Quiet +2, Ghost +2, Clumsy -1, Conspicuous -1, Heavy-Footed -1, Lumbering -2\n- Physical endurance: Tireless +2, Short of Breath -1, Asthmatic -3\n- Mental endurance: Iron Will +2, Fear of Blood -1, Faint-Hearted -3\n- First aid: First Aid +1, Sawbones +2, plus half your First Aid skill level (rounded down)",
			"DICE WITH DEATH\n- Thick-Skinned: advantage (2d6, keep the higher)\n- Thin-Skinned: disadvantage (2d6, keep the lower)\n- Having both cancels out.",
		},
	},
	{
		title = "Other Rolls",
		pages = {
			"UTILITY ROLLS\n\nDefend (close), Defend (ranged), Sneak, Notice, Physical and Mental endurance, and Skill roll. During combat, Grapple and First aid are actions on your own turn (see Grappling and First Aid).\n\n- During combat, participants can use them at any time, even outside their turn, unless they are knocked out, surrendered, or staff has paused the combat.\n- Players within 30 tiles who are not in the combat can also make these rolls into the combat log.\n\nOUTSIDE COMBAT\n\nEvery roll button still works. The result is shown to everyone within 20 tiles on the same floor, trait modifiers included.",
		},
	},
	{
		title = "Initiating PvP",
		pages = {
			"- The attacker needs a valid RP reason to start a PvP scene.\n- Initiation requires a hostile demand that includes a threat of violence.\n- The initiator types a /meloud describing how they intend to use violence. That emote is the announcement.\n- As soon as PvP has been announced, everyone at the scene must freeze in place, including players who are not planning to participate.\n- Players who were not in shout range (and therefore did not hear the announcement) may not join the PvP. See Scene Sanctity.",
			"SURRENDER OR PARTICIPATE IN COMBAT\n\nIf the initiator is attacking multiple people, they must pick one player (in OOC chat) to be the Primary Defender. The Primary Defender now has two options:\n- Surrender immediately by typing their surrender in a /meloud and complying with the attacker's hostile demands (see Surrendering).\n- Participate by describing their intent to fight or escape in a /meloud. For example: /meloud pulls out his own weapon and aims it at the attacker.",
			"PVP INVOLVING VEHICLES\n\nYou cannot initiate PvP inside a vehicle. Getting out of a vehicle is not considered an action.",
		},
	},
	{
		title = "First Round",
		pages = {
			"Dice combat in the first round is limited to two players: the Primary Attacker and the Primary Defender.\n\n- Nobody rolls for initiative at this stage. All other players simply observe the first round and remain frozen in place.\n- Don't press Roll initiative yet. The first round is played outside the combat tracker.\n\nTURN ORDER\n1. The defender may choose to surrender.\n2. The attacker takes their first turn.\n3. The defender takes their turn (attack, attempt to escape, and so on).",
			"ROLLING IN THE FIRST ROUND\n\nUse the roll buttons outside combat. Attack, Defend, Escape and so on are shown to everyone within 20 tiles, with trait modifiers included.\n\nThe system does not compare the rolls: the attacker wins ties, and damage is noted down. Once the combat exists in round two, apply that damage with the -1 button on your HP panel.",
		},
	},
	{
		title = "Following Rounds",
		pages = {
			"Once both attacker and defender have had their turn, and combat has not ended with a surrender, the second round begins.\n\n1. Every player who wants to join presses Roll initiative. The first player creates a combat centred on where they stand. Anyone within 30 tiles of that centre joins it. A new combat cannot be created within 60 tiles of another one.\n2. Once you've rolled, press Ready up. The combat starts automatically once every player is ready. Staff can also force-start it.",
			"3. Actions are taken in initiative order, from highest to lowest. Players tied on the same number roll a d20 against each other to break the tie.\n4. The initiative order stays the same for all following rounds. Knocked-out and surrendered combatants are skipped.\n\n- No one may join the combat if they were not present (within shout range) at the start of the first initiation, unless all parties already present agree. The system blocks joining once combat has started.",
			"- The tracker's Round 1 is the second round of the scene.\n- During combat you cannot move more than 30 tiles from the combat's centre.\n- A combat ends by itself when every player has left it, or after 1 hour without any activity.",
		},
	},
	{
		title = "Attack of Opportunity",
		pages = {
			"An Attack of Opportunity (AoO) is a special reaction that lets a player make a free attack during another player's turn.\n\nWHO CAN MAKE AN AOO?\n\nOnly characters with the Spearwall trait who are holding a two-handed melee weapon.\n\nWHEN DOES AN AOO TAKE PLACE?\n\nOn your turn, if you move from within 1 tile (diagonals included, same floor) of a Spearwall fighter to more than 1 tile away.",
			"- While you are in a Spearwall fighter's reach, you carry the Threatened icon and they carry the Covering icon.\n- Each Spearwall fighter can take only one AoO per turn of yours.\n- There is no AoO if you Disengaged this turn or are grappled.\n- A fighter who is knocked out, surrendered or offline cannot take an AoO. Knocked-out and surrendered players cannot be targeted by one.",
			"MARKING ALLIES\n\nA Spearwall fighter can stop their attack of opportunity from hitting friends.\n- Right-click a name in the turn order and choose Mark as ally. The name then shows (ally) for you.\n- Allies never trigger your attack of opportunity, and they do not get the Threatened icon from you.\n- Choose Remove ally mark to undo it. Marking and unmarking is shown in the combat log.",
			"HOW DOES IT WORK?\n\nThe system handles it all as soon as you step away:\n- The Spearwall fighter rolls a melee attack with their weapon (including Spearwall's -2).\n- You roll Defend (close).\n- It is resolved like a normal attack: criticals and defence fumbles apply, and damage is applied automatically.\n- You may still complete your movement.\n\nTo avoid AoOs, press Disengage before you move (see Disengaging).",
			{
				text = "AOO MELEE RANGE",
				image = IMG .. "aoo_melee_range.png",
				imgW = 321,
				imgH = 197,
			},
		},
	},
	{
		title = "Dice with Death",
		pages = {
			"Dicing with death is the ultimate consequence. When you die in PvP, you Dice with Death. You can always choose to let the death be permanent, or come to an arrangement about other consequences with the other players involved.\n\n- Deaths from PvE (zombies, falls, glitches) are not permanent unless you choose so. See the Down But Not Out system for Chapter 3.\n- If your character died in PvP by accident or while complying, they always count as having rolled a 5-6, and you do not need to make a ticket.",
			"- The default when losing PvP is Dicing with Death. You may agree OOC on an alternative with your attackers, but only if all of them agree.\n\nPress Dice with Death (d6) on the rolls panel. In a combat the result goes in the combat log. Outside combat it is shown to everyone within 20 tiles. Thick-Skinned and Thin-Skinned apply.",
			"1-2: Your character dies of their wounds in the scene. You get no actions after death unless staff or your opponents approve something, such as last words or a dramatic final moment that does not change the result of the scene or reveal your attacker.\n\n5-6: Your character is unconscious and/or unable to fight. You cannot act while the enemy is present. When they leave, roleplay appropriate injuries.",
			"3-4: Your character only survives if someone with First Aid 6+ treats them within 60 real-life minutes, starting after the whole PvP scene has ended.\n\nThe medic rolls First aid. Below 15 means severe lasting injuries (such as a permanent negative trait or a scar). 15 or higher means severe temporary injuries you must play out for at least 2 real-life weeks.\n\nInvolved characters should not actively prevent the rescue.",
		},
	},
	{
		title = "Scene Sanctity",
		pages = {
			"- After the PvP initiation emote, everyone at the scene freezes in place. Even if you think you won't be involved, you must stay put.\n- No one can join the scene later, and no one can rejoin after leaving.\n- Combat happens in the blink of an eye, but with dice it can take much longer. This rule stops people joining who would never have had time to get there, and keeps the scene flowing.",
			"- For story purposes, all parties can agree to lift this, but the agreement must cover everyone joining. That stops one side from letting only their own allies in.\n- It also means all players need to leave combat and restart it, because the system cannot add a late joiner to an existing combat. All players then follow the new turn order and manually apply any damage from the original combat.",
		},
	},
	{
		title = "Hostile RP with Cars",
		pages = {
			"People inside a car cannot always be heard from outside it (a game bug), so the players involved might not realise PvP has been initiated. Vehicles cannot be used in PvP.\n\nIf someone hits your character with a car, they must get out of the vehicle and state (OOC or IC) that it was a hostile act. The scene starts when the driver gets out, and passengers must also get out promptly if they want to take part. The player who was hit can respond with their own PvP initiation emote, roleplay, or try to de-escalate.",
			"- Drive-by shootings require a management ticket. They can be done with mechanical PvP, purely for flavour and roleplay, with a moderator online to oversee the scene.\n- Vehicles do count as cover.\n- Car chases: you cannot run someone off the road without the consent of both parties. Vehicle desync means what you see may not be happening on the other player's screen.",
		},
	},
	{
		title = "Roadblocks",
		pages = {
			"- Players may build roadblocks and barricades around their base and on the map, but they cannot block a road or path unless they are manned.\n- Larger or more permanent blockades need a ticket and staff approval. They must not be very burdensome for others: no unreasonably long detours and no large amounts of loot.",
			{
				text = "NOT ALLOWED\n\nA road completely blocked with tiles and vehicles that cannot all be removed.",
				image = IMG .. "roadblock_bad.png",
				imgW = 274,
				imgH = 212,
			},
			{
				text = "ALLOWED\n\nA manned roadblock of tiles and vehicles that others can interact with, with a way around it via side roads or detours.",
				image = IMG .. "roadblock_good.png",
				imgW = 275,
				imgH = 212,
			},
			"ROADBLOCKS AND PVP\n\n- A roadblock must actually stop vehicles. If a vehicle can drive past or around it, the driver does not have to stop.\n- The driver must stop and get out OOC so their typing is visible. Their character stays inside the vehicle IC.\n- Once the vehicle has stopped, the normal combat and escape rules apply. Anyone wanting to rob or attack must initiate PvP.\n- Avoid repeatedly attacking the same players. Use Open Communication.",
		},
	},
	{
		title = "Attacking",
		pages = {
			"1. Describe your attack with a /meloud.\n2. Select your target by clicking their name in the turn order. Click the same name again to deselect them.\n3. Press Attack / Throw.\n\nThe system then does the rest:\n- It reads the weapon in your primary hand and rolls d20 + weapon traits + other modifiers. Guns also get a range modifier (see Weapon Damage).\n- It rolls your target's defence automatically: Defend (close) against unarmed and melee attacks, Defend (ranged) against guns, crossbows, thrown weapons and explosives.",
			"- If your total is equal to or higher than the defence, you hit and the damage is applied.\n- Critical successes and failures are applied automatically (see Critical Hits).\n- Your turn ends as soon as you attack. Do your moving first.\n\nGUNS AND CROSSBOWS\n- You cannot attack with an empty weapon.\n- Each attack uses up ammo automatically: 1d3 rounds for pistols, SMGs and rifles, and 1 for shotguns and crossbows. If fewer are loaded, it fires what is left.",
			"You cannot attack a combatant who is knocked out or has surrendered.\n\nYOUR OPPONENT DEFENDS\n\nDefend (close) and Defend (ranged) are both d20 + defence traits + modifiers. Cover adds +2 against ranged attacks. Poison is -2. If the defender set advantage or disadvantage, it applies to this roll.",
		},
	},
	{
		title = "Throwing",
		pages = {
			"Throwing is an action. What you can throw:\n- Explosives (Molotovs, fire bombs, pipe bombs, aerosol bombs, grenades): everyone.\n- Short blades and short blunt weapons: only characters with Strong Arm.\n\nEverything is thrown up to 10 tiles (13 with Strong Arm). For explosives, see Explosives.",
			"TO THROW A WEAPON\n1. Describe your attempt.\n2. Select the target and press Throw weapon.\n3. The system rolls your attack and the target's Defend (ranged).\n4. If your roll is higher than or equal to your opponent's, the throw hits for 2 HP. Strong Arm adds +1, and scrap weapons deal 1 less.",
			"- Your melee category traits (Hewer, Cutter, etc.) do not apply to throws. Strong Arm's -1 penalty on other attacks does not apply to throws either.\n- After the throw, hit or miss, you must move OOC to your opponent's tile, drop the weapon there, then return to your tile. The system does not remove a thrown weapon for you.",
		},
	},
	{
		title = "Weapon Handling",
		pages = {
			"RELOADING\n- Reloading a crossbow counts as an action. Reload, then press Finish turn.\n- Reloading a rifle, pistol or any other gun does not count as an action.\n\nCHANGING WEAPONS\n- Switching from a melee weapon to a ranged weapon, or the other way round, counts as an action. If you change weapons on your turn, you cannot take any other action that turn. Press Finish turn afterwards.\n- If you begin combat unarmed, you may equip a weapon without it counting as an action.",
			"- After throwing an explosive your hands are empty, and equipping a new weapon counts as changing weapons and takes an action.\n- Quickdraw loses its initiative bonus as soon as you no longer hold a pistol.\n\nDUAL WIELDING\n\nYou may have one weapon equipped at most. Wielding more than one weapon is not allowed. The system only ever reads your primary hand.",
		},
	},
	{
		title = "Grappling",
		pages = {
			{
				text = "A grappled character cannot move freely: their movement is locked as long as the grapple is held. Grappling is not the same as restraining, which is not part of our PvP rules.",
				image = IMG .. "grappling.png",
				imgW = 285,
				imgH = 183,
			},
			"HOW TO GRAPPLE\n\nGrappling is an action.\n- You may grapple if your target is in melee range (1 tile, diagonals included).\n- You need one free hand to grapple someone.\n- A player can only be grappled by one person at a time.\n- Restraining or handcuffing someone during combat is not allowed.",
			"TO GRAPPLE\n1. Describe your attempt.\n2. Select your target in the turn order and press Grapple. Wrestler gives +2.\n3. The system rolls your opponent's Defend close automatically.\n4. If your roll is higher than or equal to your opponent's, the grapple succeeds. You get the Grappling status and your opponent the Grappled status.\n5. Your turn ends as soon as you grapple, whether it succeeds or not. Do your moving first.",
			"The system refuses the grapple if your target is further than 1 tile away, is already grappled, or if you are already grappling someone.",
			"THE GRAPPLER\n- Must keep one hand free to hold the grapple.\n- May still attack anyone in range (melee or ranged), but only with one-handed weapons.\n- May not move unless they release the grapple.\n- May release the grapple during their turn as a free action: press Release grapple. Both statuses are removed.",
			"THE GRAPPLED\n- May still attack anyone in range (melee or ranged).\n- May not move until the grapple is broken.\n- May attempt to break free (an action).\n- Cannot escape, and does not trigger attacks of opportunity.",
			"BREAKING A GRAPPLE\n\nBreaking free is an action and can only be taken on your turn.\n1. Press Break free (the Grapple button changes to this while you are grappled). Wrestler's +2 applies.\n2. The system rolls the grappler's Defend close automatically.\n3. If your roll is higher than or equal to theirs, you break free and both statuses are removed.\n4. Your turn ends, whether you break free or not.\n\nWHEN A GRAPPLE ENDS BY ITSELF\n\nThe system removes the Grappled and Grappling statuses automatically when either character is knocked out, surrenders, or leaves the combat.",
		},
	},
	{
		title = "Movement",
		pages = {
			"All movement happens on your turn.\n\nOn your turn, you can move up to 5 tiles in any direction: horizontal, vertical or diagonal. A diagonal step counts as 1 tile.\n\n- No trait: 5 tiles, 10 with a dash\n- Featherweight: 6 tiles, 12 with a dash\n- Heavyweight: 4 tiles, 8 with a dash\n\n- Press Move range to show your movement ring (inner) and your dash ring (outer). They always use your own numbers.\n- Move before you act. Attacking, throwing, surrendering or a failed escape ends your turn at once.",
			"MOVING AND MELEE\n\n- Lunger: if you attack in melee after moving 3 or more tiles in a straight line this turn (same row, same column or an exact diagonal, on the same floor), you get +2 Attack. The system measures from where your turn started to where you are when you attack.\n- Attacks of opportunity: stepping out of a Spearwall fighter's reach during your turn gives them a free attack. See Attack of Opportunity, or Disengage first.\n\nTHE COMBAT AREA\n\nDuring combat you cannot move more than 30 tiles from the combat's centre. If you do, you are snapped back to its edge.",
			"DASHING\n\nYou may use the Dash action to double your movement this turn: 10 tiles normally, 12 with Featherweight, 8 with Heavyweight.\n- This counts as an action; you can only take one action each turn.\n- You cannot use the Dash action two turns in a row.\n- There is no Dash button: move within your dash ring, then press Finish turn.",
			{
				text = "MOVE AND DASH RANGE",
				image = IMG .. "movement_dash.png",
				imgW = 211,
				imgH = 124,
			},
			"BEING GRAPPLED\n\nWhile you are being grappled you may not move until the grapple is broken, but you can take other actions, such as attacking or trying to break free with the Break free button. You cannot Escape while grappled, and your movement never triggers attacks of opportunity. The grappler may not move either until they release you. See Grappling.",
		},
	},
	{
		title = "Disengaging",
		pages = {
			"You must know how far you can go in combat; sometimes, being on the offensive is a death sentence.\n\nNever turn your back on a Spearwall. Stepping out of a Spearwall fighter's reach on your turn triggers an attack of opportunity. To prevent this, use your action to disengage.",
			"1. Press Disengage on your turn, before you move.\n2. Describe with a /meloud how you disengage. No dice are rolled.\n3. Move away. No attacks of opportunity are triggered this turn.\n4. Press Finish turn.\n\n- One Disengage covers every opponent next to you.\n- If you disengage, you may not take any other action this turn.",
		},
	},
	{
		title = "Taking Cover",
		pages = {
			"Cover helps against being targeted by ranged weapons.\n\nCover is no longer considered an action: instead, it's a status condition. It does not make you immune to damage. It gives a small defensive bonus because you are harder to hit with a ranged weapon.\n\n- Press In cover when you're behind cover, and press it again when you leave it.\n- While in cover you get +2 Defend (ranged) against guns, crossbows, thrown weapons and explosives.\n- Cover gives no bonus against melee attacks or attacks of opportunity.",
			"- Valid cover: tables, cars and other vehicles, sofas, doors, dumpsters, rubble, corpses, or the corner of a wall. The object must be reasonably sized and partly block your opponent's line of sight.\n- Invalid cover: other characters, a small plant, a wooden chair, a mailbox, anything you take out of your inventory and put down.",
		},
	},
	{
		title = "First Aid",
		pages = {
			"Patching someone up in the middle of a fight.\n\nFirst aid is an action on your turn. It treats burning and poison; it does not restore HP.\n\n1. Select the character you want to treat in the turn order, or select nobody to treat yourself. They must be within 1 tile (diagonals included). Knocked-out and surrendered characters can be treated.\n2. Press First aid. You roll d20 + half your First Aid skill level (rounded down) + modifiers: the First Aid trait (+1), Sawbones (+2), and -2 if you are poisoned yourself.",
			"3. On 12 or higher, one status is removed: burning first, otherwise poison.\n4. Your turn ends, whether it works or not.\n\n- The system refuses the attempt if the character is neither burning nor poisoned, or is out of reach. A refused attempt does not cost your turn.\n- Outside combat, First aid is a normal roll.",
		},
	},
	{
		title = "Escaping",
		pages = {
			"Not every encounter is winnable. Sometimes you have to cut your losses and try to escape.\n\nESCAPING REQUIREMENTS\n\nTo escape you must meet both requirements:\n1. You must be physically capable of fleeing. You cannot escape if you are bound, severely injured in a way that affects your movement, or being grappled. You also cannot escape if the only route out leads directly past an attacker.",
			"2. You must be somewhere escape is realistically possible.\n- Possible: a street, an open field, a room with an unblocked door.\n- Impossible: a locked room, an alley with the exit blocked, a vehicle trapped at a roadblock with no way forward.\n\nThe system blocks the Escape button while you are Grappled or have Escape-preventing wounds.",
			{
				text = "ESCAPING BEFORE COMBAT STARTS\n\nA player may try to flee before PvP combat is initiated, as long as they meet all escape requirements.\n\nIf you spot your enemy from further away than /say range, you may leave mechanically without emoting your escape.",
				image = IMG .. "escape_distance.png",
				imgW = 299,
				imgH = 171,
			},
			"If you are both close enough for normal conversation (within /say range), follow these steps:\n1. Type a /meloud that clearly describes how you flee (running away, driving off, climbing through a window, and so on). Everyone at the scene freezes in place.\n2. The potential attacker must then decide either to respond with a PvP initiation or to let you escape.\n3. If combat is initiated, the First Round begins, and the attacker goes first.",
			"ESCAPING DURING COMBAT\n\nBefore trying to escape once combat has started, make sure you meet both requirements, and remember:\n- You can only try to escape on your own turn.\n- Escape before moving any tiles. If you have moved, you may not try to escape.\n- You cannot escape after Disengaging this turn; the system blocks it.",
			"ESCAPE ROLL\n\nPress Escape. It is a flat d20 roll, and distance makes no difference. To succeed, the result must be 12 or higher.\n\nWhat changes the roll:\n- Slippery: +2\n- Poisoned: -2\n\nOUTCOMES\n- Success: you are removed from the combat and must leave the scene. You cannot stick around to watch OOC.\n- Failure: you stay in combat and your turn ends immediately. You do not get to move afterwards.",
			"RULES FOR SUCCESSFUL ESCAPEES\n\n- You may not return to the scene under any circumstances while it is still active.\n- You may not take actions related to the scene until the combat is resolved. That includes gathering allies, planning revenge or preparing a follow-up attack.\n- If you are unsure whether combat has ended, create an Open Communication thread on Discord and tag the players involved so they can confirm.",
			"- You may not use radios to call about the scene until it has been confirmed OOC that it has ended.\n- You must leave the area entirely. Staying nearby to watch is not allowed.",
		},
	},
	{
		title = "Surrendering",
		pages = {
			"A timely surrender can save your life. But acting the fool invites consequences.\n\nBy surrendering, a player places themselves at the mercy of the other side and agrees to comply with any realistic demands.\n\nIN THE SYSTEM\n- Surrender can be pressed at any time. If it is your turn, your turn ends.\n- A surrendered combatant is skipped in the turn order, cannot roll, and cannot be targeted by attacks or attacks of opportunity.",
			"- Withdraw surrender makes you a valid target again. Use it only when your surrender was declined, or when you break your surrender (see Hiding a weapon or a radio).\n- The tracker does not end the combat when a side has fully surrendered. End it through roleplay, and everyone presses Leave combat.\n\nSURRENDERING AT THE START OF COMBAT\n\nA player may surrender when PvP is initiated. In this case, the opponent must accept the surrender.",
			"SURRENDERING DURING COMBAT\n\nA player may also surrender during one of the later rounds. In this case, the opponent does not have to accept it.\n- If the opponent accepts, they must confirm it in character.\n- In a scene with multiple players, every member of the opposing side must agree for the surrender to be valid.\n- Once confirmed, the surrender is OOC binding and cannot be undone.",
			"- An attempted surrender counts as your action and your turn is ended. If surrender is declined or you have broken your surrender, press Withdraw surrender to take your next turn normally.\n\nNote: if everyone on one side has surrendered, the PvP scene ends and continues as roleplay. Click Leave combat.",
			"OBLIGATIONS OF A SURRENDERED PARTY\n\nA surrendered party:\n- Must drop any weapon they are holding on the ground.\n- Cannot join or rejoin the PvP fight if it continues.\n- Cannot try to flee, during the combat or after it.\n- Becomes the attacker's prisoner if the attacker wins the dice combat, and will not resist being restrained or kidnapped.\n- Cannot contact other parties by radio.",
			"- Is not a valid target for attacks, with the exception of area effects such as explosives.\n- May roleplay self-preservation and compliance, such as ducking and covering in a gunfight or following an attacker's orders. They may not use it to gain an IC advantage, escape, or help anyone.",
			"BROKEN SURRENDER INVITES CONSEQUENCES\n\nA surrendered character can still roleplay, move around and speak, depending on their captor's demands.\n\nHowever, if they resist, threaten the other side through roleplay, or refuse realistic demands, they have broken their surrender. This may sign their own death warrant by inviting consequences.",
			"- The opponent may attack a character who has broken their surrender on the opponent's turn and drop them to 0 HP immediately, without an attack roll. The opponent describes the action through roleplay, but not the final result of the attack.\n- Surrendered players cannot be targeted in the system, so the surrendered player presses KO on their own HP panel, or staff does it.",
			"- The player of the character who broke surrender must then roll Dice with Death.\n- By default, the character who broke surrender is unconscious for the rest of the scene. The result of the Dice with Death roll decides whether they ultimately survive or die.",
			"WHAT HAPPENS AFTER COMBAT?\n\nMy opponent has surrendered and the combat scene is over. What now?\n- You may search the surrendered character (not during combat).\n- You may steal items from them (see our Robbery rules).\n- You may kidnap them and make them your prisoner (see our Prison rules).\n- You can simply leave them alone.\n- You can make a reasonable demand.\n- If they are the target of your approved murder ticket, you may also murder them, with roleplay.",
			"WHAT IF THE SURRENDERED CHARACTER IS STILL RESISTING?\n\nA character who has surrendered is at the mercy of the other combatants. Resisting, being arrogant or being verbally abusive invites consequences (see Broken surrender).\n\nStill, keep in mind the feelings and needs of the players in the scene. Discuss options in Open Communication if things are getting tense, and a short OOC break can help. Always ask yourself what makes the better story.",
			"SEARCHING A SURRENDERED CHARACTER\n\nIt is the searcher's responsibility to emote a thorough search for what they are looking for, for example: /meloud pats him down for weapons and radios.\n\n- The defender must then drop their weapons and radio. This includes tools such as a screwdriver or a saw. Don't look for a loophole.\n- We have a mod that lets a player search another player for weapons. If it does not recognise something as a weapon, you still need to tell the player OOC that your character has a weapon.",
			"HIDING A WEAPON OR A RADIO\n\nIf the captors are not roleplaying a search, you may keep your weapon, tools or radio on your character, as long as that is realistic.\n\n- Hiding a wood axe or a shotgun under your jacket is not allowed; it would be visible on your character.\n- Using stealth rolls to hide a weapon is not allowed by default. You may propose it OOC, but the captor may decline. If the captor wants to search you for weapons, items or tools, a roleplay message is enough.",
			"- Trying to hide a weapon means you are no longer surrendering. You become a valid target for injury again and invite consequences. Press Withdraw surrender so the system lets you be targeted.",
			"REASONABLE AND REALISTIC DEMANDS\n\n- In character: made by a character during play, not as an OOC instruction.\n- Possible: something a person could actually do in the moment.\n- Scene-bound: they apply only to the current scene and cannot be enforced as long-term obligations.\n- Within the rules: they cannot break OOC robbery limits, consent requirements, or game mechanics.",
			"Important: if a demand is unrealistic, impossible or breaks the rules, refusing it is not a broken surrender. Compliance is judged only against reasonable, realistic, scene-bound demands.\n\nYou may roleplay any demand IC that you like, but the broken surrender consequences do not apply to unreasonable ones. Do not try to catch your opponents out on a technicality; roleplay in good faith.",
			"UNREASONABLE AND UNREALISTIC DEMANDS\n\n- Demanding more than the OOC robbery rules allow (\"Give me all your loot\", beyond the robbery limits).\n- Forcing OOC consent to difficult or graphic content (\"You must agree to roleplay this graphic torture scene with me\").\n- Demands that are physically or narratively impossible (\"Farmer, craft me an M-16\").\n- Demands that would inevitably cause lethal harm (\"Jump off this bridge\").",
			"EXAMPLES\n\nAllowed: \"Drop your weapon and step back.\"\nAllowed: \"Walk ten paces away while we leave.\"\nNot allowed: \"Bring me supplies tomorrow or you've failed surrender.\" You may make the demand, but the broken surrender consequence does not apply if they don't show up, because it is not scene-bound.",
			"Not allowed: \"Sit there while I cut your ear off with these rusty scissors and...\" Not allowed unless the player has consented OOC to roleplay a graphic torture scene. You may discuss a fade-to-black resolution.",
		},
	},
	{
		title = "Weapon Classes",
		pages = {
			"Everyone starts with 12 HP. At 0 HP you are knocked out (see Hit Points).\n\nThe system looks at the item in your primary hand at the moment you roll:\n- Nothing, or an item that is not a weapon: Unarmed\n- An explosive (pipe bomb, aerosol bomb, grenade): Bomb\n- A fire weapon (Molotov, fire bomb): Molotov\n- A gun firing shotgun shells: Shotgun\n- A weapon firing bolts: Crossbow",
			"- One-handed automatic guns: SMG\n- Any other two-handed gun: Rifle\n- Any other one-handed gun (pistols, revolvers, machine pistols): Pistol\n- A two-handed melee weapon: Two-handed melee\n- A one-handed melee weapon: One-handed melee",
		},
	},
	{
		title = "Weapon Damage",
		pages = {
			"MELEE WEAPONS\n- Unarmed: 1 HP, defender rolls Defend (close)\n- One-handed melee: 3 HP, defender rolls Defend (close)\n- Two-handed melee: 3 HP, defender rolls Defend (close)\n\nMelee range is 1 tile, which includes the diagonal tiles.",
			"RANGED WEAPONS\n- Pistols (and revolvers): 15 tiles, 3 HP, 1d3 rounds per attack, Medium group\n- SMGs: 15 tiles, 4 HP, 1d3 rounds per attack, Close group\n- Shotguns: 15 tiles, 4 HP, 1 shell per attack, Close group\n- Rifles: 20 tiles, 4 HP, 1d3 rounds per attack, Long group (sawn-off rifles: Close group)",
			"- Crossbows: 20 tiles, 4 HP, 1 bolt per attack, Long group. Reloading a crossbow counts as an action.\n- Throwing a weapon: 10 tiles (13 with Strong Arm), 2 HP (3 with Strong Arm)\n\n- Guns must be loaded. You cannot attack with an empty gun. The system removes the rounds from your gun for you; if fewer are loaded than it rolled, it fires what is left.\n- Range: press Gun range to see your throw range, 15 tiles and 20 tiles as rings. A tile counter shows the exact distance to where you hover.",
			"RANGE MODIFIERS\n\nGuns get a bonus or penalty on the attack roll depending on how far away the target is. Close is 1 to 5 tiles, medium is 6 to 12 tiles, long is 13 tiles or more.\n- Shotguns: +2 at close range, -4 at long range\n- SMGs: +1 at close range, -2 at long range\n- Pistols: -2 at long range\n- Rifles: -4 at close range, +1 at long range\n- Crossbows: -2 at close range, +1 at long range\n\nThere is no modifier at medium range. Melee, thrown weapons and explosives are not affected. The modifier stacks with traits and is shown in the combat log.",
			"SCRAP WEAPONS\n\nAll scrap ranged weapons do 1 HP less damage. The weapon's tooltip in the tracker shows when this applies.\n\nGUN RANGE GROUPS\n\nGun traits (Snapshooter, Gunslinger, Rifleman, Dead-Eye, Spotter, Longshot) give extra attack while using guns in a certain group.\n- Close group: shotguns, SMGs, sawn-off rifles. Bonus for Snapshooter and Gunslinger.\n- Medium group: pistols, revolvers. Bonus for Rifleman and Dead-Eye.\n- Long group: crossbows, rifles. Bonus for Spotter and Longshot.",
		},
	},
	{
		title = "Explosives",
		pages = {
			"- Fire bomb / Molotov: 3x3 area (target tile + 1 around), 10 tiles range. 1 HP right away, then 1 HP at the start of each of the victim's next 2 turns (3 HP over 3 turns).\n- Aerosol bomb, pipe bomb, grenade: 5x5 area (target tile + 2 around), 10 tiles range, 4 HP.\n\nLucky shortens the burning by 1 turn and Unlucky lengthens it by 1 turn. A scrap Molotov or bomb deals 1 less, never below 1.",
			"Throwing an explosive has its own mechanics. It is an action, and you can throw any explosive up to 10 tiles.\n\n- Explosives cannot be used in the first round of combat.\n- Hold the explosive in your primary hand and use Attack / Throw or Throw weapon on a target. The item is deleted as soon as you roll.\n- Explosives require two hands. After throwing, your hands are empty, and you must use the Change Weapon action on a later turn to hold a weapon again.",
			"- Explosives affect everyone in the combat inside the blast area, including allies, yourself, and knocked-out or surrendered combatants.\n- You cannot strap explosives to your body.\n\nRESOLVING AN EXPLOSIVE ATTACK\n1. The attacker chooses a target. The explosion is centred on that target's tile.\n2. The attacker rolls once.\n3. Everyone inside the blast area rolls their own Defend (ranged) against that roll. Cover gives +2.",
			"4. Anyone whose defence is equal to or lower than the attack is hit and takes the explosive's damage. A Molotov also sets them on fire.\n5. Your turn ends.\n\nCRITICAL SUCCESS\n\nExplosives never deal critical-success damage. A victim who fumbles their defence still takes +1d4 (see Critical Hits).",
			"CRITICAL FAILURE\n\nThe throw goes wide.\n1. The system rolls 1d3: the explosive lands that many tiles from the target, in one of 8 random directions.\n2. It goes off there. Everyone inside the new blast area rolls Defend (ranged) against your original roll, including you and your own side.\n3. Roleplay the bad throw: a slipped grip, a bad bounce, a panicked lob.",
		},
	},
	{
		title = "Critical Hits",
		pages = {
			"Sometimes a blow lands heavy on your opponent. Other times, their attacks seem more brutal than usual.\n\nCriticals are based on the natural die: the kept d20, before any modifiers. The system spots them and rolls the extra damage for you.\n\n- Normal: critical success on a natural 20, critical failure on a natural 1.\n- Wildcard: critical success on 19-20, critical failure on 1-2.\n- Even Keel: never.",
			"Lucky and Unlucky do not change criticals; they change how long status effects last.\n\nCRITICAL SUCCESS (ATTACKING)\n\nIf your natural roll is a critical success and your attack hits, the system adds 1d4 bonus damage to your weapon's damage.\n- Your opponent still rolls to defend. A critical success does not guarantee a hit: a defender with a high roll plus defence bonuses can still beat it (for example, 19 + 2 = 21 beats a natural 20).\n- It does not apply to explosives.",
			"CRITICAL FAILURE (ATTACKING)\n\nIf your natural roll is a critical failure:\n- Your attack misses automatically. Your opponent does not roll to defend, and your turn ends.\n- The log shows CRITICAL FAILURE.\n- Explosives: the throw goes wide (see Explosives).",
			"CRITICAL FAILURE (DEFENDING)\n\nIf your defence roll is a critical failure, the attack hits no matter what the totals say, and 1d4 is added to its damage. This applies to normal attacks, explosions and attacks of opportunity.\n\nA defence fumble and an attacker's critical success can happen together, adding both 1d4 bonuses.",
			"ROLEPLAYING A CRITICAL FAILURE\n\n- The player who rolled describes the outcome of their critical failure.\n- A critical failure may only affect your own character. You cannot accidentally hit, injure or otherwise negatively affect other players or their characters.\n- Stay realistic. If you describe an injury, it must be reasonable for the situation.\n- Not allowed: hitting or injuring another character because of your failed roll, or any outcome that removes another player's agency or forces them to react in a specific way.",
		},
	},
}

return DiceRulesData
