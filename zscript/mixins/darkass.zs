mixin class DarkassFunctions
{
	const pi = 3.1415926535897932384626433832795;
	bool IsCloseToLedge(Vector3 position, int radius, int stepHeight = 24, bool ceiling = false, int steps = 4)
	{
		int flags = GZF_ABSOLUTEPOS;
		if (ceiling) flags |= GZF_CEILING;
		float myZ = GetZAt(position.x, position.y, flags: flags);
		for (int x = -radius; x <= radius; x+=steps)
		{
			for (int y = -radius; y <= radius; y+=steps)
			{
				if (Abs(GetZAt(position.x + x, position.y + x, flags: flags) - myZ) > stepHeight)
				{
					return true;
				}
			}
		}
		return false;
	}

	enum TargetClosestFlags
	{
		TC_ENEMY       = 1,
		TC_ALLY        = 2,
		TC_OBJECT      = 4,
		TC_NOTPLAYER   = 8,
		TC_NOTMONSTER  = 16,
		TC_SAMESPECIES = 32,
	}

	void TargetClosest(Actor ptr, int flags = TC_ENEMY)
	{
		Actor closest;
		// In Sight first, then in sector, then any
		for (int i = 0; i < 3 && !closest; i++)
		{
			Actor other;
			ThinkerIterator it = ThinkerIterator.Create("Actor");
			while (other = Actor(it.Next()))
			{
				if (other != ptr && other.Health > 0 && other.bSHOOTABLE)
				{
					bool isAlly = ptr.bFRIENDLY && (other.bFRIENDLY || other.player) || (!ptr.bFRIENDLY && !(other.bFRIENDLY || other.player));
					bool MoP = (other.bISMONSTER || other.player);
					if (!(flags & TC_ENEMY) && MoP && !isAlly) continue;
					if (!(flags & TC_ALLY) && MoP && isAlly) continue;
					if (!(flags & TC_OBJECT) && (other.bSHOOTABLE && !MoP)) continue;
					if (flags & TC_NOTPLAYER && (other.player)) continue;
					if (flags & TC_NOTPLAYER && (other.bISMONSTER)) continue;
					if (!(flags & TC_SAMESPECIES) && (ptr.species == other.species)) continue;

					if (!closest || ptr.Distance3D(other) < ptr.Distance3D(closest))
					{
						switch (i)
						{
							case 0:
								if (ptr.CheckSight(other)) closest = other;
								break;
							case 1:
								if (ptr.cursector == other.cursector) closest = other;
								break;
							default:
								closest = other;
								break;
						}
					}
				}
			}
		}
		if (closest)
		{
			ptr.lastheard = closest;
			ptr.target = closest;
			ptr.lastenemy = closest;
		}
	}

	void LeadX(Actor ptr, float projSpeed, bool lerp = true)
	{
		if (!ptr || ptr.health <= 0) { return; }
		Vector3 position = GetLeadXPos(ptr, projSpeed, lerp);
		FacePosition(position);
	}

	void FacePosition(Vector3 position)
	{
		Actor a = Spawn("TargetMarker", position);
		if (CheckSight(a))
		{
			angle = AngleTo(a);
			pitch = PitchTo(a);
		}
		a.Destroy();
	}

	Vector3 lastVel;
	Vector3 lastPos;
	int lastTime;
	Vector3 GetLeadXPos(Actor ptr, float projSpeed, bool lerp = true)
	{
		if (!ptr || ptr.health <= 0) { return self.Pos; }
		Vector3 theirVel = ptr.Vel;
		if (!ptr.player)
		{
			// Get velocity of monster
			theirVel = (ptr.Pos - lastPos) / float(GetAge() - lastTime);
			if (GetAge() != lastTime) lastPos = ptr.Pos;
		}
		Vector3 thisVel;
		// Basic smoothing
		if (lerp)
		{
			thisVel = (theirVel + lastVel) / 2.0;
		}
		else
		{
			thisVel = theirVel;
		}
		if (GetAge() != lastTime) lastVel = thisVel;
		lastTime = GetAge();

		// From https://playtechs.blogspot.com/2007/04/aiming-at-moving-target.html
		Vector3 p = pos - ptr.pos;
		Vector3 v = thisVel;
		double s = projSpeed;
		double a = s * s - (v.x * v.x + v.y * v.y + v.z * v.z);
		double b = p.x * v.x + p.y * v.y + p.z * v.z;
		double c = p.x * p.x + p.y * p.y + p.z * p.z;
		double d = b * b + a * c;
		double t = 0;
		if (d >= 0)
		{
			t = (b + sqrt(d)) / a;
			if (t < 0)
				t = 0;
		}

		Vector3 delta = ptr.vel * t;
		if (!ptr.bNOGRAVITY && delta.z > 0)
		{
			delta.z = 0;
		}
		Vector3 position = ptr.pos + delta;
		FLineTraceData data;
		if (ptr.LineTrace(VectorAngle(thisVel.x, thisVel.y), delta.Length(), VectorAngle(Max(Abs(thisVel.x), Abs(thisVel.y)), -thisVel.z), TRF_SOLIDACTORS, ptr.height / 2, 0, 0, data))
		{
			position = data.HitLocation - (0, 0, ptr.height / 2);
		}
		return position;
	}

	action void A_LeadTarget(float projSpeed, bool lerp = true)
	{
		if (invoker.target) invoker.LeadX(invoker.target, projSpeed, lerp);
	}

	action void A_LeadTracer(float projSpeed, bool lerp = true)
	{
		if (invoker.tracer) invoker.LeadX(invoker.tracer, projSpeed, lerp);
	}

	action void A_LeadMaster(float projSpeed, bool lerp = true)
	{
		if (invoker.master) invoker.LeadX(invoker.master, projSpeed, lerp);
	}

	action void A_FacePosition(Vector3 position)
	{
		invoker.FacePosition(position);
	}

	bool CheckFullSight(Actor target, int zOffset = 0) {
		if (target == null) return false;
		if (!IsVisible(target, false)) return false;
		for (int i = 0; i <= radius; i++) {
			for (float j = -1; j <= 1; j+=2) {
				FLineTraceData data;
				LineTrace(AngleTo(target), Distance3D(target), PitchTo(target), TRF_THRUHITSCAN|TRF_SOLIDACTORS|TRF_BLOCKSELF, (height / 2) + zOffset, 0, i * j, data);
				bool result = true;
				if (data.HitType == TRACE_HitActor) {
					result = data.HitActor.bSHOOTABLE;
				}
				else if (data.HitType == TRACE_HitFloor || data.HitType == TRACE_HitCeiling || data.HitType == TRACE_HitWall) {
					result = false;
				}
				if (!result) {
					return false;
				}
			}
		}
		return true;
	}
}

Class TargetMarker : Actor
{
	Default
	{
		+NOINTERACTION;
		+FLATSPRITE;
		Height 16;
		Radius 8;
	}
	States
	{
		Spawn:
			AMRK A 35 NoDelay;
			Stop;
	}
}

Class TargetMarker2 : TargetMarker
{
	Default
	{
		Scale 0.5;
	}
}