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
	    for(int i = 0;i<AllActorClasses.Size();i++)
		{
            let wep = (class<PandInsWeapon>)(AllActorClasses[i]);
            if(wep is "PandInsWeapon" && !(wep is "Pand_Fist") && wep.GetClassName() != "PandInsWeapon")
            {
                weapon_list.Push(AllActorClasses[i].GetClassName());
            }
		}
    }

    // chose a random weapon from the weapon list
    string ChooseRandomWeapon()
    {
        return weapon_list[random(0,weapon_list.Size()-1)];
    }

    // chose a random augment from the augment list
    Name ChooseRandomAugment()
    {
        return AugmentList[random(0,AugmentList.Size()-1)];
    }

    Actor TID_Find(int tid)
    {
        if(tid > 0)
        {
            foreach(a : level.CreateActorIterator(tid))
            {
                if(a)
                {
                    return a;
                }
            }
        }
        return null;
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
    override void OnRegister()
    {
        globals = Stuffamonia_Globals.Get();
        globals.GatherWeaponList();
    }
}
