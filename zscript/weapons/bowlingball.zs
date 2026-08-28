

/*
    Normal:
        Strength: Ball knocks enemies further
        Haste: Ball speed increased
        Precision: Bigger ball
        Capacity: Cannot be used

    Conversion:
        Blast: Make the ball slightly explode on each hit and bounce
        Chaos: Make the ball spawn chaos projectiles per hit and bounce
        Flame: Makes the ball drop flames as it rolls
        Scavange: Cannot be used
        Superior: Causes the bowling ball to slightly home in on random targets

    // Magic:
        Magitech: Cannot be used
        Remnants: Cannot be used
*/

Class Pand_BowlingBall : PandInsWeapon
{
    int yoffset;
    int anim_state;

	Default
    {
        +WEAPON.WIMPY_WEAPON;
        +WEAPON.MELEEWEAPON;
        +PANDINSWEAPON.NOCAPACITYAUGMENT;
        +PANDINSWEAPON.NOSCAVENGEAUGMENT;
        PandInsWeapon.MaxAugments 3;
        Weapon.SlotNumber 1;
		Weapon.SlotPriority 0;
        Tag "Melee";
        Scale 0.2;

	}

	override string Pand_WeaponInfo()
	{
		return "One of the \cfBowling Ball\c- from the UAC bowling alley that mysteriously disappeared after use.
Stuns enemies.
It cannot be augmented.";
	}

  States
  {
        Ready:
            BOWL A 1 A_WeaponReady;
            Loop;
        Deselect:
            BOWL A 1 A_Lower(16);
            Wait;
        Select:
            BOWL A 0 A_OverlayFlags(PSP_WEAPON, PSPF_PLAYERTRANSLATED, true);
            BOWL A 1 A_Raise(16);
            Wait;
        Fire:
            BOWL A 1
            {
                switch(invoker.anim_state)
                {
                    case 0:
                        invoker.yoffset += 6;
                        if(invoker.yoffset > 100) { invoker.anim_state = 1; }
                        break;

                    case 1:
                        A_FireProjectile("BowlingBall", 0, true, 0, 0, FPF_TRANSFERTRANSLATION);
                        invoker.anim_state = 2;
                        break;

                    case 2:
                        A_SelectWeapon("", SWF_SELECTPRIORITY);
                        invoker.anim_state = 0;
                        TakeInventory("Pand_BowlingBall", 999);
                        break;
                }
                A_OverlayOffset(PSP_WEAPON, 0, 32+invoker.yoffset, WOF_INTERPOLATE);
            }
            Loop;
        Spawn:
            BBAL A -1;
            Stop;
  }
}

Class BowlingBall : Actor
{
    Default
    {
        Radius 24;
		Height 24;
        Scale 0.2;
        Speed 20;
        Damage 1;
        DamageType "BowlingBall";
        SeeSound "weapons/bowlingball/start";
        BounceSound "weapons/bowlingball/start";
        BounceType "Hexen";
        BounceFactor 0.0;
        +MISSILE;
        +RIPPER;
        +NOEXPLODEFLOOR;
        +FORCEPAIN;
        +FORCEZERORADIUSDMG;
        +CAUSEPAIN;
        +BOUNCEAUTOOFF;
        +BOUNCEONWALLS;
        -BOUNCEONFLOORS;
        +BOUNCEONCEILINGS;
    }

    States
    {
        Spawn:
            BBAL AA 0 A_StartSound("weapons/bowlingball/active", 4, CHANF_LOOP);
        Spawn2:
            BBAL ABCDEFGH 3;
            Loop;
    }
    override void Tick()
    {
        Super.Tick();
        vel *= 0.99;
        if(vel.LengthSquared() <= 0.05)
        {
            let wep = Spawn("Pand_BowlingBall", pos);
            wep.translation = translation;
            Destroy();
        }
    }
}

class BowlingBallManager : EventHandler
{
    Array<Actor> HitList;
    int hitlist_counter;

    override void WorldLoaded (WorldEvent e)
    {
        HitList.Resize(1024);
    }

    override void WorldThingDamaged (WorldEvent e)
    {
        if(e.DamageType == "BowlingBall")
        {
            hitlist_counter++;
            if(hitlist_counter >= 1024)
            {
                hitlist_counter = 0;
            }
            HitList[hitlist_counter] = e.Thing;
            e.Thing.vel.z = 10;
            e.Thing.vel.x = frandom(-10, 10);
            e.Thing.vel.y = frandom(-10, 10);
            e.Thing.tics = -1;
            e.Thing.freezetics = 0;
            e.Thing.SetOrigin((e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z+10), true);
            e.Thing.bROLLSPRITE = true;
            e.Thing.bROLLCENTER = true;
            e.Thing.A_StartSound("Bowling/Pin");
        }
    }

    override void WorldTick()
    {
        for(int i = 0; i <= hitlist_counter; i++)
        {
            if(HitList[i])
            {
                if(HitList[i].tics == -1 && HitList[i].pos.z != HitList[i].floorz)
                {
                    HitList[i].roll += 15;
                }

                if(HitList[i].pos.z == HitList[i].floorz && HitList[i].tics == -1)
                {
                    HitList[i].roll = 0;
                    HitList[i].tics = -2;
                    HitList[i].freezetics = 35*10;
                }

                if(HitList[i].freezetics == 0 && HitList[i].tics == -2)
                {
                    HitList[i].tics = 0;
                }
            }
        }
    }
}
    