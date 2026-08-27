Class Pand_DrunkMissileLauncher : PandInsWeapon
{
	Default
	{
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You got the \cfDrunk Missile Launcher\c-!";
		Inventory.PickupSound "RocketLauncher/Pickup";
		PandInsWeapon.CapacityIncrease 2;
		PandInsWeapon.MagazineSize 4;
		PandInsWeapon.MenuPic "DRUNZ0";
		Tag "Drunk Missile Launcher";
		Weapon.AmmoGive 7;
		Weapon.AmmoType "NewRocketAmmo";
		Weapon.AmmoUse 0;
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 3;
		Weapon.UpSound "Weapon/Draw";
	}

	override string Pand_WeaponInfo()
	{
		return "The \cfDrunk Missile Launcher\c- is as portable rocket salvo that shoots drunk seeker mini missiles.
		The missiles themselves don't have strong seeking, but they can bounce off walls and floors at shallow angles.
		
		Increasing capaicy will increase the shots fired at the cost of decreased reload speed.
		Alt fire will shoot one missile at a time while also auto loading between shots.

		The \c[j8]Superior\c- augment upgrades the rockets to fire the Cydestructor's mini rockets while keeping the drunk seeking effect at the cost of consuming more ammo per shot.";
	}

	States
	{
		Spawn:
			DRUN Z -1;
			Stop;
		Ready:
			DRUN A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		Deselect:
			DRUN A 0 A_StartSound("Weapon/Putaway");
			DRUN A 1 A_Lower(12);
			Wait;
		Select:
			DRUN A 1 A_Raise(12);
			Loop;
		NoAmmo:
			DRUN A 10 A_StartSound("Weapon/Empty2");
			Goto Ready;
		Fire:
			DRUN A 0
			{
				if (invoker.magCount == 1) {
					SetWeaponState("AltFire");
					return;
				}
				if (invoker.magCount <= 0 && !invoker.CountInv(invoker.AmmoType1))
				{
					SetWeaponState("NoAmmo");
					return;
				}
				if (invoker.magCount <= 0 && invoker.CountInv(invoker.AmmoType1))
				{
					SetWeaponState("Reload");
					return;
				}
			}
			DRUN A 0
			{
				A_GunFlash();
				int c = invoker.magCount;
				for (int i=0; i<c; i++)
				{
					Pand_TakeAmmo(invoker.aug_sup ? 2 : 1, true);
					if (i == 0 && c != 2 && c != 3)
					{
						A_FireCustomMissile((invoker.aug_sup ? "InsDrunkCydestructorMissile" : "InsDrunkMissile"), 0, 1, 0, -8, 0, 0);
					}
					else
					{
						double a = ((double(i - 1) / double(c - (c == 2 || c == 3 ? 0 : 1))) * 360) + (c == 2 ? 90 : 0);
						A_FireCustomMissile((i == 0 ? (invoker.aug_sup ? "InsDrunkCydestructorMissile" : "InsDrunkMissile") : (invoker.aug_sup ? "InsDrunkCydestructorMissileSilent" : "InsDrunkMissileSilent")), 0, 0, -sin(a) * 6, -8 + (cos(a) * 6), 0, 0);
					}
				}
				A_WeaponQuake(4+(c/8),8+(c/4));
				A_SetOffsetVariables(frandom(-1,1),frandom(-4,4));
			}
			DRUN DEFG 2 Bright A_PandWeaponOffset;
			DRUN H 2 Bright A_PandWeaponOffsetReset;
			DRUN A 2;
			DRUN A 12;
			DRUN A 0 A_Refire;
			Goto Ready;
		AltFire:
			DRUN A 0
			{
				if (invoker.magCount <= 0 && !invoker.CountInv(invoker.AmmoType1))
				{
					SetWeaponState("NoAmmo");
					return;
				}
				if (invoker.magCount <= 0 && invoker.CountInv(invoker.AmmoType1))
				{
					SetWeaponState("AltHold");
					return;
				}
			}
			DRUN A 0
			{
				A_GunFlash();
				Pand_TakeAmmo(invoker.aug_sup ? 2 : 1, true);
				A_FireCustomMissile((invoker.aug_sup ? "InsDrunkCydestructorMissile" : "InsDrunkMissile"), 0, 1, 0, -8, 0, 0);
				A_WeaponQuake(4,8);
				A_SetOffsetVariables(frandom(-1,1),frandom(-4,4));
			}
			DRUN DFG 2 Bright A_PandWeaponOffset;
			DRUN H 2 Bright A_PandWeaponOffsetReset;
			DRUN A 0 A_Refire;
			DRUN A 4;
			Goto Ready;
		AltHold:
			DRUN A 4 {
				if (invoker.magCount <= 0 && invoker.CountInv(invoker.AmmoType1))
				{
					A_TakeInventory(invoker.AmmoType1,1,TIF_NOTAKEINFINITE);
					invoker.magCount+=2;
					A_StartSound("RocketBox/Pickup",888,volume:0.7,pitch:1.3);
				}
			}
			Goto AltFire;
		Reload:
			DRUN A 0 {
				if (invoker.magCount >= invoker.magSize-1 || !invoker.CountInv(invoker.AmmoType1))
				{
					SetWeaponState("Ready");
					return;
				}
			}
			Goto ReloadLoop;
		ReloadLoop:
			DRUN A 4
			{
				if (invoker.magCount < invoker.magSize-1 && invoker.CountInv(invoker.AmmoType1))
				{
					A_TakeInventory(invoker.AmmoType1,1,TIF_NOTAKEINFINITE);
					invoker.magCount+=2;
					A_StartSound("RocketBox/Pickup",888,volume:0.7,pitch:1.3);
				}
			}
			DRUN A 0
			{
				if (invoker.magCount < invoker.magSize-1 && invoker.CountInv(invoker.AmmoType1))
				{
					SetWeaponState("ReloadLoop");
					return;
				}
			}
			Goto ReloadEnd;
		ReloadEnd:
			//DRUN A 8;
			DRUN A 0 A_Refire;
			Goto Ready;
/*
		Reload:
			DRUN A 0
			{
				for (int i=0;i<invoker.magSize;i++)
				{
					if (invoker.magCount < invoker.magSize-1 && invoker.CountInv(invoker.AmmoType1))
					{
						A_TakeInventory(invoker.AmmoType1,1,TIF_NOTAKEINFINITE);
						invoker.magCount+=2;
						if (i == 0)
						{
							A_StartSound("RocketBox/Pickup",888,volume:0.7,pitch:1.3);
						}
					}
				}
				A_SetTics(2 * invoker.magCount);
			}
			DRUN A 8;
			DRUN A 0 A_Refire;
			Goto Ready;
*/
	}
}

