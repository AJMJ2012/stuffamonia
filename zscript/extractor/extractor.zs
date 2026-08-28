Class TriAugmentProcessor : InsAugmentExtractor replaces InsAugmentExtractor
{
    Name gunname;
    int gun_magCount;
    int gun_magSize;
    int gun_dmax;
    bool gun_dwep;
    bool gun_broken;
    int gun_durability;
    float gun_offsetrngx;
    float gun_offsetrngy;
    float gun_scalerng;
	int gun_aug_arc;

    int used_count;
    int show_timer;

    int proc_type;
    meta string proc_msg;

    Property Type: proc_type;
    Property Msg: proc_msg;

    Stuffamonia_Globals globals;
    override void BeginPlay()
    {
        Super.BeginPlay();
        globals = Stuffamonia_Globals.Get();

        // dont let the subclasses spawn anything, cause you know, inf loops and all that
        if(self.GetClassName() != "TriAugmentProcessor") { return; }

        let rand = WRandomString.Create();
        rand.Add("TriAugmentExtractor", tri_extractor_weight);
        rand.Add("TriAugmentRemover", tri_remover_weight);
        rand.Add("TriAugmentRecycler", tri_recycler_weight);
        rand.Add("TriAugmentRoulette", tri_roulette_weight);
        rand.Add("TriAugmentTrasher", tri_trasher_weight);
        Spawn(rand.Pick(), pos);
        Destroy();
    }

    void WatchForWeapon(StateLabel label)
    {
        let rad = 30;
        BlockThingsIterator it = BlockThingsIterator.Create(self, rad);
        Actor mo;
        while(it.Next())
        {
            mo = it.thing;
            if(!mo || Distance2D(mo) > rad)
            {
                continue;
            }
            if(PandInsWeapon(mo))
            {
                gun = PandInsWeapon(mo);
                break;
            }
        }
        if(gun)
        {
            SetStateLabel(label);
        }
    }

    void ChompGun()
    {
        for(int a = 0;a < gun.aug_str; a++) auglist.Push("StrengthAugment");
        for(int a = 0;a < gun.aug_prs; a++) auglist.Push("PrecisionAugment");
        for(int a = 0;a < gun.aug_hst; a++) auglist.Push("HasteAugment");
        for(int a = 0;a < gun.aug_cap; a++) auglist.Push("CapacityAugment");
        for(int a = 0;a < gun.aug_bls; a++) auglist.Push("BlastAugment");
        for(int a = 0;a < gun.aug_chs; a++) auglist.Push("ChaosAugment");
        for(int a = 0;a < gun.aug_flm; a++) auglist.Push("FlameAugment");
        for(int a = 0;a < gun.aug_scv; a++) auglist.Push("ScavengeAugment");
        augsup = gun.aug_sup;
        augfor = gun.aug_moreaugs;
        augmag = gun.aug_mag;
		
        gunname = gun.GetClassName();
        gun_magCount = gun.magCount;
        gun_magSize = gun.magSize;
        gun_dmax = gun.dmax;
        gun_dwep = gun.dwep;
        gun_broken = gun.dbroken;
        gun_durability = gun.durability;
        gun_offsetrngx = gun.offsetrngx;
        gun_offsetrngy = gun.offsetrngy;
        gun_scalerng = gun.scalerng;
		gun_aug_arc = gun.aug_arc; // Arcane Remnants cannot be removed, but they are kept when a weapon is cleaned.

        A_StartSound("Armor/Salvage");

        // if the player throws in a gun with no aug, dont trash the weapon
        // i've made this mistake before...
        if(auglist.Size() == 0 && augsup == 0 && augfor == 0 && augmag == 0) { return; }
        gun.Destroy();
    }

    void SpitAugs()
    {
        if(leuser)
        {
            A_Face(leuser);
        }
        for(int a = 0;a < auglist.Size();a++)
        {
            SpawnDingy(auglist[a]);
        }
        if(augsup)
        {
            SpawnDingy("SuperiorAugment");
        }
        if(augfor)
        {
            SpawnDingy("AugmentFormatter");
        }
        for(int a = 0;a < augfor-1;a++)
        {
            SpawnDingy("AugmentFormatter");
        }
        if(augmag)
        {
            SpawnDingy("MagitechAugment");
        }
        for(int a = 0;a < augmag-1;a++)
        {
            SpawnDingy("MagitechAugment");
        }
        A_StartSound("Extractor/Dispense");

        augsup = 0;
        augfor = 0;
        augmag = 0;
        auglist.Clear();
    }

    // insurrection's extractor spawn function, but returns the spawned object
    Actor SpawnDingy(string uhh)
    {
        let mysdrop = Spawn(uhh,(pos.x,pos.y,pos.z+30));
        mysdrop.Angle = Angle+frandom(-20,20);
        mysdrop.VelFromAngle(frandom(4,7));
        mysdrop.Vel.Z = frandom(1.0,1.8);
        mysdrop.bNoGravity = false;
        return mysdrop;
    }

    void SpitGun()
    {
        if(leuser)
        {
            A_Face(leuser);
        }
        let gun = PandInsWeapon(SpawnDingy(gunname));

        gun.dmax = gun_dmax;
        gun.dwep = gun_dwep;
        gun.dbroken = gun_broken;
        gun.durability = gun_durability;
        gun.offsetrngx = gun_offsetrngx;
        gun.offsetrngy = gun_offsetrngy;
        gun.scalerng = gun_scalerng;
        gun.aug_arc = gun_aug_arc;
    }

    void FancyVisualShow_Start()
    {
        show_timer = 0;
        A_StartSound("Ascension/MysteryBox");
    }

    void FancyVisualShow()
    {
        show_timer++;

        angle += 8;
        // spin 2 particles around the machine
        double x = cos((angle) * M_PI) * 32;
        double y = sin((angle) * M_PI) * 32;
        A_SpawnParticleEx(
            random(0, 0xFFFFFF),
            TexMan.CheckForTexture("SPKWA0"),
            style: STYLE_ADD,
			flags: SPF_FULLBRIGHT|SPF_RELATIVE|SPF_ROLL,
			lifetime: 35*1,
            size: frandom(16.0,20.0),
			xoff: x,
			yoff: y,
			velz: random(2,5)
            );

        x = cos((angle + 180) * M_PI) * 32;
        y = sin((angle + 180) * M_PI) * 32;
        A_SpawnParticleEx(
            random(0, 0xFFFFFF),
            TexMan.CheckForTexture("SPKWA0"),
            style: STYLE_ADD,
			flags: SPF_FULLBRIGHT|SPF_RELATIVE|SPF_ROLL,
			lifetime: 35*1,
            size: frandom(16.0,32.0),
			xoff: x,
			yoff: y,
			velz: random(2,5)
            );
        if(show_timer >= 160)
        {
            show_timer = 0;
            SetStateLabel("SetRandomAugs");
        }
    }

    void SpitRandom()
    {
        let choice = globals.ChooseRandomWeapon();
        SpawnDingy(choice);
        int rare_extra = random(0,100);
        int augsize = auglist.size();
        if(rare_extra == 0)
        {
            augsize -= 1;
            augsize *= 2;
        }
        let aug_amount = random(0, augsize);
        for(int a = 0; a < aug_amount; a++)
        {
            SpawnDingy(globals.ChooseRandomAugment());
        }
        CheckUsedUp();
        A_StartSound("Extractor/Dispense");
    }

    void CheckUsedUp()
    {
        used_count++;
        int player_count = 0;
        for (int i = 0; i < MAXPLAYERS; ++i)
		{
		    if (playeringame[i])
			{
                player_count++;
            }
        }
        if(used_count >= player_count * 2)
        {
            A_StartSound("ArmorKit/Off",pitch:0.8);
            Destroy();
        }
    }

    void SpitBoth()
    {
        SpitAugs();
        SpitGun();
    }

    void TurnOff()
    {
        A_StartSound("ArmorKit/Off",pitch:0.8);
        beingused = false;
    }

    override bool Used(Actor user)
    {
        if(Distance3D(user) < 50 && !beingused)
        {
            PandHUDMessageHandler.PlainMsg(user.PlayerNumber(),"CONFONT", proc_msg, (240,130), (480,360), 0, time:(0.2,5.0,0.2));
            A_StartSound("ArmorKit/Pickup",pitch:0.8);
            beingused = true;
            leuser = user;
            A_Face(user);
            SetStateLabel("WatchForWeapon");
            return true;
        }
    	return false;
    }
}

