
// i know i should be doing this in acs, but the script editor in udb is a mess in linux
// and slade doesnt want to compile anything, so screw it im doing it all here
// but it also means i have more access to things like all the weapons classes and properties and stuff
// so thats nice i guess
class DevMapEvents : EventHandler
{
    Stuffamonia_Globals globals;
    PandGlobalVariables globals_pand;

    array<PandInsWeapon> spawned_weapons;
    array<PandBasicArmorPickup> spawned_armors;

    override void OnRegister()
    {
        globals = Stuffamonia_Globals.Get();
        globals_pand = PandGlobalVariables.Get();
    }

    override void WorldLoaded(WorldEvent e)
    {
        if(level.MapName == "stuff_dev")
        {
            Actor.Spawn("TriAugmentExtractor", globals.TID_Find(31).pos);
            Actor.Spawn("TriAugmentRemover", globals.TID_Find(32).pos);
            Actor.Spawn("TriAugmentRecycler", globals.TID_Find(33).pos);
            Actor.Spawn("TriAugmentRoulette", globals.TID_Find(34).pos);
            Actor.Spawn("TriAugmentTrasher", globals.TID_Find(35).pos);
            level.ChangeSky(TexMan.CheckForTexture("PANDSKY2"), TexMan.CheckForTexture("PANDSKY2"));
        }
    }