Mixin Class InsDrunkMissileStuff
{
	Default
	{
		BounceFactor 1.0;
		+BOUNCEONCEILINGS;
		+BOUNCEONFLOORS;
		+BOUNCEONWALLS;
		+DONTBOUNCEONSKY;
		+SCREENSEEKER;
		+SEEKERMISSILE;
		+USEBOUNCESTATE;
	}
	// Don't collide with the world at shallow angles.
	State BounceStuff() {
		A_SetAngle(VectorAngle(vel.x, vel.y));
		A_SetPitch(VectorAngle(vel.xy.Length(), vel.z));
		double dAngle = ((pAngle % 360) - (angle % 360));
		double dPitch = ((pPitch % 360) - (pitch % 360));

		console.printf("pAngle: " .. pAngle);
		console.printf("angle: " .. angle);
		console.printf("dAngle: " .. dAngle);

		console.printf("pPitch: " .. pPitch);
		console.printf("pitch: " .. pitch);
		console.printf("dPitch: " .. dPitch);

		if (abs(dAngle) > 30 && abs(dAngle) < 330 || abs(dPitch) > 30 && abs(dPitch) < 330)
		{ // Explode if the angle or pitch is greater than 30 degrees.
			bBOUNCEONCEILINGS = false;
			bBOUNCEONFLOORS = false;
			bBOUNCEONWALLS = false;
			A_Stop();
			A_PlaySound(DeathSound);
			return ResolveState("Death");
		}
		return ResolveState("Spawn");
	}

	int sRandom;
	double pAngle;
	double pPitch;
	override void Tick() {
		Super.Tick();
		A_SetAngle(VectorAngle(vel.x, vel.y));
		A_SetPitch(VectorAngle(vel.xy.Length(), vel.z));
		pAngle = angle;
		pPitch = pitch;
	}

	override void BeginPlay()
	{
		Super.BeginPlay();
		sRandom = Random(0,3);
	}

	States
	{
		Bounce:
			"####" # 0 BounceStuff();
			Goto Spawn;
	}
}

