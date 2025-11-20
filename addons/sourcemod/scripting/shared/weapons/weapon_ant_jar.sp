#pragma semicolon 1
#pragma newdecls required

public void AntJar_Jarate(int client, int weapon, int victim)
{
	TF2_MakeBleed(victim, client, 10.0);
	RequestFrame(RemoveJarate, GetClientUserId(victim));
}

static void RemoveJarate(int userid)
{
	int client = GetClientOfUserId(userid);
	if(client)
		TF2_RemoveCondition(client, TFCond_Jarated);
}
