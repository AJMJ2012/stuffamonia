Class InsSoulSpearProjectileEx : InsSoulSpearProjectile replace InsSoulSpearProjectile
{
    prev_tri_soulspear_radius;
    prev_tri_soulspear_height;
    override void Tick()
    {
        Super.Tick();
        if(tri_soulspear_radius != prev_tri_soulspear_radius || tri_soulspear_height != prev_tri_soulspear_height)
        {
            if(tri_soulspear_radius > 0 && tri_soulspear_height > 0)
            {
                A_SetSize(tri_soulspear_radius, tri_soulspear_height);
            }
            else
            {
                A_SetSize(8, 8);
            }
            prev_tri_soulspear_radius = tri_soulspear_radius;
            prev_tri_soulspear_height = tri_soulspear_height;
        }
    }
}

Class InsSoulSpearProjectilePoweredEx : InsSoulSpearProjectilePowered replaces InsSoulSpearProjectile
{
    prev_tri_soulspear_powered_radius;
    prev_tri_soulspear_powered_height;
    override void Tick()
    {
        Super.Tick();
        if(tri_soulspear_powered_radius != prev_tri_soulspear_powered_radius || tri_soulspear_powered_height != prev_tri_soulspear_powered_height)
        {
            if(tri_soulspear_powered_radius > 0 && tri_soulspear_powered_height > 0)
            {
                A_SetSize(tri_soulspear_powered_radius, tri_soulspear_powered_height);
            }
            else
            {
                A_SetSize(10, 12);
            }
            prev_tri_soulspear_powered_radius = tri_soulspear_powered_radius;
            prev_tri_soulspear_powered_height = tri_soulspear_powered_height;
        }
    }
}
