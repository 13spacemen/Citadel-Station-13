/mob/living/simple_animal/hostile/asteroid/hivelord
	name = "hivelord"
	desc = "A truly alien creature, it is a mass of unknown organic material, constantly fluctuating. When attacking, pieces of it split off and attack in tandem with the original."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "Hivelord"
	icon_living = "Hivelord"
	icon_aggro = "Hivelord_alert"
	icon_dead = "Hivelord_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	move_to_delay = 14
	ranged = 1
	vision_range = 4
	aggro_vision_range = 7
	speed = 3
	maxHealth = 75
	health = 75
	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "lashes out at"
	attack_verb_simple = "lash out at"
	speak_emote = list("telepathically cries")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "falls right through the strange body of the"
	ranged_cooldown = 0
	ranged_cooldown_time = 15
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 3
	minimum_distance = 3
	pass_flags = PASSTABLE
	loot = list(/obj/item/organ/regenerative_core)
	var/brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood

/mob/living/simple_animal/hostile/asteroid/hivelord/OpenFire(the_target)
	if(world.time >= ranged_cooldown)
		var/mob/living/simple_animal/hostile/asteroid/hivelordbrood/A = new brood_type(src.loc)

		A.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)
		A.GiveTarget(target)
		A.friends = friends
		A.faction = faction.Copy()
		if(!A == /mob/living/simple_animal/hostile/poison/bees/toxin)
			A.my_creator = type
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/asteroid/hivelord/AttackingTarget()
	OpenFire()
	return TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/spawn_crusher_loot()
	loot += crusher_loot //we don't butcher

/mob/living/simple_animal/hostile/asteroid/hivelord/death(gibbed)
	mouse_opacity = MOUSE_OPACITY_ICON
	..(gibbed)

//A fragile but rapidly produced creature
/mob/living/simple_animal/hostile/asteroid/hivelordbrood
	name = "hivelord brood"
	desc = "A fragment of the original Hivelord, rallying behind its original. One isn't much of a threat, but..."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "Hivelordbrood"
	icon_living = "Hivelordbrood"
	icon_aggro = "Hivelordbrood"
	icon_dead = "Hivelordbrood"
	icon_gib = "syndicate_gib"
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	move_to_delay = 1
	friendly_verb_continuous = "buzzes near"
	friendly_verb_simple = "buzz near"
	vision_range = 10
	speed = 3
	maxHealth = 1
	health = 1
	movement_type = FLYING
	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 2
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	speak_emote = list("telepathically cries")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "falls right through the strange body of the"
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE | PASSMOB //they shouldn't get stuck behind hivelords.
	density = FALSE
	del_on_death = 1
	var/swarming = FALSE
	var/my_creator = null

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/Initialize()
	. = ..()
	if(swarming)
		AddComponent(/datum/component/swarming) //oh god not the bees
	addtimer(CALLBACK(src, .proc/death), 100)

