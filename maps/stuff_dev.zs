// i know i should be doing this in acs, but the script editor in udb is a mess in linux
// and slade doesnt want to compile anything, so screw it im doing it all here
// but it also means i have more access to things like all the weapons classes and properties and stuff
// so thats nice i guess
class DevMapEvents : EventHandler
{
    const TAG_START = 1;

    // Thrust Thing line action, just used so switches actually click and change texture
    // i cant find a way to make switches work any other way in zscript :|
    const LINE_ACTION = 72;
    const BUTTON_WEAPONS = 0;
    const BUTTON_AUGMENTS = 1;
    const BUTTON_WEAPONRESET = 2;
    const BUTTON_CLEAR_AUGMENTS = 3;
    const BUTTON_GAMELEVEL = 4;
    const BUTTON_CLASS = 5;
    const BUTTON_CLEAR_WEAPONS = 6;
    const BUTTON_CLEAR_SPAWNED_ITEMS = 7;
    const BUTTON_SPAWN_EVERYTHING = 8;

    Stuffamonia_Globals globals;
    PandGlobalVariables globals_pand;

    array<Actor> spawned;

    static const name specific_health_items[] =
    {
        "NewMedikit",
        "NewStimpack"
    };

    static const name specific_inv_items[] =
    {
        "PandArmorCase",
        "ArmorReconstructionKit",
        "DistortionMark",
        "FieldKit",
        "InfernalWard",
        "WeaponSupplyKit",
        "ShoulderCannon",
        "ProvisionalVessel",
        "InsMysteryBox"
    };

    static const name specific_pups_items[] =
    {
        "AbyssalGuardsphere",
        "AbyssalRejuvenationSphere",
        "AbyssalVilesphere",
        "NewSoulSphere",
        "LifeSphere",
        "NewMegasphere",
        "SuperSphere",
        "NewBerserk",
        "NewBlurSphere",
        "Doomsphere",
        "DoubleDamageSphere",
        "PandLightGoggles",
        "GammaVisionGoggles",
        "NewInvulSphere",
        "PandAllMap",
        "PandMapScanner",
        "NewRadSuit",
        "ReincarnationSphere",
        "Salvationsphere",
        "ShieldSphere",
        "TerrorSphere",
        "InsAmuletOfPower"
    };

    void ChangeClass(Actor who)
    {
        who.TakeInventory("InsAlreadyGotClass", 0xFFFFFF);
        ClearPlayerAugments(who);
        ClearPlayerWeapons(who);
        ClearPlayerAmmo(who);
        EventHandler.SendNetworkEvent("Pand_OpenClassMenu");
    }

    void ChangeGameLevel(int amount)
    {
        if(globals_pand)
        {
            switch(amount)
            {
                case 0: globals_pand.GameLevel -= 100;  break;
                case 1: globals_pand.GameLevel -= 10;   break;
                case 2: globals_pand.GameLevel -= 1;    break;
                case 3: globals_pand.GameLevel = 0;     break;
                case 4: globals_pand.GameLevel += 1;    break;
                case 5: globals_pand.GameLevel += 10;   break;
                case 6: globals_pand.GameLevel += 100;  break;
            }
        }
    }

    void ClearSpawnedItems()
    {
        // destroy anything that was previously spawned
        foreach(weapon : spawned)
        {
            // also dont destroy anything the player has picked up
            if(weapon && !Inventory(weapon).owner)
            {
                weapon.Destroy();
            }
        }
        spawned.Clear();
    }

    void ClearPlayerWeapons(Actor who)
    {
        foreach(weapon : globals.weapon_list)
        {
            if(weapon)
            {
                who.TakeInventory(weapon, 0xFFFFFF);
            }
        }
    }

    void ClearPlayerAmmo(Actor who)
    {
	    for(int i = 0; i < AllActorClasses.Size(); i++)
		{
            let ammo = (class<Ammo>)(AllActorClasses[i]);
            if(ammo is "Ammo")
            {
                who.TakeInventory(AllActorClasses[i].GetClassName(), 0xFFFFFF);
            }
		}
    }

