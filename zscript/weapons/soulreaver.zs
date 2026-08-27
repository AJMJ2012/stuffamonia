// Based on Eriguns2's Soul Reaver

class Pand_SoulReaver : PandInsWeapon
{
	Default
	{
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You got the \cfSoul Reaver\c-!";
		Inventory.PickupSound "HelArkh/Pickup";
		PandInsWeapon.MaxAugments 3;
		PandInsWeapon.MenuPic "HESRA0";
		Tag "Soul Reaver";
		Weapon.AmmoGive 100;
		Weapon.AmmoType "PandDemonBloodAmmo";
		Weapon.AmmoUse 50;
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 7;
		Weapon.SlotPriority -1;
		Weapon.UpSound "HelArkh/Draw";
	}

	override string Pand_WeaponInfo()
	{
		return "Dug up from the deepest depths of hell, the \cfSoul Reaver\c- is an excellent weapon to rip demon souls from their bodies.

		The \c[j8]Superior\c- augment turns your soul carrier projectile into a slow moving ball of death.";
	}

	States
	{
		Spawn:
			HESR A -1;
			Stop;
		Ready:
			HSRG A 1 A_WeaponReady();
			Loop;
		Deselect:
			HSRG A 0 A_StopSound(CHAN_WEAPON);
			HSRG A 0 A_StartSound("Weapon/Putaway");
			HSRG A 1 A_Lower(12);
			Wait;
		Select:
			HSRG A 1 A_Raise(12);
			Loop;
		NoAmmo:
			HSRG A 10 A_StartSound("Weapon/Empty4");
			Goto Ready;
		Fire:
			HSRG A 0 EMPCheck();
			HSRG A 0 A_JumpIfNoAmmo("NoAmmo");
			HSRG C 3 Bright A_PlaySound("weapons/reavercharge", CHAN_BODY);
			HSRG DEF 3 Bright;
			HSRF AB 3 Bright;
			HSRF C 3 Bright A_PlaySound("weapons/reaverloop", CHAN_WEAPON, 1.0, 1);
			HSRF DEFGH 3 Bright;

		Hold:
			HSRF EFGH 3 Bright
			{
				if (!(player.buttons & BT_ATTACK))
				{
					SetWeaponState("Release");
				}
			}
			Loop;
		Release:
			HSRF I 4 Bright
			{
				A_GunFlash("Flash");

				if (invoker.aug_sup)
				{
					A_SetBlend("FF FF FF", 1.0, 25);
					A_PlaySound("weapons/reaverpow", CHAN_WEAPON);
					Pand_FireProjectile("InsSuperSoulShot", 2);
				}
				else
				{
					A_SetBlend("FF FF FF", 0.66, 15);
					A_PlaySound("weapons/reaverfire", CHAN_WEAPON);
					Pand_FireProjectile("InsSoulReaverShot", 2);
				}
			}
			HSRF J 4 Bright;
			HSRG B 8;
			Goto Ready;
		Flash:
			TNT1 A 2 Bright A_Light(2);
			TNT1 A 2 Bright A_Light(1);
			Goto LightDone;
	}
}

class InsSoulReaverShot : PandInsProjectile
{
	const SOUL_COUNT = 5;

	Default
	{
		+BLOODLESSIMPACT;
		+EXTREMEDEATH;
		+FORCEXYBILLBOARD;
		Alpha 1.0;
		DamageFunction 100;
		DamageType "Chaos";
		DeathSound "weapons/reaverhit";
		Decal "Scorch";
		Height 16;
		Obituary "%o was raptured by %k's soul reaver.";
		PandProjectile.ParticleColors "FFFFFF", "DDDDDD", "BBBBBB", "999999";
		Projectile;
		Radius 11;
		RenderStyle "Add";
		Scale 0.66;
		SeeSound "weapons/reaverhit";
		Speed 30;
	}
	States
	{
	Spawn:
		SPIR P 1 Bright
		{
			A_SpawnItemEx("InsSoulReaverTrail", frandom(0.5, -0.5), 0, frandom(0.5, -0.5), 0, 0, 0, 0, SXF_CLIENTSIDE);
			A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(8,16),frandom(4,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,0),0,frandom(0,3),0,0,-0.03,1,-1,-0.6);
		}
		Loop;
	Death:
		TNT1 A 0
		{
			for(user_fx = 0;user_fx<=20;user_fx++)
				A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-0.75);
		}
		REAX AB 3 Bright;
		REAX C 3 Bright
		{
			for(int i = 0; i < SOUL_COUNT; i++)
			{
				A_SpawnItemEx("InsSoulSpirit", xvel: 12, angle: (i * 360 / SOUL_COUNT) + frandom(-5, 5), flags: SXF_TRANSFERPOINTERS);
			}
		}
		REAX DEFGHI 3 Bright;
		Stop;
	}
}