//Legion
/mob/living/simple_animal/hostile/asteroid/hivelord/legion
	name = "legion"
	desc = "You can still see what was once a human under the shifting mass of corruption."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "legion"
	icon_living = "legion"
	icon_aggro = "legion"
	icon_dead = "legion"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	obj_damage = 60
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "lashes out at"
	attack_verb_simple = "lash out at"
	speak_emote = list("echoes")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "bounces harmlessly off of"
	crusher_loot = /obj/item/crusher_trophy/legion_skull
	loot = list(/obj/item/organ/regenerative_core/legion)
	brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion
	del_on_death = 1
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	var/dwarf_mob = FALSE
	var/mob/living/carbon/human/stored_mob

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/random/Initialize()
	. = ..()
	if(prob(5))
		new /mob/living/simple_animal/hostile/asteroid/hivelord/legion/dwarf(loc)
		return INITIALIZE_HINT_QDEL

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/dwarf
	name = "dwarf legion"
	desc = "You can still see what was once a rather small human under the shifting mass of corruption."
	icon_state = "dwarf_legion"
	icon_living = "dwarf_legion"
	icon_aggro = "dwarf_legion"
	icon_dead = "dwarf_legion"
	maxHealth = 60
	health = 60
	speed = 2 //faster!
	move_to_delay = 10 //actually faster!
	crusher_drop_mod = 20
	dwarf_mob = TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/beegion
	name = "beegion"
	desc = "You can still see what was once a human under the shifting mass of - oh my God, those are bees."
	brood_type = /mob/living/simple_animal/hostile/poison/bees/toxin

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/death(gibbed)
	visible_message("<span class='warning'>The skulls on [src] wail in anger as they flee from their dying host!</span>")
	var/turf/T = get_turf(src)
	if(T)
		if(stored_mob)
			stored_mob.forceMove(get_turf(src))
			stored_mob = null
		else if(fromtendril)
			new /obj/effect/mob_spawn/human/corpse/charredskeleton(T)
		else if(dwarf_mob)
			new /obj/effect/mob_spawn/human/corpse/damaged/legioninfested/dwarf(T)
		else
			new /obj/effect/mob_spawn/human/corpse/damaged/legioninfested(T)
	..(gibbed)

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/tendril
	fromtendril = TRUE

//Legion skull
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion
	name = "legion"
	desc = "One of many."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "legion_head"
	icon_living = "legion_head"
	icon_aggro = "legion_head"
	icon_dead = "legion_head"
	icon_gib = "syndicate_gib"
	friendly_verb_continuous = "buzzes near"
	friendly_verb_simple = "buzz near"
	vision_range = 10
	maxHealth = 1
	health = 5
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	speak_emote = list("echoes")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "is shrugged off by"
	del_on_death = TRUE
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	swarming = TRUE
	var/can_infest_dead = FALSE

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(isturf(loc))
		for(var/mob/living/carbon/human/H in view(src,1)) //Only for corpse right next to/on same tile
			if(H.stat == UNCONSCIOUS || (can_infest_dead && H.stat == DEAD))
				infest(H)

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/proc/infest(mob/living/carbon/human/H)
	visible_message("<span class='warning'>[name] burrows into the flesh of [H]!</span>")
	var/mob/living/simple_animal/hostile/asteroid/hivelord/legion/L = check_infest_type(H)
	visible_message("<span class='warning'>[L] staggers to [L.p_their()] feet!</span>")
	H.death()
	H.adjustBruteLoss(1000)
	L.stored_mob = H
	H.forceMove(L)
	qdel(src)

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/proc/check_infest_type(mob/living/carbon/human/human)
	var/mob/living/simple_animal/hostile/asteroid/hivelord/legion/L
	var/list/blacklisted_types = list(/mob/living/simple_animal/hostile/asteroid/hivelord/legion/dwarf)
	if(HAS_TRAIT(human, TRAIT_DWARF)) //dwarf legions aren't just fluff!
		L = new /mob/living/simple_animal/hostile/asteroid/hivelord/legion/dwarf(human.loc)
	else if(my_creator)
		if(my_creator in blacklisted_types)
			L = new(human.loc)
		else
			L = new my_creator(human.loc)
	else
		L = new(human.loc)
	return L

//Advanced Legion is slightly tougher to kill and can raise corpses (revive other legions)
/mob/living/simple_animal/hostile/asteroid/hivelord/legion/advanced
	stat_attack = DEAD
	maxHealth = 120
	health = 120
	brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/advanced
	icon_state = "dwarf_legion"
	icon_living = "dwarf_legion"
	icon_aggro = "dwarf_legion"
	icon_dead = "dwarf_legion"

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/advanced
	stat_attack = DEAD
	can_infest_dead = TRUE

