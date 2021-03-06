/obj/item/weapon/material/hatchet/tacknife/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	desc = "A mechanical blade deployed from your arm. The favourite hidden weapon of many criminal types."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "armblade"
	applies_material_colour = 0

/obj/item/organ_module/active/simple/armblade
	name = "embedded armblade"
	desc = "A mechanical blade designed to be inserted into an arm. Gives you a nice advantage in a brawl."
	verb_name = "Deploy armblade"
	icon_state = "armblade"
	matter = list(MATERIAL_STEEL = 16)
	allowed_organs = list(BP_R_ARM, BP_L_ARM)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade



/obj/item/weapon/material/hatchet/tacknife/armblade/claws
	icon_state = "wolverine"
	name = "claws"
	desc = "A set of claws deployed from the tips of your fingers. Great for cutting people into ribbons."

/obj/item/organ_module/active/simple/wolverine
	name = "embedded claws"
	desc = "A variant on the popular armblade, these claws allow for a more traditional unarmed brawl style while still mantaining your advantage."
	verb_name = "Deploy embedded claws"
	icon_state = "wolverine"
	allowed_organs = list(BP_R_ARM, BP_L_ARM)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade/claws

