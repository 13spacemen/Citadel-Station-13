/// IN THE FUTURE, WE WILL PROBABLY REFACTOR TO LESSEN THE NEED FOR UPDATE_MOBILITY, BUT FOR NOW.. WE CAN START DOING THIS.
/// FOR BLOCKING MOVEMENT, USE TRAIT_MOBILITY_NOMOVE AS MUCH AS POSSIBLE. IT WILL MAKE REFACTORS IN THE FUTURE EASIER.
/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOMOVE), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOPICKUP), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOUSE), .proc/update_mobility)

//Stuff like mobility flag updates, resting updates, etc.

//Force-set resting variable, without needing to resist/etc.
/mob/living/proc/set_resting(new_resting, silent = FALSE, updating = TRUE)
	if(new_resting != resting)
		resting = new_resting
		if(!silent)
			to_chat(src, "<span class='notice'>You are now [resting? "resting" : "getting up"].</span>")
		update_resting(updating)
		if(has_gravity() && resting)
			playsound(src, "bodyfall", 20, 1)

/mob/living/proc/update_resting(update_mobility = TRUE)
	if(update_mobility)
		update_mobility()

//Force mob to rest, does NOT do stamina damage.
//It's really not recommended to use this proc to give feedback, hence why silent is defaulting to true.
/mob/living/proc/KnockToFloor(disarm_items = FALSE, silent = TRUE, updating = TRUE)
	if(!silent && !resting)
		to_chat(src, "<span class='warning'>You are knocked to the floor!</span>")
	set_resting(TRUE, TRUE, updating)
	if(disarm_items)
		drop_all_held_items()

/mob/living/proc/lay_down()
	set name = "Rest"
	set category = "IC"
	if(client?.prefs?.autostand)
		intentionalresting = !intentionalresting
		to_chat(src, "<span class='notice'>You are now attempting to [intentionalresting ? "[!resting ? "lay down and ": ""]stay down" : "[resting ? "get up and ": ""]stay up"].</span>")
		if(intentionalresting && !resting)
			set_resting(TRUE, FALSE)
		else
			resist_a_rest()
	else
		if(!resting)
			set_resting(TRUE, FALSE)
			to_chat(src, "<span class='notice'>You are now laying down.</span>")
		else
			resist_a_rest()

