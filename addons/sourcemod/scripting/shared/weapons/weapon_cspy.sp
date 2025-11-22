#pragma semicolon 1
#pragma newdecls required
static int KnifeUp;

public void CSpy_Effects(int client)
{
	KnifeUp++;
	if(KnifeUp >= (GetRandomInt(5,10)))
	{
		KnifeUp = 0;
		switch(GetRandomInt(1,6))
		{
			case 1:
			{
				TF2_AddCondition(client, TFCond_CritCola, 2.0, 0);
			}
			case 2:
			{
				TF2_AddCondition(client, TFCond_Ubercharged, 2.0, 0);
			}
			case 3:
			{
				TF2_AddCondition(client, TFCond_Stealthed, 2.0, 0);
			}
			case 4:
			{
				TF2_AddCondition(client, TFCond_Kritzkrieged, 2.0, 0);
			}
			case 5:
			{
				TF2_AddCondition(client, TFCond_Buffed, 2.0, 0);
			}
			case 6:
			{
				TF2_AddCondition(client, TFCond_SpeedBuffAlly, 2.0, 0);
			}
		}
	}
}