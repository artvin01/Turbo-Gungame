#pragma semicolon 1
#pragma newdecls required



enum struct ItemInfo
{
	bool HasNoClip;
	int Reload_ModeForce;
	float WeaponScore;
	char Classname[36];
	char Desc[256];

	int Index;
	int Attrib[32];
	float Value[32];
	int Attribs;
	float WeaponSizeOverride;
	float WeaponSizeOverrideViewmodel;
	char WeaponModelOverride[128];
	int Weapon_Bodygroup;
	int WeaponModelIndexOverride;

	Function FuncAttack;
	Function FuncAttack2;
	Function FuncAttack3;
	Function FuncReload4;
	void Self(ItemInfo info)
	{
		info = this;
	}

	
	bool SetupKV(KeyValues kv, const char[] name, const char[] prefix="")
	{
		static char buffer[512];
		
		
		Format(buffer, sizeof(buffer), "%sdesc", prefix);
		kv.GetString(buffer, this.Desc, 256);
		
		Format(buffer, sizeof(buffer), "%sclassname", prefix);
		kv.GetString(buffer, this.Classname, 36);

		Format(buffer, sizeof(buffer), "%sscore", prefix);
		this.WeaponScore = kv.GetFloat(buffer, 0.0);
		
		Format(buffer, sizeof(buffer), "%sindex", prefix);
		this.Index = kv.GetNum(buffer);
		
		Format(buffer, sizeof(buffer), "%sreload_mode", prefix);
		this.Reload_ModeForce = kv.GetNum(buffer);
		
		Format(buffer, sizeof(buffer), "%sno_clip", prefix);
		this.HasNoClip				= view_as<bool>(kv.GetNum(buffer));
		
		Format(buffer, sizeof(buffer), "%smodel_weapon_override", prefix);
		kv.GetString(buffer, this.WeaponModelOverride, sizeof(buffer));

		Format(buffer, sizeof(buffer), "%sweapon_bodygroup", prefix);
		this.Weapon_Bodygroup	= kv.GetNum(buffer, -1);

		Format(buffer, sizeof(buffer), "%sweapon_custom_size", prefix);
		this.WeaponSizeOverride			= kv.GetFloat(buffer, 1.0);

		Format(buffer, sizeof(buffer), "%sweapon_custom_size_viewmodel", prefix);
		this.WeaponSizeOverrideViewmodel			= kv.GetFloat(buffer, 1.0);

		if(this.WeaponModelOverride[0])
		{
			this.WeaponModelIndexOverride = PrecacheModel(this.WeaponModelOverride, true);
		}
		else
		{
			this.WeaponModelIndexOverride = 0;
		}
	
		
		Format(buffer, sizeof(buffer), "%sfunc_attack", prefix);
		kv.GetString(buffer, buffer, sizeof(buffer));
		this.FuncAttack = GetFunctionByName(null, buffer);
		
		Format(buffer, sizeof(buffer), "%sfunc_attack2", prefix);
		kv.GetString(buffer, buffer, sizeof(buffer));
		this.FuncAttack2 = GetFunctionByName(null, buffer);
		
		Format(buffer, sizeof(buffer), "%sfunc_attack3", prefix);
		kv.GetString(buffer, buffer, sizeof(buffer));
		this.FuncAttack3 = GetFunctionByName(null, buffer);
		
		Format(buffer, sizeof(buffer), "%sfunc_attack4", prefix);
		kv.GetString(buffer, buffer, sizeof(buffer));
		this.FuncReload4 = GetFunctionByName(null, buffer);
		
		
		static char buffers[64][16];
		Format(buffer, sizeof(buffer), "%sattributes", prefix);
		kv.GetString(buffer, buffer, sizeof(buffer));
		this.Attribs = ExplodeString(buffer, ";", buffers, sizeof(buffers), sizeof(buffers[])) / 2;
		for(int i; i < this.Attribs; i++)
		{
			this.Attrib[i] = StringToInt(buffers[i*2]);
			if(!this.Attrib[i])
			{
				LogMessage("Found invalid attribute on '%s'", name);
				this.Attribs = i;
				break;
			}
			
			this.Value[i] = StringToFloat(buffers[i*2+1]);
		}


		return true;
	}
}
/*
	"weapons"
	{
		"SMG"	//Weapon name for inside and translations
		{
			"score"							"1.0"										 //1.0 means its pretty very OP, 0.0 means its very garbage
			"classname"						"tf_weapon_bonesaw"
			"attributes"					"2 ; 2.2 ; 6 ; 0.7"
			"index"							"198"   


			"func_attack"					"Fusion_Melee_Empower_StatePre"		//m1 attack
			//idealy these shouldnt be used often
			"func_attack2"					"Fusion_Melee_Empower_StatePre"		//m2
			"func_attack2"					"Fusion_Melee_Empower_StatePre"		//R
			"func_attack4"					"Fusion_Melee_Empower_StatePre"		//M3??

			"model_weapon_override"			"models/zombie_riot/weapons/custom_weaponry_1_52.mdl"
			"weapon_bodygroup"				"1024"
			"weapon_custom_size_viewmodel"  "0.8"
			"weapon_custom_size"			"1.4"
			"ability_onequip"				"0"	
			"no_clip"						"0"
 			"reload_mode"					"1"  //1 means entire clip, 2 means one at a time. default is whatever the weapon had as a norm.
			//This will override the weapon third and first person model.
			"viewmodel_force_class"		"8"
		}

	}

*/
static ArrayList WeaponList;
void Weapons_ConfigsExecuted()
{
	
	if(StoreItems)
		delete StoreItems;
	
	StoreItems = new ArrayList(sizeof(Item));
	
	char buffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, buffer, sizeof(buffer), CONFIG_CFG, "weapons");
	KeyValues kv = new KeyValues("Weapons");
	kv.SetEscapeSequences(true);
	kv.ImportFromFile(buffer);

	
	kv.GotoFirstSubKey();
	do
	{
		ConfigSetup(-1, kv);
	} while(kv.GotoNextKey());
}


static void ConfigSetup(int section, KeyValues kv)
{
	char buffer[128], buffers[12][32];
		
		
	StoreItems.PushArray(item);
	else if(kv.GotoFirstSubKey())
	{
		item.Slot = -1;
		int sec = StoreItems.PushArray(item);
		
		do
		{
			ConfigSetup(sec, kv);
		}
		while(kv.GotoNextKey());
		kv.GoBack();
	}
}