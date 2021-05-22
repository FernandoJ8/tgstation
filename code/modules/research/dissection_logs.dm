
/obj/item/dissection_log
	name = "dissection log"
	desc = "A log that describes the proceedings and findings of a dissection. It has been performed on nothing."
	if(item_flags.Find(DISS_MONKEY))
		desc = "A log that describes the proceedings and findings of a dissection. It has been performed on a monkey"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "dissection_log"
	var/dissected_species = FALSE

/obj/item/dissection_log/Initialize(mapload,obj_flags ,dissected_species)
	. = ..()

/obj/item/dissection_log/adv
	name = "Advanced dissection log"
	desc = "A detailed log that thoroughly describes the proceedings and findings of a dissection."
	icon_state = "dissection_log_adv"

/obj/item/dissection_log/exp
	name = "Experimental dissection log"
	desc = "A very detailed log that describes the questionable proceedings and findings of an experimental dissection."
	icon_state = "dissection_log_exp"

/obj/item/dissection_log/alien
	name = "Extraterrestrial dissection log"
	desc = "An otherwordly log that describes the incomprehensibly complex procedings and findings of an alien dissection."
	icon_state = "dissection_log_alien"