Class InsDrunkMissile : InsPulverizerRocket
{
	Mixin InsDrunkMissileStuff;

	Default
	{
		Speed 24;
		Scale 0.8;
	}

	States
	{
		Spawn:
			MMIS A 1 Bright Light("MROCKET")
			{
				if (GetAge() == sRandom)
				{
					A_StartSound("DrunkMissile/Fire", pitch:FRandom(0.9, 1.1));
				}
				if (GetAge() > 12)
				{ // Don't seek until 12 tics have passed.
					A_SeekerMissile(0, 1.0546875, SMF_LOOK|SMF_PRECISE, 256, 8);
				}
				if (GetAge() > 0 && GetAge() % 6 == 0)
				{ // Drunk move every 6 tics after 6 tics.
					A_SetAngle(angle + 11.25*FRandom(-1,1));
					A_SetPitch(pitch + 5.625*FRandom(-1,1));
					A_ChangeVelocity(cos(angle)*cos(pitch)*speed, sin(angle)*cos(pitch)*speed, sin(pitch)*speed, CVF_REPLACE);
				}
				if (GetAge() % 2 == 1)
				{ // Only spawn effects every 2nd tick.
					A_SpawnItemEx("RocketSmokeTrail2",-12,frandom(-2,2),frandom(-2,2),frandom(-2,0));
					for(user_fx = 0;user_fx<=2;user_fx++)
						A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(15,25),frandom(6,9),0,frandom(-18,-12),frandom(-2,2),frandom(-2,2),frandom(-3,0),frandom(-2,2),frandom(-2,2),0,0,0,1,-1,-1);
				}
			}
			Loop;
	}
}

Class InsDrunkMissileSilent : InsDrunkMissile
{
	Default
	{
		PandProjectile.FireSound "";
	}
}



Class InsDrunkCydestructorMissile : InsCydestructorRocket
{
	Mixin InsDrunkMissileStuff;

	Default
	{
		Speed 12;
		Scale 0.8;
	}

	States
	{
		Spawn:
			CYR0 A 1 Bright Light("ROCKET")
			{
				if (GetAge() == sRandom)
				{
					A_StartSound("DrunkMissile/Fire", pitch:FRandom(0.9, 1.1));
				}
				if (GetAge() > 12)
				{ // Don't seek until 12 tics have passed.
					A_SeekerMissile(0, 1.0546875, SMF_LOOK|SMF_PRECISE, 256, 8);
				}
				if (GetAge() > 0 && GetAge() % 6 == 0)
				{
					A_SetAngle(angle + 5.625*FRandom(-1,1));
					A_SetPitch(pitch + 2.8125*FRandom(-1,1));
					A_ChangeVelocity(cos(angle)*cos(pitch)*speed, sin(angle)*cos(pitch)*speed, sin(pitch)*speed, CVF_REPLACE);
				}
				if (GetAge() < 20 + sRandom)
				{
					for(user_fx = 0;user_fx<=3;user_fx++)
						A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(15,25),frandom(6,9),0,frandom(-18,-12),frandom(-3,3),frandom(-3,3),frandom(-3,0),frandom(-2,2),frandom(-2,2),0,0,0,1,-1,-1);
				}
				if (GetAge() == 20 + sRandom) {
					Speed *= 4.0;
					A_ScaleVelocity(4.0);
					A_StartSound("Rocket/Fire",7);
				}
				if (GetAge() >= 20 + sRandom)
				{
					A_SpawnItemEx("RocketSmokeTrail2",-12,frandom(-2,2),frandom(-2,2),frandom(-2,0));
					if(random(0,1) == 0) A_SpawnItemEx("FireProjectileTrail",-12,0,0,frandom(-2,0),frandom(-1,1),frandom(-1,1));
					else A_SpawnItemEx("FireProjectileTrail2",-12,0,0,frandom(-2,0),frandom(-1,1),frandom(-1,1));
					for(user_fx = 0;user_fx<=3;user_fx++)
						A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(15,25),frandom(6,9),0,frandom(-18,-12),frandom(-3,3),frandom(-3,3),frandom(-3,0),frandom(-2,2),frandom(-2,2),0,0,0,1,-1,-1);
				}
			}
			Loop;
	}
}

Class InsDrunkCydestructorMissileSilent : InsDrunkCydestructorMissile
{
	Default
	{
		PandProjectile.FireSound "";
	}
}