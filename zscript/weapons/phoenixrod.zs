Class Pand_PhoenixRod : PandInsWeapon
{
	Default
	{
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 3;
		Weapon.AmmoType "Pand_InsMana";
		Weapon.AmmoUse 40;
		Weapon.AmmoGive 0;
		PandInsWeapon.CapacityIncrease 2;
		PandInsWeapon.MagazineSize 4;
		PandInsWeapon.MagicAmmoRegenDelay 5;
		+WEAPON.AMMO_OPTIONAL;
		+PANDINSWEAPON.MAGICWEAPON;
		Weapon.UpSound "Weapon/Draw";
		Inventory.PickupSound "Wand/Pickup";
		Tag "PhoenixRod";
		Inventory.PickupMessage "You got the \cfPhoenixRod\c-!";
        PandInsWeapon.MenuPic "WPHXB0";
	}

	override string Pand_WeaponInfo()
	{
let minfo =
"Insert Description Here
			
Magic weapons require a \c[z6]Magitech\c- Augment in order to accept other augment types. These types of weapons do not accept \c[j8]Superior\c- Augments, however they can be given extra abilities through the rare \c[b1]Amulets of Power\c-...";
return minfo;
	}

	States
	{
		Spawn:
			WPHX A -1;
			Stop;
		Ready:
			PHNX A 1 A_WeaponReady;
			Loop;
		Deselect:
			TNT1 A 0 A_StartSound("Weapon/Putaway");
			PHNX A 1 A_Lower(12);
			Wait;
		Select:
			PHNX A 1 A_Raise(12);
			Wait;
		NoAmmo:
			PHNX A 10 A_StartSound("Weapon/Empty2");
			Goto Ready;
		Fire:
			PHNX A 0 
			{
				if(invoker.magCount <= 0 && CountInv(invoker.ammoType1) < invoker.ammoUse1) SetWeaponState("NoAmmo");
				Pand_ManaCooldown();
			}
			PHNX A 6
			{
				if(HasAmulet())
					A_StartSound("PhoenixRod/ShootPowered", slot: CHAN_WEAPON, flags: CHANF_OVERLAP);
				else
					A_StartSound("PhoenixRod/Shoot", slot: CHAN_WEAPON, flags: CHANF_OVERLAP);
			}
			PHNX B 4;
			PHNX C 2 Offset(0, 48)
			{
				A_GunFlash();
				A_WeaponQuake(6,12);
				A_PandWeaponOffset();
				if(HasAmulet())
					Pand_FireProjectile("InsPhoenixShotPowered",2,flags:ZPF_DontUseAmmo);
				else
					Pand_FireProjectile("InsPhoenixShot",2,flags:ZPF_DontUseAmmo);
				Pand_MagicAmmoUse(1);
			}
			PHNX C 2 Offset(0, 56);
			PHNX D 2 Offset(0, 52);
			PHNX D 2 Offset(0, 48);
			PHNX B 2 Offset(0, 44);
			PHNX B 2 Offset(0, 40);
			PHNX A 2 Offset(0, 36);
			PHNX A 2 Offset(0, 32);
			PHNX A 0 A_ReFire;
			Goto Ready;
	}

	action void FirePhoenixRod()
	{
		if(invoker.magCount <= 0 && CountInv(invoker.ammoType1) < invoker.ammoUse1) return;

	}
}

Class InsPhoenixShot : PandInsProjectile
{
	Default
	{
		Radius 11;
		Height 8;
		Speed 20;
		DamageFunction 80;
		Damagetype "Magic";
		PandProjectile.ParticleColors "FFFF8C", "FF5A10", "FFE74E", "FFAF31";
		+EXTREMEDEATH;
		+PANDINSPROJECTILE.EXPLOSIVE;
		Decal "BigScorch";
		RenderStyle "Add";
		DeathSound "PhoenixRod/Hit";
	}
	States
	{
		Spawn:
			FX04 A 1 Bright Light("DiabloistFlare1") 
			{
				A_StartSound("PhoenixRod/Fly", slot: CHAN_6, flags: CHANF_LOOPING, volume: 0.5);
				Spawn("RocketSmokeTrail2", Pos, ALLOW_REPLACE);
				for(user_fx = 0;user_fx<=3;user_fx++)
					A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(7,15),frandom(6,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,2),frandom(-1,1),frandom(-1,1),0,0,0,1,-1,-1);
			}
			Loop;
		Death:
			TNT1 A 0 A_StartSound("MiniMissile/Explode", slot: CHAN_7);
			TNT1 A 0 
			{
				A_StopSound(CHAN_6);
				bFORCEXYBILLBOARD = true;
				A_QuakeEx(4,4,4,12,0,900,0,QF_SCALEDOWN,0,0,0,300);
				bEXTREMEDEATH = false;
				A_InsSetScale(1.0);
				A_InsExplode(128,128,1,0,30);
				for(user_fx = 0;user_fx<=70;user_fx++)
					A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(20,30),frandom(5,10),frandom(0,360),frandom(0,20),0,frandom(-20,20),frandom(0,8),0,frandom(-8,8),-0.1,0,-0.05,1,-1,-0.2);
			}
			XPL0 ABCDEF 1 Bright Light("ROCKET_X1");
			XPL0 GHIJKL 1 Bright Light("ROCKET_X2");
			XPL0 MNOPQR 1 Bright Light("ROCKET_X3") A_FadeOut;
			Stop;
	}
}

