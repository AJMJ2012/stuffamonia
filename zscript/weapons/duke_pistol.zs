
Class Duke_Weapon : PandInsWeapon {} // this is just an identifier to ID duke specific weapons for class buffs
Class Duke_Pistol : Duke_Weapon
{
    double duke_accuracy;
    Default
    {
        Weapon.BobStyle "Smooth";
        Weapon.SlotNumber 2;
        Weapon.SlotPriority 0;
        Weapon.AmmoType "NewClip";
        Weapon.AmmoUse 0;
        Weapon.AmmoGive 20;
        Decal "BulletChip";
        Tag "Glock 17";
        +WEAPON.WIMPY_WEAPON;
        Inventory.PickupMessage "You got the \cfGlock 17\c-!";
        Inventory.PickupSound "Pistol/Pickup";
        Weapon.UpSound "Weapon/Draw";
        PandInsWeapon.SuperiorString "is now the \cfGolden Glock 17\c-\nNow instantly reloads";
        PandInsWeapon.MagazineSize 12;
        PandInsWeapon.CapacityIncrease 2;
        PandInsWeapon.MenuPic "DUK1Z0";
    }

    override string Pand_WeaponInfo()
    {
        return "The \cfGlock 17\c-, Duke's pistol of choice.
        The \c[j8]Superior\c- augment basicly turns it into a tiny assult rifle with no reload.";
    }

    States
    {
		Ready:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"Ready_Gold");
			DUK1 A 1 A_WeaponReady;
			Loop;

        Deselect:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"Deselect_Gold");
            DUK1 A 0 A_StartSound("Weapon/Putaway");
            DUK1 A 1 A_Lower(14);
            Wait;

        Select:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"Select_Gold");
            DUK1 A 1 A_Raise(12);
            Loop;

        Fire:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"Fire_Gold");
			DUK1 B 0
            {
                if(invoker.magCount <= 0 && CountInv(invoker.AmmoType1))
                {
                    SetWeaponState("Reload");
                    return;
                }
                else if(invoker.magCount <= 0 && !CountInv(invoker.AmmoType1))
                {
                    SetWeaponState("NoAmmo");
                    return;
                }
                invoker.WasPressed(BT_ATTACK);
                A_StartSound("Duke/Pistol/Fire", CHAN_WEAPON);
                A_AlertMonsters();
                A_WeaponQuake(2,2);
                A_FireProjectile("DukePistolCasingSpawner",0,0,2,4);
                A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);

                // original duke pistol did 6 + random(0, 5) damage, but that feels weak here
                // flame augments have inverted and much different offset ranges than tracers do
                if(invoker.aug_flm)
                {
                    Pand_FireHitscan(2.5, 12, tracerType:"BulletTracer", Offset: (0, 8, 0), flags:ZHF_DontUseAmmo);
                }
                else
                {
                    Pand_FireHitscan(2.5, 12, tracerType:"BulletTracer", Offset: (0, -4, 0), flags:ZHF_DontUseAmmo);
                }

                Pand_TakeAmmo(1,true);
            }
            DUK1 B 1;
            DUK1 C 1 A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);
            DUK1 A 1
            {
                A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);
            }
            DUK1 A 3;
            DUK1 A 0 A_ReFire;
			Goto Ready;

        Reload:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"Reload_Gold");
			DUK1 D 0
            {
                A_StartSound("Duke/Pistol/Insert", CHAN_AUTO);
                A_StartSound("Duke/Pistol/Eject", CHAN_AUTO);
                A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);
                A_Overlay(-3, "ClipFall");
                A_Overlay(-4, "ClipInsert");
            }
            DUK1 D 1 A_OverlayOffset(1, 0, 32-0, WOF_INTERPOLATE);
            DUK1 D 1 A_OverlayOffset(1, 15, 32-20, WOF_INTERPOLATE);
            DUK1 E 1 A_OverlayOffset(1, 25, 32-35, WOF_INTERPOLATE);
            DUK1 E 1 A_OverlayOffset(1, 30, 32-45, WOF_INTERPOLATE);
            DUK1 E 20 A_OverlayOffset(1, 30, 32-45, WOF_INTERPOLATE);
            DUK1 E 1 A_OverlayOffset(1, 28, 32-43, WOF_INTERPOLATE);
            DUK1 E 1 A_OverlayOffset(1, 25, 32-41, WOF_INTERPOLATE);
            DUK1 D 1 A_OverlayOffset(1, 15, 32-20, WOF_INTERPOLATE);
            DUK1 D 1 A_OverlayOffset(1, 0, 32-0, WOF_INTERPOLATE);
            DUK1 D 0 Pand_Reload(12);
			Goto Ready;

        ClipFall:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"ClipFall_Gold");
            DUK1 F 5 A_OverlayOffset(-3, 0, 0);
            DUK1 FFFFFFFFF 1
            {
                A_OverlayOffset(-3, -8, 15, WOF_ADD|WOF_INTERPOLATE);
            }
            Stop;

        ClipInsert:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"ClipInsert_Gold");
            DUK1 G 15 A_OverlayOffset(-4, -72, 135);
            DUK1 GGGGGGGG 1
            {
                A_OverlayOffset(-4, 8, -15, WOF_ADD|WOF_INTERPOLATE);
            }
            DUK1 H 4;
            DUK1 HH 1
            {
                A_OverlayOffset(-4, -8, 15, WOF_ADD|WOF_INTERPOLATE);
            }
            Stop;

        NoAmmo:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"NoAmmo_Gold");
            DUK1 A 10 A_StartSound("Weapon/Empty");
            Goto Ready;

        Spawn:
            DUK1 A 0 A_JumpIf(invoker.aug_sup,"Spawn_Gold");
            DUK1 Z -1;
            Stop;

        ////////////////////////////////////////
        // Golden Version
        ////////////////////////////////////////

		Ready_Gold:
			DUK1 I 1 A_WeaponReady;
			Loop;

        Deselect_Gold:
            DUK1 I 0 A_StartSound("Weapon/Putaway");
            DUK1 I 1 A_Lower(14);
            Wait;

        Select_Gold:
            DUK1 I 1 A_Raise(12);
            Loop;

        Fire_Gold:
			DUK1 J 0
            {
                if(invoker.magCount <= 0 && CountInv(invoker.AmmoType1))
                {
                    Pand_Reload(12);
                }
                if(invoker.magCount <= 0 && !CountInv(invoker.AmmoType1))
                {
                    SetWeaponState("NoAmmo_Gold");
                    return;
                }

                invoker.WasPressed(BT_ATTACK);
                A_StartSound("Duke/Pistol/Fire", CHAN_WEAPON);
                A_AlertMonsters();
                A_WeaponQuake(2,2);
                A_FireProjectile("DukePistolCasingSpawner",0,0,2,4);
                A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);

                // original duke pistol did 6 + random(0, 5) damage, but that feels weak here
                // flame augments have inverted and much different offset ranges than tracers do
                
                if(invoker.aug_flm)
                {
                    Pand_FireHitscan(2.5, 12, tracerType:"BulletTracer", Offset: (0, 8, 0), flags:ZHF_DontUseAmmo);
                }
                else
                {
                    Pand_FireHitscan(2.5, 12, tracerType:"BulletTracer", Offset: (0, -4, 0), flags:ZHF_DontUseAmmo);
                }
                Pand_TakeAmmo(1,true);
            }
            DUK1 J 1;
            DUK1 K 1 A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);
            DUK1 I 1
            {
                A_OverlayOffset(1, 0, 32, WOF_INTERPOLATE);
            }
            DUK1 I 3;
            DUK1 I 0 A_ReFire;
			Goto Ready_Gold;

        Reload_Gold:
            DUK1 L 0;
			Goto Ready_Gold;

        NoAmmo_Gold:
            DUK1 I 10 A_StartSound("Weapon/Empty");
            Goto Ready_Gold;

        Spawn_Gold:
            DUK1 Y -1;
            Stop;
    }

    override void DoEffect()
	{
        if(!gotsupped && aug_sup)
		{
            SetTag("Golden Glock 17");
            gotsupped = true;
		}
        Super.DoEffect();
	}
}

Class DukePistolCasingSpawner : PistolCasingSpawner
{
    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 1 A_SpawnProjectile("BulletCasing",0,10,random(100,80),2,random(0,45));
            Stop;
    }
}

