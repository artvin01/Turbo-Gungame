#pragma semicolon 1
#pragma newdecls required

public void Spell_Setup(int client)
{
	SpawnWeapon(client, "tf_weapon_spellbook", 1069, 0, 0, {0}, NULL_VECTOR, 0);
	int iSpellbook = GetSpellbook(client);
	if (iSpellbook == -1)
		return;

	SetEntProp(iSpellbook, Prop_Send, "m_iSelectedSpellIndex", 0);
	SetEntProp(iSpellbook, Prop_Send, "m_iSpellCharges", 100);
}

public void Spell_Fire(int client)
{
	Client_ForceUseAction(client);
}

void Client_ForceUseAction(int client)
{
	KeyValues kv;
	
	kv = new KeyValues("+use_action_slot_item_server");
	FakeClientCommandKeyValues(client, kv);
	delete kv;
	
	kv = new KeyValues("-use_action_slot_item_server");
	FakeClientCommandKeyValues(client, kv);
	delete kv;
}

stock int GetSpellbook(int client)
{
	int iSpellbook = MaxClients+1;
	while ((iSpellbook = FindEntityByClassname(iSpellbook, "tf_weapon_spellbook")) != -1)
		if (IsValidEntity(iSpellbook) && GetEntPropEnt(iSpellbook, Prop_Send, "m_hOwnerEntity") == client && !GetEntProp(iSpellbook, Prop_Send, "m_bDisguiseWeapon"))
			return iSpellbook;
	
	return -1;
}