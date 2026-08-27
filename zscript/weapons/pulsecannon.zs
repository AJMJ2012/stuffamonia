// Based on Final Doomer's BTSX Pulse Cannon

Class Pand_PulseCannon : PandInsWeapon
{
	Default
	{
		+PANDINSWEAPON.NOSUPERIORAUGMENT; // For Now
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You got the \cfPulse Cannon\c-!";
		PandInsWeapon.MenuPic "XROKZ0";
		Tag "Pulse Cannon";
		Weapon.AmmoGive 25;
		Weapon.AmmoType "NewCell";
		Weapon.AmmoUse 5;
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 4;
		Weapon.UpSound "Weapon/Draw";
	}

	override string Pand_WeaponInfo()
	{
		return "The \cfPulse Cannon\c- is a heavy plasma weapon alternative to the standard \cfRocket Launcher\c-.
		
		It has increased speed and impact damage but lower splash damage however with no blast falloff compared to it's explosive counterpart.

		No \c[j8]Superior\c- augment support right now.";
	}

	States
	{
		Spawn:
			XROK Z -1;
			Loop;
		Ready:
			XROK A 1 A_WeaponReady();
			Loop;
		Select:
			XROK A 1 A_Raise(12);
			Loop;
		Deselect:
			XROK A 0 A_StartSound("Weapon/Putaway");
			XROK A 1 A_Lower(12);
			Wait;
		NoAmmo:
			XROK A 10 A_StartSound("Weapon/Empty4");
			Goto Ready;
		Fire:
			XROK A 0 EMPCheck();
			XROK A 0 A_JumpIfNoAmmo("NoAmmo");
			XROK A 0 A_PlaySound("btsxrocketlauncher/charge", 6, 1, 0, 1.25);
			XROK BCDEFGH 2;
			XROK H 0
			{
				A_GunFlash("Flash");
				A_AlertMonsters();
				Pand_FireProjectile("InsPulseCannonProjectile", 2);
			}
			XROK I 1 Bright A_SetPitch(pitch - 1.75);
			XROK I 1 Bright A_SetPitch(pitch - 0.5);
			XROK J 1 Bright A_SetPitch(pitch + 0.05);
			XROK J 1 Bright A_SetPitch(pitch + 0.25);
			XROK K 1 Bright A_SetPitch(pitch + 0.6);
			XROK K 1 Bright A_SetPitch(pitch + 0.39);
			XROK L 1 Bright A_SetPitch(pitch + 0.31);
			XROK L 1 Bright A_SetPitch(pitch + 0.25);
			XROK M 1 Bright A_SetPitch(pitch + 0.19);
			XROK M 1 Bright A_SetPitch(pitch + 0.13);
			XROK C 1 A_SetPitch(pitch + 0.07);
			XROK C 1 A_SetPitch(pitch + 0.01);
			XROK A 2;
			Goto Ready;

		Flash:
			TNT1 A 2 A_Light(7);
			TNT1 A 2 A_Light(4);
			TNT1 A 2 A_Light(3);
			TNT1 A 2 A_Light2;
			TNT1 A 2 A_Light1;
			TNT1 A 0 A_Light0;
			Goto LightDone;
	}
}

Class InsPulseCannonProjectile : PandInsProjectile
{
	Default
	{
		+EXPLODEONWATER;
		+EXTREMEDEATH;
		+FORCEXYBILLBOARD;
		+PANDINSPROJECTILE.EXPLOSIVE;
		DamageFunction 200; // Buffed from 160
		DamageType "Plasma";
		Decal "BigScorch";
		Height 8;
		InsPulseCannonProjectile.ParticleColors "ffffff", "e7e7ff", "c7c7ff", "7373ff", "3737ff";
		PandInsProjectile.FXColor "Blue";
		Projectile;
		Radius 4;
		RenderStyle "Add";
		SeeSound "btsxrocketlauncher/fire";
		Speed 50;
	}

	// 1 more than PandInsProjectile has
	color pcolor5;
	property ParticleColors: pcolor1, pcolor2, pcolor3, pcolor4, pcolor5;

	override void BeginPlay()
	{
		Super.BeginPlay();
		ParticleColor.Push(pcolor5);
	}

	States
	{
		Spawn:
			TRCR A 1 Light("BBFG10k")
			{
				for(user_fx = 0;user_fx<=2;user_fx++)
					A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(20,25),frandom(8,15),0,0,0,0,frandom(-1,1),frandom(-1,1),frandom(-1,1),0,0,0,1,-1,-1);
			}
			Loop;
		Death:
			TNT1 A 0
			{
				bEXTREMEDEATH = false;
				bFORCEXYBILLBOARD = true;
				A_InsExplode(60, 128, 1, 0, 128);
				A_Quake(1, 12, 0, 1024, "");
				A_Quake(5, 8, 0, 512, "");
				A_SpawnItemEx("InsPulseCannonProjectileWave", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION);
				A_SpawnItemEx("InsPulseCannonProjectileFlash", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION);
				A_PlaySound("btsxrocketlauncher/explosion", CHAN_WEAPON, 1, 0, 0.5);
				A_PlaySound("btsxrocketlauncher/explosion", 7, 0.10, 0, 0.01);
				for(user_fx = 0;user_fx<=70;user_fx++)
					A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(20,30),frandom(15,20),frandom(0,360),frandom(0,20),0,frandom(-20,20),frandom(0,12),0,frandom(-12,12),-0.1,0,-0.05,1,-1,-0.4);
				for (int a=0; a<4;a++)
					A_SpawnItemEx("BlueBFGExplosionParticle",random(-10,10),random(-10,10),random(-10,10),frandom(-8,8),frandom(-8,8),frandom(-8,8));
				A_InsSetScale(1.8);
				A_SetTranslucent(0.98, 1);
			}
			XRKP G 3 Bright Light("BBFG10k_X2") A_SpawnItemEx("BlueBFGLightningTrail");
			XRKP H 3 Bright Light("BBFG10k_X1") A_SpawnItemEx("BlueBFGLightningTrail");
			XRKP I 3 Bright Light("BBFG10k_X2") A_SpawnItemEx("BlueBFGLightningTrail");
			XRKP J 3 Bright Light("BBFG10k_X3") A_SpawnItemEx("BlueBFGLightningTrail");
			XRKP K 3 Bright Light("BBFG10k_X4") A_SpawnItemEx("BlueBFGLightningTrail");
			XRKP L 3 Bright Light("BBFG10k_X5") A_SpawnItemEx("BlueBFGLightningTrail");
			Stop;
		}
}

Class InsPulseCannonProjectileWave : Actor
{
	Default
	{
		Radius 4;
		Height 4;
		RenderStyle "Add";
		+FORCEXYBILLBOARD
		+NOINTERACTION
		Scale 4.0;
		Alpha 0.25;
	}
	States
	{
		Spawn:
			XRKP BCDEF 2 Bright;
			Stop;
	}
}

Class InsPulseCannonProjectileFlash : Actor
{
	Default
	{
		Radius 4;
		Height 4;
		RenderStyle "Add";
		+FORCEXYBILLBOARD
		+NOINTERACTION
		Scale 3.5;
		Alpha 1.0;
	}
	States
	{
		Spawn:
			SLGW B 1 Bright NoDelay;
			SLGW B 1 Bright
			{
				scale.x -= 0.5;
				scale.y = scale.x;
				if (scale.x <= 0)
					Destroy();
			}
			Loop;
	}
}