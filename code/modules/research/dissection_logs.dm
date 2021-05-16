
/obj/item/dissection_log
	name = "dissection log"
	desc = "A log that describes the proceedings and findings of a dissection."
	icon = bureaucracy.dmi
	icon_state = "dissection_log"
	var/dissected_species = FALSE

/obj/item/dissection_log/Initialize(mapload,dissection_type ,dissected_species)
	. = ..()

/obj/item/dissection_log/adv
	name = "Advanced dissection log"
	desc = "A detailed log that thoroughly describes the proceedings and findings of a dissection."
	icon_state += "_adv"

/obj/item/dissection_log/exp
	name = "Experimental dissection log"
	desc = "A very detailed log that describes the questionable proceedings and findings of an experimental dissection."
	icon_state += "_exp"

/obj/item/dissection_log/alien
	name = "Extraterrestrial dissection log"
	desc = "An otherwordly log that describes the incomprehensibly complex procedings and findings of an alien dissection."
	icon_state += "_alien"
