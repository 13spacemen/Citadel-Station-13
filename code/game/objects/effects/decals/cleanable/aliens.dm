// Note: BYOND is object oriented. There is no reason for this to be copy/pasted blood code.

/obj/effect/decal/cleanable/blood/xeno
	name = "xeno blood"
	desc = "It's green and acidic. It looks like... <i>blood?</i>"
	color = BLOOD_COLOR_XENO
	blood_DNA = list("UNKNOWN DNA" = "X*")

/obj/effect/decal/cleanable/blood/splatter/xeno
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/gibs/xeno
	name = "xeno gibs"
	desc = "Gnarly..."
	icon_state = "xgib1"
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6")
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/gibs/xeno/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidxenogibs", 5)

/obj/effect/decal/cleanable/blood/gibs/xeno/streak(list/directions)
	set waitfor = 0
	var/direction = pick(directions)
	for(var/i = 0, i < pick(1, 200; 2, 150; 3, 50), i++)
		sleep(2)
		if(i > 0)
			var/list/datum/disease/diseases
			GET_COMPONENT(infective, /datum/component/infective)
			if(infective)
				diseases = infective.diseases
			var/obj/effect/decal/cleanable/blood/gibs/gibbers = src
			var/obj/effect/decal/cleanable/blood/splatter/xeno/splat = new /obj/effect/decal/cleanable/blood/splatter/xeno(loc, diseases)
			splat.color = gibbers.blood_color
			splat.blood_color = gibbers.blood_color
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/blood/gibs/xeno/up/xeno
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibup1","xgibup1","xgibup1")

/obj/effect/decal/cleanable/blood/gibs/xeno/down/xeno
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibdown1","xgibdown1","xgibdown1")

/obj/effect/decal/cleanable/blood/gibs/xeno/body/xeno
	random_icon_states = list("xgibhead", "xgibtorso")

/obj/effect/decal/cleanable/blood/gibs/xeno/torso/xeno
	random_icon_states = list("xgibtorso")

/obj/effect/decal/cleanable/blood/gibs/xeno/limb/xeno
	random_icon_states = list("xgibleg", "xgibarm")

/obj/effect/decal/cleanable/blood/gibs/xeno/core/xeno
	random_icon_states = list("xgibmid1", "xgibmid2", "xgibmid3")

/obj/effect/decal/cleanable/blood/gibs/xeno/larva
	random_icon_states = list("xgiblarva1", "xgiblarva2")

/obj/effect/decal/cleanable/blood/gibs/xeno/larva/body
	random_icon_states = list("xgiblarvahead", "xgiblarvatorso")

/obj/effect/decal/cleanable/blood/xtracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/blood/xtracks/Initialize()
	add_blood(list("UNKNOWN DNA" = "X*"))
	. = ..()