class InsSoulReaverTrail : PandFX
{
	Default
	{
		-RANDOMIZE;
		+FORCEXYBILLBOARD;
		+NOBLOCKMAP;
		+NOBLOCKMONST;
		+NOGRAVITY;
		+NOTELEPORT;
		+THRUACTORS;
		Alpha 1.0;
		Renderstyle "Add";
		Scale 0.15;
	}
	States
	{
	Spawn:
		REAX KKKJ 1 Bright;
		REAX JJ 1 Bright A_FadeOut(0.25);
		Loop;
	}
}

class InsSoulSpirit : InsSoulReaverShot
{
	int seekTics;
	property SeekTics:seekTics;

	Default
	{
		+RIPPER;
		+SEEKERMISSILE;
		BounceFactor 1.0;
		BounceType "Hexen";
		DamageFunction 2;
		DamageType "Chaos";
		Decal "PlasmaScorchLower";
		Height 4;
		InsSoulSpirit.SeekTics 105;
		Radius 8;
		Scale 1.0;
		SeeSound "weapons/reaversoulout";
		Speed 12;
		WallBounceFactor 1.0;
	}

	override int SpecialMissileHit(Actor victim)
	{
		self.bPAINLESS = victim.bDONTRIP;
		return MHIT_PASS;
	}

	States
	{
	Spawn:
		REAS A 1 Bright NoDelay
		{
			if (self.seekTics > 0)
			{
				self.seekTics--;
				if(self.seekTics <= 0)
				{
					self.bBounceOnWalls    = false;
					self.bBounceOnCeilings = false;
					self.bBounceOnFloors   = false;
				}
				A_SeekerMissile(17, 17, SMF_LOOK | SMF_PRECISE);
			}
			A_SpawnItemEx("InsSoulReaverTrail", frandom(0.5, -0.5), 0, frandom(0.5, -0.5), 0, 0, 0, 0, SXF_CLIENTSIDE);
			A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(8,16),frandom(4,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,0),0,frandom(0,3),0,0,-0.03,1,-1,-0.6);
		}
		Loop;
	Death:
		TNT1 A 0
		{
			for(user_fx = 0;user_fx<=20;user_fx++)
				A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-0.75);
		}
		REAX A 3 Bright A_SetScale(0.5);
		REAX B 3 Bright;
		REAX C 3 Bright;
		REAX DEFGHI 3 Bright;
		Stop;
	}
}

class InsSuperSoulShot : InsSoulReaverShot
{
	Default
	{
		+RIPPER;
		DamageFunction 5;
		DamageType "Chaos";
		Obituary "%o was cast to hell by %k's powered soul reaver.";
		Scale 1.0;
		Speed 10;
	}

	override int SpecialMissileHit(Actor victim)
	{
		self.bPAINLESS = victim.bDONTRIP;
		return MHIT_PASS;
	}

	States
	{
	Spawn:
		REAB A 0 Bright NoDelay A_PlaySound("weapons/reaverloop2", CHAN_BODY, 1.0, 1);
	Fly:
		REAB ABCDE 3 Bright
		{
			A_SpawnItemEx("InsSuperSoulSpirit", 0, 0, 0, 12, 0, 0, random(1, 360), SXF_TRANSFERPOINTERS, 0);
			A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(8,16),frandom(4,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,0),0,frandom(0,3),0,0,-0.03,1,-1,-0.6);
		}
		Loop;
	Death:
		TNT1 A 0
		{
			for(user_fx = 0;user_fx<=20;user_fx++)
				A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-0.75);
		}
		REAB F 3 Bright;
		REAX BCDEFGHI 3 Bright;
		Stop;
	}
}

class InsSuperSoulSpirit : InsSoulSpirit
{
	Default
	{
		BounceCount 2;
		DamageFunction 1;
		Obituary "%o was cast to hell by %k's powered soul reaver.";
		SeeSound "weapons/reaversoulfly";
	}
}
