// Based on Final Doomer's Hellbound Totenheim
// Light version that uses the HE Rocket rather than a nuke

Class Pand_Totenheim : PandInsWeapon Replaces BigRocketDrop
{
	const AmmoRequirement = 10;

	Default
	{
		+PANDINSWEAPON.NOMAGCAPACITY;
		+PANDINSWEAPON.NOSUPERIORAUGMENT; // For Now
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You got the \cfTotenheim\c-!";
		Inventory.PickupSound "HERocket/Pickup";
		Obituary "%k felt a small explosion wasn't good enough for %o.";
		PandInsWeapon.MagazineSize 1;
		PandInsWeapon.MaxAugments 3;
		PandInsWeapon.MenuPic "HBFGZ0";
		Tag "Totenheim";
		Weapon.AmmoGive 20;
		Weapon.AmmoType "NewRocketAmmo";
		Weapon.AmmoUse 0;
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 7;
		Weapon.SlotPriority -1;
		Weapon.UpSound "HERocket/Up";
	}

	override string Pand_WeaponInfo()
	{
		return "The \cfTotenheim\c- is as heavy portable high explosive warhead launcher. Due to it's bulky size it can only load one missile at a time. The missiles must be primed before firing thus adding a short delay.

		This weapon's missile causes a massive explosion on impact which can annihilate large crowds of demons. Because of this, you will want to be careful with self damage because you \c[w2]absolutely will\c- kill yourself if you don't use it correctly.

		No \c[j8]Superior\c- augment support right now.";
	}

	States
	{
		Spawn:
			HBFG Z -1;
			Loop;
		Ready:
			HBFG A 1
			{
				A_WeaponReady(WRF_ALLOWRELOAD);
				A_PlaySound("hellboundbfg9000/idle", 7, 0.4, 1, 1.4);
			}
			Loop;
		Select:
			HBFG A 1 A_Raise(12);
			Loop;
		Deselect:
			HBFG A 0 A_StopSound(7);
			HBFG A 1 A_Lower(12);
			Wait;
		NoAmmo:
			HBFG A 6 A_PlaySound("weapons/dryfire1", 5, 1, 0, 1.25);
			Goto Ready;
		Fire:
			HBFG A 0 EMPCheck();
			HBFG A 0
			{
				if(invoker.magCount == 0 && invoker.CountInv(invoker.AmmoType1) >= AmmoRequirement)
					SetWeaponState("Reload");
				else if(invoker.magCount == 0 && invoker.CountInv(invoker.AmmoType1) < AmmoRequirement)
					SetWeaponState("NoAmmo");
			}
			HBFG A 0
			{
				A_PlaySound("hellboundbfg9000/charge", 7, 1, 0, 0.8);
				A_AlertMonsters(random(256,400));
			}
			HBFG BCDEFGHI 2;
			HBFG A 1;
			HBFG A 0 A_GunFlash("Flash");
			HBFG S 3 Bright;
			HBFG A 0
			{
				Pand_TakeAmmo(1,true);
				A_Recoil(3);
				A_AlertMonsters();
				A_PlaySound("hellboundbfg9000/fire", CHAN_WEAPON, 1, 0, 0.8);
				A_PlaySound("hellboundbfg9000/firemain", 5, 1, 0, 1.2);
				A_Quake(6, 20, 0, 512, "");
				Pand_FireProjectile("InsHighExplosiveRocket", 2);
			}
			HBFG T 1 Bright A_SetPitch(pitch - 2.75);
			HBFG T 1 Bright A_SetPitch(pitch - 0.5);
			HBFG T 1 Bright A_SetPitch(pitch + 0.05);
			HBFG U 1 Bright A_SetPitch(pitch + 1.25);
			HBFG U 1 Bright A_SetPitch(pitch + 0.7);
			HBFG U 1 Bright A_SetPitch(pitch + 0.43);
			HBFG V 1 Bright A_SetPitch(pitch + 0.31);
			HBFG V 1 Bright A_SetPitch(pitch + 0.29);
			HBFG V 1 Bright A_SetPitch(pitch + 0.17);
			HBFG W 1 Bright A_SetPitch(pitch + 0.05);
			HBFG W 2;
			HBFG X 3;
			HBFG A 3;
			HBFG A 11 A_ReFire;
			Goto Ready;
		Reload:
			HBFG A 0 A_JumpIf(CountInv(invoker.AmmoType1) < AmmoRequirement || invoker.magCount >= invoker.magSize,"Ready");
			HBFG A 0 A_PlaySound("hellboundbfg9000/load", 5, 1, 0, 1.2);
			HBFG JKLMNOP 2;
			HBFG R 2
			{
				Pand_Reload2(AmmoRequirement);
			}
			HBFG A 4;
			Goto Ready;
		Flash:
			TNT1 A 3 A_Light2;
			TNT1 A 3 A_Light(5);
			TNT1 A 3 A_Light2;
			TNT1 A 3 A_Light1;
			TNT1 A 0 A_Light0;
			Goto LightDone;
	}
}