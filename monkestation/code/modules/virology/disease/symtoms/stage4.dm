/datum/symptom/spaceadapt
	name = "Space Adaptation Effect"
	desc = "Heals the infected from the effects of space exposure, should they remain in a vacuum."
	stage = 4
	max_count = 1
	badness = EFFECT_DANGER_HELPFUL
	chance = 10
	max_chance = 25

/datum/symptom/spaceadapt/activate(mob/living/carbon/mob)
	mob.dna.add_mutation(/datum/mutation/human/pressure_adaptation)
	mob.dna.add_mutation(/datum/mutation/human/temperature_adaptation)

/datum/symptom/spaceadapt/deactivate(mob/living/carbon/mob)
	mob.dna.remove_mutation(/datum/mutation/human/pressure_adaptation)
	mob.dna.remove_mutation(/datum/mutation/human/temperature_adaptation)

/datum/symptom/minttoxin
	name = "Creosote Syndrome"
	desc = "Causes the infected to synthesize a wafer thin mint."
	stage = 4
	badness = EFFECT_DANGER_HARMFUL

/datum/symptom/minttoxin/activate(mob/living/carbon/mob)
	if(istype(mob) && mob.reagents.get_reagent_amount(/datum/reagent/consumable/mintextract) < 5)
		to_chat(mob, "<span class='notice'>You feel a minty freshness</span>")
		mob.reagents.add_reagent(/datum/reagent/consumable/mintextract, 5)

/datum/symptom/deaf
	name = "Dead Ear Syndrome"
	desc = "Kills the infected's aural senses."
	stage = 4
	max_multiplier = 5
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/deaf/activate(mob/living/carbon/mob)
	var/obj/item/organ/internal/ears/ears = mob.get_organ_slot(ORGAN_SLOT_EARS)
	if(!ears)
		return //cutting off your ears to cure the deafness: the ultimate own
	to_chat(mob, span_userdanger("Your ears pop and begin ringing loudly!"))
	ears.deaf = min(20, ears.deaf + 15)

	if(prob(multiplier * 5))
		if(ears.damage < ears.maxHealth)
			to_chat(mob, span_userdanger("Your ears pop painfully and start bleeding!"))
			// Just absolutely murder me man
			ears.apply_organ_damage(ears.maxHealth)
			mob.emote("scream")
			ADD_TRAIT(mob, TRAIT_DEAF, DISEASE_TRAIT)

/datum/symptom/deaf/deactivate(mob/living/carbon/mob)
	REMOVE_TRAIT(mob, TRAIT_DEAF, DISEASE_TRAIT)


/datum/symptom/killertoxins
	name = "Toxification Syndrome"
	desc = "A more advanced version of Hyperacidity, causing the infected to rapidly generate toxins."
	stage = 4
	badness = EFFECT_DANGER_DEADLY
	multiplier = 3
	max_multiplier = 5

/datum/symptom/killertoxins/activate(mob/living/carbon/mob)
	mob.adjustToxLoss(5*multiplier)


/datum/symptom/dna
	name = "Reverse Pattern Syndrome"
	desc = "Attacks the infected's DNA, causing rapid spontaneous mutation, and inhibits the ability for the infected to be affected by cryogenics."
	stage = 4
	badness = EFFECT_DANGER_DEADLY

/datum/symptom/dna/activate(mob/living/carbon/mob)
	mob.bodytemperature = max(mob.bodytemperature, 350)
	scramble_dna(mob, TRUE, TRUE, TRUE, rand(15,45))
	mob.adjustCloneLoss(10)


/datum/symptom/immortal
	name = "Longevity Syndrome"
	desc = "Grants functional immortality to the infected so long as the symptom is active. Heals broken bones and healing external damage. Creates a backlash if cured."
	stage = 4
	badness = EFFECT_DANGER_HELPFUL
	var/total_healed = 0

