#pragma semicolon 1
#pragma newdecls required

public void Weapon_FuckedupLauncherShoot(int client, int weapon, bool crit)
{
	float damage = 75.0;
	damage *= Attributes_Get(weapon, 2, 1.0);
	
	//This spawns the projectile, this is a return int, if you want, you can do extra stuff with it, otherwise, it can be used as a void.
	int projectile = Wand_Projectile_Spawn(client, -1250.0, 10.0, damage, 0, weapon, "");
	WandProjectile_ApplyFunctionToEntity(projectile, FuckTouch);
	ApplyCustomModelToWandProjectile(projectile, "models/weapons/w_missile.mdl", 1.15, "scythe_spin");
}

public void FuckTouch(int entity, int target)
{
	static float Entity_Position[3];
	int particle = EntRefToEntIndex(i_WandParticle[entity]);
	if (target > 0)	
	{
		//Code to do damage position and ragdolls
		static float angles[3];
		GetEntPropVector(entity, Prop_Send, "m_angRotation", angles);
		float vecForward[3];
		GetAngleVectors(angles, vecForward, NULL_VECTOR, NULL_VECTOR);
		WorldSpaceCenter(target, Entity_Position);


		//float Dmg_Force[3]; CalculateDamageForce(vecForward, 10000.0, Dmg_Force);
		//SDKHooks_TakeDamage(target, owner, owner, f_WandDamage[entity], DMG_PLASMA, weapon, Dmg_Force, Entity_Position);	// 2048 is DMG_NOGIB?
		TF2_Explode(entity, Entity_Position, 100.0, 120.0, "ExplosionCore_MidAir", "weapons/explode1.wav");
		if(IsValidEntity(particle))
		{
			RemoveEntity(particle);
			TF2_Explode(entity, Entity_Position, 100.0, 120.0, "ExplosionCore_MidAir", "weapons/explode1.wav");
		}
		RemoveEntity(entity);
	}
	else if(target == 0)
	{
		if(IsValidEntity(particle))
		{
			RemoveEntity(particle);
			TF2_Explode(entity, Entity_Position, 100.0, 120.0, "ExplosionCore_MidAir", "weapons/explode1.wav");
		}
		RemoveEntity(entity);
	}
}