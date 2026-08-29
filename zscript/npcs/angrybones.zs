Class Base_AngryBones : PandMonster
{
    mixin DarkassFunctions;
	int baseSeeTimer;
	int seeTimer;
	Default
	{
		Health 300;
		Radius 20;
		Height 56;
		Mass 500;
		Speed 15;
		PainChance 50;
		Scale 0.8;
		+ALWAYSFAST;
		+FLOORCLIP;
		+NOBLOCKMONST;
		+QUICKTORETALIATE;
		+DONTHARMSPECIES;
  		+NOINFIGHTSPECIES;
		Species "Skeleton";
		DamageFactor "Skeleton", 0;
		PainChance "Skeleton", 0;
		Tag "Angry Bones";
		HitObituary "%o got boned by the Angry Bones";
		Obituary "%o got boned by the Angry Bones";
		PandMonster.MenuPic "ZKELA1D1";
		PandMonster.MenuSpecies "Revenant";
	}

	override string Pand_MonsterInfo()
	{
	return "Dark Add Info Here Please.";
	}

	States
	{
		Spawn:
			ZKEL A 0 A_StopSound(CHAN_VOICE);
			ZKEL AB 10 A_AngryLook;
			Loop;
		Roam:
			ZKEL A 0 A_StopSound(CHAN_VOICE);
			ZKEL AABBCCDDEEFF 2 A_AngryWander;
			Loop;
		See:
			ZKEL L 0 A_StartSound("AngryBones/See", CHAN_VOICE);
			ZKEL L 35 A_AngrySee;
			goto Chase;
		Chase:
			ZKEL A 0 A_StartSound("AngryBones/Chase", CHAN_VOICE, CHANF_LOOP);
			ZKEL AAABBBCCCDDDEEEFFF 1 A_AngryChase;
			Goto Chase+1;
		Melee:
		Missile:
			ZKEL G 4 A_FaceTarget;
			ZKEL H 4 A_AngryLaunch;
			ZKEL H 1 A_AngryFly;
			Wait;
		Punch:
			ZKEL I 4 A_AngryPunch;
			Goto Chase;
		Land:
			ZKEL I 6;
			Goto Chase;
		Pain:
			ZKEL L 10 A_StartSound("AngryBones/See", CHAN_VOICE);
			Goto Chase;
		Death:
			ZKEL L 7 A_StartSound("AngryBones/Die", CHAN_VOICE);
			ZKEL M 7;
			ZKEL N 7 A_StartSound(DeathSound, CHAN_BODY);
			ZKEL O 7 A_NoBlocking;
			ZKEL P 7;
			ZKEL Q -1;
			Stop;
		Raise:
			ZKEL Q 5;
			ZKEL PONML 5;
			Goto See;
	}

	void A_AngryLook()
	{
		if (health <= 0) return;
		A_LookEx(LOF_NOSEESOUND, 0, 0, 0, 180, "Roam");
		if (bFRIENDLY) {
			SetStateLabel("Roam");
		}
	}

	void A_AngrySee()
	{
		if (health <= 0) return;
		A_FaceTarget();
		seeTimer = baseSeeTimer;
	}

	void A_AngryWander()
	{
		if (health <= 0) return;
		A_Chase(null, null, CHF_NOPLAYACTIVE);
		if (CheckIfTargetInLOS())
		{
			SetStateLabel("See");
		}
	}

	void A_AngryChase()
	{
		if (health <= 0) return;
		if (target == null)
		{
			SetStateLabel("Roam");
			return;
		}

		// Compensate for moving players
		Vector3 position = GetLeadXPos(target, speed);
		Actor a = Spawn("TargetMarker2", position);
		Vector2 distance = (Distance2D(a), abs(pos.z - position.z));
		a.Destroy();
		float g = gravity * floorsector.gravity * (level.gravity / 800.0);

		StateLabel missile = null;
		if (pos.z == floorz)
		{
			float cx = max(radius, MeleeRange) + target.radius;
			float cz = pos.z + height;
			float dx = (speed * 32);
			float dz = (speed * 32) / 2.0;
			bool flag1 = distance.x < dx;
			bool flag2 = target.pos.z > cz;
			bool flag3 = distance.x >= cx;
			bool flag4 = distance.y < dz;
			if (flag1 && ((flag2 && flag3 && flag4) || !flag2) && (CheckFullSight(target) || CheckFullSight(target, height / 2)))
			{
				missile = "Missile";
			}
			A_Chase("Melee", missile, CHF_NOPLAYACTIVE);
		}
	}

	void A_AngryLaunch()
	{
		if (health <= 0) return;
		if (target == null) return;

		// Compensate for moving players
		Vector3 position = GetLeadXPos(target, speed / 2.0);
		Actor a = Spawn("TargetMarker2", position);
		Vector2 distance = (Distance2D(a), abs(pos.z - position.z));
		a.Destroy();
		float g = gravity * floorsector.gravity * (level.gravity / 800.0);
		A_StartSound("skeleton/swing", CHAN_WEAPON);
		A_FacePosition(position);
/*
		// Older code
		float Vx = distance.x / speed / 2.0;
		float Vz = sqrt(2 * g * max(distance.y, Vx * pi));
*/
		// Newer Code
		float t = max(1, min(speed, distance.Length() / speed));
		float dx = max(0, distance.x - (radius + target.radius));
		float dz = max(0, distance.y);
		float Vx = dx / t;
		float Vz = (dz + 0.5 * g * t * t) / t;

		Vel.x = cos(angle) * Vx;
		Vel.y = sin(angle) * Vx;
		Vel.z = Vz;
	}

	void A_AngryFly()
	{
		if (health <= 0) return;
		int tics = 0; // Tics before A_TwitchMelee is called.
		if (target != null && CheckIfTargetInLOS(180, 0, max(radius, MeleeRange) + target.radius + ((Vel.x, Vel.y).Length() * tics)) || pos.z == floorz || BlockingMobj != null && BlockingMobj.bSHOOTABLE)
		{
			Tracer = BlockingMobj;
			SetStateLabel("Punch");
		}
		if (pos.z > floorz && (vel.z > -1 && vel.z < 1))
		{
			// Allows climbing ledges.
			Vel.x += cos(angle) * 2;
			Vel.y += sin(angle) * 2;
		}
	}

	void A_AngryPunch()
	{
		if (Tracer != null) A_RearrangePointers(AAPTR_TRACER, AAPTR_MASTER, AAPTR_TARGET);
		A_FaceTarget();
		A_CustomMeleeAttack(random(1, 10) * 3, "skeleton/melee");
		if (Tracer != null) A_RearrangePointers(AAPTR_TRACER, AAPTR_MASTER, AAPTR_NULL);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		baseSeeTimer = 1050;
	}

	override void Tick()
	{
		Super.Tick();
		if (health <= 0) return;
		if (target == null) return;
		if (pos.z > target.pos.z + MaxStepHeight)
		{
			bDROPOFF = true;
		}
		else {
			bDROPOFF = false;
		}
		if (CheckIfTargetInLOS())
		{
			seeTimer = baseSeeTimer;
		}
		else if (seeTimer-- == 0)
		{
			SetStateLabel("Roam");
		}
	}
}