/datum/symptom/immortal/activate(mob/living/carbon/mob)
	if(istype(mob, /mob/living/carbon/human))
		for(var/datum/wound/wound as anything in mob.all_wounds)
			to_chat(mob, span_notice("You feel the [wound] heal itself."))
			wound.remove_wound()
			break
			
	var/heal_amt = 5*multiplier
	var/current_health = mob.getBruteLoss()
	if(current_health >= heal_amt)
		total_healed += heal_amt * 0.2
	else
		total_healed += (heal_amt - current_health) * 0.2
	mob.adjustBruteLoss(-heal_amt)
	mob.adjustFireLoss(-heal_amt)
	mob.adjustCloneLoss(-heal_amt)

/datum/symptom/immortal/deactivate(mob/living/carbon/mob)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		to_chat(H, span_warning("You suddenly feel hurt and old..."))
		H.age += 4 * multiplier * total_healed
	mob.adjustBruteLoss(total_healed)
	mob.adjustFireLoss(total_healed)

/datum/symptom/bones
	name = "Fragile Person Syndrome"
	desc = "Attacks the infected's body structure, making it more fragile."
	stage = 4
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/bones/activate(mob/living/carbon/mob)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/bodypart/bp in H.bodyparts)
			bp.wound_resistance -= 10

/datum/symptom/bones/deactivate(mob/living/carbon/mob)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/bodypart/bp in H.bodyparts)
			bp.wound_resistance += 10

/datum/symptom/fizzle
	name = "Fizzle Effect"
	desc = "Causes an ill, though harmless, sensation in the infected's throat."
	stage = 4
	badness = EFFECT_DANGER_FLAVOR

/datum/symptom/fizzle/activate(mob/living/carbon/mob)
	mob.emote("me",1,pick("sniffles...", "clears their throat..."))

/datum/symptom/delightful
	name = "Delightful Effect"
	desc = "A more powerful version of Full Glass. Makes the infected feel delightful."
	stage = 4
	badness = EFFECT_DANGER_HELPFUL

/datum/symptom/delightful/activate(mob/living/carbon/mob)
	to_chat(mob, "<span class = 'notice'>You feel delightful!</span>")
	if (mob.reagents.get_reagent_amount(/datum/reagent/drug/happiness) < 10)
		mob.reagents.add_reagent(/datum/reagent/drug/happiness, 10)

/datum/symptom/spawn
	name = "Arachnogenesis Effect"
	desc = "Converts the infected's stomach to begin producing creatures of the arachnid variety."
	stage = 4
	badness = EFFECT_DANGER_HARMFUL
	var/spawn_type= /mob/living/basic/spider/growing/spiderling/guard
	var/spawn_name="spiderling"

/datum/symptom/spawn/activate(mob/living/carbon/mob)
	playsound(mob.loc, 'sound/effects/splat.ogg', 50, 1)

	new spawn_type(get_turf(mob))
	mob.emote("me",1,"vomits up a live [spawn_name]!")

/datum/symptom/spawn/roach
	name = "Blattogenesis Effect"
	desc = "Converts the infected's stomach to begin producing creatures of the blattid variety."
	stage = 4
	badness = EFFECT_DANGER_HINDRANCE
	spawn_type=/mob/living/basic/cockroach
	spawn_name="cockroach"

/datum/symptom/gregarious
	name = "Gregarious Impetus"
	desc = "Infests the social structures of the infected's brain, causing them to feel better in crowds of other potential victims, and punishing them for being alone."
	stage = 4
	badness = EFFECT_DANGER_HINDRANCE
	max_chance = 25
	max_multiplier = 4

