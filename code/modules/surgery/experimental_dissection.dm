
#define DISS_MONKEY 1
#define DISS_HUMAN 2
#define DISS_LIZARD 3
#define DISS_INSECT 4
#define DISS_SPECIAL 5

/datum/surgery/advanced/experimental_dissection
	name = "Dissection"
	desc = "A surgical procedure which analyzes the biology of a corpse and logs the results for scientific study."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/dissection,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living) //Feel free to dissect devils but they're magic.
	replaced_by = /datum/surgery/advanced/experimental_dissection/adv
	requires_tech = FALSE
	var/dissection_type = /obj/item/dissection_log
	var/findings = 1

/datum/surgery/advanced/experimental_dissection/can_start(mob/user, mob/living/target)
	. = ..()
	if(HAS_TRAIT_FROM(target, TRAIT_DISSECTED,"[name]"))
		to_chat(user, "<span class='warning'>This corpse has already been dissected and is unsable.</span>")
		return FALSE
	if(target.stat != DEAD)
		to_chat(user, "<span class='warning'>You can't dissect a living being!.</span>")
		return FALSE
/datum/surgery_step/dissection
	name = "dissection"
	implements = list(/obj/item/scalpel/augment = 75, /obj/item/scalpel/advanced = 60, TOOL_SCALPEL = 45, /obj/item/kitchen/knife = 20, /obj/item/shard = 10)// special tools not only cut down time but also improve probability
	time = 125
	silicons_obey_prob = TRUE
	repeatable = TRUE

/datum/surgery_step/dissection/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] starts dissecting [target].</span>", "<span class='notice'>You start dissecting [target].</span>")

/datum/surgery_step/dissection/proc/check_value(mob/living/target, datum/surgery/advanced/experimental_dissection/surgery)

	//determine bonus applied
	if(ismonkey(target))
		surgery.findings = DISS_MONKEY
	else if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H?.dna?.species)
			if(islizard(H))
				surgery.findings = DISS_LIZARD
			else if(isplasmaman(H) || isethereal(H))
				surgery.findings = DISS_SPECIAL
			else if(ismoth(H) || isflyperson(H))
				surgery.findings = DISS_INSECT
	else
		surgery.findings = DISS_HUMAN

/datum/surgery_step/dissection/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/advanced/experimental_dissection/surgery, default_display_results = FALSE)
	if (istype(surgery, /datum/surgery/advanced/experimental_dissection/))
		user.visible_message("<span class='notice'>[user] dissects [target] and logs a medical report", "<span class='notice'>You dissect [target] and log your findings.</span>")
		new surgery.dissection_type(user.loc, surgery.findings)
		var/obj/item/bodypart/L = target.get_bodypart(BODY_ZONE_CHEST)
		target.apply_damage(80, BRUTE, L)
		ADD_TRAIT(target, TRAIT_DISSECTED, "[surgery.name]")
		repeatable = FALSE
		return ..()

/datum/surgery_step/dissection/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] dissects [target]!</span>", "<span class='notice'>You attempt to dissect [target], but fail to make any breakthroughs.</span>")
	to_chat(user, "It looks like there's still something to uncover from dissecting [target].")
	var/obj/item/bodypart/L = target.get_bodypart(BODY_ZONE_CHEST)
	target.apply_damage(80, BRUTE, L)
	return TRUE

/datum/surgery/advanced/experimental_dissection/adv
	name = "Thorough Dissection"
	replaced_by = /datum/surgery/advanced/experimental_dissection/exp
	requires_tech = TRUE
	dissection_type = /obj/item/dissection_log/adv

/datum/surgery/advanced/experimental_dissection/exp
	name = "Experimental Dissection"
	replaced_by = /datum/surgery/advanced/experimental_dissection/alien
	requires_tech = TRUE
	dissection_type = /obj/item/dissection_log/exp

/datum/surgery/advanced/experimental_dissection/alien
	name = "Extraterrestrial Dissection"
	requires_tech = TRUE
	replaced_by = null
	dissection_type = /obj/item/dissection_log/alien
