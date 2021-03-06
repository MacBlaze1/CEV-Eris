//Procedures in this file: Inernal wound patching, Implant removal, Hardsuit removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////


/datum/surgery_step/fix_vein
	priority = 2
	requedQuality = QUALITY_CLAMPING
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

/datum/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected) return
	var/internal_bleeding = 0
	for(var/datum/wound/W in affected.wounds) if(W.internal)
		internal_bleeding = 1
		break

	return affected.open == (affected.encased ? 3 : 2) && internal_bleeding

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool].",
		"You start patching the damaged vein in [target]'s [affected.name] with \the [tool]."
	)
	target.custom_pain("The pain in [affected.name] is unbearable!",1)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"\blue [user] has patched the damaged vein in [target]'s [affected.name] with \the [tool].",
		"\blue You have patched the damaged vein in [target]'s [affected.name] with \the [tool]."
	)

	for(var/datum/wound/W in affected.wounds) if(W.internal)
		affected.wounds -= W
		affected.update_damages()
	if (ishuman(user) && prob(40)) user:bloody_hands(target, 0)

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"\red [user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!",
		"\red Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"
	)
	affected.take_damage(5, 0)

/datum/surgery_step/fix_dead_tissue		//Debridement
	priority = 2
	requedQuality = QUALITY_CLAMPING

	can_infect = 1
	blood_level = 1

	min_duration = 110
	max_duration = 160

/datum/surgery_step/fix_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0

	if (target_zone == BP_MOUTH || target_zone == BP_EYES)
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected && affected.open >= 2 && (affected.status & ORGAN_DEAD)

/datum/surgery_step/fix_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].",
		"You start cutting away necrotic tissue in [target]'s [affected.name] with \the [tool]."
	)
	target.custom_pain("The pain in [affected.name] is unbearable!",1)
	..()

/datum/surgery_step/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"\blue [user] has cut away necrotic tissue in [target]'s [affected.name] with \the [tool].",
		"\blue You have cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."
	)
	affected.status &= ~ORGAN_DEAD
	playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

/datum/surgery_step/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"\red [user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!",
		"\red Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"
	)
	affected.createwound(CUT, 20, 1)

/datum/surgery_step/treat_necrosis
	priority = 2
	allowed_tools = list(
		/obj/item/weapon/reagent_containers/dropper = 100,
		/obj/item/weapon/reagent_containers/glass/bottle = 75,
		/obj/item/weapon/reagent_containers/glass/beaker = 75,
		/obj/item/weapon/reagent_containers/spray = 50,
		/obj/item/weapon/reagent_containers/glass/bucket = 50,
		/obj/item/weapon/reagent_containers = 35,
	)

	can_infect = 0
	blood_level = 0

	min_duration = 50
	max_duration = 60

/datum/surgery_step/treat_necrosis/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!istype(tool, /obj/item/weapon/reagent_containers))
		return 0

	var/obj/item/weapon/reagent_containers/container = tool
	if(!container.reagents.has_reagent("peridaxon"))
		return 0

	if(!hasorgans(target))
		return 0

	if (target_zone == BP_MOUTH || target_zone == BP_EYES)
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == 3 && (affected.status & ORGAN_DEAD)

/datum/surgery_step/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]." , \
		"You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]."
	)
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!",1)
	..()

/datum/surgery_step/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/weapon/reagent_containers))
		return

	var/obj/item/weapon/reagent_containers/container = tool

	//technically it's contact, but the reagents are being applied to internal tissue
	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)
	if (trans > 0)

		if(container.reagents.has_reagent("peridaxon"))
			affected.status &= ~ORGAN_DEAD

		user.visible_message(
			"\blue [user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name]",
			"\blue You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."
		)

/datum/surgery_step/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/weapon/reagent_containers))
		return

	var/obj/item/weapon/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message(
		"\red [user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!",
		"\red Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"
	)

		//no damage or anything, just wastes medicine

/datum/surgery_step/hardsuit
	requedQuality = QUALITY_WELDING

	can_infect = 0
	blood_level = 0

	min_duration = 120
	max_duration = 180
/datum/surgery_step/hardsuit/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target))
		return 0
	return (target_zone == BP_CHEST) && istype(target.back, /obj/item/weapon/rig) && !(target.back.canremove)

/datum/surgery_step/hardsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts cutting through the support systems of [target]'s [target.back] with \the [tool]." ,
		"You start cutting through the support systems of [target]'s [target.back] with \the [tool]."
	)
	..()

/datum/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/obj/item/weapon/rig/rig = target.back
	if(!istype(rig))
		return
	rig.reset()
	user.visible_message(
		SPAN_NOTICE("[user] has cut through the support systems of [target]'s [rig] with \the [tool]."),
		SPAN_NOTICE("You have cut through the support systems of [target]'s [rig] with \the [tool].")
	)

/datum/surgery_step/hardsuit/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_DANGER("[user]'s [tool] can't quite seem to get through the metal..."),
		SPAN_DANGER("Your [tool] can't quite seem to get through the metal. It's weakening, though - try again.")
	)
