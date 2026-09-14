class Pand_Expander : PandInsWeapon
{
    double glow_alpha;
    bool glow_down;
	Default
	{
		Inventory.PickupMessage "You got the \cfExpander\c-!";
		Inventory.PickupSound "HERocket/Pickup";
		Obituary "%k grew 2 sizes that day by %o's expander.";
		PandInsWeapon.MaxAugments 5;
		PandInsWeapon.MenuPic "EGUNA0";
		Tag "Expander";
		Weapon.AmmoGive 20;
		Weapon.AmmoType "NewCell";
		Weapon.AmmoUse 1;
		Weapon.BobStyle "Smooth";
		Weapon.SlotNumber 6;
		Weapon.SlotPriority -1;
		Weapon.UpSound "HERocket/Up";
        Scale 0.5;
	}
    override string Pand_WeaponInfo()
    {
let minfo =
"The \cfExpander\c- is a cell weapon that causes enemies to exapnd and explode, hurting everything around it

Augments act different for this gun, none of them effect the weapon itself, only the expanding enemies.

The damage dealt by the exploding enemy is based on half their starting health.

The Strength augment effects the explosion's radius.
The Blast augment effects the explosion's damage.
The Haste augment effects expansion speed.
The Precision augment has no effect.
The Chaos augment will spawn a significant number of chaos projectiles from the explosion.
The Flame augment will spray out a radius of fire, effected by strength augment radius upgrades.
The Scavenge augment will cause a significant increase in drops of random ammos.
The Superior version will cause any enemies killed by the explosion to also expand and explode, causing a chain reaction.

\c-";
return minfo;
    }

	States
	{
	    Ready:
	    	DUK7 A 1
            {
                A_WeaponReady();
                A_ExpanderGlow();
            }
	    	Loop;
	    Deselect:
	    	DUK7 A 1
            {
                A_Lower();
                A_ExpanderGlow();
            }
	    	Loop;
	    Select:
	    	DUK7 A 1
            {
                A_Raise();
                A_ExpanderGlow();
            }
	    	Loop;
	    Fire:
            DUK7 A 0 A_ExpanderFire();
	    	DUK7 BBBBBA 1 A_OverlayOffset(PSP_WEAPON, frandom(-1, 1), 32+frandom(-1, 1));
	    	DUK7 A 5
            {
                A_OverlayOffset(PSP_WEAPON, 0, 32);
                A_ReFire();
            }
	    	Goto Ready;

	    Crystal:
	    	DUK7 C 1 bright;
	    	Loop;

	    CrystalBack:
	    	DUK6 G 1;
	    	Loop;

        CrystalFire:
            DUK7 DEF 1;
            Loop;

	    Spawn:
	    	EGUN A -1;
	    	Stop;

        DeadLowered:
            DUK7 A -1
            {
                A_Overlay(-2, "null");
                A_Overlay(-3, "null");
            }
            Stop;
	}


    action void A_ExpanderFire()
    {
        A_Overlay(-2, "CrystalFire");
        A_OverlayAlpha(-2, 1.0);
        A_OverlayOffset(PSP_WEAPON, frandom(-1, 1), 32+frandom(-1, 1));
        A_StartSound("Expander/Fire", 1, CHANF_DEFAULT, 0.2);
        A_FireBullets(3, 3, 1, 15, "GrowPuff");
    }

    action void A_ExpanderGlow()
    {
        A_Overlay(-2, "Crystal");
        A_OverlayFlags(-2, PSPF_FORCEALPHA, true);
        A_Overlay(-3, "CrystalBack");
        if(!invoker.glow_down)
        {
            invoker.glow_alpha += 0.05;
            if(invoker.glow_alpha >= 1)
            {
                invoker.glow_down = true;
            }
        }
        else
        {
            invoker.glow_alpha -= 0.05;
            if(invoker.glow_alpha <= 0)
            {
                invoker.glow_down = false;
            }
        }
        A_OverlayAlpha(-2, invoker.glow_alpha);
    }
}

Class GrowPuff : BulletPuff
{
    bool scaledown;
    Default
    {
        Scale 0.05;
        VSpeed 0;
        DamageType "Grow";
        Alpha 1;
        RenderStyle "Add";
        -ZDOOMTRANS;
        -ALLOWPARTICLES;
        +PUFFONACTORS;
    }
    States
    {
    	Spawn:
		GROW ABCD 4 Bright;
        Loop;
    }

    override void Tick()
    {
        Super.Tick();
        if(!scaledown)
        {
            scale.x += 0.05;
            scale.y += 0.05;
            if(scale.x >= 0.5)
            {
                scaledown = true;
            }
        }
        else
        {
            scale.x -= 0.05;
            scale.y -= 0.05;
            if(scale.x <= 0)
            {
                A_Remove(AAPTR_DEFAULT, RMVF_EVERYTHING);
            }
        }
    }
}