//Legion that spawns Legions
/mob/living/simple_animal/hostile/big_legion
	name = "legion"
	desc = "One of many."
	icon = 'icons/mob/lavaland/64x64megafauna.dmi'
	icon_state = "legion"
	icon_living = "legion"
	icon_dead = "legion"
	health = 450
	maxHealth = 450
	melee_damage_lower = 20
	melee_damage_upper = 20
	anchored = FALSE
	AIStatus = AI_ON
	stop_automated_movement = FALSE
	wander = TRUE
	maxbodytemp = INFINITY
	layer = MOB_LAYER
	del_on_death = TRUE
	sentience_type = SENTIENCE_BOSS
	loot = list(/obj/item/organ/regenerative_core/legion = 3, /obj/effect/mob_spawn/human/corpse/damaged/legioninfested = 5)
	move_to_delay = 14
	vision_range = 5
	aggro_vision_range = 9
	speed = 3
	faction = list("mining")
	weather_immunities = list("lava","ash")
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

/mob/living/simple_animal/hostile/big_legion/Initialize()
	.=..()
	AddComponent(/datum/component/spawner, list(/mob/living/simple_animal/hostile/asteroid/hivelord/legion), 200, faction, "peels itself off from", 3)

//Tendril-spawned Legion remains, the charred skeletons of those whose bodies sank into laval or fell into chasms.
/obj/effect/mob_spawn/human/corpse/charredskeleton
	name = "charred skeletal remains"
	burn_damage = 1000
	mob_name = "ashen skeleton"
	mob_gender = NEUTER
	husk = FALSE
	mob_species = /datum/species/skeleton
	mob_color = "#454545"

//Legion infested mobs

/obj/effect/mob_spawn/human/corpse/damaged/legioninfested/dwarf/equip(mob/living/carbon/human/H)
	. = ..()
	H.dna.add_mutation(DWARFISM)