    void ClearPlayerInventory(Actor who)
    {
	    for(int i = 0;i < AllActorClasses.Size(); i++)
		{
            let item = (class<Inventory>)(AllActorClasses[i]);
            if(item is "Inventory")
            {
                who.TakeInventory(AllActorClasses[i].GetClassName(), 0xFFFFFF);
            }
		}
    }

    void ClearPlayerAugments(Actor who)
    {
        who.TakeInventory("BlastAugment", 0xFFFFFF);
        who.TakeInventory("ChaosAugment", 0xFFFFFF);
        who.TakeInventory("StrengthAugment", 0xFFFFFF);
        who.TakeInventory("HasteAugment", 0xFFFFFF);
        who.TakeInventory("AugmentFormatter", 0xFFFFFF);
        who.TakeInventory("SuperiorAugment", 0xFFFFFF);
        who.TakeInventory("FlameAugment", 0xFFFFFF);
        who.TakeInventory("ScavengeAugment", 0xFFFFFF);
        who.TakeInventory("CapacityAugment", 0xFFFFFF);
        who.TakeInventory("PrecisionAugment", 0xFFFFFF);
        who.TakeInventory("ArcaneRemnant", 0xFFFFFF);
        who.TakeInventory("MagitechAugment", 0xFFFFFF);
        who.TakeInventory("AugmentCarryToken",0xFFFFFF);
    }

    void SpawnEverything()
    {
        int tag = TAG_START;
        ClearSpawnedItems();

        // weapons
        foreach(weapon : globals.weapon_list)
        {
            if(weapon)
            {
                spawned.Push(Actor.Spawn(weapon, globals.TID_Find(tag).pos));
                tag++;
            }
        }

        // armor
        foreach(armor : globals.armor_list)
        {
            if(armor)
            {
                spawned.Push(Actor.Spawn(armor, globals.TID_Find(tag).pos));
                tag++;
            }
        }

        // ammo
	    for(int i = 0; i < AllActorClasses.Size(); i++)
		{
            let ammo = (class<Pand_Ammo>)(AllActorClasses[i]);
            if(ammo is "Pand_Ammo" && ammo.GetClassName() != "Pand_Ammo")
            {
                spawned.Push(Actor.Spawn(ammo, globals.TID_Find(tag).pos));
                tag++;
            }
		}
        spawned.Push(Actor.Spawn("Backpack", globals.TID_Find(tag).pos));
        tag++;

        // health
	    for(int i = 0; i < AllActorClasses.Size(); i++)
		{
            let hpbonus = (class<NewHealthBonus>)(AllActorClasses[i]);
            if(hpbonus is "NewHealthBonus")
            {
                spawned.Push(Actor.Spawn(hpbonus, globals.TID_Find(tag).pos));
                tag++;
            }
		}

        foreach(hpitem : specific_health_items)
        {
            spawned.Push(Actor.Spawn(hpitem, globals.TID_Find(tag).pos));
            tag++;
        }

        // runes
        for(int i = 0; i < AllActorClasses.Size(); i++)
		{
            let rune = (class<BaseRune>)(AllActorClasses[i]);
            if(rune is "BaseRune" && rune.GetClassName() != "BaseRune")
            {
                spawned.Push(Actor.Spawn(rune, globals.TID_Find(tag).pos));
                tag++;
            }
		}

        // inventory
        foreach(inv : specific_inv_items)
        {
            spawned.Push(Actor.Spawn(inv, globals.TID_Find(tag).pos));
            tag++;
        }

        // powerups
        foreach(pup : specific_pups_items)
        {
            spawned.Push(Actor.Spawn(pup, globals.TID_Find(tag).pos));
            tag++;
        }

        // augments
        for(int i = 0; i < AllActorClasses.Size(); i++)
		{
            let aug = (class<BaseAugment>)(AllActorClasses[i]);
            if(aug is "BaseAugment" && aug.GetClassName() != "BaseAugment")
            {
                spawned.Push(Actor.Spawn(aug, globals.TID_Find(tag).pos));
                tag++;
            }
		}


    }

