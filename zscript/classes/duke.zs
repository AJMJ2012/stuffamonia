
/*
    Duke Nukem Class Ideas:

    Slot 1:
        Name:       Mighty Foot
        Ammo:       None
        Special:    Significant Knockback?

    Slot 2:
        Name:       Glock 17
        Ammo:       Clips
        Special:    Golden Eagle? No Reloading?

    Slot 3:
        Name:       Winchester 1300 Defender
        Ammo:       Shells
        Special:    Always Pain Chance enemies?

    Slot 4:
        Name:       Ripper
        Ammo:       Clips
        Special:    All 3 Barrels Shoot at the same time?

    Slot 5:
        Name:       RPG
        Ammo:       Rockets
        Special:    Rockets follow player's aim?

        ------------------------

        Name:       Pipebomb
        Ammo:       Rockets
        Limit:      Can only throw 1 at a time
        Special:    Can throw as many as you want
        Notes:      Precision augments increase throw distance?

        ------------------------

        Name:       Devastator
        Ammo:       Rockets(2 rockets per 1 ammo)
        Special:    4 rockets per barrel instead of 2?

        ------------------------

        Name:       Trip Bomb
        Ammo:       Rockets
        Limits:     Precision augments can't be used
        Special:    Entire line explodes instead of the bomb itself?

    Slot 6:
        Name:       Expander
        Ammo:       Cells
        Special:    Exploding Enemies shoot out more expander hitscans
                    Causing a chance for expanding enemy chain reactions

        ------------------------

        Name:       Freezer
        Ammo:       Cells
        Limits:     Doesnt bounce?
        Special:    Bounces?

    Slot 7 or 8:
        Name:       Shrink Ray
        Ammo:       None, durability is ammo
        Limits:     Can't directly kill
        Special:    Radius that can shrink multiple targets?
        Notes:      Insanely overpowered
                    slot 7 might even go in slot 8
                    might not allow augments
                    maybe remnants
                    might even be a durability weapon, durability is losts on monster health
                    might have it so it only shoots 1 shot, but uses all the cells you have,
                        depending on how many cells you have directly relates to how much radius it has to shrink multiple monsters
                        if its maxed out at 198 with backpack, you get one shot to shrink bosses
        ------------------------
*/

Class DukeNukem_Buff : Pand_InsClassBuff
{
    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
        if(Owner && passive && damage > 0)
        {
            // player has armor, do nothing
            if(Owner.CountInv("PandBasicArmor") > 0) { return; }

            // player armor is depleted, 17.5% damage reduction(half of the reduction the weakest armor would give you)
            newdamage = damage * 0.825;
        }
	}
}

Class DukeNukem_Class : Pand_BasePlayerClass
{
    Default
    {
        Inventory.Icon "DUKEMENU";
        Tag "Duke Nukem";
        Pand_BasePlayerClass.ClassTitle "Alien Ass Kicker";
        Pand_BasePlayerClass.SetSkin "Duke";
        Pand_BasePlayerClass.SelectWep "Duke_Pistol";
    }

    override void GivePlayerStuff()
    {
        Owner.GiveInventory("Duke_Pistol", 1);
        Owner.GiveInventory("NewClip",48);
        Owner.GiveInventory("DukeNukem_Buff", 1);
        Owner.GiveInventory("TheMightyFoot", 1);
        Owner.SetAmmoCapacity("NewClip",200);
        Owner.SetAmmoCapacity("NewShell",50);
        Owner.SetAmmoCapacity("NewRocketAmmo",50);
        Owner.SetAmmoCapacity("NewCell",99);
        Owner.SetAmmoCapacity("PandHellfireAmmo",200);
        Owner.SetAmmoCapacity("PandDemonBloodAmmo",200);
    }

override string Pand_ClassInfo()
{
return "Starts with:
\c[v7]Mighty Foot, A very strong knockback melee
\c[v7]Glock 17\c-
48 Bullets

Abilities:
\c[90]+17.5% damage reduction when armor is depleted
\c[90]+5% increased damage and accuracy when using his own weapons
\c[v7]Shoulder cannons replaced with the Mighty Foot
\c[z9]-33% max cell capacity
\c[z9]Berserk has no effect on kicks";
}

override string Pand_ClassLore()
{
return "Duke Nukem is a tough, foul-mouthed, ego fueled, interstellar action hero from another universe.

Through some kind of nonsense, Duke and his items have been transported here to take on hell.

Some of the local gear doesn't quite make sense in his hands and some of his weapons have taken on different properties from this universe.";
}

}

