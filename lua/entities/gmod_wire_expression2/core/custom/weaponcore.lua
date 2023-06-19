E2Lib.RegisterExtension("weaponcore", false)

local function ValidPly( ply )
	if not ply or not ply:IsValid() or not ply:IsPlayer() then
		return false
	end
	return true
end

local function hasAccess(ply)
	if ply:IsAdmin() then
		return true
	end
	return false
end

local function getWeaponByClass(ply, weap)
	for k,v in pairs(ply:GetWeapons()) do
		if v:GetClass() == weap then
			return v
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------

e2function void entity:plyGive(string weaponid)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:Give(weaponid)
end

e2function void entity:plyGiveAmmo(string ammotype, number count)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:GiveAmmo(count, ammotype, false)
end

e2function void entity:plySetAmmo(string ammotype, number count)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:SetAmmo(count, type)
end

-----
e2function void entity:plySelectWeapon(string weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:SelectWeapon(weapon)
end

-----
e2function void entity:plyDropWeapon(string weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end
	
	this:DropNamedWeapon(weapon)
end

e2function void entity:plyDropWeapon(entity weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end
	
	this:DropWeapon(weapon)
end

-----
e2function void entity:plyStripWeapon(string weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:StripWeapon(weapon)
end

e2function void entity:plyStripWeapon(entity weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:StripWeapon(weapon:GetClass())
end

e2function void entity:plyStripWeapons()
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:StripWeapons()
end

e2function void entity:plyStripAmmo()
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end

	this:StripAmmo()
end

e2function void entity:plySetClip1(ammo)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end
	if not (this:IsWeapon() or this:IsPlayer()) then return end

	local weap = this
	if this:IsPlayer() then
		weap = this:GetActiveWeapon()
	end

	weap:SetClip1(ammo)
end

e2function void entity:plySetClip2(ammo)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player) then return self:throw("You do not have access", nil) end
	if not (this:IsWeapon() or this:IsPlayer()) then return end

	local weap = this
	if this:IsPlayer() then
		weap = this:GetActiveWeapon()
	end

	weap:SetClip2(ammo)
end

e2function entity entity:getWeapon(string class)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end

	return getWeaponByClass(this, class)
end

e2function array entity:getWeapons()
	if not ValidPly(this) then return self:throw("Invalid player", nil) end

	return this:GetWeapons()
end


e2function number entity:hasWeapon(string weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end

	return this:HasWeapon(weapon)
end

------------------------------------------------------------------------------
local registered_e2s_switch = {}
local weaponPly = nil
local weaponOld = nil
local weaponNext = nil
local weaponswitchclk = 0

E2Lib.registerEvent("weaponSwitch", {
	{ "Player", "e" },
	{ "OldWeapon", "e" },
	{ "NewWeapon", "e" }
})
 
registerCallback("destruct",function(self)
		registered_e2s_switch[self.entity] = nil
end)

hook.Add("PlayerSwitchWeapon","Expresion2PlayerSwitchWeapon", function(ply, oldWeapon, newWeapon)
	for ent,_ in pairs(registered_e2s_switch) do
		weaponPly = ply
		weaponOld = oldWeapon
		weaponNext = newWeapon

		weaponswitchclk = 1
		ent:Execute()
		weaponswitchclk = 0
	end

	E2Lib.triggerEvent("weaponSwitch", {ply, oldWeapon, newWeapon})
end)
 
e2function void runOnWeaponSwitch(activate)
	if activate ~= 0 then
		registered_e2s_switch[self.entity] = true
	else
		registered_e2s_switch[self.entity] = nil
	end
end
 
e2function number weaponSwitchClk()
	return weaponswitchclk
end

e2function entity lastWeaponSwitchPlayer()
	return weaponPly
end

e2function entity lastWeaponSwitchOld()
	return weaponOld
end

e2function entity lastWeaponSwitchNext()
	return weaponNext
end


------------------------------------------------------------------------------
local registered_e2s_equip = {}
local weaponEquiped = nil
local weaponequipclk = 0

E2Lib.registerEvent("weaponEquip", {
	{ "Player", "e" },
	{ "Weapon", "e" },
	{ "OnSpawn", "n" }
})

E2Lib.registerEvent("weaponDrop", {
	{ "Player", "e" },
	{ "Weapon", "e" }
})

registerCallback("destruct",function(self)
	registered_e2s_equip[self.entity] = nil
end)

local lastPlayerSpawn = {}

hook.Add("PlayerSpawn", "Exp2WpPlayerSpawn", function(player)
	lastPlayerSpawn[player] = CurTime()
end)

hook.Add("PlayerInitialSpawn", "Exp2WpPlayerSpawn", function(player)
	lastPlayerSpawn[player] = CurTime()
end)

hook.Add("PlayerDisconnected", "Exp2WpPlayerDisconnected", function(player)
	lastPlayerSpawn[player] = nil
end)

hook.Add("WeaponEquip","Expresion2WeaponEquip", function(weapon, ply)
	timer.Simple(0, function()
		for ent,_ in pairs(registered_e2s_equip) do
			weaponEquiped = weapon

			weaponequipclk = 1
			ent:Execute()
			weaponequipclk = 0
		end

		E2Lib.triggerEvent("weaponEquip", {ply, weapon, (CurTime() - (lastPlayerSpawn[ply] or 0)) < 0.1 and 1 or 0})
	end)
end)

hook.Add('PlayerDroppedWeapon', 'Expresion2PlayerDroppedWeapon', function(ply, weapon)
	E2Lib.triggerEvent("weaponDrop", {ply, weapon})
end)

e2function void runOnWeaponEquip(activate)
	if activate ~= 0 then
		registered_e2s_equip[self.entity] = true
	else
		registered_e2s_equip[self.entity] = nil
	end
end
 
e2function number weaponEquipClk()
	return weaponequipclk
end


e2function entity lastWeaponEquip()
	return weaponEquiped
end