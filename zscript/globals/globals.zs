Class Stuffamonia_Globals : Thinker
{
    // every extractor had these when they spawned
    // lets save some resources by making these global
    Array<string> weapon_list;
    static const name AugmentList[] =
    {
        "StrengthAugment",
        "HasteAugment",
        "PrecisionAugment",
        "CapacityAugment",
        "BlastAugment",
        "ChaosAugment",
        "FlameAugment",
        "ScavengeAugment",
        "AugmentFormatter",
        "SuperiorAugment"
    };
    void GatherWeaponList()
    {
        // taken from mystery box code
        for(int i = 0; i < AllActorClasses.Size(); i++)
        {
            let wep = (class<PandInsWeapon>)(AllActorClasses[i]);
            if(wep is "PandInsWeapon" && !(wep is "Pand_Fist") && wep.GetClassName() != "PandInsWeapon")
            {
                weapon_list.Push(AllActorClasses[i].GetClassName());
            }
        }
    }

    string ChooseRandomWeapon()
    {
        return weapon_list[random(0,weapon_list.Size()-1)];
    }

    Name ChooseRandomAugment()
    {
        return AugmentList[random(0,AugmentList.Size()-1)];
    }

    string RandomWeighted(array<string> items)
    {

        return "";
    }

    // zscript boilerplate stuff
    static Stuffamonia_Globals Get()
    {
        ThinkerIterator it = ThinkerIterator.Create('Stuffamonia_Globals', STAT_STATIC);
        Stuffamonia_Globals p = Stuffamonia_Globals(it.Next());
        if (!p)
        {
            p = new("Stuffamonia_Globals");
            p.ChangeStatNum(STAT_STATIC);
        }
        return p;
    }
}

class Stuffamonia_Events : EventHandler
{
    Stuffamonia_Globals globals;
    override void NewGame()
    {
        globals = Stuffamonia_Globals.Get();
        globals.GatherWeaponList();
    }
}
