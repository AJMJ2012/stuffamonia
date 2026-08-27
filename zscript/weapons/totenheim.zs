// Based on Final Doomer's Hellbound Totenheim

Class Pand_Totenheim : PandInsWeapon Replaces BigRocketDrop
{
	Default
	{
		+PANDINSWEAPON.NOSUPERIORAUGMENT; // For Now
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You got the \cfTotenheim\c-!";
		Inventory.PickupSound "HERocket/Pickup";
		Obituary "%k felt a small explosion wasn't good enough for %o.";
		PandInsWeapon.MaxAugments 3;
		PandInsWeapon.MenuPic "HBFGZ0";
		Tag "Totenheim";
		Weapon.AmmoGive 20;
		Weapon.AmmoType "NewRocketAmmo";
		Weapon.AmmoUse 20;
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 7;
		Weapon.SlotPriority -1;
		Weapon.UpSound "HERocket/Up";
	}

	override string Pand_WeaponInfo()
	{
		return "The \cfTotenheim\c-. A portable nuclear missile weapon designed for one purpose: Extreme devastation.

		No \c[j8]Superior\c- augment support right now.";
	}

	override string Pand_WeaponInfo()
	{
		return "The \cfTotenheim\c- is as heavy portable nuclear warhead launcher with massive destructive potential. The missiles can only be loaded and primed during the firing sequence as it is otherwise too dangerous carry thus adding additonal delay.

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
				A_WeaponReady();
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
			HBFG A 0 A_JumpIfNoAmmo("NoAmmo");
			HBFG A 0
			{
				A_PlaySound("hellboundbfg9000/charge", 7, 1, 0, 0.8);
				A_AlertMonsters(random(256,400));
			}
			HBFG BCDEFGHI 2;
			HBFG A 1;
			HBFG A 0 A_PlaySound("hellboundbfg9000/load", 5, 1, 0, 1.2);
			HBFG JKLMNOPR 2;
			HBFG A 4;
			HBFG A 0 A_GunFlash("Flash");
			HBFG S 3 Bright;
			HBFG A 0
			{
				A_AlertMonsters();
				A_PlaySound("hellboundbfg9000/fire", CHAN_WEAPON, 1, 0, 0.8);
				A_PlaySound("hellboundbfg9000/firemain", 5, 1, 0, 1.2);
				A_Quake(6, 20, 0, 512, "");
				Pand_FireProjectile("FDHellboundTotenheimMissile", 3);
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
		Flash:
			TNT1 A 3 A_Light2;
			TNT1 A 3 A_Light(5);
			TNT1 A 3 A_Light2;
			TNT1 A 3 A_Light1;
			TNT1 A 0 A_Light0;
			Goto LightDone;
	}
}

Class FDHellboundTotenheimMissile : PandInsFastProjectile
{
	Default
	{
		+EXPLODEONWATER;
		+EXTREMEDEATH;
		+FORCEXYBILLBOARD;
		+PANDINSFASTPROJECTILE.EXPLOSIVE;
		+SKYEXPLODE;
		DamageFunction 500;
		DamageType "Explosive";
		Decal "TotenheimScorch";
		Height 12;
		MissileHeight 8;
		MissileType "FDHellboundTotenheimTrail";
		Projectile;
		Radius 9;
		SeeSound "hellboundbfg9000/fire";
		Speed 30;
	}

	States
	{
	Spawn:
		NKWH A 0 NoDelay A_PlaySound("hellboundbfg9000/loop", 7, 0.8, 1, 0.8);
		NKWH A 0 A_SpawnItemEx("FDHellboundTotenheimMissileFlare",0,0,0,0,0,0,0,SXF_SETMASTER|SXF_ORIGINATOR);
		NKWH A 1 Bright Light("FDRocketPulse");
		Wait;
	Death:
		TNT1 A 0 A_Explode(512, 512, XF_HURTSOURCE);
		TNT1 A 0
		{
			for(user_fx=0;user_fx<12;user_fx++)
				if (random(0,1) == 0)
					A_SpawnParticle("730000", SPF_FULLBRIGHT | SPF_RELATIVE, random(30,70), random(1,10), frandom(0,360), 0,0,0, frandom(0.2,12.0),frandom(-0.2,0.2),frandom(-6.0,6.0), 0,0,-0.1, 0.98, -1);
			for(user_fx=0;user_fx<23;user_fx++)
				if (random(0,1) == 0)
					A_SpawnParticle("ef0000", SPF_FULLBRIGHT | SPF_RELATIVE, random(25,60), random(1,10), frandom(0,360), 0,0,0, frandom(0.2,12.0),frandom(-0.2,0.2),frandom(-6.0,6.0), 0,0,-0.1, 0.98, -1);
			for(user_fx=0;user_fx<36;user_fx++)
				if (random(0,1) == 0)
					A_SpawnParticle("f37317", SPF_FULLBRIGHT | SPF_RELATIVE, random(20,50), random(1,10), frandom(0,360), 0,0,0, frandom(0.2,12.0),frandom(-0.2,0.2),frandom(-6.0,6.0), 0,0,-0.1, 0.98, -1);
			for(user_fx=0;user_fx<44;user_fx++)
				if (random(0,1) == 0)
					A_SpawnParticle("ffa35b", SPF_FULLBRIGHT | SPF_RELATIVE, random(15,40), random(1,10), frandom(0,360), 0,0,0, frandom(0.2,12.0),frandom(-0.2,0.2),frandom(-6.0,6.0), 0,0,-0.1, 0.98, -1);
			for(user_fx=0;user_fx<9;user_fx++)
				if (random(0,1) == 0)
					A_SpawnParticle("ffffff", SPF_FULLBRIGHT | SPF_RELATIVE, random(10,30), random(1,4), frandom(0,360), 0,0,0, frandom(0.2,12.0),frandom(-0.2,0.2),frandom(-6.0,6.0), 0,0,0, 0.98, -1);

			A_Quake(1, 48, 0, 2048, "");
			A_Quake(7, 32, 0, 1024, "");
			A_Quake(9, 24, 0, 768, "");

			A_KillChildren("Normal",KILS_KILLMISSILES);
			A_SetScale(7.0);
			A_SetTranslucent(0.98, 1);
			A_PlaySound("hellboundbfg9000/explosionmain", 5, 1, 0, 0.25);
			A_PlaySound("hellboundbfg9000/explosion", CHAN_WEAPON, 1, 0, 0.3);
			A_PlaySound("hellboundbfg9000/far", 7, 1, 0, 0.01);
			A_SpawnItemEx("FDHellboundTotenheimRadiationSpot", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
			A_SpawnItemEx("FDHellboundTotenheimExplosionFlare", 0,0,0, 0,0,0, 0, SXF_TRANSFERPOINTERS | SXF_NOCHECKPOSITION);
			A_SpawnItemEx("FDHellboundTotenheimBlaster", 0,0,0, 0,0,0, 0, SXF_TRANSFERPOINTERS | SXF_NOCHECKPOSITION);
			A_SpawnItemEx("FDHellboundTotenheimShroomer", 0,0,0, 0,0,0, 0, SXF_TRANSFERPOINTERS | SXF_NOCHECKPOSITION);
		}

		MEXP A 4 Bright Light("FDHellBoundTotenheimExplosion1");
		MEXP B 4 Bright Light("FDHellBoundTotenheimExplosion2");
		MEXP C 3 Bright Light("FDHellBoundTotenheimExplosion3");
		MEXP D 3 Bright Light("FDHellBoundTotenheimExplosion4");
		MEXP E 2 Bright Light("FDHellBoundTotenheimExplosion5");
		MEXP F 2 Bright Light("FDHellBoundTotenheimExplosion6");
		Stop;
	}
}

Class FDHellboundTotenheimMissileFlare : Actor
{
	Default
	{
		+NOINTERACTION;
		Alpha 0.5;
		Projectile;
		Renderstyle "Add";
		Scale 0.4;
	}
	States
	{
		Spawn:
			OGLO A 1 Bright A_Warp(AAPTR_MASTER,-24,0,0,0,WARPF_INTERPOLATE);
			Loop;
		Death:
			TNT1 A 0;
			Stop;
	}
}

Class FDHellboundTotenheimTrail : Actor
{
	Default
	{
		+NOINTERACTION;
	}
	States
	{
		Spawn:
			TNT1 A 0 NoDelay A_SpawnItemEx("FDHellboundTotenheimTrailSmoke", -28+frandom(3.0,-3.0),frandom(3.0,-3.0),2+frandom(3.0,-3.0), frandom(-0.4,0.4),frandom(-0.4,0.4),frandom(-0.2,0.5));
			TNT1 A 0 A_SpawnItemEx("FDHellboundTotenheimTrailEmber", -28,0,0);
			Stop;
	}
}

Class FDHellboundTotenheimTrailSmoke : Actor
{
	Default
	{
		+NOINTERACTION;
		Alpha 0.3;
		Renderstyle "Translucent";
		Scale 0.2;
	}
	States
	{
		Spawn:
			SMOK A 0 NoDelay A_SetScale(scalex*random(1,-1),scalex);
			SMOK ABCDEFGHIJKLMNOPQ 2 A_FadeOut(0.01);
			Stop;
	}
}

Class FDHellboundTotenheimTrailEmber : Actor
{
	Default
	{
		+NOINTERACTION;
		Renderstyle "Add";
		Scale 0.125;
	}
	States
	{
		Spawn:
			OGLO A 0 NoDelay A_ChangeVelocity(frandom(0.1,-0.1),frandom(0.1,-0.1),frandom(0.1,-0.1));
			OGLO A 1 Bright A_FadeOut(0.1);
			OGLO A 0 A_SetScale(ScaleX * 0.96);
			OGLO A 0 A_JumpIf(ScaleX <= 0.05, "Null");
			Loop;
	}
}

// Kaboom
Class FDHellboundTotenheimExplosionFlare : Actor
{
	Default
	{
		+NOINTERACTION;
		Alpha 0.6;
		Projectile;
		Renderstyle "Add";
		Scale 22.0;
	}
	States
	{
		Spawn:
			OGLO A 1 Bright A_SetScale(ScaleX * 0.98);
			OGLO A 0 A_FadeOut(0.01);
			OGLO A 0 A_JumpIf(ScaleX <= 0.05, "Null");
			Loop;
		Death:
			TNT1 A 0;
			Stop;
	}
}

Class FDHellboundTotenheimShroomer : Actor
{
	int c;
	Default
	{
		+NOINTERACTION;
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay { c = 12; }
	Looplet:
		TNT1 A random(2,5) A_SpawnItemEx("FDHellboundTotenheimShroom", 0,0,0, frandom(0.05,3.5),0,frandom(0.05,3.5), frandom(0.0,360.0));
		TNT1 A 0
		{
			if (c-- <= 0)
				Destroy();
		}
		Loop;
	}
}

Class FDHellboundTotenheimShroom : Actor
{
	Default
	{
		Renderstyle "Add";
		Alpha 0.8;
		Scale 8.0;
		+NOINTERACTION;
	}
	States
	{
		Spawn:
			TNT1 A 0 NoDelay A_SetScale(frandom(8.0,14.0));
			TNT1 A 0 A_SetScale(scalex * random(1,-1), scalex);
			
			// you don't wanna apply this directly in previous thing,
			// unless you wanna flip whole thing over either.
			
			TBST ABCDEFGHIJKLMNOPQR random(1,3) Bright;
			TBST STUVWXYZ random(1,3) A_FadeOut(0.05);
			Stop;
	}
}

Class FDHellboundTotenheimBlaster : Actor
{
	int c;
	Default
	{
		+NOINTERACTION;
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay { c = 300; }
	Looplet:
		TNT1 A 0 A_SpawnItemEx("FDHellboundTotenheimBlast", 0,0,0, frandom(7.0,22.5),0,frandom(5.0,12.0)*frandom(1,-1), frandom(0.0,360.0), SXF_TRANSFERPOINTERS, 32);
		TNT1 A 0
		{
			if (c-- <= 0)
				Destroy();
		}
		Loop;
	}
}

Class FDHellboundTotenheimBlast : Actor
{
	Default
	{
		Height 8;
		Radius 4;
		+FORCERADIUSDMG;
		+NOGRAVITY;
		+THRUACTORS;
		Projectile;
		Alpha 0.7;
		Renderstyle "Add";
		Scale 2.0;
	}
	States
	{
		Spawn:
			TNT1 A 0 NoDelay A_SetScale(frandom(2.0,2.5));
			TNT1 A 0 A_SetScale(scalex*random(1,-1),scaley*random(1,-1));
			TBSW AABBCCDDEEFFGGHHIIJJ random(2,3) Bright
			{
				A_SpawnItemEx("FDHellboundTotenheimSmoke", frandom(15.0,-15.0),frandom(15.0,-15.0),frandom(15.0,-15.0), frandom(0.2,0.4),0,frandom(0.2,0.4)*frandom(1,-1), frandom(0.0,360.0), 0, 230);
				A_Explode(20,128,XF_HURTSOURCE);
				A_FadeOut(frandom(0.00,0.02));
			}
			TBSW KKKLLL 3 A_FadeOut(frandom(0.00,0.02));
			Stop;
	}
}

Class FDHellboundTotenheimSmoke : Actor
{
	Default
	{
		Renderstyle "Translucent";
		Alpha 0.3;
		Scale 2.0;
		+NOINTERACTION;
	}
	States
	{
		Spawn:
			TNT1 A random(5,8) NoDelay;
			TNT1 A 0 A_SetScale(frandom(2.0,2.5));
			TNT1 A 0 A_SetScale(scalex*random(1,-1),scaley*random(1,-1));
			SMOK ABCDEFGHIJKLMNOPQ random(5,8) A_FadeOut(0.02);
			Stop;
	}
}

Class FDHellboundTotenheimGeigerSpawner : CustomInventory
{
	Default
	{
		-COUNTITEM;
		+INVENTORY.ALWAYSPICKUP;
		Inventory.PickupMessage "";
		Inventory.PickupSound "";
	}
	States
	{
	Spawn:
		TNT1 A 1;
		Stop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("FDHellboundTotenheimGeigerCooldown", 1, "NoGeiger");
		TNT1 A 0 A_GiveInventory("FDHellboundTotenheimGeigerCooldown", 1);
		TNT1 A 0 A_SpawnItemEx("FDHellboundTotenheimGeigerSound", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION);
		Stop;
	NoGeiger:
		TNT1 A 0;
		Stop;
	}
}

Class FDHellboundTotenheimGeigerSound : Actor
{
	Default
	{
		+NOINTERACTION;
		+NOCLIP;
	}
	States
	{
	Spawn:
		TNT1 A random(0,8) NoDelay;
		TNT1 A 0 A_PlaySound("effects/geigerburst", CHAN_WEAPON, 1, 0, 2.0);
		TNT1 A 50;
		Stop;
	}
}

Class FDHellboundTotenheimGeigerCooldown : Powerup
{
	Default
	{
		+INVENTORY.UNTOSSABLE;
		Powerup.Duration -5;
		Powerup.Duration 12;
	}
}

Class FDHellboundTotenheimRadiationSpot : Actor
{ 
	Default
	{
		+NODAMAGETHRUST;
		+NOTELEPORT;
		+NOTIMEFREEZE;
		DamageType "Chaos";
		Decal "";
	}

	int radiationtimer;
	int radiationdissipate;
	States
	{
		Spawn:
			TNT1 A 0;
		RadiationLoop:
			TNT1 A 0
			{
				if (radiationtimer-- <= 0)
					return ResolveState("RadiationDamage");
				return ResolveState(null);
			}
			TNT1 A 1 Light("FDHellBoundTotenheimRadiation")
			{
				for (int a=0;a<24;a++)
					if (random(0,1) == 0)
						A_SpawnParticle ("1cfe12", SPF_FULLBRIGHT | SPF_RELATIVE, random(3,50), random(1,3), frandom(0,360), frandom(-512.0,512.0),frandom(-512.0,512.0),frandom(-512.0,512.0), frandom(0.01,0.2),frandom(-0.1,0.1),frandom(-0.2,0.2), 0,0,0, 0.2, -1);
				for (int a=0;a<24;a++)
					if (random(0,1) == 0)
						A_SpawnParticle ("64fe5d", SPF_FULLBRIGHT | SPF_RELATIVE, random(3,50), random(1,3), frandom(0,360), frandom(-512.0,512.0),frandom(-512.0,512.0),frandom(-512.0,512.0), frandom(0.01,0.2),frandom(-0.1,0.1),frandom(-0.2,0.2), 0,0,0, 0.2, -1);
				for (int a=0;a<24;a++)
					if (random(0,1) == 0)
						A_SpawnParticle ("08ca00", SPF_FULLBRIGHT | SPF_RELATIVE, random(3,50), random(1,3), frandom(0,360), frandom(-512.0,512.0),frandom(-512.0,512.0),frandom(-512.0,512.0), frandom(0.01,0.2),frandom(-0.1,0.1),frandom(-0.2,0.2), 0,0,0, 0.2, -1);
				A_RadiusGive ("FDHellboundTotenheimGeigerSpawner", random(50,700), RGF_PLAYERS, 1);
			}
			Loop;
		RadiationDamage:
			TNT1 A 0
			{
				if (radiationdissipate++ >= 30)
					Destroy();
				radiationdissipate++;
				radiationtimer = 32;
			}
			TNT1 A 0 A_Explode (10, 1024, XF_HURTSOURCE, 0, 1024);
			Goto RadiationLoop;
	}
}