#pragma semicolon 1
#pragma newdecls required


static Handle Local_Timer[MAXPLAYERS] = {null, ...};
public void KamikazeMapStart()
{
	PrecacheSound("mvm/mvm_tank_explode.wav");
}
public void KamikazteForceTaunt(int client, int weapon, bool crit, int slot)
{
	FakeClientCommand(client, "taunt");
}
public void KamikazeCreate(int client, int weapon)
{
	if (Local_Timer[client] != null)
	{
		delete Local_Timer[client];
		Local_Timer[client] = null;
	}

	DataPack pack;
	Local_Timer[client] = CreateDataTimer(0.1, Timer_Local, pack, TIMER_REPEAT);
	pack.WriteCell(client);
	pack.WriteCell(EntIndexToEntRef(client));
	pack.WriteCell(EntIndexToEntRef(weapon));
}

static Action Timer_Local(Handle timer, DataPack pack)
{
	pack.Reset();
	int clientidx = pack.ReadCell();
	int client = EntRefToEntIndex(pack.ReadCell());
	int weapon = EntRefToEntIndex(pack.ReadCell());
	if(!IsValidClient(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || !IsValidEntity(weapon))
	{
		Local_Timer[clientidx] = null;

		return Plugin_Stop;
	}	
	if (TF2_IsPlayerInCondition(client, TFCond_Taunting))
	{
		Local_Timer[clientidx] = null;
		//1.5 seconds very accurate
		DataPack pack1 = new DataPack();
		pack1.WriteCell(EntIndexToEntRef(client));
		pack1.WriteCell(EntIndexToEntRef(weapon));
		RequestFrames(Kamikaze_ExplodeMeNow, RoundToNearest(66.0 * 1.0), pack1);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}


void Kamikaze_ExplodeMeNow(DataPack pack)
{
	pack.Reset();
	int client = EntRefToEntIndex(pack.ReadCell());
	int weapon = EntRefToEntIndex(pack.ReadCell());
	if(!IsValidClient(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || !IsValidEntity(weapon))
	{
		return;
	}
	if (!TF2_IsPlayerInCondition(client, TFCond_Taunting))
	{
		return;
	}
	
	static float startPosition[3];
	WorldSpaceCenter(client, startPosition);
	TF2_Explode(client, startPosition, 1000.0, 100.0, "hightower_explosion", "common/null.wav");
	EmitSoundToAll("mvm/mvm_tank_explode.wav", client, SNDCHAN_STATIC, 90, _, 0.8);
}