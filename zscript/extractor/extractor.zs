Class InsAugmentExtractorEx : InsAugmentExtractor replaces InsAugmentExtractor
{
    enum EXTRACTOR_VERSIONS
    {
        AUGMENT_EXTRACTOR,  // extracts augments, destroys weapon(orange)
        AUGMENT_REMOVER,    // removes augments, keeps weapon(white)
        AUGMENT_RECYCLER,   // extracts augments, returns weapon(blue)
        AUGMENT_ROULETTE,   // gamble weapon/augments for random weapon/augments(Rainbow)
        AUGMENT_TRASHER     // destroys augments and weapon (red)
    }

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

    int vers;
    Array<string> weps;
    int used_count;
    int show_timer;
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

    States
    {
        Spawn:
            TNT1 A 1 NoDelay
            {
                vers = Random(0,4);
                switch(vers)
                {
                    case AUGMENT_EXTRACTOR:
                        SetStateLabel("Spawn_Extractor");
                        break;
                    case AUGMENT_REMOVER:
						if (Random(0,1) == 0) // Needs to be more rare
							SetStateLabel("Spawn_Remover");
                        break;
                    case AUGMENT_RECYCLER:
						if (Random(0,2) == 0) // Needs to be more rare
							SetStateLabel("Spawn_Recycler");
                        break;
                    case AUGMENT_ROULETTE:
						//SetStateLabel("Spawn_Roulette"); // Needs Reworking
                        break;
                    case AUGMENT_TRASHER:
                        //SetStateLabel("Spawn_Trasher"); // Sick of this joke
                        break;
                }
            }
            Loop;

        /////////////////////////
        // Augment Trasher
        /////////////////////////
        Spawn_Trasher:
            EXTC J 10;
            Loop;

        WatchForWeapon_Trasher:
            EXTC JJLLJJLLJJLLJJLLJJLL 10 WatchForWeapon('ChompGunAndAugs');
            TNT1 A 0 TurnOff();
            Goto Spawn_Trasher;

        ChompGunAndAugs:
            EXTC K 60 ChompGun();
            TNT1 A 0 TurnOff();
            Goto Spawn_Trasher;

        /////////////////////////
        // Augment Extractor
        /////////////////////////
        Spawn_Extractor:
            EXTC A 10;
            Loop;

        WatchForWeapon_Extractor:
            EXTC AACCAACCAACCAACCAACC 10 WatchForWeapon('ChompGun');
            TNT1 A 0 TurnOff();
            Goto Spawn_Extractor;

        ChompGun:
            EXTC B 60 ChompGun();
            EXTC C 20 SpitAugs();
            TNT1 A 0 TurnOff();
            Goto Spawn_Extractor;

        /////////////////////////
        // Augment Remover
        /////////////////////////
        Spawn_Remover:
            EXTC D 10;
            Loop;

        WatchForWeapon_Remover:
            EXTC DDFFDDFFDDFFDDFFDDFF 10 WatchForWeapon('ChompAugs');
            TNT1 A 0 TurnOff();
            Goto Spawn_Remover;

        ChompAugs:
            EXTC E 60 ChompGun();
            EXTC F 20 SpitGun();
            TNT1 A 0 TurnOff();
            Goto Spawn_Remover;

        /////////////////////////
        // Augment Recycler
        /////////////////////////
        Spawn_Recycler:
            EXTC G 10;
            Loop;

        WatchForWeapon_Recycler:
            EXTC GGIIGGIIGGIIGGIIGGII 10 WatchForWeapon('NoChomp');
            TNT1 A 0 TurnOff();
            Goto Spawn_Recycler;

        NoChomp:
            EXTC H 60 ChompGun();
            EXTC I 20 SpitBoth();
            TNT1 A 0 TurnOff();
            Goto Spawn_Recycler;

        /////////////////////////
        // Augment Roulette
        /////////////////////////
        Spawn_Roulette:
            EXTC M 10;
            Loop;

        WatchForWeapon_Roulette:
            EXTC MMOOMMOOMMOOMMOOMMOO 10 WatchForWeapon('ChompShow');
            TNT1 A 0 TurnOff();
            Goto Spawn_Trader;

        ChompShow:
            EXTC N 0 ChompGun();
            EXTC N 1 FancyVisualShow_Start();
        DoShow:
            EXTC ADGJM 1 FancyVisualShow();
            Loop;

        SetRandomAugs:
            EXTC O 20 SpitRandom();
            TNT1 A 0 TurnOff();
            Goto Spawn_Roulette;
    }

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        // taken from mystery box code
        for(int i = 0; i < AllActorClasses.Size(); i++)
        {
            let wep = (class<PandInsWeapon>)(AllActorClasses[i]);
            if(wep is "PandInsWeapon" && !(wep is "Pand_Fist") && wep.GetClassName() != "PandInsWeapon")
            {
                weps.Push(AllActorClasses[i].GetClassName());
            }
        }
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
		gun_aug_arc = gun.aug_arc; // Arcane Remnantns cannot be removed, but they are kept when a weapon is cleaned.

        gun.Destroy();
        A_StartSound("Armor/Salvage");
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
        gun.aug_arc = gun_aug_arc; // Arcane Remnantns cannot be removed, but they are kept when a weapon is cleaned.
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
        let choice = weps[random(0,weps.Size()-1)];
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
            SpawnDingy(AugmentList[random(0,AugmentList.Size()-1)]);
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
            switch(vers)
            {
                case AUGMENT_TRASHER:
                    PandHUDMessageHandler.PlainMsg(user.PlayerNumber(),"CONFONT","Drop a weapon with augments to destroy augments and weapon.",(240,130),(480,360),0,time:(0.2,5.0,0.2));
                    break;
                case AUGMENT_EXTRACTOR:
                    PandHUDMessageHandler.PlainMsg(user.PlayerNumber(),"CONFONT","Drop a weapon with augments to extract augments.\nThis will destroy the weapon!",(240,130),(480,360),0,time:(0.2,5.0,0.2));
                    break;
                case AUGMENT_REMOVER:
                    PandHUDMessageHandler.PlainMsg(user.PlayerNumber(),"CONFONT","Drop a weapon with augments to remove augments\nThis will destroy all the weapon's augments!",(240,130),(480,360),0,time:(0.2,5.0,0.2));
                    break;
                case AUGMENT_RECYCLER:
                    PandHUDMessageHandler.PlainMsg(user.PlayerNumber(),"CONFONT","Drop a weapon with augments to extract augments and recycle weapon.\nAugments and weapon are not lost.",(240,130),(480,360),0,time:(0.2,5.0,0.2));
                    break;
                case AUGMENT_ROULETTE:
                    PandHUDMessageHandler.PlainMsg(user.PlayerNumber(),"CONFONT","Drop a weapon to receive a random weapon with random augments.\nHas limited uses based on player count.",(240,130),(480,360),0,time:(0.2,5.0,0.2));
                    break;
            }
            A_StartSound("ArmorKit/Pickup",pitch:0.8);
            beingused = true;
            leuser = user;
            A_Face(user);
            switch(vers)
            {
                case AUGMENT_TRASHER:
                    SetStateLabel("WatchForWeapon_Trasher");
                    break;
                case AUGMENT_EXTRACTOR:
                    SetStateLabel("WatchForWeapon_Extractor");
                    break;
                case AUGMENT_REMOVER:
                    SetStateLabel("WatchForWeapon_Remover");
                    break;
                case AUGMENT_RECYCLER:
                    SetStateLabel("WatchForWeapon_Recycler");
                    break;
                case AUGMENT_ROULETTE:
                    SetStateLabel("WatchForWeapon_Roulette");
                    break;
            }
            return true;
        }
    	return false;
    }
}