/obj/effect/mob_spawn/human/corpse/damaged/legioninfested/Initialize()
	var/type = pickweight(list("Miner" = 45, "Ashwalker" = 10, "Golem" = 10,"Clown" = 10, pick(list("Shadow", "YeOlde","Operative", "Cultist", "Lavaknight")) = 4, "Assistant" = 20, "Beelegion" = 1))
	switch(type)
		if("Miner")
			mob_species = pickweight(list(/datum/species/human = 70, /datum/species/lizard = 26, /datum/species/fly = 2, /datum/species/plasmaman = 2))
			if(mob_species == /datum/species/plasmaman)
				uniform = /obj/item/clothing/under/plasmaman/mining
				head = /obj/item/clothing/head/helmet/space/plasmaman/mining
				belt = /obj/item/tank/internals/plasmaman/belt
				mask = /obj/item/clothing/mask/gas/explorer
			else
				uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
				if (prob(4))
					belt = pickweight(list(/obj/item/storage/belt/mining = 2, /obj/item/storage/belt/mining/alt = 2))
				else if(prob(10))
					belt = pickweight(list(/obj/item/pickaxe = 8, /obj/item/pickaxe/mini = 4, /obj/item/pickaxe/silver = 2, /obj/item/pickaxe/diamond = 1))
				else
					belt = /obj/item/tank/internals/emergency_oxygen/engi
			if(mob_species != /datum/species/lizard)
				shoes = /obj/item/clothing/shoes/workboots/mining
			gloves = /obj/item/clothing/gloves/color/black
			mask = /obj/item/clothing/mask/gas/explorer
			if(prob(20))
				suit = pickweight(list(/obj/item/clothing/suit/hooded/explorer/standard = 6, /obj/item/clothing/suit/hooded/cloak/goliath = 2, /obj/item/clothing/suit/hooded/explorer/exo = 6, /obj/item/clothing/suit/hooded/explorer/seva = 6))
			if(prob(30))
				r_pocket = pickweight(list(/obj/item/stack/marker_beacon = 20, /obj/item/stack/spacecash/c1000 = 7, /obj/item/reagent_containers/hypospray/medipen/survival = 2, /obj/item/borg/upgrade/modkit/damage = 1 ))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/stack/spacecash/c1000 = 7, /obj/item/reagent_containers/hypospray/medipen/survival = 2, /obj/item/borg/upgrade/modkit/cooldown = 1 ))
		if("Ashwalker")
			mob_species = /datum/species/lizard/ashwalker
			uniform = /obj/item/clothing/under/costume/gladiator/ash_walker
			if(prob(95))
				head = /obj/item/clothing/head/helmet/gladiator
			else
				head = /obj/item/clothing/head/helmet/skull
				suit = /obj/item/clothing/suit/armor/bone
				gloves = /obj/item/clothing/gloves/bracer
			if(prob(5))
				back = pickweight(list(/obj/item/spear/bonespear = 3, /obj/item/fireaxe/boneaxe = 2))
			if(prob(10))
				belt = /obj/item/storage/belt/mining/primitive
			if(prob(30))
				r_pocket = /obj/item/kitchen/knife/combat/bone
			if(prob(30))
				l_pocket = /obj/item/kitchen/knife/combat/bone
		if("Clown")
			name = pick(GLOB.clown_names)
			outfit = /datum/outfit/job/clown
			belt = null
			backpack_contents = list()
			if(prob(70))
				backpack_contents += pick(list(/obj/item/stamp/clown = 1, /obj/item/reagent_containers/spray/waterflower = 1, /obj/item/reagent_containers/food/snacks/grown/banana = 1, /obj/item/megaphone/clown = 1, /obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter = 1, /obj/item/pneumatic_cannon/pie = 1))
			if(prob(30))
				backpack_contents += list(/obj/item/stack/sheet/mineral/bananium = pickweight(list( 1 = 3, 2 = 2, 3 = 1)))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/bikehorn/golden = 3, /obj/item/bikehorn/airhorn= 1 ))
			if(prob(10))
				r_pocket = /obj/item/implanter/sad_trombone
		if("Golem")
			mob_species = pick(list(/datum/species/golem/adamantine, /datum/species/golem/plasma, /datum/species/golem/diamond, /datum/species/golem/gold, /datum/species/golem/silver, /datum/species/golem/plasteel, /datum/species/golem/titanium, /datum/species/golem/plastitanium))
			if(prob(30))
				glasses = pickweight(list(/obj/item/clothing/glasses/meson = 2, /obj/item/clothing/glasses/hud/health = 2, /obj/item/clothing/glasses/hud/diagnostic =2, /obj/item/clothing/glasses/science = 2, /obj/item/clothing/glasses/welding = 2, /obj/item/clothing/glasses/night = 1))
			if(prob(10))
				belt = pick(list(/obj/item/storage/belt/mining/vendor, /obj/item/storage/belt/utility/full))
			if(prob(50))
				neck = /obj/item/bedsheet/rd/royal_cape
			if(prob(10))
				l_pocket = pick(list(/obj/item/crowbar/power, /obj/item/wrench/power, /obj/item/weldingtool/experimental))
		if("YeOlde")
			mob_gender = FEMALE
			uniform = /obj/item/clothing/under/costume/maid
			gloves = /obj/item/clothing/gloves/color/white
			shoes = /obj/item/clothing/shoes/laceup
			head = /obj/item/clothing/head/helmet/knight
			suit = /obj/item/clothing/suit/armor/riot/knight
			back = /obj/item/shield/riot/buckler
			belt = /obj/item/nullrod/claymore
			r_pocket = /obj/item/tank/internals/emergency_oxygen
			mask = /obj/item/clothing/mask/breath
		if("Operative")
			id_job = "Operative"
			outfit = /datum/outfit/syndicatecommandocorpse
		if("Shadow")
			mob_species = /datum/species/shadow
			r_pocket = /obj/item/reagent_containers/pill/shadowtoxin
			neck = /obj/item/clothing/accessory/medal/plasma/nobel_science
			uniform = /obj/item/clothing/under/color/black
			shoes = /obj/item/clothing/shoes/sneakers/black
			suit = /obj/item/clothing/suit/toggle/labcoat
			glasses = /obj/item/clothing/glasses/sunglasses/blindfold
			back = /obj/item/tank/internals/oxygen
			mask = /obj/item/clothing/mask/breath
		if("Cultist")
			uniform = /obj/item/clothing/under/costume/roman
			suit = /obj/item/clothing/suit/cultrobes
			head = /obj/item/clothing/head/culthood
			suit_store = /obj/item/tome
			r_pocket = /obj/item/restraints/legcuffs/bola/cult
			l_pocket = /obj/item/melee/cultblade/dagger
			glasses =  /obj/item/clothing/glasses/hud/health/night/cultblind
			backpack_contents = list(/obj/item/reagent_containers/glass/beaker/unholywater = 1, /obj/item/cult_shift = 1, /obj/item/flashlight/flare/culttorch = 1, /obj/item/stack/sheet/runed_metal = 15)
		if("Lavaknight")
			uniform = /obj/item/clothing/under/misc/assistantformal
			mask = /obj/item/clothing/mask/breath
			shoes = /obj/item/clothing/shoes/sneakers/black
			r_pocket = /obj/item/melee/transforming/energy/sword/cx/broken
			suit = /obj/item/clothing/suit/space/hardsuit/lavaknight
			suit_store = /obj/item/tank/internals/oxygen
			id = /obj/item/card/id/knight
			id_job = "Knight"
		if("Assistant")
			uniform = /obj/item/clothing/under/color/grey
			belt = /obj/item/tank/internals/emergency_oxygen
			mask = /obj/item/clothing/mask/gas
			gloves = /obj/item/clothing/gloves/color/fyellow
			id = /obj/item/card/id/silver/reaper //looks cool and has a fancy name but only a 1% chance
			if(prob(99))
				id = /obj/item/card/id
				id_job = "Assisant"
			if(prob(95))
				head = /obj/item/clothing/head/hardhat/red
			if(prob(5))
				gloves = /obj/item/clothing/gloves/color/yellow
			if(prob(10))
				back = /obj/item/spear
			else if(prob(80)) //Now they dont always have a backpack
				back = /obj/item/storage/backpack
				backpack_contents = list(/obj/item/stack/cable_coil = 1, /obj/item/storage/fancy/donut_box = 1, /obj/item/storage/fancy/cigarettes/cigpack_shadyjims = 1, /obj/item/lighter = 1)
			if(prob(90))
				r_pocket = /obj/item/kitchen/knife
			if(prob(60))
				l_pocket = /obj/item/soap/homemade

		if("Beelegion")
			uniform = /obj/item/clothing/under/color/yellow
			suit = /obj/item/clothing/suit/hooded/bee_costume
			shoes = /obj/item/clothing/shoes/sneakers/yellow
			gloves = /obj/item/clothing/gloves/color/yellow
			belt = /obj/item/storage/belt/fannypack/yellow
			id_job = "Assisant"
			id = /obj/item/card/id
			l_pocket = /obj/item/reagent_containers/food/drinks/soda_cans/buzz_fuzz
			mask = /obj/item/clothing/mask/rat/bee
	. = ..()

// Snow Legion
/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow
	name = "snow legion"
	desc = "You can still see what was once a human under the shifting snowy mass, clearly decorated by a clown."
	icon = 'icons/mob/icemoon/icemoon_monsters.dmi'
	icon_state = "snowlegion"
	icon_living = "snowlegion"
	icon_aggro = "snowlegion_alive"
	icon_dead = "snowlegion"
	crusher_loot = /obj/item/crusher_trophy/legion_skull
	loot = list(/obj/item/organ/regenerative_core/legion)
	brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/snow

/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow/tendril
	fromtendril = TRUE

// Snow Legion skull
/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion/snow
	name = "snow legion"
	desc = "One of many."
	icon = 'icons/mob/icemoon/icemoon_monsters.dmi'
	icon_state = "snowlegion_head"
	icon_living = "snowlegion_head"
	icon_aggro = "snowlegion_head"
	icon_dead = "snowlegion_head"
