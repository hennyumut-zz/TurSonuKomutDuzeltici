/*
 * CS:GO - Server Commands & Cvar Resetter
 * by, Henny!
 * 
 * Copyright (C) 2016-2020 & Henny!
 *
 * This file is part of the Henny! SourceMod Plugin Package.
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>
 *
 */

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define DEBUG
#define plugintag "SM"

#define pluginname "[CSGO] Server Commands & Cvar Resetter"
#define pluginauthor "Henny!"
#define pluginversion "1.0.0"
#define pluginurl ""

public Plugin myinfo =
{
	name 	= pluginname,
	author 	= pluginauthor,
	version = pluginversion,
	url 	= pluginurl
};

public void OnPluginStart()
{
	HookEvent("round_start", roundStarted, EventHookMode_Pre);
}

public Action roundStarted(Event event, const char[] name, bool dontBroadcast)
{
	Handle cvarFF, cvarAmmo, cvarGravity, cvarRespawnT, cvarRespawnCT = INVALID_HANDLE;
	int intFF, intAmmo, intGravity, intRespawnT, intRespawnCT;
	
	cvarFF = FindConVar("mp_teammates_are_enemies");
	cvarAmmo = FindConVar("sv_infinite_ammo");
	cvarGravity = FindConVar("sv_gravity");
	cvarRespawnT = FindConVar("mp_respawn_on_death_t");
	cvarRespawnCT = FindConVar("mp_respawn_on_death_ct");
	
	if (cvarFF != INVALID_HANDLE)
		intFF = GetConVarInt(cvarFF);
		
	if (cvarAmmo != INVALID_HANDLE)
		intAmmo = GetConVarInt(cvarAmmo);
		
	if (cvarGravity != INVALID_HANDLE)
		intGravity = GetConVarInt(cvarGravity);
		
	if (cvarRespawnT != INVALID_HANDLE)
		intRespawnT = GetConVarInt(cvarRespawnT);
		
	if (cvarRespawnCT != INVALID_HANDLE)
		intRespawnCT = GetConVarInt(cvarRespawnCT);
	
	if (intFF || intAmmo || (intGravity != 800) || intRespawnT || intRespawnCT)
	{
		PrintToChatAll("\x02[%s] \x01Bir önceki turdan açık kalan kodlar \x0Fdüzeltildi.", plugintag);
		
		if (intFF)
			setCvar("mp_teammates_are_enemies", 0);
		
		if (intAmmo)
			setCvar("sv_infinite_ammo", 0);
		
		if (intGravity != 800)
			setCvar("sv_gravity", 800);
		
		if (intRespawnT)
			setCvar("mp_respawn_on_death_t", 0);
		
		if (intRespawnCT)
			setCvar("mp_respawn_on_death_ct", 0);
	}
}

public void setCvar(char cvarName[256], int cvarValue)
{
	Handle cvarHandle = FindConVar(cvarName);
	if (cvarHandle == null)
	{
		return;
	}
		
	int cvarFlags = GetConVarFlags(cvarHandle);
	
	cvarFlags &= ~FCVAR_NOTIFY;
	SetConVarFlags(cvarHandle, cvarFlags);
	SetConVarInt(cvarHandle, cvarValue);
	
	cvarFlags |= FCVAR_NOTIFY;
	SetConVarFlags(cvarHandle, cvarFlags);
}