/datum/symptom/gregarious/activate(mob/living/carbon/mob)
	var/others_count = 0
	for(var/mob/living/carbon/m in oview(5, mob))
		others_count += 1

	if (others_count >= multiplier)
		to_chat(mob, span_notice("A friendly sensation is satisfied with how many are near you - for now."))
		mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, -multiplier)
		mob.reagents.add_reagent(/datum/reagent/drug/happiness, multiplier) // ADDICTED TO HAVING FRIENDS
		if (multiplier < max_multiplier)
			multiplier += 0.15 // The virus gets greedier
	else
		to_chat(mob, span_warning("A hostile sensation in your brain stings you... it wants more of the living near you."))
		mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, multiplier / 2)
		mob.AdjustParalyzed(multiplier) // This practically permaparalyzes you at higher multipliers but
		mob.AdjustKnockdown(multiplier) // that's your fucking fault for not being near enough people
		mob.AdjustStun(multiplier)   // You'll have to wait until the multiplier gets low enough
		if (multiplier > 1)
			multiplier -= 0.3 // The virus tempers expectations

/datum/symptom/magnitis
	name = "Magnitis"
	desc = "This disease disrupts the magnetic field of the body, making it act as if a powerful magnet."
	stage = 4
	badness = EFFECT_DANGER_HARMFUL
	chance = 5
	max_chance = 20

/datum/symptom/magnitis/activate(mob/living/carbon/mob)
	if(mob.reagents.has_reagent(/datum/reagent/iron))
		return

	var/intensity = 1 + (count > 10) + (count > 20)
	if (prob(20))
		to_chat(mob, "<span class='warning'>You feel a [intensity < 3 ? "slight" : "powerful"] shock course through your body.</span>")
	for(var/obj/M in orange(3 * intensity,mob))
		if(!M.anchored)
			var/iter = rand(1,intensity)
			for(var/i=0,i<iter,i++)
				step_towards(M,mob)
	for(var/mob/living/silicon/S in orange(3 * intensity,mob))
		if(istype(S, /mob/living/silicon/ai))
			continue
		var/iter = rand(1,intensity)
		for(var/i=0,i<iter,i++)
			step_towards(S,mob)

/datum/symptom/dnaspread
	name = "Retrotransposis"
	desc = "This symptom transplants the genetic code of the intial vector into new hosts."
	badness = EFFECT_DANGER_HARMFUL
	stage = 4
	var/datum/dna/saved_dna
	var/original_name
	var/activated = 0

/datum/symptom/dnaspread/activate(mob/living/carbon/mob)
	if(!activated)
		to_chat(mob, "<span class='warning'>You don't feel like yourself..</span>")
	if(!iscarbon(mob))
		return
	var/mob/living/carbon/C = mob
	if(!saved_dna)
		saved_dna = new
		original_name = C.real_name
		C.dna.copy_dna(saved_dna)
	C.regenerate_icons()
	saved_dna.copy_dna(C.dna)
	C.real_name = original_name
	activated = TRUE

/datum/symptom/dnaspread/deactivate(mob/living/carbon/mob)
	activated = FALSE

/datum/symptom/dnaspread/Copy(datum/disease/advanced/disease)
	var/datum/symptom/dnaspread/new_e = ..(disease)
	new_e.original_name = original_name
	new_e.saved_dna = saved_dna
	return new_e

/datum/symptom/species
	name = "Lizarditis"
	desc = "Turns you into a Lizard."
	badness = EFFECT_DANGER_HARMFUL
	stage = 4
	var/datum/species/old_species
	var/datum/species/new_species = /datum/species/lizard
	max_count = 1
	max_chance = 24

/datum/symptom/species/activate(mob/living/carbon/mob)
	var/mob/living/carbon/human/H = mob
	if(!ishuman(H))
		return
	old_species = mob.dna.species
	if(!old_species)
		return
	H.set_species(new_species)

/datum/symptom/species/deactivate(mob/living/carbon/mob)
	var/mob/living/carbon/human/H = mob
	if(!ishuman(H))
		return
	if(!old_species)
		return
	H.set_species(old_species)

/datum/symptom/species/moth
	name = "Mothification"
	desc = "Turns you into a Moth."
	new_species = /datum/species/moth