    // go through the global weapon list and spawn the weapons in the requested slot
    void SpawnWeapons(int slot)
    {
        int tag = TAG_START;
        ClearSpawnedItems();
        foreach(weapon : globals.weapon_list)
        {
            if(weapon)
            {
                class<Weapon> wep_class = weapon;
                if(GetDefaultByType(wep_class).SlotNumber == slot)
                {
                    let wep = Actor.Spawn(weapon, globals.TID_Find(tag).pos);
                    spawned.Push(wep);
                    tag++;
                }
            }
        }
    }

    // go through the global armor list and spawn all the armors
    void SpawnArmors()
    {
        int tag = TAG_START;
        ClearSpawnedItems();
        foreach(armor : globals.armor_list)
        {
            if(armor)
            {
                spawned.Push(Actor.Spawn(armor, globals.TID_Find(tag).pos));
                tag++;
            }
        }
    }

    void GiveAugment(int type, Actor who)
    {
        switch(type)
        {
            case 0:     who.GiveInventory("BlastAugment", 1);       break;
            case 1:     who.GiveInventory("ChaosAugment", 1);       break;
            case 2:     who.GiveInventory("StrengthAugment", 1);    break;
            case 3:     who.GiveInventory("HasteAugment", 1);       break;
            case 4:     who.GiveInventory("AugmentFormatter", 1);   break;
            case 5:     who.GiveInventory("SuperiorAugment", 1);    break;
            case 6:     who.GiveInventory("FlameAugment", 1);       break;
            case 7:     who.GiveInventory("ScavengeAugment", 1);    break;
            case 8:     who.GiveInventory("CapacityAugment", 1);    break;
            case 9:     who.GiveInventory("PrecisionAugment", 1);   break;
            case 10:    who.GiveInventory("ArcaneRemnant", 1);     break;
            case 11:    who.GiveInventory("MagitechAugment", 1);   break;
        }
        who.GiveInventory("AugmentCarryToken",1);
    }

    void ResetWeapon(Actor who)
    {
        let plr = who.player;
        if(plr && plr.ReadyWeapon)
        {
            let wep = PandInsWeapon(plr.ReadyWeapon);
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
    }

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

    override void WorldLinePreActivated(WorldEvent e)
    {
        if(level.MapName == "stuff_dev")
        {
            // this just seemed easier than using a tag iterator
            // line needs some kind of special to active, so highjack thrust thing with no force,
            // the more i go, the more cursed this gets lol
            if(e.ActivatedLine.special == LINE_ACTION)
            {
                int special = e.ActivatedLine.args[0];
                int arg = e.ActivatedLine.args[4];
                Actor who = e.Thing;
                switch(special)
                {
                    case BUTTON_WEAPONS:                SpawnWeapons(arg);              break;
                    case BUTTON_AUGMENTS:               GiveAugment(arg, who);          break;
                    case BUTTON_WEAPONRESET:            ResetWeapon(who);               break;
                    case BUTTON_CLEAR_AUGMENTS:         ClearPlayerAugments(who);       break;
                    case BUTTON_GAMELEVEL:              ChangeGameLevel(arg);           break;
                    case BUTTON_CLEAR_WEAPONS:          ClearPlayerWeapons(who);        break;
                    case BUTTON_CLEAR_SPAWNED_ITEMS:    ClearSpawnedItems();            break;
                    case BUTTON_CLASS:                  ChangeClass(who);               break;
                    case BUTTON_SPAWN_EVERYTHING:       SpawnEverything();              break;
                }
            }
        }
    }
}