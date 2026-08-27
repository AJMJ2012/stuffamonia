Class InsSapphireWandProjectileEx : InsSapphireWandProjectile replaces InsSapphireWandProjectile
{
  States
  {
    Spawn:
        SWPR AABB 1 Bright Light("PLASMABALL")
            {
            if(tri_sapphirewand_weave) { A_Weave(2,2,1.5,1); }
            A_SpawnItemEx("PlasmaBallTrail",frandom(-1,1),frandom(-1,1),frandom(-1,1),frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
            for(user_fx = 0;user_fx<=3;user_fx++)
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(7,15),frandom(6,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,2),frandom(-1,1),frandom(-1,1),0,0,0,1,-1,-1);
            }
            Loop;
        }
}