/mob/living/proc/resist_a_rest(automatic = FALSE, ignoretimer = FALSE) //Lets mobs resist out of resting. Major QOL change with combat reworks.
	if(!resting || stat || attemptingstandup)
		return FALSE
	if(ignoretimer)
		set_resting(FALSE, FALSE)
		return TRUE
	else
		var/totaldelay = 3 //A little bit less than half of a second as a baseline for getting up from a rest
		if(getStaminaLoss() >= STAMINA_SOFTCRIT)
			to_chat(src, "<span class='warning'>You're too exhausted to get up!")
			return FALSE
		attemptingstandup = TRUE
		var/health_deficiency = max((maxHealth - (health - getStaminaLoss()))*0.5, 0)
		if(!has_gravity())
			health_deficiency = health_deficiency*0.2
		totaldelay += health_deficiency
		var/standupwarning = "[src] and everyone around them should probably yell at the dev team"
		switch(health_deficiency)
			if(-INFINITY to 10)
				standupwarning = "[src] stands right up!"
			if(10 to 35)
				standupwarning = "[src] tries to stand up."
			if(35 to 60)
				standupwarning = "[src] slowly pushes [p_them()]self upright."
			if(60 to 80)
				standupwarning = "[src] weakly attempts to stand up."
			if(80 to INFINITY)
				standupwarning = "[src] struggles to stand up."
		var/usernotice = automatic ? "<span class='notice'>You are now getting up. (Auto)</span>" : "<span class='notice'>You are now getting up.</span>"
		visible_message("<span class='notice'>[standupwarning]</span>", usernotice, vision_distance = 5)
		if(do_after(src, totaldelay, target = src, required_mobility_flags = MOBILITY_MOVE))
			set_resting(FALSE, FALSE)
			attemptingstandup = FALSE
			return TRUE
		else
			visible_message("<span class='notice'>[src] falls right back down.</span>", "<span class='notice'>You fall right back down.</span>")
			attemptingstandup = FALSE
			if(has_gravity())
				playsound(src, "bodyfall", 20, 1)
			return FALSE

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/living/proc/update_mobility()
	var/stat_softcrit = stat == SOFT_CRIT
	var/stat_conscious = (stat == CONSCIOUS) || stat_softcrit

	var/conscious = !IsUnconscious() && stat_conscious && !HAS_TRAIT(src, TRAIT_DEATHCOMA)

	var/has_arms = get_num_arms()
	var/has_legs = get_num_legs()
	var/ignore_legs = get_leg_ignore()
	var/stun = IsStun()
	var/paralyze = IsParalyzed()
	var/knockdown = IsKnockdown()
	var/daze = IsDazed()
	var/immobilize = IsImmobilized()

	var/chokehold = pulledby && pulledby.grab_state >= GRAB_NECK
	var/restrained = restrained()
	var/pinned = resting && pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE // Cit change - adds pinning for aggressive-grabbing people on the ground
	var/canmove = !immobilize && !stun && conscious && !paralyze && !buckled && (!stat_softcrit || !pulledby) && !chokehold && !IsFrozen() && (has_arms || ignore_legs || has_legs) && !pinned && !recoveringstam
	var/canresist = !stun && conscious && !stat_softcrit && !paralyze && (has_arms || ignore_legs || has_legs) && !recoveringstam

	if(canmove)
		mobility_flags |= MOBILITY_MOVE
	else
		mobility_flags &= ~MOBILITY_MOVE

	if(canresist)
		mobility_flags |= MOBILITY_RESIST
	else
		mobility_flags &= !MOBILITY_RESIST

	var/canstand_involuntary = conscious && !stat_softcrit && !knockdown && !chokehold && !paralyze && (ignore_legs || has_legs) && !(buckled && buckled.buckle_lying) && !recoveringstam
	var/canstand = canstand_involuntary && !resting

	var/should_be_lying = !canstand
	if(buckled)
		if(buckled.buckle_lying != -1)
			should_be_lying = buckled.buckle_lying

	if(should_be_lying)
		mobility_flags &= ~MOBILITY_STAND
		if(!lying) //force them on the ground
			lying = pick(90, 270)
	else
		mobility_flags |= MOBILITY_STAND
		lying = 0

	if(should_be_lying || restrained || incapacitated())
		mobility_flags &= ~(MOBILITY_UI|MOBILITY_PULL)
	else
		mobility_flags |= MOBILITY_UI|MOBILITY_PULL

	var/canitem_general = !paralyze && !stun && conscious && !chokehold && !restrained && has_arms && !recoveringstam
	if(canitem_general)
		mobility_flags |= (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE | MOBILITY_HOLD)
	else
		mobility_flags &= ~(MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE | MOBILITY_HOLD)

	if(HAS_TRAIT(src, TRAIT_MOBILITY_NOMOVE))
		DISABLE_BITFIELD(mobility_flags, MOBILITY_MOVE)
	if(HAS_TRAIT(src, TRAIT_MOBILITY_NOPICKUP))
		DISABLE_BITFIELD(mobility_flags, MOBILITY_PICKUP)
	if(HAS_TRAIT(src, TRAIT_MOBILITY_NOUSE))
		DISABLE_BITFIELD(mobility_flags, MOBILITY_USE)

	if(daze)
		DISABLE_BITFIELD(mobility_flags, MOBILITY_USE)

	//Handle update-effects.
	if(!(mobility_flags & MOBILITY_HOLD))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_PULL))
		if(pulling)
			stop_pulling()
	if(!(mobility_flags & MOBILITY_UI))
		unset_machine()

	if(isliving(pulledby))
		var/mob/living/L = pulledby
		L.update_pull_movespeed()

	//Handle lying down, voluntary or involuntary
	density = !lying
	if(lying)
		set_resting(TRUE, TRUE, FALSE)
		if(layer == initial(layer)) //to avoid special cases like hiding larvas.
			layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_transform()
	lying_prev = lying

	//Handle citadel autoresist
	if((mobility_flags & MOBILITY_MOVE) && !intentionalresting && canstand_involuntary && iscarbon(src) && client?.prefs?.autostand)//CIT CHANGE - adds autostanding as a preference
		addtimer(CALLBACK(src, .proc/resist_a_rest, TRUE), 0) //CIT CHANGE - ditto

	return mobility_flags
