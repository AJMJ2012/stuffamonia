Class Pand_MysticSword : PandInsWeapon
{
    Default
    {
        Weapon.BobStyle "Smooth";
        Weapon.SlotNumber 3;
        Weapon.SlotPriority 3;
        Weapon.AmmoType "Pand_InsMana";
        Weapon.AmmoUse 5;
        Weapon.AmmoGive 0;
        PandInsWeapon.CapacityIncrease 5;
        PandInsWeapon.MagazineSize 15;
        PandInsWeapon.MagicAmmoRegenDelay 5;
        +WEAPON.AMMO_OPTIONAL;
        +WEAPON.NOALERT;
        +PANDINSWEAPON.MAGICWEAPON;
        Weapon.UpSound "Weapon/Draw";
        Inventory.PickupSound "Wand/Pickup";
        Tag "Mystic Sword";
        Inventory.PickupMessage "You got the \cfMystic Sword\c-!";
        PandInsWeapon.MenuPic "WFRSB0";
    }

    override string Pand_WeaponInfo()
    {
let minfo =
"It's a sword that throws magic, also acts like a melee weapon.
            
Magic weapons require a \c[z6]Magitech\c- Augment in order to accept other augment types. These types of weapons do not accept \c[j8]Superior\c- Augments, however they can be given extra abilities through the rare \c[b1]Amulets of Power\c-...";
return minfo;
    }

    States
	{
        Spawn:
            WFRS A -1;
            Stop;

        Ready:
            FSRD AAAABBBBCCCC 1 Bright Offset(0, 32) A_WeaponReady;
            Loop;

        Deselect:
            TNT1 A 0 A_StartSound("Weapon/Putaway");
            FSRD AAAABBBBCCCC 1 Bright A_Lower(12);
            Wait;

        Select:
            FSRD AAAABBBBCCCC 1 Bright A_Raise(12);
            Wait;

        Fire:
            TNT1 A 0
            {
                Pand_ManaCooldown();
                A_AlertMonsters();
            }
            FSRD DE 3 Bright Offset (5, 36);
            FSRD F 2 Bright Offset (5, 36) { A_StartSound("mysticsword/fire", 7); FireMysticSword((0, 24, 16)); }
            FSRD G 3 Bright Offset (5, 36) FireMysticSword((0, 16, 8));
            FSRD H 2 Bright Offset (5, 36) FireMysticSword((0, 0, 0));
            FSRD I 2 Bright Offset (5, 36) FireMysticSword((0, -16, -8));
            FSRD I 10 Bright Offset (5, 150) FireMysticSword((0, -24, -16));
            FSRD A 1 Bright Offset (5, 60);
            FSRD B 1 Bright Offset (5, 55);
            FSRD C 1 Bright Offset (5, 50);
            FSRD A 1 Bright Offset (5, 45);
            FSRD B 1 Bright Offset (5, 40) A_OverlayFlags(PSP_WEAPON, PSPF_INTERPOLATE, false);
            Goto Ready;
	}

    action void FireMysticSword(Vector3 voffset)
    {
        A_OverlayFlags(PSP_WEAPON, PSPF_INTERPOLATE, true);
        A_Saw("","",PandDmg(50),"SawPuff",SF_NORANDOM|SF_NOPULLIN|SF_NOTURN|SF_NOUSEAMMO);
        if(invoker.magCount <= 0 && CountInv(invoker.ammoType1) < invoker.ammoUse1) return;
        A_GunFlash();
        if(HasAmulet())
        {
            Pand_FireProjectile("InsSoulSpearProjectilePowered",3,offset:voffset,flags:ZPF_DontUseAmmo);
        }
        else
        {
            Pand_FireProjectile("InsMysticSwordProjectile",4,offset:voffset,flags:ZPF_DontUseAmmo);
        }
        Pand_MagicAmmoUse(1);
    }
}

Class InsMysticSwordProjectile : PandInsProjectile
{
    Default
    {
        Radius 8;
        Height 8;
        Speed 50;
        DamageFunction 10;
        Renderstyle "Add";
        PandInsProjectile.FXColor "Blue";
        PandProjectile.ParticleColors "E8FAFE", "72DCF8", "32B3EE", "1746C1";
        Damagetype "Magic";
        Decal "BaronScorch";
        PandProjectile.FireSound "Wand/Fire";
        DeathSound "weapons/plasmax";
    }
    States
    {
        Spawn:
            SWPR AABB 1 Bright Light("PLASMABALL") 
                {
                A_SpawnItemEx("PlasmaBallTrail",frandom(-1,1),frandom(-1,1),frandom(-1,1),frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
                for(user_fx = 0;user_fx<=3;user_fx++)
                    A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(7,15),frandom(6,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,2),frandom(-1,1),frandom(-1,1),0,0,0,1,-1,-1);
                }
                Loop;
        Death:
            TNT1 A 0 
                {
                for(user_fx = 0;user_fx<=30;user_fx++)
                    A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-1.2);
                }
            SWPR CDEFG 3 Bright Light("PLASMA_X1");
            Stop;
    }
}