// extracts augments, destroys weapon (orange)
class TriAugmentExtractor : TriAugmentProcessor
{
    Default
    {
        TriAugmentProcessor.Msg "Drop a weapon to extract augments.\nThis will destroy the weapon!";
    }
    States
    {
        Spawn:
            EXTC A 10;
            Loop;

        WatchForWeapon:
            EXTC AACCAACCAACCAACCAACC 10 WatchForWeapon('ChompGun');
            TNT1 A 0 TurnOff();
            Goto Spawn;

        ChompGun:
            EXTC B 60 ChompGun();
            EXTC C 20 SpitAugs();
            TNT1 A 0 TurnOff();
            Goto Spawn;
    }
}

// extracts augments, returns weapon(blue)
class TriAugmentRecycler : TriAugmentProcessor
{
    Default
    {
        TriAugmentProcessor.Msg "Drop a weapon to extract augments and recycle weapon.\nAugments and weapon are not lost.";
    }
    States
    {
        Spawn:
            EXTC G 10;
            Loop;

        WatchForWeapon:
            EXTC GGIIGGIIGGIIGGIIGGII 10 WatchForWeapon('NoChomp');
            TNT1 A 0 TurnOff();
            Goto Spawn;

        NoChomp:
            EXTC H 60 ChompGun();
            EXTC I 20 SpitBoth();
            TNT1 A 0 TurnOff();
            Goto Spawn;
    }
}

