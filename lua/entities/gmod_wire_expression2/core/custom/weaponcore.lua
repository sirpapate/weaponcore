E2Lib.RegisterExtension("weaponcore", true)

local sbox_E2_Dmg_Adv = CreateConVar( "sbox_E2_WeaponCore_allow_all_users", "0", FCVAR_ARCHIVE )

local function isFriend(owner, player)
	if owner == player then
		return true
	end

    if CPPI then
		for _, friend in pairs(player:CPPIGetFriends()) do
			if friend == owner then
				return true
			end
		end

		return false
    else
        return E2Lib.isFriend(owner, player)
    end
end

local function ValidPly( ply )
	if not ply or not ply:IsValid() or not ply:IsPlayer() then
		return false
	end
	return true
end

local function hasAccess(ply, target)
	if sbox_E2_Dmg_Adv:GetInt() == 1 then
		if isFriend(ply, target) then
			return true
		end
	else
		if ply:IsAdmin() then
			return true
		end
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

--- Give the player a weapon.
[deprecated = "Use the plyGiveWeapon method instead"]
e2function void entity:plyGive(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:Give(weaponClass)
end

--- Give the player a weapon.
e2function void entity:plyGiveWeapon(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:Give(weaponClass)
end

--- Gives ammo to a player.
e2function void entity:plyGiveAmmo(string ammoType, number amount)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:GiveAmmo(amount, ammoType, false)
end

--- Sets the amount of of the specified ammo for the player.
e2function void entity:plySetAmmo(string ammoType, number amount)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:SetAmmo(amount, type)
end

--- Sets the player active weapon.
e2function void entity:plySelectWeapon(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:SelectWeapon(weaponClass)
end

--- Drops the player's weapon of a specific class.
e2function void entity:plyDropWeapon(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end
	
	this:DropNamedWeapon(weaponClass)
end

--- Forces the player to drop the specified weapon.
e2function void entity:plyDropWeapon(entity weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end
	
	this:DropWeapon(weapon)
end

--- Removes the specified weapon class from a certain player.
e2function void entity:plyStripWeapon(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:StripWeapon(weaponClass)
end

--- Removes the specified weapon from a certain player
e2function void entity:plyStripWeapon(entity weapon)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:StripWeapon(weapon:GetClass())
end

--- Removes all weapons from a certain player
e2function void entity:plyStripWeapons()
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:StripWeapons()
end

--- Removes all ammo from the player.
e2function void entity:plyStripAmmo()
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end

	this:StripAmmo()
end

--- Lets you change the number of bullets in the given weapons primary clip.
e2function void entity:plySetClip1(number amount)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end
	if not (this:IsWeapon() or this:IsPlayer()) then return end

	local weap = this
	if this:IsPlayer() then
		weap = this:GetActiveWeapon()
	end

	weap:SetClip1(amount)
end

--- Lets you change the number of bullets in the given weapons secondary clip.
e2function void entity:plySetClip2(number amount)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end
	if not hasAccess(self.player, this) then return self:throw("You do not have access", nil) end
	if not (this:IsWeapon() or this:IsPlayer()) then return end

	local weap = this
	if this:IsPlayer() then
		weap = this:GetActiveWeapon()
	end

	weap:SetClip2(amount)
end

--- Returns the weapon entity whit the class.
e2function entity entity:getWeapon(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end

	return getWeaponByClass(this, weaponClass)
end

--- Returns a table of the player's weapons.
e2function array entity:getWeapons()
	if not ValidPly(this) then return self:throw("Invalid player", nil) end

	return this:GetWeapons()
end

--- Returns if the player has the specified weapon.
e2function number entity:hasWeapon(string weaponClass)
	if not ValidPly(this) then return self:throw("Invalid player", nil) end

	return this:HasWeapon(weaponClass)
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
 
--- If set to 1, the chip will be executed when the player switches weapons.
[deprecated = "Use the weaponSwitch event instead"]
e2function void runOnWeaponSwitch(activate)
	if activate ~= 0 then
		registered_e2s_switch[self.entity] = true
	else
		registered_e2s_switch[self.entity] = nil
	end
end

--- Returns 1 if the player has switched weapons.
[nodiscard, deprecated = "Use the weaponSwitch event instead"]
e2function number weaponSwitchClk()
	return weaponswitchclk
end

--- Returns the player that switched weapons.
[nodiscard, deprecated = "Use the weaponSwitch event instead"]
e2function entity lastWeaponSwitchPlayer()
	return weaponPly
end

--- Returns the weapon the player switched from.
[nodiscard, deprecated = "Use the weaponSwitch event instead"]
e2function entity lastWeaponSwitchOld()
	return weaponOld
end

--- Returns the weapon the player switched to.
[nodiscard, deprecated = "Use the weaponSwitch event instead"]
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

--- Is set to 1, E2 will run when a player equips a weapon.
[deprecated = "Use the weaponEquip event instead"]
e2function void runOnWeaponEquip(activate)
	if activate ~= 0 then
		registered_e2s_equip[self.entity] = true
	else
		registered_e2s_equip[self.entity] = nil
	end
end

--- Returns 1 if the E2 is run because of a weapon equip.
[nodiscard, deprecated = "Use the weaponEquip event instead"]
e2function number weaponEquipClk()
	return weaponequipclk
end

--- Returns the last equipped weapon.
[nodiscard, deprecated = "Use the weaponEquip event instead"]
e2function entity lastWeaponEquip()
	return weaponEquiped
end