version "4.10.0"


//Class InsShotgunSpawnerEx : PandRandomSpawner replaces Shotgun
//{
//    Default
//    {
//        DropItem "Pand_Shotgun", 0, 100;
//        DropItem "Pand_SlugShotgun", 0, 50;
//        DropItem "Pand_AutoShotgun", 0, 20;
//        DropItem "Pand_MysticSword", 0, 20;
//        DropItem "Pand_RiotShotgun", 15, 15;
//        DropItem "InsRareAsFuckWeaponSpawn", 80, 2;
//    }
//}

// pandemonia patches
#include "zscript/extractor/extractor.zs"
#include "zscript/weapons/enlightener.zs"
#include "zscript/weapons/sapphirewand.zs"
//#include "zscript/weapons/mysticsword.zs"
//#include "zscript/augment_menu.zs"

/*
class ReplacerEvent : EventHandler
{
    override void CheckReplacement (ReplaceEvent e)
    {
        if (e.Replacee.GetClassName() == "Pand_Shotgun" ||
            e.Replacee.GetClassName() == "Pand_SlugShotgun" ||
            e.Replacee.GetClassName() == "Pand_AutoShotgun" ||
            e.Replacee.GetClassName() == "Pand_RiotShotgun")
        {
            if(random(0, 256) < 10)
            {
                e.Replacement = 'Pand_MysticSword';
            }
        }
    }

    override void PlayerSpawned(PlayerEvent e)
    {
        if(pan_pistolstartbehavior == 1)
        {
            PlayerInfo player = players[e.PlayerNumber];
            for (let probe = player.mo.inv; probe != NULL; probe = probe.Inv)
            {
                let ammoitem = Ammo(probe);

                if (ammoitem && ammoitem.GetParentAmmo() == ammoitem.GetClass())
                {
                    if (ammoitem.Amount < ammoitem.MaxAmount || sv_unlimited_pickup)
                    {
                        int amount = ammoitem.Default.BackpackAmount;
                        ammoitem.Amount += amount;
                        if (ammoitem.Amount > ammoitem.MaxAmount && !sv_unlimited_pickup)
                        {
                            ammoitem.Amount = ammoitem.MaxAmount;
                        }
                        ammoitem.AttachToOwner(player.mo);
                    }
                }
            }
        }
    }
}

*/