// removes augments, keeps weapon(white)
class TriAugmentRemover : TriAugmentProcessor
{
    Default
    {
        TriAugmentProcessor.Msg "Drop a weapon to remove augments\nThis will destroy all the weapon's augments!";
    }
    States
    {
        Spawn:
            EXTC D 10;
            Loop;

        WatchForWeapon:
            EXTC DDFFDDFFDDFFDDFFDDFF 10 WatchForWeapon('ChompAugs');
            TNT1 A 0 TurnOff();
            Goto Spawn;

        ChompAugs:
            EXTC E 60 ChompGun();
            EXTC F 20 SpitGun();
            TNT1 A 0 TurnOff();
            Goto Spawn;
    }
}

// gamble weapon/augments for random weapon/augments(Rainbow)
class TriAugmentRoulette : TriAugmentProcessor
{
    Default
    {
        TriAugmentProcessor.Msg "Drop a weapon to receive a random weapon with random augments.\nHas limited uses based on player count.";
    }
    States
    {
        Spawn:
            EXTC M 10;
            Loop;

        WatchForWeapon:
            EXTC MMOOMMOOMMOOMMOOMMOO 10 WatchForWeapon('ChompShow');
            TNT1 A 0 TurnOff();
            Goto Spawn;

        ChompShow:
            EXTC N 0 ChompGun();
            EXTC N 1 FancyVisualShow_Start();
        DoShow:
            EXTC ADGJM 1 FancyVisualShow();
            Loop;

        SetRandomAugs:
            EXTC O 20 SpitRandom();
            TNT1 A 0 TurnOff();
            Goto Spawn;
    }
}

// destroys augments and weapon (red) (darks clear favorite :D)
class TriAugmentTrasher : TriAugmentProcessor
{
    Default
    {
        TriAugmentProcessor.Msg "Drop a weapon to \c[Red]destroy\c[white] the weapon and it's augments!";
    }
    States
    {
        Spawn:
            EXTC J 10;
            Loop;

        WatchForWeapon:
            EXTC JJLLJJLLJJLLJJLLJJLL 10 WatchForWeapon('ChompGunAndAugs');
            TNT1 A 0 TurnOff();
            Goto Spawn;

        ChompGunAndAugs:
            EXTC K 60 ChompGun();
            TNT1 A 0 TurnOff();
            Goto Spawn;
    }
}