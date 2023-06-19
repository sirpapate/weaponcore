# WeaponCore

WeaponCore is an extension for the [Expression 2][Expression 2] chip that allows you to manipulate weapons and ammo. It also allows you to run code when a player switches weapons or equips a weapon.

## Workshop Installation

The WeaponCore is available on the Steam Workshop! Go to the [WeaponCore Workshop Page][WeaponCore Workshop Page] and press `Subscribe`. For can go to the [Expression 2 Core Collection][Expression 2 Core Collection] for more extensions.

## Manual Installation

Clone this repository into your `steamapps\common\GarrysMod\garrysmod\addons` folder using this command if you are using git:

    git clone https://github.com/sirpapate/weaponcore.git

## Documentation

### Console Commands

`sbox_E2_WeaponCore_allow_all_users`

If set to 1, all users will be able to use the WeaponCore on there prop protection friends or themselves. If set to 0, only admins will be able to use the WeaponCore.

default: 0

### Events

| Declaration                                                             | Replacing                          |                                           |
|-------------------------------------------------------------------------|------------------------------------|-------------------------------------------|
| `event weaponSwitch(Player:entity, OldWeapon:entity, NewWeapon:entity)` | runOnWeaponSwitch, weaponSwitchClk | Triggered when a player switches weapons. |
| `event weaponEquip(Player:entity, Weapon:entity, OnSpawn:number)`       | runOnWeaponEquip, weaponEquipClk   | Triggered when a player equips a weapon.  |
| `event weaponDrop(Player:entity, Weapon:entity)`                        |                                    | Triggered when a player drops a weapon.   |

### Tick Functions
| Function                                             | Return | Description                                                                |
|------------------------------------------------------|--------|----------------------------------------------------------------------------|
| `runOnWeaponSwitch(Activate:number)`                 | void   | If set to 1, the chip will be executed when the player switches weapons.   |
| `weaponSwitchClk()`                                  | number | Returns 1 if the player has switched weapons.                              |
| `lastWeaponSwitchPlayer()`                           | entity | Returns the player that switched weapons.                                  |
| `lastWeaponSwitchOld()`                              | entity | Returns the weapon the player switched from.                               |
| `lastWeaponSwitchNext()`                             | entity | Returns the weapon the player switched to.                                 |
| `runOnWeaponEquip(Activate:number)`                  | void   | Is set to 1, E2 will run when a player equips a weapon.                    |
| `weaponEquipClk()`                                   | number | Returns 1 if the E2 is run because of a weapon equip.                      |
| `lastWeaponEquip()`                                  | entity | Returns the last equipped weapon.                                          |

### Player Functions

Player functions are restricted to admins only.

| Function                                             | Return | Description                                                                |
|------------------------------------------------------|--------|----------------------------------------------------------------------------|
| `entity:plyGive(WeaponClass:string)`                 | void   | Give the player a weapon.                                                  |
| `entity:plyGiveWeapon(WeaponClass:string)`           | void   | Give the player a weapon.                                                  |
| `entity:plyGiveAmmo(AmmoType:string, Amount:number)` | void   | Gives ammo to a player.                                                    |
| `entity:plySetAmmo(AmmoType:string, Amount:number)`  | void   | Sets the amount of of the specified ammo for the player.                   |
| `entity:plySelectWeapon(WeaponClass:string)`         | void   | Sets the player active weapon.                                             |
| `entity:plyDropWeapon(WeaponClass:string)`           | void   | Drops the player's weapon of a specific class.                             |
| `entity:plyDropWeapon(Weapon:entity)`                | void   | Forces the player to drop the specified weapon.                            |
| `entity:plyStripWeapon(WeaponClass:string)`          | void   | Removes the specified weapon class from a certain player.                  |
| `entity:plyStripWeapon(Weapon:entity)`               | void   | Removes the specified weapon from a certain player                         |
| `entity:plyStripWeapons()`                           | void   | Removes all weapons from a certain player                                  |
| `entity:plyStripAmmo()`                              | void   | Removes all ammo from the player.                                          |
| `entity:plySetClip1(Amount:number)`                  | void   | Lets you change the number of bullets in the given weapons primary clip.   |
| `entity:plySetClip2(Amount:number)`                  | void   | Lets you change the number of bullets in the given weapons secondary clip. |

### Getters

| Function                                             | Return | Description                                                                |
|------------------------------------------------------|--------|----------------------------------------------------------------------------|
| `entity:getWeapon(WeaponClass:string)`               | entity | Returns the weapon entity whit the class.                                  |
| `entity:getWeapons()`                                | array  | Returns a table of the player's weapons.                                   |
| `entity:hasWeapon(WeaponClass:string)`               | number | Returns if the player has the specified weapon.                            |

[WeaponCore Workshop Page]: <https://steamcommunity.com/sharedfiles/filedetails/?id=452197127>
[Expression 2 Core Collection]: <https://steamcommunity.com/workshop/filedetails/?id=726399057>
[Expression 2]: <https://github.com/wiremod/wire/wiki/Expression-2>