    override void WorldLineActivated(WorldEvent e)
    {
        if(level.MapName == "stuff_dev")
        {
            // this just seemed easier than using a tag iterator
            // line needs some kind of special to active, so highjack thrust thing with no force,
            // the more i go, the more cursed this gets lol
            if(e.ActivatedLine.special == 72)
            {
                switch(e.ActivatedLine.args[0])
                {
                    // weapon slot numbers
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                        // destroy any weapons that were previously spawned
                        foreach(weapon : spawned_weapons)
                        {
                            // also dont destroy any of the weapons the player has picked up
                            if(weapon && !weapon.owner)
                            {
                                weapon.Destroy();
                            }
                        }
                        spawned_weapons.Clear();

                        // go through the global weapon list and spawn the weapons in the requested slot
                        int tag_start = 2;
                        foreach(weapon : globals.weapon_list)
                        {
                            if(weapon)
                            {
                                class<Weapon> wep_class = weapon;
                                if(GetDefaultByType(wep_class).SlotNumber == e.ActivatedLine.args[0])
                                {
                                    let wep = PandInsWeapon(Actor.Spawn(weapon, globals.TID_Find(tag_start).pos));
                                    spawned_weapons.Push(wep);
                                    tag_start++;
                                }
                            }
                        }
                        break;

                    // augment giver buttons
                    case 10: e.Thing.GiveInventory("BlastAugment", 1);      e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 11: e.Thing.GiveInventory("ChaosAugment", 1);      e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 12: e.Thing.GiveInventory("StrengthAugment", 1);   e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 13: e.Thing.GiveInventory("HasteAugment", 1);      e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 14: e.Thing.GiveInventory("AugmentFormatter", 1);  e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 15: e.Thing.GiveInventory("SuperiorAugment", 1);   e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 16: e.Thing.GiveInventory("FlameAugment", 1);      e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 17: e.Thing.GiveInventory("ScavengeAugment", 1);   e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 18: e.Thing.GiveInventory("CapacityAugment", 1);   e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 19: e.Thing.GiveInventory("PrecisionAugment", 1);  e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 20: e.Thing.GiveInventory("ArcaneRemnant", 1);     e.thing.GiveInventory("AugmentCarryToken",1); break;
                    case 21: e.Thing.GiveInventory("MagitechAugment", 1);   e.thing.GiveInventory("AugmentCarryToken",1); break;

                    // reset weapon button
                    case 22:
                        if(e.Thing.player && e.Thing.player.ReadyWeapon)
                        {
                            let wep = PandInsWeapon(e.Thing.player.ReadyWeapon);
                            wep.conversionaug = "null";
                            wep.curaugs = 0;
                            wep.aug_str = 0;
                            wep.aug_prs = 0;
                            wep.aug_hst = 0;
                            wep.aug_cap = 0;
                            wep.aug_bls = 0;
                            wep.aug_chs = 0;
                            wep.aug_flm = 0;
                            wep.aug_scv = 0;
                            wep.aug_sup = 0;
                            wep.aug_moreaugs = 0;
                            wep.aug_arc = 0;
                            wep.aug_mag = 0;
                            wep.gotsupped = false;

                            class<PandInsWeapon> wep_class = wep.GetClassName();
                            wep.maxaugs         = GetDefaultByType(wep_class).maxaugs;
                            wep.magCount        = GetDefaultByType(wep_class).magCount;
                            wep.magSize         = GetDefaultByType(wep_class).magSize;
                            wep.dmax            = GetDefaultByType(wep_class).dmax;
                            wep.dwep            = GetDefaultByType(wep_class).dwep;
                            wep.dbroken         = GetDefaultByType(wep_class).dbroken;
                            wep.durability      = GetDefaultByType(wep_class).durability;
                            wep.offsetrngx      = GetDefaultByType(wep_class).offsetrngx;
                            wep.offsetrngy      = GetDefaultByType(wep_class).offsetrngy;
                            wep.scalerng        = GetDefaultByType(wep_class).scalerng;
                            wep.capincrease     = GetDefaultByType(wep_class).capincrease;
                            wep.duraincrease    = GetDefaultByType(wep_class).duraincrease;
                            wep.wepbar          = GetDefaultByType(wep_class).wepbar;
                            wep.wepbarmax       = GetDefaultByType(wep_class).wepbarmax;
                            wep.ammouse1        = GetDefaultByType(wep_class).ammouse1;
                            wep.ammouse2        = GetDefaultByType(wep_class).ammouse2;
                        }

                    // clear augment inventory button
                    case 23:
                        e.Thing.TakeInventory("BlastAugment", 999);
                        e.Thing.TakeInventory("ChaosAugment", 999);
                        e.Thing.TakeInventory("StrengthAugment", 999);
                        e.Thing.TakeInventory("HasteAugment", 999);
                        e.Thing.TakeInventory("AugmentFormatter", 999);
                        e.Thing.TakeInventory("SuperiorAugment", 999);
                        e.Thing.TakeInventory("FlameAugment", 999);
                        e.Thing.TakeInventory("ScavengeAugment", 999);
                        e.Thing.TakeInventory("CapacityAugment", 999);
                        e.Thing.TakeInventory("PrecisionAugment", 999);
                        e.Thing.TakeInventory("ArcaneRemnant", 999);
                        e.Thing.TakeInventory("MagitechAugment", 999);
                        e.thing.TakeInventory("AugmentCarryToken",999);
                        break;

                    // game level buttons
                    case 24: if(globals_pand) { globals_pand.GameLevel -= 100; } break;
                    case 25: if(globals_pand) { globals_pand.GameLevel -= 10; } break;
                    case 26: if(globals_pand) { globals_pand.GameLevel -= 1; } break;
                    case 27: if(globals_pand) { globals_pand.GameLevel = 0; } break;
                    case 28: if(globals_pand) { globals_pand.GameLevel += 1; } break;
                    case 29: if(globals_pand) { globals_pand.GameLevel += 10; } break;
                    case 30: if(globals_pand) { globals_pand.GameLevel += 100; } break;

                    // reset armors button
                    case 31:
                        // destroy any armors that were previously spawned
                        foreach(armor : spawned_armors)
                        {
                            if(armor)
                            {
                                armor.Destroy();
                            }
                        }
                        spawned_armors.Clear();

                        // go through the global armor list and spawn all the armors
                        int tag_start2 = 39;
                        foreach(armor : globals.armor_list)
                        {
                            if(armor)
                            {
                                spawned_armors.Push(PandBasicArmorPickup(Actor.Spawn(armor, globals.TID_Find(tag_start2).pos)));
                                tag_start2++;
                            }
                        }
                        break;
                }
            }
        }
    }
}