Class InsPhoenixShotPowered : InsPhoenixShot
{
	Default
	{
		Speed 30;
		+SEEKERMISSILE;
		DeathSound "PhoenixRod/HitPowered";
	}
	States
	{
		Spawn:
			CFFX N 1 Bright Light("DiabloistFlare1") 
			{
				A_StartSound("PhoenixRod/Fly", slot: CHAN_6, flags: CHANF_LOOPING, volume: 0.5);
				for(int i=-1;i<=1;i+=2) {
					Actor puff = Spawn("RocketSmokeTrail2", Pos, ALLOW_REPLACE);
					if (puff != null)
					{
						puff.Vel.XY = AngleToVector(Angle + (90 * i), 1.3);
						puff.angle = angle;
					}
				}
				for(user_fx = 0;user_fx<=3;user_fx++)
					A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(7,15),frandom(6,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,2),frandom(-1,1),frandom(-1,1),0,0,0,1,-1,-1);

				A_SeekerMissile(2,20,SMF_LOOK|SMF_CURSPEED);
				for(int i=-1;i<=1;i+=2) {
					Actor puff = Spawn("InsPhoenixShotPoweredTrail", Pos, ALLOW_REPLACE);
					if (puff != null)
					{
						puff.Vel.XY = AngleToVector(Angle + (90 * i), 1.3);
						puff.angle = angle;
					}
				}
			}
			Loop;
		Death:
			TNT1 A 0 
			{
				A_SpawnItemEx("InsPhoenixShotPoweredFX", flags: SXF_NOCHECKPOSITION);
				A_StartSound("PhoenixRod/ExplodePowered", slot: CHAN_7);
			}
			Goto Super::Death+1;
	}
}

Class InsPhoenixShotPoweredTrail : Actor
{
	Default
	{
		+NOINTERACTION;
		RenderStyle "Add";
	}

	States
	{
		Spawn:
			FX09 ABCDEF 2 NoDelay;
			Stop;
	}
}

Class InsPhoenixShotPoweredFX : Actor
{
	Default
	{
		+NOINTERACTION;
		+FORCEYBILLBOARD;
		+NOTIMEFREEZE;
		RenderStyle "Add";
		Scale 0.5;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		A_ChangeVelocity(0, 0, 1, CVF_REPLACE);
	}

	override void Tick()
	{
		Super.Tick();
		A_SetScale(Scale.X + 0.05);
	}

	States
	{
		Spawn:
			PHFX A 8 NoDelay;
			PHFX ABCDEFGHIJKLMNOP 2;
			Stop;
	}
}

// Alternatives
/*
Class InsPhoenixShotPoweredFXAlt : InsPhoenixShotPoweredFX
{
	bool startFade;
	States
	{
		Spawn:
			PHFX A 1
			{
				A_SetScale(Scale.X + 0.025);
				if (GetAge() > 17.5)
				{
					if (!startFade)
					{
						Actor a = Spawn("InsPhoenixShotPoweredFXAlt2", pos, ALLOW_REPLACE);
						a.Scale = Scale;
						startFade = true;
					}
					A_FadeOut(1.0 / 17.5);
				}
			}
			Loop;
	}
}

Class InsPhoenixShotPoweredFXAlt2 : InsPhoenixShotPoweredFX
{
	Default
	{
		Alpha 0;
	}
	States
	{
		Spawn:
			PHFX B 1
			{
				if (GetAge() > 17.5)
				{
					A_FadeOut(1.0 / 17.5);
				}
				else
				{
					A_FadeIn(1.0 / 17.5);
				}
			}
			Loop;
	}
}
*/