// The Enlightener is missing the durability converter

Class EnlightenerDurabilityConverter : PandInsDurabilityWeaponBuffer 
{
    Default
    {
        PandDurabilityWeaponBuffer.DurabilityWep "Pand_Enlightener";
    }

    States
    {
        Spawn:
            6S05 Z 1 A_ItemParticle();
            Loop;
    }
}