// this sure is a hack lol
class TheMightyFoot_Button : EventHandler
{
    override bool InputProcess(InputEvent e)
    {
        // player exists
        if(players[consoleplayer].mo)
        {
            // player is duke class
            if(players[consoleplayer].mo.FindInventory("DukeNukem_Buff"))
            {
                // player is alive
                if(players[consoleplayer].mo.health > 0)
                {
                    // shoulder cannon button
                    if(Bindings.GetBinding(e.KeyScan) == "Pand_UseShoulder")
                    {
                        if(e.type == InputEvent.Type_KeyDown)
                        {
                            EventHandler.SendNetworkEvent("TheMightyFoot", 1);
                        }
                        else if(e.type == InputEvent.Type_KeyUp)
                        {
                            EventHandler.SendNetworkEvent("TheMightyFoot", 0);
                        }
                    }
                }
            }
        }
        return false;
    }

	override void NetworkProcess(ConsoleEvent e)
	{
        if (e.name == "TheMightyFoot")
        {
			if (e.IsManual || !PlayerInGame[e.Player] || !(players[e.Player].mo)) { return; }
            let foot = TheMightyFoot(players[e.Player].mo.FindInventory("TheMightyFoot"));
            if(foot)
            {
                switch(e.args[0])
                {
                    case 1:
                        if(!foot.kicking)
                        {
                            foot.kicking = true;
                            foot.Use(false);
                        }

                        break;
                    case 0:
                        foot.stopkicking = true;
                        break;
                }
            }
        }
	}
}

Class TheMightyFoot : CustomInventory
{
    bool kicking;
    bool stopkicking;
    Default
    {
        +INVENTORY.ALWAYSPICKUP;
        +INVENTORY.UNDROPPABLE;
        +INVENTORY.KEEPDEPLETED;
        +INVENTORY.UNCLEARABLE;
    }
    States
    {
        Spawn:
            TNT1 A -1;
            Stop;

        Use:
            TNT1 A 0 
            {
                A_Overlay(-1337, "Kick"); 
            }
            Fail;

        Kick:
            DUK0 A 7;
            // pand's fist damage is 20 normally, 100 berserk, 70 range
            DUK0 B 5 A_CustomPunch(90, true, CPF_PULLIN, "FistPuff", 100);
            DUK0 A 7;
            DUK0 A 0
            {
                if(invoker.stopkicking)
                {
                    if(invoker.kicking)
                    {
                        invoker.stopkicking = false;
                    }
                    else
                    {
                        A_Overlay(-1337, "StopKicking");
                    }
                }
            }
            Loop;

        StopKicking:
            DUK0 A 0
            {
                invoker.stopkicking = false;
                invoker.kicking = false;
            }
            Stop;
    }
}


// replace the shouldercannon with one that will not let the duke class pick it up
// any other class picks this up and is given the original shouldercannon item
// the shoulder cannon class is very complex and inheriting it isnt enough
class ShoulderCannonGiver : Inventory replaces ShoulderCannon
{
    States
    {
        Spawn:
            SCNN Z -1;
            Stop;
    }
    override bool TryPickup(in out actor toucher)
	{
        if(toucher.FindInventory("DukeNukem_Buff"))
        {
            return false;
        }
        else
        {
            Super.TryPickup(toucher);
            toucher.GiveInventory("ShoulderCannon", 1);
            GoAwayAndDie();
            return false;
        }
	}
}












