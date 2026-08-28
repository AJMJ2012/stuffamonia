

class DevMapEvents : EventHandler
{
    Stuffamonia_Globals globals;

    array<PandInsWeapon> spawned_weapons;

    override void OnRegister()
    {
        globals = Stuffamonia_Globals.Get();
    }

    // i know i should be doing this in acs, but the script editor in udb is a mess in linux
    // and slade doesnt want to compile anything, so screw it im doing it all here
    // but it also means i have more access to things like all the weapons classes and properties and stuff
    // so thats nice i guess
    override void WorldLineActivated(WorldEvent e) 
    {
        // this just seemed easier than using a tag iterator
        // line needs some kind of special to active, so highjack thrust thing with no force, 
        // the more i go, the more cursed this gets lol
        if(e.ActivatedLine.special == 72)
        {
            // destroy any weapons that were previously spawned
            foreach(weapon : spawned_weapons)
            {
                // also dont destroy any of the weapons the player has picked up
                if(weapon && !weapon.owner)
                {
                    weapon.Destroy();
                }
            }
            spawned_weapons.Clear();

            // go through the global weapon list and spawn the weapons in the requested slot
            int tag_start = 2;
            foreach(weapon : globals.weapon_list)
            {
                if(weapon)
                {
                    class<Weapon> wep_class = weapon;
                    if(GetDefaultByType(wep_class).SlotNumber == e.ActivatedLine.args[0])
                    {
                        let wep = PandInsWeapon(Actor.Spawn(weapon, globals.TID_Find(tag_start).pos));
                        spawned_weapons.Push(wep);
                        tag_start++;
                    }
                }
            }
        }
    }
}